import 'package:fortunica/data/models/enums/gender.dart';
import 'package:fortunica/fortunica_extensions.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/models/customer_info/customer_info.dart';
import 'package:fortunica/data/models/customer_info/note.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/customer_profile/customer_profile_cubit.dart';
import 'package:fortunica/presentation/common_widgets/customer_profile/widgets/notes_widget.dart';
import 'package:fortunica/presentation/common_widgets/customer_profile/widgets/question_properties_widget.dart';
import 'package:fortunica/presentation/common_widgets/user_avatar.dart';
import 'package:fortunica/presentation/screens/chat/chat_cubit.dart';
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart';

class CustomerProfileWidget extends StatelessWidget {
  final String customerId;
  final ValueChanged<CustomerProfileScreenArguments?>?
      updateClientInformationCallback;

  final ChatCubit? chatCubit;

  const CustomerProfileWidget({
    Key? key,
    required this.customerId,
    this.updateClientInformationCallback,
    this.chatCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerProfileCubit(
        customerId,
        updateClientInformationCallback,
        chatCubit,
      ),
      child: Builder(
        builder: (context) {
          final CustomerProfileCubit customerProfileCubit =
              context.read<CustomerProfileCubit>();

          final CustomerInfo? customerInfo = context
              .select((CustomerProfileCubit cubit) => cubit.state.customerInfo);
          final bool needRefresh = context
              .select((CustomerProfileCubit cubit) => cubit.state.needRefresh);
          final ThemeData theme = Theme.of(context);

          return RefreshIndicator(
            onRefresh: chatCubit != null
                ? chatCubit!.refreshChatInfo
                : customerProfileCubit.getData,
            notificationPredicate: (_) => needRefresh,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics()
                    .applyTo(const ClampingScrollPhysics()),
                child: Builder(
                  builder: (context) {
                    if (customerInfo == null) {
                      return ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                          )
                        ],
                      );
                    } else {

                      final Gender? gender = customerInfo.gender;
                      final DateTime? birthdate = customerInfo.birthdate;
                      return Column(
                        children: [
                          Container(
                            color: theme.canvasColor,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                AppConstants.horizontalScreenPadding,
                                vertical: 24.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    UserAvatar(
                                      avatarUrl: customerInfo.zodiac
                                          ?.imagePath(context),
                                      diameter: 96.0,
                                      isZodiac: true,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants
                                          .horizontalScreenPadding),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                        ),
                                        child: Builder(builder: (context) {
                                          final String? firstName =
                                              customerInfo.firstName;
                                          final String? lastName =
                                              customerInfo.lastName;
                                          return Text(
                                            firstName != null &&
                                                lastName != null
                                                ? '$firstName $lastName'
                                                : SFortunica.of(context)
                                                .notSpecifiedFortunica,
                                            textAlign: TextAlign.center,
                                            style: theme
                                                .textTheme.headlineMedium,
                                          );
                                        }),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          if (birthdate !=
                                              null)
                                            Text(
                                              DateFormat(datePattern5)
                                                  .format(
                                                birthdate
                                                    .toLocal(),
                                              )
                                                  .capitalize ??
                                                  '',
                                              style: theme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: theme.shadowColor,
                                              ),
                                            ),
                                          if (gender != null ||
                                              birthdate !=
                                                  null)
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                Container(
                                                  width: 4.0,
                                                  height: 4.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          90.0),
                                                      color:
                                                      theme.hintColor),
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                              ],
                                            ),
                                          if (gender != null)
                                            Text(
                                              gender.name(context),
                                              style: theme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: theme.shadowColor,
                                              ),
                                            )
                                        ],
                                      ),
                                    ],
                                  )),
                              Builder(builder: (context) {
                                final List<String>? questionProperties =
                                customerInfo.advisorMatch?.values
                                    .toList();
                                return (questionProperties != null &&
                                    questionProperties.isNotEmpty)
                                    ? Column(
                                  children: [
                                    const SizedBox(
                                        height: AppConstants
                                            .horizontalScreenPadding),
                                    Wrap(
                                      runSpacing: 8.0,
                                      children: [
                                        QuestionPropertiesWidget(
                                          properties:
                                          questionProperties,
                                        )
                                      ],
                                    )
                                  ],
                                )
                                    : const SizedBox.shrink();
                              }),
                            ]),
                          ),
                          Builder(builder: (context) {
                            final List<Note>? notes = context.select(
                                    (CustomerProfileCubit cubit) =>
                                cubit.state.notes);
                            return NotesWidget(
                              notes: notes,
                              images: const [
                                [
                                  //'https://cdn.shopify.com/s/files/1/0275/3318/0970/products/AgendaNotebook-2_800x.jpg'
                                ],
                              ],
                            );
                          })
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
