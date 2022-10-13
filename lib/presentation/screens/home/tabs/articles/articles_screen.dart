import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
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
      child: Builder(builder: (BuildContext context) {
        final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();
        return Scaffold(
            appBar: WideAppBar(
              title: S.of(context).articles,
              iconPath: Assets.vectors.check.path,
              bottomWidget: Builder(builder: (context) {
                final int selectedFilterIndex = context.select(
                        (ArticlesCubit cubit) => cubit.state.selectedFilterIndex);
                final List<String> filters = [
                  'All',
                  'Only Premium Products',
                  'Private Questions',
                  'Market: '
                ];
                return ListOfFiltersWidget(
                  currentFilterIndex: selectedFilterIndex,
                  filters: filters,
                  onTap: articlesCubit.updateFilterIndex,
                );
              }),
            ),
            body: Column(
              children: [
                const PercentageWidget(),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    children: const [SliderWidget(), ListOfArticlesWidget()],
                  )),
                )
              ],
            ));
      }),
    );
  }
}
