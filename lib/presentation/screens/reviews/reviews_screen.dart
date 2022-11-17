import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/reviews/reviews_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/reviews/widgets/review_card_widget.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => Get.put<ReviewsCubit>(ReviewsCubit()),
        child: Builder(builder: (context) {
          final ReviewsCubit reviewsCubit = context.read<ReviewsCubit>();
          return Scaffold(
            key: reviewsCubit.scaffoldKey,
            drawer: const AppDrawer(),
            body: SafeArea(
                top: false,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    ScrollableAppBar(
                      title: S.of(context).reviews,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                          padding: const EdgeInsets.all(
                              AppConstants.horizontalScreenPadding),
                          child: Column(
                            children: List.generate(
                                10,
                                (index) => const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppConstants
                                                  .horizontalScreenPadding /
                                              2),
                                      child: ReviewCardWidget(),
                                    )),
                          )),
                    )
                  ],
                )),
          );
        }));
  }
}
