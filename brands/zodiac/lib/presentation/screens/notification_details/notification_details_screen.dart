import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/transparrent_app_bar.dart';
import 'package:zodiac/presentation/screens/notification_details/notification_details_cubit.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final int pushId;
  final bool needRefreshList;

  const NotificationDetailsScreen({
    Key? key,
    required this.pushId,
    required this.needRefreshList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationDetailsCubit(
        pushId,
        needRefreshList,
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Builder(builder: (context) {
                  final String? notificationContent = context.select(
                      (NotificationDetailsCubit cubit) =>
                          cubit.state.notificationContent);
                  final bool loadStopped = context.select(
                      (NotificationDetailsCubit cubit) =>
                          cubit.state.loadStopped);

                  return notificationContent != null
                      ? IndexedStack(index: loadStopped ? 0 : 1, children: [
                          InAppWebView(
                            initialData: InAppWebViewInitialData(
                              data: notificationContent,
                            ),
                            initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                useShouldOverrideUrlLoading: true,
                                supportZoom: false,
                              ),
                            ),
                            onLoadStop: (_, __) {
                              final NotificationDetailsCubit
                                  notificationDetailsCubit =
                                  context.read<NotificationDetailsCubit>();

                              notificationDetailsCubit.stopLoading();
                            },
                            shouldOverrideUrlLoading:
                                (controller, navigationAction) async {
                              Uri? url = navigationAction.request.url;
                              logger.d(url);
                              if (url != null) {
                                if (url.scheme.startsWith('http')) {
                                  launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else if (url.scheme == 'zodiac') {
                                  final NotificationDetailsCubit
                                      notificationDetailsCubit =
                                      context.read<NotificationDetailsCubit>();
                                  notificationDetailsCubit
                                      .navigateFromNotification(context,
                                          url.host, url.queryParameters);
                                }
                              }

                              return NavigationActionPolicy.CANCEL;
                            },
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ])
                      : const SizedBox.shrink();
                }),
              ),
              const Positioned(
                  top: 0.0, right: 0.0, left: 0.0, child: TransparentAppBar()),
            ],
          ),
        ),
      ),
    );
  }
}
