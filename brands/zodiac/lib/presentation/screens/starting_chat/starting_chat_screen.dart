import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';

class StartingChatScreen extends StatelessWidget {
  const StartingChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.canvasColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 52.0,
                          ),
                          Text(
                            'Starting chat with...',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Stack(
                            children: [
                              AvatarGlow(
                                endRadius: 81,
                                duration: const Duration(milliseconds: 4000),
                                glowColor: theme.primaryColorDark,
                                child: const UserAvatar(
                                  avatarUrl: '',
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Center(
                                  child: Text(
                                    'Whale',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 48.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: theme.secondaryHeaderColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 32.0,
                                  ),
                                  child: Column(children: [
                                    Text(
                                      'Helpful tips:',
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      'How much time they have. There are short and long rituals',
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 16.0,
                                      ),
                                    )
                                  ]),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: AppElevatedButton(
                        title: 'Start Chat',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          'Decline',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 17.0,
                            color: theme.shadowColor,
                          ),
                        )
                      ],
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
  }
}
