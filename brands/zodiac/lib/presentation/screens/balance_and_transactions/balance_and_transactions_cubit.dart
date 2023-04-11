import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
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
  late final StreamSubscription<double> _appBarHeightSubscription;
  final List<PaymentInformation> _transactionsListData = [];
  final _tilePositions = <DateTime, _TilePosition>{};

  BalanceAndTransactionsCubit(
    this._mainCubit,
    this._userRepository,
  ) : super(const BalanceAndTransactionsState()) {
    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });

    _appBarHeightSubscription = _mainCubit.appBarHeightTrigger.listen((value) {
      if (value != state.appBarHeight) {
        emit(state.copyWith(appBarHeight: value));
      }
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
      dateCreate: _getCurrentScrollingDateCreate(
          scrollController.position.extentBefore),
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
    _appBarHeightSubscription.cancel();
    super.close();
  }

  Future<void> getPaymentsList({bool refresh = false}) async {
    if (!refresh && _count != null && _offset >= _count!) {
      return;
    }

    if (refresh) {
      _tilePositions.clear();
      _transactionsListData.clear();
    }

    try {
      _isLoading = true;

      _offset = refresh ? 0 : _offset;
      final PaymentsListResponse response = await _userRepository
          .getPaymentsList(ListRequest(count: _limit, offset: _offset));

      _count = response.count ?? 0;
      _offset = _offset + _limit;

      _transactionsListData.addAll(response.result ?? []);
      final Map<DateTime, List<PaymentInformation>> transactionsMap =
          _toTransactionsMapItem(_transactionsListData);
      final List<TransactionUiModel> transactionUiModelsList =
          _toTransactionUiModels(transactionsMap);
      setTilePositions(transactionUiModelsList);

      emit(state.copyWith(
        transactionsList: transactionUiModelsList,
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

  void setTilePositions(List<TransactionUiModel> items) {
    int position = 333;
    DateTime? date;
    for (var item in items) {
      item.when(
        data: (data) {
          final itemHeight = _getTileHeight(data.length);
          _tilePositions[date!] =
              _TilePosition(position, position + itemHeight);
          position = position + itemHeight + 23 + 24;
          return null;
        },
        separator: (dateCreate) {
          date = dateCreate!;
          return null;
        },
      );
    }
  }

  DateTime? _getCurrentScrollingDateCreate(double extentBefore) {
    final bool isAppBarHeightMax = state.appBarHeight != null
        ? state.appBarHeight! >= AppConstants.appBarHeight * 2
        : false;
    final MapEntry<DateTime, _TilePosition>? entry = _tilePositions.entries
        .toList()
        .lastWhereOrNull((e) =>
            e.value.start - (isAppBarHeightMax ? 55 : 0) < extentBefore &&
            extentBefore < e.value.end + (isAppBarHeightMax ? -65 : -12));
    return entry?.key;
  }

  int _getTileHeight(int count) {
    return count == 1 ? 80 : 56 * 2 + (count - 2) * 64 + 32;
  }
}

class _TilePosition {
  final int start;
  final int end;
  const _TilePosition(this.start, this.end);
}
