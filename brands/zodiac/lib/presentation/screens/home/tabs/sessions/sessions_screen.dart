import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/domain/repositories/zodiac_chats_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/widgets/zodiac_chat_list_tile_widget.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionsCubit(
        zodiacGetIt.get<ZodiacChatsRepository>(),
        zodiacGetIt.get<BrandManager>(),
        MediaQuery.of(context).size.height,
      ),
      child: Builder(builder: (context) {
        final SessionsCubit zodiacSessionsCubit = context.read<SessionsCubit>();
        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: const HomeAppBar(withBrands: true),
          body: SafeArea(child: Builder(builder: (context) {
            final List<ZodiacChatsListItem>? chatsList =
                context.select((SessionsCubit cubit) => cubit.state.chatList);

            return chatsList != null
                ? chatsList.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: zodiacSessionsCubit.refreshChatsList,
                        child: CustomScrollView(
                            shrinkWrap: true,
                            controller:
                                zodiacSessionsCubit.chatsListScrollController,
                            physics: const ClampingScrollPhysics()
                                .applyTo(const AlwaysScrollableScrollPhysics()),
                            slivers: [
                              const SliverPersistentHeader(
                                delegate: _SearchTextField(),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      AppConstants.horizontalScreenPadding),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: chatsList.length,
                                    itemBuilder: (context, index) {
                                      final ZodiacChatsListItem item =
                                          chatsList[index];

                                      return GestureDetector(
                                        onTap: () {
                                          _goToChatHistory(context, item);
                                        },
                                        child: ZodiacChatListTileWidget(
                                          item: item,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 25.0),
                                  ),
                                ),
                              ),
                            ]),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppConstants.horizontalScreenPadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EmptyListWidget(
                                    title:
                                        SZodiac.of(context).noSessionsYetZodiac,
                                    label: SZodiac.of(context)
                                        .yourClientSessionHistoryWillAppearHereZodiac,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                : const SizedBox.shrink();
          })),
        );
      }),
    );
  }

  void _goToChatHistory(BuildContext context, ZodiacChatsListItem item) {
    context.push(
      route: ZodiacChat(
        userData: UserData(
          id: item.userId,
          avatar: item.avatar,
          name: item.name,
        ),
      ),
    );
  }
}

class _SearchTextField extends SliverPersistentHeaderDelegate {
  const _SearchTextField() : super();

  @override
  double get maxExtent => 53.0;

  @override
  double get minExtent => 1.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final SessionsCubit zodiacSessionsCubit = context.read<SessionsCubit>();
    final double height = maxExtent - shrinkOffset - 21.0;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: height > 0 ? 10.0 : 0.0,
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          child: Container(
            height: height > 0 ? height : 0.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 12.0,
              ),
              child: Row(
                children: [
                  Assets.vectors.search.svg(
                    height: AppConstants.iconSize,
                    width: AppConstants.iconSize,
                    color: Theme.of(context).shadowColor,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: zodiacSessionsCubit.searchEditingController,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 17.0,
                          ),
                      decoration: InputDecoration(
                        hintText: SZodiac.of(context).searchZodiac,
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 17.0,
                                  color: Theme.of(context).shadowColor,
                                ),
                        isCollapsed: true,
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
                  )
                ],
              ),
            ),
          ),
        ),
        const Divider(
          height: 1.0,
        ),
      ],
    );
  }
}
