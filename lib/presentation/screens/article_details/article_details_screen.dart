import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/transparrent_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/di/mixins/share_mixin.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/article_details/article_details_cubit.dart';

class ArticleDetailsScreen extends StatelessWidget with ShareMixin {
  //TODO - add article object
  const ArticleDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_VirtualArticleModel> similarArticles = [
      const _VirtualArticleModel(
          title: 'title',
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg'),
      const _VirtualArticleModel(
          title: 'title',
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg'),
      const _VirtualArticleModel(
          title: 'title',
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg'),
      const _VirtualArticleModel(
          title: 'title',
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg'),
    ];
    return BlocProvider(
      create: (BuildContext context) => ArticleDetailsCubit(),
      child: Builder(builder: (context) {
        final ArticleDetailsCubit articleDetailsCubit =
            context.read<ArticleDetailsCubit>();
        return Scaffold(
            body: Stack(
              fit: StackFit.passthrough,
              children: [
                SingleChildScrollView(
                  controller: articleDetailsCubit.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg',
                        fit: BoxFit.cover,
                        height: 220.0,
                        width: Get.width,
                      ),
                      Container(
                        color: Get.theme.canvasColor,
                        padding: const EdgeInsets.fromLTRB(
                            AppConstants.horizontalScreenPadding,
                            12.0,
                            AppConstants.horizontalScreenPadding,
                            AppConstants.horizontalScreenPadding),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Late Spring Solar Eclipse Ignites Creative Instincts',
                                  style: Get.textTheme.headlineMedium),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const UserAvatar(
                                          diameter: 36.0,
                                          avatarUrl:
                                              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Column(children: [
                                          Text(
                                            'Psychic Cilla',
                                            style: Get.textTheme.bodySmall
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Text(
                                            '2022-09-19T10:05:38.697Z'
                                                .parseDateTimePattern1,
                                            style: Get.textTheme.displaySmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Get.theme.shadowColor),
                                          ),
                                        ]),
                                      )
                                    ]),
                              ),
                              Text(
                                articleDetailsCubit.description,
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Get.theme.shadowColor),
                              )
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppConstants.horizontalScreenPadding),
                                child: Text(
                                  S.of(context).similarArticles,
                                  style: Get.textTheme.headlineMedium,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                  height: 116.0,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(
                                          left: AppConstants
                                              .horizontalScreenPadding),
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (_, index) =>
                                          _SimilarArticleWidget(
                                              similarArticle:
                                                  similarArticles[index]),
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(
                                              width: AppConstants
                                                  .horizontalScreenPadding),
                                      itemCount: similarArticles
                                          .length) /*SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  child: Row(
                                      children: similarArticles
                                          .mapIndexed((element, index) =>
                                              _SimilarArticleWidget(
                                                  similarArticle: element))
                                          .toList()),
                                ),*/
                                  ),
                            ]),
                      )
                    ],
                  ),
                ),
                const TransparentAppBar()
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(builder: (context) {
                  final double articleReadPercentage = context.select(
                      (ArticleDetailsCubit cubit) =>
                          cubit.state.articleReadPercentage);
                  return LinearProgressIndicator(
                    value: articleReadPercentage,
                  );
                }),
                Container(
                  height: 62.0,
                  color: Get.theme.canvasColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 14.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Assets.vectors.letters.svg(),
                        ),
                        GestureDetector(
                          onTap: articleDetailsCubit.editFavoriteValue,
                          child: Builder(builder: (context) {
                            final bool isFavorite = context.select(
                                (ArticleDetailsCubit cubit) =>
                                    cubit.state.isFavorite);

                            return isFavorite
                                ? Assets.vectors.filledFav.svg()
                                : Assets.vectors.fav.svg();
                          }),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickAndShareImage(context);
                          },
                          child: Assets.vectors.share.svg(),
                        )
                      ]),
                ),
              ],
            ));
      }),
    );
  }
}

class _SimilarArticleWidget extends StatelessWidget {
  final _VirtualArticleModel similarArticle;

  const _SimilarArticleWidget({Key? key, required this.similarArticle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 134.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            child: Image.network(similarArticle.imagePath,
                fit: BoxFit.cover, height: 75.0, width: 134.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            similarArticle.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

//TODO -- remove it later
class _VirtualArticleModel {
  final String imagePath;
  final String title;

  const _VirtualArticleModel({required this.imagePath, required this.title});
}
