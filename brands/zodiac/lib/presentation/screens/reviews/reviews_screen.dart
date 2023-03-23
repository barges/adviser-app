import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/review_item_zodiac.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/screens/reviews/reviews_cubit.dart';
import 'package:zodiac/presentation/screens/reviews/widgets/review_card_widget.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewsCubit(
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ZodiacCachingManager>(),
      ),
      child: Builder(
        builder: (context) {
          final ReviewsCubit reviewsCubit = context.read<ReviewsCubit>();
          final List<ZodiacReviewItem>? reviewList =
              context.select((ReviewsCubit cubit) => cubit.state.reviewList);
          return Scaffold(
            key: reviewsCubit.scaffoldKey,
            body: SafeArea(
              top: false,
              child: Builder(
                builder: (context) {
                  return RefreshIndicator(
                    onRefresh: reviewsCubit.refreshReviews,
                    notificationPredicate: (_) =>
                        !(reviewList?.isEmpty == true),
                    edgeOffset: AppConstants.appBarHeight * 2 +
                        MediaQuery.of(context).padding.top,
                    child: CustomScrollView(
                      controller: reviewsCubit.reviewScrollController,
                      physics: const ClampingScrollPhysics()
                          .applyTo(const AlwaysScrollableScrollPhysics()),
                      slivers: [
                        ScrollableAppBar(
                          title: SZodiac.of(context).reviewsZodiac,
                        ),
                        Builder(builder: (context) {
                          if (reviewList != null && reviewList.isNotEmpty) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.0,
                                        index == 0 ? 16.0 : 0.0,
                                        16.0,
                                        index != (reviewList.length - 1)
                                            ? 8.0
                                            : 16.0),
                                    child: ReviewCardWidget(
                                        item: reviewList[index]),
                                  );
                                },
                                childCount: reviewList.length,
                              ),
                            );
                          } else if (reviewList?.isEmpty == true) {
                            return SliverFillRemaining(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EmptyListWidget(
                                    title:
                                        SZodiac.of(context).noReviewsYetZodiac,
                                    label: SZodiac.of(context)
                                        .reviewsFromYourClientsWillAppearHereZodiac,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SliverFillRemaining(child: SizedBox());
                          }
                        })
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
