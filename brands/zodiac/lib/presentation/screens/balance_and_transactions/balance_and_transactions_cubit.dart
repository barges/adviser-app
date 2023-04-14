import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_state.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/label_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/time_item_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/transaction_statistic_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/transaction_tile_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const double appBarExtension = AppConstants.appBarHeight;
const double startTilePosition = appBarExtension +
    labelWidgetHeight +
    paddingBottomTimeItem +
    statisticWidgetHeight +
    paddingottomStatisticWidget +
    paddingTopTimeItem +
    timeItemHeight +
    paddingBottomTimeItem;
const double internalItemTileHeight =
    userAvatarDiameter + paddingBottomTile * 2;
const double singleItemTileHeight = userAvatarDiameter + paddingTile * 2;
const double correctionTilePositionEnd = 12.0;

class BalanceAndTransactionsCubit extends Cubit<BalanceAndTransactionsState> {
  final ZodiacMainCubit _mainCubit;
  final ZodiacUserRepository _userRepository;
  final ScrollController scrollController = ScrollController();
  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;
  late final BehaviorSubject _scrollStream = BehaviorSubject<double>();
  late final StreamSubscription _scrollSubscription;
  final List<PaymentInformation> _transactionsListData = [];
  final _tilePositions = <DateTime, _TilePosition>{};
  final int _limit = 20;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;
  bool _isScrollUp = false;

  BalanceAndTransactionsCubit(
    this._mainCubit,
    this._userRepository,
  ) : super(const BalanceAndTransactionsState()) {
    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });

    scrollController.addListener(_scrollControllerListener);

    _scrollSubscription = _scrollStream
        .debounceTime(const Duration(milliseconds: 50))
        .listen((extentBefore) async {
      DateTime? dateCreate = await compute(_getCurrentScrollingDateCreate,
          [extentBefore, _tilePositions, _isScrollUp]);
      emit(state.copyWith(
        dateCreate: dateCreate,
      ));
    });

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

    _isScrollUp = scrollController.position.userScrollDirection ==
        ScrollDirection.forward;

    _scrollStream.add(scrollController.position.extentBefore);
  }

  void _checkIfNeedAndLoadData() {
    if (!_isLoading && scrollController.position.extentAfter <= 200) {
      getPaymentsList();
    }
  }

  @override
  Future<void> close() async {
    _updateUserBalanceSubscription.cancel();
    _scrollSubscription.cancel();
    scrollController.dispose();
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
      final List<TransactionUiModel> transactionUiModelsList =
          await compute(_toTransactionUiModels, _transactionsListData);

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

  void setTilePositions(List<TransactionUiModel> items) {
    double position = startTilePosition;
    DateTime? date;
    for (var item in items) {
      item.when(
        data: (data) {
          final itemHeight = _getTileHeight(data.length);
          _tilePositions[date!] =
              _TilePosition(position, position + itemHeight);
          position = position +
              itemHeight +
              paddingTopTimeItem +
              timeItemHeight +
              paddingBottomTimeItem;
          return null;
        },
        separator: (dateCreate) {
          date = dateCreate!;
          return null;
        },
      );
    }
  }

  double _getTileHeight(int count) {
    return count == 1
        ? singleItemTileHeight
        : (userAvatarDiameter + paddingBottomTile) * 2 +
            (count - 2) * internalItemTileHeight +
            paddingTile * 2;
  }
}

class _TilePosition {
  final double start;
  final double end;
  const _TilePosition(this.start, this.end);
}

List<TransactionUiModel> _toTransactionUiModels(List<PaymentInformation> data) {
  final uiModelItems = <TransactionUiModel>[];
  DateTime? dateCreate;
  List<PaymentInformation> items = [];
  for (var item in data) {
    if (item.dateCreate == null) continue;

    if (dateCreate?.day != item.dateCreate?.day ||
        dateCreate?.month != item.dateCreate?.month ||
        dateCreate?.year != item.dateCreate?.year) {
      items = [];
      dateCreate = item.dateCreate;
      uiModelItems.add(TransactionUiModel.separator(dateCreate));
      uiModelItems.add(TransactionUiModel.data(items));
    }
    items.add(item);
  }
  return uiModelItems;
}

DateTime? _getCurrentScrollingDateCreate(List<dynamic> params) {
  double extentBefore = params[0];
  Map<DateTime, _TilePosition> tilePositions = params[1];
  bool isScrollUp = params[2];
  double correctedExtentBefore =
      extentBefore + (isScrollUp ? appBarExtension : 0.0);
  if (correctedExtentBefore < startTilePosition) {
    return null;
  }
  final MapEntry<DateTime, _TilePosition>? entry = tilePositions.entries
      .toList()
      .lastWhereOrNull((e) =>
          e.value.start < correctedExtentBefore &&
          correctedExtentBefore < e.value.end - correctionTilePositionEnd);
  return entry?.key;
}
