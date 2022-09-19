import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar_with_change_language_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/widgets/list_of_articles_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/widgets/percentage_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/widgets/slider_widget.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ArticlesCubit(),
      child: Builder(builder: (BuildContext context) => const _BuildUI()),
    );
  }
}

class _BuildUI extends StatelessWidget {
  const _BuildUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();
    return Scaffold(
        appBar: SimpleAppBarWithChangeLanguageWidget(
            title: S.of(context).articles, iconPath: Assets.vectors.check.path),
        body: Column(
          children: [
            Builder(builder: (context) {
              final int selectedFilterIndex = context.select(
                  (ArticlesCubit cubit) => cubit.state.selectedFilterIndex);
              final List<String> filters = [
                S.of(context).all,
                S.of(context).onlyPremiumProducts,
                S.of(context).privateQuestions,
              ];
              final List<VoidCallback> onTaps = filters
                  .map((e) =>
                      () => articlesCubit.updateFilterIndex(filters.indexOf(e)))
                  .toList();
              return ListOfFiltersWidget(
                currentFilterIndex: selectedFilterIndex,
                filters: filters,
                onTaps: onTaps,
              );
            }),
            const PercentageWidget(),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: const [SliderWidget(), ListOfArticlesWidget()],
              )),
            )
          ],
        ));
  }
}
