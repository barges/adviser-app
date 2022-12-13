import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_state.dart';
import 'package:shared_advisor_interface/extensions.dart';

enum HistoryScrollDirection {
  up,
  down,
}

class HistoryCubit extends Cubit<HistoryState> {
  final ScrollController historyMessagesScrollController = ScrollController();
  final ChatsRepository _repository;
  final String _clientId;
  final String? _storyId;
  FlutterSoundPlayer? _playerMedia;
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final Codec _codec = Codec.aacMP4;

  final List<History> _historyList = [];
  final int _limit = 15;
  bool _hasMore = true;
  String? _lastItem;
  bool _hasBefore = false;
  String? _firstItem;
  bool isLoading = false;

  HistoryCubit(
    this._repository,
    this._clientId,
    this._playerMedia,
    this._storyId,
  ) : super(const HistoryState()) {
    _getHistoryList(firstRequest: true);
    historyMessagesScrollController.addListener(scrollControllerListener);
  }

  @override
  Future<void> close() {
    historyMessagesScrollController.dispose();
    _playerMedia?.closePlayer();
    _playerMedia = null;
    return super.close();
  }

  void scrollControllerListener() {
    if (!_mainCubit.state.isLoading &&
        historyMessagesScrollController.position.extentAfter <= 300) {
      _getHistoryList(
        scrollDirection: HistoryScrollDirection.down,
      );
    }
    if (!_mainCubit.state.isLoading &&
        historyMessagesScrollController.position.extentBefore <= 300) {
      _getHistoryList(
        scrollDirection: HistoryScrollDirection.up,
      );
    }
  }

  Future<void> _getHistoryList({
    bool firstRequest = false,
    HistoryScrollDirection? scrollDirection,
  }) async {
    if (!isLoading) {
      isLoading = true;
      try {
        if (firstRequest && _mainCubit.state.internetConnectionIsAvailable) {
          final HistoryResponse result = await _repository.getHistoryList(
            clientId: _clientId,
            limit: _limit,
            storyId: _storyId,
          );
          _hasMore = result.hasMore ?? true;
          _hasBefore = result.hasBefore ?? true;
          _lastItem = result.history?.lastOrNull?.id;
          _firstItem = result.firstItem;

          _historyList.addAll(result.history ?? const []);
          emit(state.copyWith(
            historyMessages: List.of(_historyList),
          ));
          isLoading = false;
          _getHistoryList(scrollDirection: HistoryScrollDirection.up);
        } else {
          if (_hasMore &&
              _mainCubit.state.internetConnectionIsAvailable &&
              scrollDirection == HistoryScrollDirection.down) {
            final HistoryResponse result = await _repository.getHistoryList(
              clientId: _clientId,
              limit: _limit,
              lastItem: _lastItem,
            );

            _hasMore = result.hasMore ?? false;
            _lastItem = result.lastItem;

            _historyList.addAll(result.history ?? const []);

            emit(state.copyWith(
              historyMessages: List.of(_historyList),
            ));
          } else if (_hasBefore &&
              _mainCubit.state.internetConnectionIsAvailable &&
              scrollDirection == HistoryScrollDirection.up) {
            final HistoryResponse result = await _repository.getHistoryList(
              clientId: _clientId,
              limit: _limit,
              firstItem: _firstItem,
            );
            _hasBefore = result.hasBefore ?? false;
            _firstItem = result.firstItem;

            _historyList.insertAll(0, result.history ?? const []);
            emit(state.copyWith(
              historyMessages: List.of(_historyList),
            ));
          }
        }
      } on DioError catch (e) {
        logger.d(e);
      }
      isLoading = false;
    }
  }

  Future<void> startPlayAudio(String audioUrl) async {
    if (state.audioUrl != audioUrl) {
      await _playerMedia?.stopPlayer();

      emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
          audioUrl: audioUrl,
        ),
      );
    }

    if (_playerMedia != null && _playerMedia!.isPaused) {
      await _playerMedia!.resumePlayer();

      emit(
        state.copyWith(
          isPlayingAudio: true,
          isPlayingAudioFinished: false,
        ),
      );
      return;
    }

    await _playerMedia?.startPlayer(
      fromURI: audioUrl,
      codec: _codec,
      sampleRate: 44000,
      whenFinished: () => emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
        ),
      ),
    );

    emit(
      state.copyWith(
        isPlayingAudio: true,
        isPlayingAudioFinished: false,
      ),
    );
  }

  Future<void> pauseAudio() async {
    await _playerMedia?.pausePlayer();

    emit(
      state.copyWith(
        isPlayingAudio: false,
      ),
    );
  }

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
