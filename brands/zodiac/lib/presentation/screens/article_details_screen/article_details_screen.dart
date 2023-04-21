import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zodiac/data/models/articles/article_content.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/appbar/transparrent_app_bar.dart';
import 'package:zodiac/presentation/screens/article_details_screen/article_details_cubit.dart';
import 'package:zodiac/zodiac.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final int articleId;

  const ArticleDetailsScreen({Key? key, required this.articleId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticleDetailsCubit(
        zodiacGetIt.get<ZodiacArticlesRepository>(),
        zodiacGetIt.get<ConnectivityService>(),
        articleId,
      ),
      child: Builder(builder: (context) {
        final ArticleContent? articleContent = context
            .select((ArticleDetailsCubit cubit) => cubit.state.articleContent);
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
                            if (articleContent != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        width: 36.0,
                                        ZodiacBrand().iconPath,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                SZodiac.of(context).zodiacTeam,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .hoverColor),
                                              ),
                                              if (articleContent.dateCreate !=
                                                  null)
                                                Text(
                                                  DateFormat(dateFormat)
                                                      .format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              (articleContent
                                                                      .dateCreate!) *
                                                                  1000))
                                                      .parseDateTimePattern1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontSize: 12.0,
                                                          color:
                                                              Theme.of(context)
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
                                onTapUrl: (url) async {
                                  if (!await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Could not launch $url'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                  return true;
                                },
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              TransparentAppBar(
                needShowInternetError: articleContent == null,
              ),
            ],
          ),
        );
      }),
    );
  }
}
