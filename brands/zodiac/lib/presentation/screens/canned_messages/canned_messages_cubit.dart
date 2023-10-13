import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages/canned_messages_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_messages/canned_messages_response.dart';
import 'package:zodiac/domain/repositories/zodiac_canned_messages_repository.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_state.dart';

const maximumMessageSymbols = 280;

@injectable
class CannedMessagesCubit extends Cubit<CannedMessagesState> {
  final ZodiacCannedMessagesRepository _zodiacCannedMessagesRepository;
  final GlobalKey cannedMessageManagerKey = GlobalKey();
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
        selectedCategoryIndex: 0,
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

  void setUpdateCategory(int categoryIndex) {
    CannedCategory? cannedCategory =
        state.categories!.isNotEmpty ? state.categories![categoryIndex] : null;
    _updateCategory = cannedCategory;
  }

  void setUpdateCannedMessage(CannedMessage cannedMessage) {
    _updateMessage = cannedMessage;
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

        if (state.selectedCategoryIndex == 0 ||
            state.categories![state.selectedCategoryIndex - 1].id ==
                newCannedMessage.categoryId) {
          final messages = List.of(state.messages!);
          messages.insert(0, newCannedMessage);
          emit(state.copyWith(
            messages: messages,
          ));
        }

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

        if (state.selectedCategoryIndex == 0 ||
            state.categories![state.selectedCategoryIndex - 1].id ==
                updatedMessage.categoryId) {
          final messages = List.of(state.messages!);
          messages.replaceRange(
              messages.indexOf(_updateMessage!), 1, [updatedMessage]);
          emit(state.copyWith(
            messages: messages,
          ));
        } else {
          final messages = List.of(state.messages!);
          messages.removeAt(messages
              .indexWhere((element) => element.id == updatedMessage.id));
          emit(state.copyWith(
            messages: List.of(messages),
          ));
        }

        return true;
      }
    }
    return false;
  }

  Future<void> deleteCannedMessage(int? messageId) async {
    if (await _deleteCannedMessage(messageId)) {
      final messages = List.of(state.messages!);
      messages
          .removeAt(messages.indexWhere((element) => element.id == messageId));
      emit(state.copyWith(
        messages: List.of(messages),
      ));
    }
  }

  CannedCategory? getCategoryById(int id) {
    return state.categories!.firstWhereOrNull((element) => element.id == id);
  }

  Future<void> getCannedMessagesByCategory(int categoryIndex) async {
    if (categoryIndex != 0) {
      final selectedCategory = state.categories![categoryIndex - 1];
      await _getCannedMessages(selectedCategory.id);
    } else {
      await _getCannedMessages();
    }

    emit(state.copyWith(
      selectedCategoryIndex: categoryIndex,
    ));

    Utils.animateToWidget(cannedMessageManagerKey);
  }

  Future<void> _getCannedCategories() async {
    try {
      final CannedMessagesResponse response =
          await _zodiacCannedMessagesRepository
              .getCannedCategories(AuthorizedRequest());

      if (response.status == true && response.categories != null) {
        emit(state.copyWith(
          categories: List.of(response.categories!),
        ));
      }
    } catch (e) {
      logger.d(e);
      rethrow;
    }
  }

  Future<void> _getCannedMessages([int? categoryId]) async {
    try {
      final CannedMessagesResponse response =
          await _zodiacCannedMessagesRepository
              .getCannedMessages(CannedMessagesRequest(categoryId: categoryId));

      final List<CannedMessage>? messages = response.messages;
      if (response.status == true && messages != null) {
        emit(state.copyWith(
          messages: List.of(messages),
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
