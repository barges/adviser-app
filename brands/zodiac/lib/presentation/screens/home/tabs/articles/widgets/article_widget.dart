import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/articles/article.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_cubit.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;

  const ArticleWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();
    return GestureDetector(
      onTap: () async {
        if (article.id != null) {
          context.push(route: ZodiacArticleDetails(articleId: article.id!));
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
                      ((article.dateCreate ?? 0) * 1000),
                      isUtc: true))
                  .parseDateTimePattern2,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 12.0,
                    color: Theme.of(context).shadowColor,
                  ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
        child: Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).canvasColor,
                fontSize: 12.0,
              ),
        ),
      ),
    );
  }
}
