import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class BalanceAndTransactionsCubit extends Cubit<BalanceAndTransactionsState> {
  final ZodiacMainCubit _mainCubit;
  final ZodiacUserRepository _userRepository;
  final int _limit = 20;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;
  final ScrollController scrollController = ScrollController();
  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;
  final _tilePositions = <DateTime, _TilePosition>{};

  BalanceAndTransactionsCubit(
    this._mainCubit,
    this._userRepository,
  ) : super(const BalanceAndTransactionsState()) {
    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });
    scrollController.addListener(_scrollControllerListener);
    _loadData();
  }

  Future<void> _loadData() async {
    await getPaymentsList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        _checkIfNeedAndLoadData();
      }
    });
  }

  void _scrollControllerListener() {
    _checkIfNeedAndLoadData();

    final isVisibleUpButton = scrollController.position.extentBefore > 300;
    if (isVisibleUpButton != state.isVisibleUpButton) {
      emit(state.copyWith(
        isVisibleUpButton: isVisibleUpButton,
      ));
    }

    emit(state.copyWith(
      monthLabel:
          _getCurrentScrollingMonth(scrollController.position.extentBefore),
    ));
  }

  void _checkIfNeedAndLoadData() {
    if (!_isLoading && scrollController.position.extentAfter <= 200) {
      getPaymentsList();
    }
  }

  @override
  Future<void> close() async {
    _updateUserBalanceSubscription.cancel();
    super.close();
  }

  Future<void> getPaymentsList({bool refresh = false}) async {
    if (!refresh && _count != null && _offset >= _count!) {
      return;
    }

    if (refresh) {
      _tilePositions.clear();
    }

    try {
      _isLoading = true;

      _offset = refresh ? 0 : _offset;
      final PaymentsListResponse response = await _userRepository
          .getPaymentsList(ListRequest(count: _limit, offset: _offset));

      // For test
      /*const jsonData =
          '{"status":true,"error_code":0,"error_msg":"","count":"49","result":[{"id":2016271,"date_create":1656574785,"source":2,"fee":1.99,"amount":2.2,"length":301,"note":"Mobile Customer","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":2016171,"date_create":1656437948,"source":2,"fee":12.99,"amount":7.44,"length":123,"note":"Removed by GDPR","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1976725,"date_create":1599548789,"source":0,"fee":0,"amount":-186.84,"length":0,"note":"Withdrawal September (Paypal)","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1862452,"date_create":1542358044,"source":6,"fee":12.99,"amount":2.8,"length":74,"note":"Received tip","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1862448,"date_create":1542358026,"source":1,"fee":12.99,"amount":4.47,"length":74,"note":"Chat Session with user_UCRXMO","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1858898,"date_create":1542201931,"source":1,"fee":12.99,"amount":7.26,"length":120,"note":"Chat Session with Customer","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1858894,"date_create":1542201619,"source":1,"fee":12.99,"amount":3.63,"length":120,"note":"Chat Session with Customer (amount correcting)","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1858491,"date_create":1542196656,"source":1,"fee":12.99,"amount":4.59,"length":76,"note":"Chat Session with user_UCRXMO","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1857755,"date_create":1542112243,"source":1,"fee":12.99,"amount":10.23,"length":169,"note":"Chat Session with user_UCRXMO","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"},{"id":1857749,"date_create":1542111089,"source":1,"fee":1.99,"amount":1.54,"length":168,"note":"Chat Session with user_UCRXMO","avatar":"https://d1lj31fhs0ywmr.cloudfront.net/dev/users/default/simple/tiny_list.png"}]}';
      final parsedJson = jsonDecode(jsonData);
      final PaymentsListResponse response =
          PaymentsListResponse.fromJson(parsedJson);*/

      List<PaymentInformation>? result = response.result ?? [];
      _count = response.count ?? 0;
      _offset = _offset + _limit;

      final Map<DateTime, List<PaymentInformation>> transactionsMap =
          _toTransactionsMapItem(result);
      final List<TransactionUiModel> transactionUiModelsList =
          _toTransactionUiModels(transactionsMap);
      final List<TransactionUiModel> stateTransactionUiModelsList =
          refresh || state.transactionsList == null
              ? <TransactionUiModel>[]
              : List.of(state.transactionsList!);
      final List<TransactionUiModel> transactionsList =
          stateTransactionUiModelsList.isEmpty
              ? transactionUiModelsList
              : _jointData(
                  stateTransactionUiModelsList, transactionUiModelsList);
      setTilePositions(transactionsList);

      emit(state.copyWith(
        transactionsList: transactionsList,
      ));
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      logger.d(e);
    }
  }

  Map<DateTime, List<PaymentInformation>> _toTransactionsMapItem(
      List<PaymentInformation> data) {
    final Map<DateTime, List<PaymentInformation>> transactions = {};
    DateTime? dateCreate;
    List<PaymentInformation> items = [];
    for (var item in data) {
      if (item.dateCreate == null) continue;

      if (dateCreate?.day != item.dateCreate?.day ||
          dateCreate?.month != item.dateCreate?.month ||
          dateCreate?.year != item.dateCreate?.year) {
        items = [];
        dateCreate = item.dateCreate;
        transactions[dateCreate!] = items;
      }
      items.add(item);
    }
    return transactions;
  }

  List<TransactionUiModel> _toTransactionUiModels(
      Map<DateTime, List<PaymentInformation>> items) {
    final uiModelItems = <TransactionUiModel>[];
    for (var entry in items.entries) {
      uiModelItems.add(TransactionUiModel.separator(entry.key));
      uiModelItems.add(TransactionUiModel.data(entry.value));
    }
    return uiModelItems;
  }

  List<TransactionUiModel> _jointData(
      List<TransactionUiModel> left, List<TransactionUiModel> right) {
    final DateTime? leftDateTime = left[left.length - 2]
        .when(data: (data) => null, separator: (dateCreate) => dateCreate);
    final DateTime? rightDateTime = right.first
        .when(data: (_) => null, separator: (dateCreate) => dateCreate);
    if (leftDateTime?.month == rightDateTime?.month &&
        leftDateTime?.year == rightDateTime?.year) {
      final List<PaymentInformation>? rightItems =
          right[1].when(data: (data) => data, separator: (_) => null);
      final TransactionUiModel leftLast = left.last.map(
          data: (data) => data.copyWith(items: [...data.items, ...rightItems!]),
          separator: (dateCreate) => dateCreate);
      left.replaceRange(left.length - 1, left.length, [leftLast]);
      right.removeRange(0, 2);
    }
    return left..addAll(right);
  }

  void setTilePositions(List<TransactionUiModel> items) {
    final entriesTilePositions = _tilePositions.entries.toList();
    final startIndexItems =
        entriesTilePositions.isEmpty ? 0 : entriesTilePositions.length * 2 - 3;
    final startIndexPositions =
        entriesTilePositions.isEmpty ? 0 : entriesTilePositions.length - 2;
    int position = entriesTilePositions.isEmpty
        ? 333
        : entriesTilePositions[startIndexPositions].value.start;
    DateTime? date = entriesTilePositions.isEmpty
        ? null
        : _tilePositions.keys.toList()[startIndexPositions];
    TransactionUiModel item;
    for (var i = startIndexItems; i < items.length; i++) {
      item = items[i];
      item.when(
        data: (data) {
          final itemWidth = _getTileWidth(data.length);
          _tilePositions[date!] = _TilePosition(position, position + itemWidth);
          position = position + itemWidth + 23 + 24;
          return null;
        },
        separator: (dateCreate) {
          date = dateCreate!;
          return null;
        },
      );
    }
  }

  DateTime? _getCurrentScrollingMonth(double extentBefore) {
    final MapEntry<DateTime, _TilePosition>? entry = _tilePositions.entries
        .toList()
        .lastWhereOrNull(
            (e) => e.value.start < extentBefore && extentBefore < e.value.end);
    return entry?.key;
  }

  int _getTileWidth(int count) {
    return count == 1 ? 80 : 56 * 2 + (count - 2) * 64 + 32;
  }
}

class _TilePosition {
  final int start;
  final int end;
  const _TilePosition(this.start, this.end);
}
