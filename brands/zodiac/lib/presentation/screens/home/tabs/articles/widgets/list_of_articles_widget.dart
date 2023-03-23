import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/articles/article.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_cubit.dart';

class ListOfArticlesWidget extends StatelessWidget {
  const ListOfArticlesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
      child: Builder(builder: (context) {
        final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();
        final List<Article>? articleList =
            context.select((ArticlesCubit cubit) => cubit.state.articleList);
        if (articleList == null) {
          return const SizedBox.shrink();
        } else if (articleList.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () => articlesCubit.getArticles(refresh: true),
            child: ListView.separated(
                controller: articlesCubit.articlesScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (_, index) =>
                    _ArticleWidget(article: articleList[index]),
                separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 32.0),
                    child: SizedBox(
                      height: 1.0,
                      child: Divider(),
                    )),
                itemCount: articleList.length),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => articlesCubit.getArticles(refresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: EmptyListWidget(
                          title: 'No articles yet',
                          label: 'Here will appear articles',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class _ArticleWidget extends StatelessWidget {
  final Article article;

  const _ArticleWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();
    return GestureDetector(
      onTap: () async {
        if (article.id != null) {
          await context.push(
              route: ZodiacArticlesDetails(articleId: article.id!));
          articlesCubit.markAsRead(article.id!);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImageWidget(
                uri: Uri.parse(article.img ?? ''),
                width: MediaQuery.of(context).size.width,
                height: 184.0,
                radius: AppConstants.buttonRadius,
              ),
              if (!article.isRead)
                Positioned(
                  left: 12.0,
                  top: 12.0,
                  width: 40.0,
                  height: 18.0,
                  child: _ArticleStatusWidget(
                      title: SZodiac.of(context).newZodiac,
                      backgroundColor: AppColors.promotion),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              DateFormat(dateFormat)
                  .format(DateTime.fromMillisecondsSinceEpoch(
                      (article.dateCreate ?? 0) * 1000))
                  .parseDateTimePattern2,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).shadowColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(article.name ?? '',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(article.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).shadowColor)),
          )
        ],
      ),
    );
  }
}

class _ArticleStatusWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final List<Color>? gradient;

  const _ArticleStatusWidget(
      {Key? key, required this.title, this.backgroundColor, this.gradient})
      : assert(backgroundColor == null || gradient == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          gradient:
              gradient != null ? LinearGradient(colors: gradient ?? []) : null,
          borderRadius: BorderRadius.circular(4.0)),
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).canvasColor,
                fontSize: 12.0,
              ),
        ),
      ),
    );
  }
}
