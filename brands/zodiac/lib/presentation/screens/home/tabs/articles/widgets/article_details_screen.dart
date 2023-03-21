import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors_light.dart';
import 'package:zodiac/data/models/articles/article_content.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/appbar/transparrent_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_cubit.dart';

class ArticleDetailsScreen extends StatelessWidget {
  const ArticleDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ArticlesCubit(
        zodiacGetIt.get<ZodiacArticlesRepository>(),
      )..getArticleContent(143),
      child: Builder(builder: (context) {
        final ArticleContent? articleContent =
            context.select((ArticlesCubit cubit) => cubit.state.articleContent);
        return Scaffold(
          body: Stack(
            fit: StackFit.passthrough,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (articleContent?.img != null)
                      AppImageWidget(
                        uri: Uri.parse(articleContent?.img ?? ''),
                        width: MediaQuery.of(context).size.width,
                        height: 220.0,
                      ),
                    if (articleContent?.img == null)
                      Container(
                        height: 220.0,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: SvgPicture.asset(
                              width: AppConstants.iconSize,
                              Assets.vectors.placeholderCoverImage.path),
                        ),
                      ),
                    Container(
                      color: Theme.of(context).canvasColor,
                      padding: const EdgeInsets.fromLTRB(
                          AppConstants.horizontalScreenPadding,
                          12.0,
                          AppConstants.horizontalScreenPadding,
                          AppConstants.horizontalScreenPadding),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(articleContent?.name ?? '',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const UserAvatar(
                                        diameter: 36.0,
                                        avatarUrl:
                                            'https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg'),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Column(children: [

                                        Text(
                                          'Psychic Cilla',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          DateFormat(dateFormat)
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      (articleContent
                                                                  ?.dateCreate ??
                                                              0) *
                                                          1000))
                                              .parseDateTimePattern1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .shadowColor),
                                        ),
                                      ]),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: HtmlWidget(
                                articleContent?.content ?? '',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context).shadowColor),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              const TransparentAppBar()
            ],
          ),
        );
      }),
    );
  }
}
