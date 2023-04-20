import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/notification/notification_item.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/notifications/notifications_cubit.dart';
import 'package:zodiac/presentation/screens/notifications/widgets/notifications_list_tile_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<ConnectivityService>(),
      ),
      child: Builder(builder: (context) {
        final NotificationsCubit notificationsCubit =
            context.read<NotificationsCubit>();
        final List<NotificationItem>? notifications = context
            .select((NotificationsCubit cubit) => cubit.state.notifications);
        final bool internetConnectionIsAvailable = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

        return Scaffold(
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () =>
                  notificationsCubit.getNotifications(refresh: true),
              edgeOffset: (AppConstants.appBarHeight * 2) +
                  MediaQuery.of(context).padding.top,
              notificationPredicate: (_) => internetConnectionIsAvailable,
              child: CustomScrollView(
                controller: notificationsCubit.scrollController,
                physics: notifications?.isEmpty == true ||
                        !internetConnectionIsAvailable
                    ? const NeverScrollableScrollPhysics()
                    : null,
                slivers: [
                  ScrollableAppBar(
                    title: SZodiac.of(context).notificationsZodiac,
                  ),
                  internetConnectionIsAvailable
                      ? notifications != null
                          ? notifications.isNotEmpty
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        0,
                                        index == 0 ? 16.0 : 0.0,
                                        0.0,
                                        index == notifications.length - 1
                                            ? 8.0
                                            : 0.0,
                                      ),
                                      child: NotificationsListTileWidget(
                                        item: notifications[index],
                                      ),
                                    ),
                                    childCount: notifications.length,
                                  ),
                                )
                              : SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppConstants.horizontalScreenPadding,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Spacer(flex: 1),
                                        EmptyListWidget(
                                          title: SZodiac.of(context)
                                              .noNotificationsYetZodiac,
                                          label: SZodiac.of(context)
                                              .yourNotificationsHistoryWillAppearHereZodiac,
                                        ),
                                        const Spacer(flex: 2)
                                      ],
                                    ),
                                  ),
                                )
                          : const SliverFillRemaining(
                              child: SizedBox.shrink(),
                            )
                      : SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              NoConnectionWidget(),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
