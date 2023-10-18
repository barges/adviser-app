import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_constants.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_cubit.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_state.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/auto_reply_body_widget.dart';

class AutoReplyScreen extends StatelessWidget {
  const AutoReplyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => zodiacGetIt.get<AutoReplyCubit>(),
      child: Builder(builder: (context) {
        final AutoReplyCubit autoReplyCubit = context.read<AutoReplyCubit>();

        final bool autoReplyEnabled = context
            .select((AutoReplyCubit cubit) => cubit.state.autoReplyEnabled);

        final bool dataFetched =
            context.select((AutoReplyCubit cubit) => cubit.state.dataFetched);

        return Scaffold(
          appBar: WideAppBar(
            bottomWidget: Text(
              SZodiac.of(context).autoReplyZodiac,
              style: theme.textTheme.headlineMedium,
            ),
            topRightWidget: dataFetched
                ? Builder(
                    builder: (context) {
                      bool buttonEnabled =
                          context.select((AutoReplyCubit cubit) {
                        final AutoReplyState state = cubit.state;

                        bool result;

                        if (state.autoReplyEnabled) {
                          String? selectedMessage = state.messages
                              ?.firstWhereOrNull((element) =>
                                  element.id == state.selectedMessageId)
                              ?.message;

                          if (selectedMessage != null) {
                            if (cubit.isSingleTimeMessage(selectedMessage)) {
                              result = state.time != AutoReplyConstants.time;
                            } else if (cubit
                                .isMultiTimeMessage(selectedMessage)) {
                              result = state.timeFrom !=
                                      AutoReplyConstants.timeFrom &&
                                  state.timeTo != AutoReplyConstants.timeTo;
                            } else {
                              result = true;
                            }
                          } else {
                            result = false;
                          }
                        } else {
                          result = true;
                        }

                        return result;
                      });

                      return Opacity(
                        opacity: buttonEnabled ? 1.0 : 0.4,
                        child: AppIconButton(
                          icon: Assets.vectors.check.path,
                          onTap: buttonEnabled
                              ? () => autoReplyCubit.saveChanges(context)
                              : null,
                        ),
                      );
                    },
                  )
                : null,
            bottomRightWidget: dataFetched
                ? CupertinoSwitch(
                    value: autoReplyEnabled,
                    onChanged: autoReplyCubit.onAutoReplyEnabledChange,
                    activeColor: theme.primaryColor,
                    trackColor: theme.hintColor,
                  )
                : null,
          ),
          body: dataFetched
              ? AutoReplyBodyWidget(autoReplyEnabled: autoReplyEnabled)
              : Builder(builder: (context) {
                  final bool internetConnectionIsAvailable = context.select(
                      (MainCubit cubit) =>
                          cubit.state.internetConnectionIsAvailable);
                  if (internetConnectionIsAvailable) {
                    final bool alreadyTriedToFetchData = context.select(
                        (AutoReplyCubit cubit) =>
                            cubit.state.alreadyTriedToFetchData);
                    if (alreadyTriedToFetchData) {
                      return RefreshIndicator(
                        onRefresh: autoReplyCubit.getInitialData,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics()
                              .applyTo(const ClampingScrollPhysics()),
                          slivers: const [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: SomethingWentWrongWidget(),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const CustomScrollView(
                      physics: ClampingScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NoConnectionWidget(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
        );
      }),
    );
  }
}
