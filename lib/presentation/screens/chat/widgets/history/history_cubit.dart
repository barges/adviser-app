import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

List<HistoryUiModel> _groupTopHistory(List<History> data) {
  final Map<String, List<History>> groupedItem =
      groupBy<History, String>(data, (e) {
    return e.question?.storyID ?? '';
  });
  final items = <HistoryUiModel>[];
  groupedItem.forEach((key, value) {
    items.addAll(value.map((e) => HistoryUiModel.data(e)));
    items.add(HistoryUiModel.separator(value.lastOrNull?.question));
  });

  return items;
}

List<HistoryUiModel> _groupBottomHistory(List<History> data) {
  final Map<String, List<History>> groupedItem =
      groupBy<History, String>(data, (e) {
    return e.question?.storyID ?? '';
  });
  final items = <HistoryUiModel>[];
  groupedItem.forEach((key, value) {
    items.add(HistoryUiModel.separator(value.lastOrNull?.question));
    items.addAll(value.map((e) => HistoryUiModel.data(e)));
  });

  return items;
}

class HistoryCubit extends Cubit<HistoryState> {
  final ScrollController historyMessagesScrollController = ScrollController();
  final ConnectivityService _connectivityService =
      getIt.get<ConnectivityService>();
  final ChatsRepository _repository;
  final String _clientId;
  final String? _storyId;
  FlutterSoundPlayer? _playerMedia;

  final List<History> _topHistoriesList = [];
  final List<History> _bottomHistoriesList = [];
  final int _limit = 15;
  final GlobalKey scrollItemKey = GlobalKey();
  bool _hasMore = true;
  String? _lastItem;
  bool _hasBefore = false;
  String? _firstItem;
  bool _isBottomLoading = false;
  bool _isTopLoading = false;

  HistoryCubit(
    this._repository,
    this._clientId,
    this._playerMedia,
    this._storyId,
  ) : super(const HistoryState()) {
    if (_storyId == null) {
      _getOldBottomHistoriesList();
      historyMessagesScrollController
          .addListener(scrollControllerListenerForStoryFromTop);
    } else {
      _getHistoriesFromMiddleList();
      historyMessagesScrollController
          .addListener(scrollControllerListenerForStoryFromMiddle);
    }
  }

  @override
  Future<void> close() {
    historyMessagesScrollController.dispose();
    _playerMedia?.closePlayer();
    _playerMedia = null;
    return super.close();
  }

  void scrollControllerListenerForStoryFromTop() {
    if (historyMessagesScrollController.position.extentAfter <= 500) {
      _loadBottomData();
    }
  }

  void scrollControllerListenerForStoryFromMiddle() {
    if (historyMessagesScrollController.position.extentAfter <= 500) {
      _loadTopData();
    }
    if (historyMessagesScrollController.position.extentBefore <= 400) {
      _loadBottomData();
    }
  }

  void _loadBottomData() {
    if (!_isBottomLoading) {
      _isBottomLoading = true;
      _getOldBottomHistoriesList();
    }
  }

  void _loadTopData() {
    if (!_isTopLoading) {
      _isTopLoading = true;
      _getNewTopHistoriesList();
    }
  }

  Future<void> _getHistoriesFromMiddleList() async {
    if (await _connectivityService.checkConnection()) {
      final HistoryResponse result = await _repository.getHistoryList(
        clientId: _clientId,
        limit: _limit,
        storyId: _storyId,
      );
      _hasMore = result.hasMore ?? true;
      _lastItem = result.lastItem;
      _hasBefore = result.hasBefore ?? false;
      _firstItem = result.firstItem;

      _topHistoriesList.addAll(result.history?.reversed ?? const []);

      final List<HistoryUiModel> items =
          await compute(_groupTopHistory, _topHistoriesList);

      emit(state.copyWith(
        topHistoriesList: items,
      ));

      _getOldBottomHistoriesList();
    }
  }

  Future<void> _getNewTopHistoriesList() async {
    if (_hasBefore && await _connectivityService.checkConnection()) {
      final HistoryResponse result = await _repository.getHistoryList(
        clientId: _clientId,
        limit: _limit,
        firstItem: _firstItem,
      );
      _hasBefore = result.hasBefore ?? false;
      _firstItem = result.firstItem;

      _topHistoriesList.addAll(
        result.history?.reversed ?? [],
      );

      final List<HistoryUiModel> items =
          await compute(_groupTopHistory, _topHistoriesList);

      emit(state.copyWith(
        topHistoriesList: items,
      ));
    }
    _isTopLoading = false;
  }

  Future<void> _getOldBottomHistoriesList() async {
    if (_hasMore && await _connectivityService.checkConnection()) {
      final HistoryResponse result = await _repository.getHistoryList(
        clientId: _clientId,
        limit: _limit,
        lastItem: _lastItem,
      );
      _hasMore = result.hasMore ?? true;
      _lastItem = result.lastItem;

      _bottomHistoriesList.addAll(result.history ?? const []);

      final List<HistoryUiModel> items =
          await compute(_groupBottomHistory, _bottomHistoriesList);

      emit(state.copyWith(
        bottomHistoriesList: items,
      ));
    }
    _isBottomLoading = false;
  }
}
