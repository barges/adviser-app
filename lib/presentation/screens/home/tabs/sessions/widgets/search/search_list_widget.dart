import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/search/search_list_cubit.dart';

class SearchListWidget extends StatelessWidget {
  final VoidCallback closeOnTap;
  final MarketsType marketsType;

  const SearchListWidget({
    Key? key,
    required this.closeOnTap,
    required this.marketsType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchListCubit(
        getIt.get<ChatsRepository>(),
        context,
        closeOnTap,
      ),
      child: BlocListener<MainCubit, MainState>(
        listener: (_, state) {
          if (!state.internetConnectionIsAvailable) {
            closeOnTap();
          }
        },
        child: Builder(builder: (context) {
          final SearchListCubit searchListCubit =
              context.read<SearchListCubit>();
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).canvasColor,
                  height: AppConstants.appBarHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: _SearchFieldWidget(
                          controller: searchListCubit.searchTextController,
                          onChanged: searchListCubit.changeText,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      AppIconButton(
                        icon: Assets.vectors.close.path,
                        onTap: closeOnTap,
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
                Builder(builder: (context) {
                  final List<ChatItem> conversationsList = context.select(
                      (SearchListCubit cubit) => cubit.state.conversationsList);

                  return Expanded(
                    child: Container(
                      color: Theme.of(context).canvasColor,
                      child: ListView.separated(
                        controller:
                            searchListCubit.conversationsScrollController,
                        padding: const EdgeInsets.all(
                          AppConstants.horizontalScreenPadding,
                        ),
                        itemBuilder: (_, index) {
                          final ChatItem question = conversationsList[index];
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              searchListCubit.goToCustomerSessions(
                                  conversationsList[index]);
                            },
                            child: SizedBox(
                              height: 42.0,
                              child: Row(
                                children: [
                                  UserAvatar(
                                    avatarUrl: question
                                        .clientInformation?.zodiac
                                        ?.imagePath(context),
                                    isZodiac: true,
                                    diameter: 42,
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      question.clientName ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontSize: 15.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 10.0,
                        ),
                        itemCount: conversationsList.length,
                      ),
                    ),
                  );
                })
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchFieldWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 8.0,
            ),
            child: Assets.vectors.search.svg(
              color: Theme.of(context).shadowColor,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 17.0,
                  ),
              decoration: InputDecoration(
                hintText: S.of(context).search,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 17.0,
                      color: Theme.of(context).shadowColor,
                    ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 4.0,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
