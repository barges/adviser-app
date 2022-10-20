import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ListOfArticlesWidget extends StatelessWidget {
  const ListOfArticlesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<VirtualArticleModel> articles = [
      const VirtualArticleModel(
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg',
          category: 'category 1',
          date: '2022-09-19T10:05:38.697Z',
          title: 'Title of the Article goes here',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dignissim pellentesque mi elit feugiat sed'),
      const VirtualArticleModel(
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg',
          category: 'category 2',
          date: '2022-07-19T10:05:38.697Z',
          title: 'Title of the Article goes here',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dignissim pellentesque mi elit feugiat sed'),
      const VirtualArticleModel(
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg',
          category: 'category 3',
          date: '2022-04-19T10:05:38.697Z',
          title: 'Title of the Article goes here',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dignissim pellentesque mi elit feugiat sed'),
      const VirtualArticleModel(
          imagePath:
              'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg',
          category: 'category 4',
          date: '2022-01-19T10:05:38.697Z',
          title: 'Title of the Article goes here',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dignissim pellentesque mi elit feugiat sed')
    ];
    return Padding(
      padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) => ArticleWidget(article: articles[index]),
          separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.horizontalScreenPadding),
              child: SizedBox(
                height: 1.0,
                child: Divider(),
              )),
          itemCount: articles.length),
    );
  }
}

class ArticleWidget extends StatelessWidget {
  final VirtualArticleModel article;

  const ArticleWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.articleDetails);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 184.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(article.imagePath, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.isNewArticle)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ArticleStatusWidget(
                                title: S.of(context).newLabel,
                                backgroundColor: AppColors.promotion),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      if (article.isMandatoryArticle)
                        ArticleStatusWidget(
                            title: S.of(context).mandatory,
                            gradient: const [
                              AppColors.ctaGradient1,
                              AppColors.ctaGradient2
                            ]),
                    ],
                  ),
                )
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.date.parseDateTimePattern2,
                      style: Get.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Get.theme.shadowColor),
                    ),
                    Text('#${article.category}',
                        style: Get.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Get.theme.primaryColor)),
                  ],
                ),
              ),
              Expanded(child: SizedBox.fromSize())
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(article.title, style: Get.textTheme.headlineMedium),
          ),
          Text(article.description,
              style: Get.textTheme.bodyMedium
                  ?.copyWith(color: Get.theme.shadowColor))
        ],
      ),
    );
  }
}

class ArticleStatusWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final List<Color>? gradient;

  const ArticleStatusWidget(
      {Key? key, required this.title, this.backgroundColor, this.gradient})
      : assert(backgroundColor == null || gradient == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 3.0),
      decoration: BoxDecoration(
          color: backgroundColor,
          gradient:
              gradient != null ? LinearGradient(colors: gradient ?? []) : null,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Text(title.toUpperCase(),
          style: Get.textTheme.labelMedium
              ?.copyWith(color: Get.theme.canvasColor)),
    );
  }
}

class VirtualArticleModel {
  final bool isNewArticle;
  final bool isMandatoryArticle;
  final String date;
  final String category;
  final String title;
  final String description;
  final String imagePath;

  const VirtualArticleModel(
      {this.isNewArticle = true,
      this.isMandatoryArticle = true,
      required this.date,
      required this.category,
      required this.title,
      required this.description,
      required this.imagePath});
}
