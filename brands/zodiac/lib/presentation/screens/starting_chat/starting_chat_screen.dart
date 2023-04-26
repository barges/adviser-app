import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chat/call_data.dart';
import 'package:zodiac/domain/repositories/zodiac_chats_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/starting_chat/starting_chat_cubit.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class StartingChatScreen extends StatelessWidget {
  final CallData callData;

  const StartingChatScreen({
    Key? key,
    required this.callData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (context) => StartingChatCubit(
        zodiacGetIt.get<WebSocketManager>(),
        zodiacGetIt.get<ZodiacChatsRepository>(),
      ),
      child: Builder(builder: (context) {
        final StartingChatCubit startingChatCubit =
            context.read<StartingChatCubit>();
        return Scaffold(
            backgroundColor: theme.canvasColor,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 68.0,
                        ),
                        Assets.zodiac.zodiacPsychicsLogo.svg(
                          width: 227.0,
                          height: 86.0,
                          color: AppColors.purple,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10.0),
                              Stack(
                                children: [
                                  AvatarGlow(
                                    endRadius: 81,
                                    duration:
                                        const Duration(milliseconds: 4000),
                                    glowColor: theme.primaryColorDark,
                                    child: UserAvatar(
                                      avatarUrl: callData.userData?.avatar,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(
                                        callData.userData?.name ?? '',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                SZodiac.of(context).chatRequestZodiac,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 15.0,
                                  color: theme.shadowColor,
                                ),
                              ),
                              const SizedBox(
                                height: 48.0,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 24.0),
                              //   child: Container(
                              //       width: MediaQuery.of(context).size.width,
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(12.0),
                              //         color: theme.secondaryHeaderColor,
                              //       ),
                              //       child: Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //           horizontal: 24.0,
                              //           vertical: 32.0,
                              //         ),
                              //         child: Column(children: [
                              //           Text(
                              //             SZodiac.of(context).helpfulTips,
                              //             style: theme.textTheme.labelMedium
                              //                 ?.copyWith(
                              //               fontSize: 17.0,
                              //             ),
                              //           ),
                              //           const SizedBox(height: 16.0),
                              //           Builder(builder: (context) {
                              //             final String? adviceTip =
                              //                 context.select(
                              //                     (StartingChatCubit cubit) =>
                              //                         cubit.state.adviceTip);
                              //             return Text(
                              //               //'How much time they have. There are short and long rituals',
                              //               adviceTip ?? '',
                              //               textAlign: TextAlign.center,
                              //               style: theme.textTheme.bodyMedium
                              //                   ?.copyWith(
                              //                 fontSize: 16.0,
                              //               ),
                              //             );
                              //           })
                              //         ]),
                              //       )),
                              // )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.horizontalScreenPadding,
                          ),
                          child: AppElevatedButton(
                            title: SZodiac.of(context).startChatZodiac,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () => startingChatCubit
                              .declineCall(callData.userData?.id),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.vectors.cross.svg(
                                height: AppConstants.iconSize,
                                width: AppConstants.iconSize,
                                color: theme.shadowColor,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                SZodiac.of(context).declineZodiac,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 17.0,
                                  color: theme.shadowColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
