import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/article_details/article_details_state.dart';

class ArticleDetailsCubit extends Cubit<ArticleDetailsState> {
  final BuildContext context;

  ArticleDetailsCubit(this.context) : super(const ArticleDetailsState()) {
    scrollController.addListener(addScrollControllerListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => emit(state.copyWith(
        articleReadPercentage:
            (numberOfLines(MediaQuery.of(context).size.height - 200.0) /
                    numberOfLines(MediaQuery.of(context).size.height -
                        scrollController.offset))
                .toDouble())));
  }

  ScrollController scrollController = ScrollController();

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  //TODO -- remove it later...
  final String description =
      'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.';

  void addScrollControllerListener() {
    if (state.articleReadPercentage < 1) {
      emit(state.copyWith(
          articleReadPercentage: min(
              1.0,
              numberOfLines(MediaQuery.of(context).size.height - 200.0) /
                  numberOfLines(MediaQuery.of(context).size.height -
                      scrollController.offset))));
    }
  }

  int numberOfLines(double value) {
    try {
      return (description.length /
              (MediaQuery.of(context).size.width * 0.12)) ~/
          (MediaQuery.of(context).size.height / value);
    } catch (_) {
      return 0;
    }
  }

  void editFavoriteValue() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }
}
