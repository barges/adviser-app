import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages/canned_messages_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_messages/canned_messages_response.dart';
import 'package:zodiac/domain/repositories/zodiac_canned_messages_repository.dart';

import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_state.dart';

const maximumMessageSymbols = 280;

@injectable
class CannedMessagesCubit extends Cubit<CannedMessagesState> {
  final ZodiacCannedMessagesRepository _zodiacCannedMessagesRepository;
  final List<CannedMessage> _messages = [];
  CannedCategory? _selectedCategory;
  CannedCategory? _categoryToAdd;
  CannedCategory? _updateCategory;
  CannedMessage? _updateMessage;
  String _textCannedMessageToAdd = '';
  String _updatedText = '';

  CannedMessagesCubit(
    this._zodiacCannedMessagesRepository,
  ) : super(const CannedMessagesState()) {
    _init();
  }

  _init() async {
    await loadData();

    if (state.categories != null && state.categories!.isNotEmpty) {
      _categoryToAdd = state.categories!.first;
    }
  }

  Future<void> loadData() async {
    try {
      await _getCannedCategories();
      await _getCannedMessages();
      emit(state.copyWith(
        showErrorData: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        showErrorData: true,
      ));
    }
  }

  void setTextCannedMessageToAdd(String text) {
    _textCannedMessageToAdd = text;
    emit(state.copyWith(
      isSaveTemplateButtonEnabled: _isCountSymbolsOk(text.length),
    ));
  }

  void setUpdatedText(String text) {
    _updatedText = text;
  }

  void setCategoryToAdd(int categoryIndex) {
    _categoryToAdd = state.categories![categoryIndex];
  }

  void setCategory(int? categoryIndex) {
    CannedCategory? cannedCategory =
        categoryIndex != null ? state.categories![categoryIndex] : null;
    _selectedCategory = cannedCategory;
  }

  void setUpdateCategory(int categoryIndex) {
    CannedCategory? cannedCategory =
        state.categories!.isNotEmpty ? state.categories![categoryIndex] : null;
    _updateCategory = cannedCategory;
  }

  void setUpdateCannedMessage(CannedMessage cannedMessage) {
    _updateMessage = cannedMessage;
  }

  Future<void> filterCannedMessagesByCategory() async {
    if (_selectedCategory != null) {
      emit(state.copyWith(
        messages: _messages
            .where((element) => element.categoryId == _selectedCategory?.id)
            .toList(),
      ));
    } else {
      emit(state.copyWith(
        messages: List.of(_messages),
      ));
    }
  }

  Future<bool> saveTemplate() async {
    if (_textCannedMessageToAdd.isNotEmpty) {
      final CannedMessagesResponse? response = await _addCannedMessages();
      if (response != null) {
        final newCannedMessage = CannedMessage(
            id: response.messageId,
            categoryId: _categoryToAdd?.id,
            categoryName: _categoryToAdd?.name,
            text: _textCannedMessageToAdd);
        _messages.insert(0, newCannedMessage);
        await filterCannedMessagesByCategory();
        return true;
      }
    }
    return false;
  }

  Future<bool> updateCannedMessage() async {
    if (_updatedText.isNotEmpty) {
      if (await _updateCannedMessage()) {
        final CannedMessage updatedMessage = _updateMessage!.copyWith(
            id: _updateMessage?.id,
            categoryId: _updateCategory?.id,
            categoryName: _updateCategory?.name,
            text: _updatedText);
        _messages.replaceRange(
            _messages.indexOf(_updateMessage!), 1, [updatedMessage]);
        await filterCannedMessagesByCategory();
        return true;
      }
    }
    return false;
  }

  Future<void> deleteCannedMessage(int? messageId) async {
    if (await _deleteCannedMessage(messageId)) {
      _messages.removeWhere((element) => element.id == messageId);
      await filterCannedMessagesByCategory();
    }
  }

  CannedCategory? getCategoryById(int id) {
    return state.categories!.firstWhereOrNull((element) => element.id == id);
  }

  Future<void> _getCannedCategories() async {
    try {
      final CannedMessagesResponse response =
          await _zodiacCannedMessagesRepository
              .getCannedCategories(AuthorizedRequest());

      if (response.status == true &&
          response.categories != null &&
          response.categories!.isNotEmpty) {
        emit(state.copyWith(
          categories: List.of(response.categories!),
        ));
      }
    } catch (e) {
      logger.d(e);
      rethrow;
    }
  }

  Future<void> _getCannedMessages() async {
    try {
      final CannedMessagesResponse response =
          await _zodiacCannedMessagesRepository
              .getCannedMessages(CannedMessagesRequest());

      _messages.clear();

      if (response.status == true && response.messages != null) {
        _messages.addAll(response.messages!);
        emit(state.copyWith(
          messages: List.of(_messages),
        ));
      }
    } catch (e) {
      logger.d(e);
      rethrow;
    }
  }

  Future<CannedMessagesResponse?> _addCannedMessages() async {
    try {
      final CannedMessagesResponse response =
          await _zodiacCannedMessagesRepository.addCannedMessage(
              CannedMessagesRequest(
                  categoryId: _categoryToAdd?.id,
                  text: _textCannedMessageToAdd));

      if (response.status == true && response.messageId != null) {
        return response;
      }
    } catch (e) {
      logger.d(e);
    }

    return null;
  }

  Future<bool> _updateCannedMessage() async {
    try {
      final BaseResponse response = await _zodiacCannedMessagesRepository
          .updateCannedMessage(CannedMessagesRequest(
              messageId: _updateMessage?.id,
              categoryId: _updateCategory?.id,
              text: _updatedText));

      if (response.status == true) {
        return true;
      }
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  Future<bool> _deleteCannedMessage(int? messageId) async {
    try {
      final BaseResponse response = await _zodiacCannedMessagesRepository
          .deleteCannedMessage(CannedMessagesRequest(messageId: messageId));

      if (response.status == true) {
        return true;
      }
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  bool _isCountSymbolsOk(int count) {
    return count > 0 && count <= maximumMessageSymbols;
  }
}