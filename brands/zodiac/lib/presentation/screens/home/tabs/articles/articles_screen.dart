import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/home/home_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/widgets/list_of_articles_widget.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => zodiacGetIt.get<ArticlesCubit>(),
      child: Builder(builder: (BuildContext context) {
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        return Scaffold(
            appBar: HomeAppBar(
              title: SZodiac.of(context).articlesZodiac,
              iconPath: Assets.vectors.articles.path,
              bottomWidget: Builder(builder: (context) {
                return Opacity(
                  opacity: isOnline ? 1.0 : 0.4,
                );
              }),
            ),
            body: Builder(builder: (context) {
              if (isOnline) {
                return const ListOfArticlesWidget();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoConnectionWidget(),
                  ],
                );
              }
            }));
      }),
    );
  }
}
