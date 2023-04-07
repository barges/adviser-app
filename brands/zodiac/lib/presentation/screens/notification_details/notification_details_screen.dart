import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_advisor_interface/global.dart';
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
                  String? notificationContent = context.select(
                      (NotificationDetailsCubit cubit) =>
                          cubit.state.notificationContent);
                  logger.d(notificationContent);

                  return notificationContent != null
                      ? InAppWebView(
                          initialData: InAppWebViewInitialData(
                            data: notificationContent,
                          ),
                          initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                  useShouldOverrideUrlLoading: true)),
                          shouldOverrideUrlLoading:
                              (controller, navigationAction) async {
                            Uri? url = navigationAction.request.url;
                            logger.d(url);

                            if (url.toString().startsWith('zodiac://')) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Host: ${url?.host}\n'
                                    'Query parameters: ${url?.queryParameters}'),
                              ));
                              return NavigationActionPolicy.CANCEL;
                            } else {
                              return NavigationActionPolicy.ALLOW;
                            }
                          },
                        )
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
