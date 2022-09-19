import 'package:bloc/bloc.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit() : super(const ArticlesState());

  void updateFilterIndex(int index) {
    emit(state.copyWith(selectedFilterIndex: index));
  }

  void updatePercentageValue(int newValue) {
    emit(state.copyWith(percentageValue: newValue));
  }

  void updateSliderIndex(int index) {
    emit(state.copyWith(sliderIndex: index));
  }
}
