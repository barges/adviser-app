import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

List<HistoryUiModel> _groupTopHistory(List<History> data) {
  final List<List<History>> groupedItem = _groupByStoryId(data);

  final items = <HistoryUiModel>[];
  for (var value in groupedItem) {
    items.addAll(value.map((e) => HistoryUiModel.data(e)));
    items.add(HistoryUiModel.separator(value.lastOrNull?.question));
  }

  return items;
}

List<HistoryUiModel> _groupBottomHistory(List<History> data) {
  final List<List<History>> groupedItem = _groupByStoryId(data);

  final items = <HistoryUiModel>[];
  for (var value in groupedItem) {
    items.add(HistoryUiModel.separator(value.lastOrNull?.question));
    items.addAll(value.map((e) => HistoryUiModel.data(e)));
  }

  return items;
}

List<List<History>> _groupByStoryId(List<History> data) {
  final List<List<History>> histories = [];

  List<History> historiesById = [];
  String? previousId = data.firstOrNull?.question?.storyID;
  for (int i = 0; i < data.length; i++) {
    final History history = data[i];
    final bool isLastIndex = i == data.length - 1;
    final String? currentStoryId = history.question?.storyID;
    if (previousId != null && currentStoryId != null) {
      if (!isLastIndex) {
        if (currentStoryId == previousId) {
          historiesById.add(history);
        } else {
          histories.add(historiesById);
          historiesById = [];
          previousId = currentStoryId;
          historiesById.add(history);
        }
      } else {
        if (currentStoryId == previousId) {
          historiesById.add(history);
          histories.add(historiesById);
        } else {
          histories.add(historiesById);
          historiesById = [];
          historiesById.add(history);
          histories.add(historiesById);
        }
      }
    }
  }
  return histories;
}

class HistoryCubit extends Cubit<HistoryState> {
  final ScrollController historyMessagesScrollController = ScrollController();
  final ConnectivityService _connectivityService;
  final ChatsRepository _repository;
  final VoidCallback _showErrorAlert;
  final String _clientId;
  final String? _storyId;

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
    this._connectivityService,
    this._showErrorAlert,
    this._clientId,
    this._storyId,
  ) : super(const HistoryState()) {
    if (_storyId == null) {
      _getOldBottomHistoriesList();
      historyMessagesScrollController.addListener(() {
        if (historyMessagesScrollController.position.extentAfter <= 500) {
          _loadBottomData();
        }
      });
    } else {
      _getHistoriesFromMiddleList();
      historyMessagesScrollController.addListener(() {
        if (historyMessagesScrollController.position.extentAfter <= 500) {
          _loadBottomData();
        }
        if (historyMessagesScrollController.position.extentBefore <= 500) {
          _loadTopData();
        }
      });
    }
  }

  @override
  Future<void> close() {
    historyMessagesScrollController.dispose();
    return super.close();
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
    try {
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

        _bottomHistoriesList.addAll(result.history ?? const []);

        final List<HistoryUiModel> items =
            await compute(_groupBottomHistory, _bottomHistoriesList);

        emit(state.copyWith(
          bottomHistoriesList: items,
        ));

        _getNewTopHistoriesList();
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 409) {
        _showErrorAlert();
      }
      logger.d(e);
    }
  }

  Future<void> _getNewTopHistoriesList() async {
    try {
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
    } on DioError catch (e) {
      if (e.response?.statusCode == 409) {
        _showErrorAlert();
      }
      logger.d(e);
    } finally {
      _isTopLoading = false;
    }
  }

  Future<void> _getOldBottomHistoriesList() async {
    try {
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
    } on DioError catch (e) {
      if (e.response?.statusCode == 409) {
        _showErrorAlert();
      }
      logger.d(e);
    } finally {
      _isBottomLoading = false;
    }
  }
}
