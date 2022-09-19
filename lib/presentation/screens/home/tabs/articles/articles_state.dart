import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState([
    @Default(0) int selectedFilterIndex,
    @Default(0) int percentageValue,
    @Default(0) int sliderIndex,
  ]) = _ArticlesState;
}
