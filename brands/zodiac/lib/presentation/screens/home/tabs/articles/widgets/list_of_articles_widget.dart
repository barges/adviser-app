import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/articles/article.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/widgets/article_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ListOfArticlesWidget extends StatelessWidget {
  const ListOfArticlesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ZodiacMainCubit mainCubit =
        context.read<ZodiacMainCubit>();
    return Padding(
      padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
      child: Builder(builder: (context) {
        final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();
        final List<Article>? articleList =
            context.select((ArticlesCubit cubit) => cubit.state.articleList);
        return RefreshIndicator(
          onRefresh: () {
            mainCubit.updateArticleCount();
            return articlesCubit.getArticles(refresh: true);
          },
          child: Builder(builder: (context) {
            if (articleList == null) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                  )
                ],
              );
            } else if (articleList.isNotEmpty) {
              return ListView.separated(
                  controller: articlesCubit.articlesScrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) =>
                      ArticleWidget(article: articleList[index]),
                  separatorBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 32.0),
                      child: SizedBox(
                        height: 1.0,
                        child: Divider(),
                      )),
                  itemCount: articleList.length);
            } else {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: EmptyListWidget(
                            title: SZodiac.of(context).noArticlesYet,
                            label: SZodiac.of(context).hereWillAppearArticles,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
        );
      }),
    );
  }
}