import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/widgets/list_of_articles_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticlesCubit(
        zodiacGetIt.get<ZodiacArticlesRepository>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<BrandManager>(),
      ),
      child: Builder(builder: (BuildContext context) {
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        return Scaffold(
            appBar: HomeAppBar(
              title: SZodiac.of(context).articlesZodiac,
              iconPath: Assets.vectors.articles.path,
            ),
            body: SafeArea(
              child: Builder(builder: (context) {
                if (isOnline) {
                  return Stack(
                    children: [
                      const ListOfArticlesWidget(),
                      Positioned(
                          top: 0.0,
                          right: 0.0,
                          left: 0.0,
                          child: Builder(builder: (context) {
                            final AppError appError = context.select(
                                (ZodiacMainCubit cubit) =>
                                    cubit.state.appError);
                            return AppErrorWidget(
                              errorMessage: appError.getMessage(context),
                              close: context
                                  .read<ZodiacMainCubit>()
                                  .clearErrorMessage,
                            );
                          }))
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoConnectionWidget(),
                    ],
                  );
                }
              }),
            ));
      }),
    );
  }
}
