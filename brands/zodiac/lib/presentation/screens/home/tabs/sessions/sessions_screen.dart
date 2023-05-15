import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/domain/repositories/zodiac_sessions_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/widgets/zodiac_chat_list_tile_widget.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionsCubit(
        zodiacGetIt.get<ZodiacSessionsRepository>(),
        zodiacGetIt.get<BrandManager>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<WebSocketManager>(),
        MediaQuery.of(context).size.height,
      ),
      child: Builder(builder: (context) {
        final SessionsCubit zodiacSessionsCubit = context.read<SessionsCubit>();
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: const HomeAppBar(withBrands: true),
            body: SafeArea(child: Builder(builder: (context) {
              final bool isOnline = context.select((MainCubit cubit) =>
                  cubit.state.internetConnectionIsAvailable);
              final AppError appError = context
                  .select((ZodiacMainCubit cubit) => cubit.state.appError);
              return Stack(
                children: [
                  Builder(builder: (context) {
                    final List<ZodiacChatsListItem>? chatsList = context
                        .select((SessionsCubit cubit) => cubit.state.chatList);

                    if (!isOnline) {
                      return CustomScrollView(slivers: [
                        SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                NoConnectionWidget(),
                              ],
                            )),
                      ]);
                    } else if (chatsList != null) {
                      if (chatsList.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: zodiacSessionsCubit.refreshChatsList,
                          child: SlidableAutoCloseBehavior(
                            child: CustomScrollView(
                              controller:
                                  zodiacSessionsCubit.chatsListScrollController,
                              physics: const ClampingScrollPhysics().applyTo(
                                  const AlwaysScrollableScrollPhysics()),
                              slivers: [
                                const SliverPersistentHeader(
                                  delegate: _SearchTextField(),
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 12.0,
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: chatsList.length,
                                    (context, index) {
                                      final ZodiacChatsListItem item =
                                          chatsList[index];

                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              _goToChatHistory(context, item);
                                            },
                                            child: ZodiacChatListTileWidget(
                                              item: item,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: zodiacSessionsCubit.refreshChatsList,
                          child: CustomScrollView(
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
                                        title: SZodiac.of(context)
                                            .noSessionsYetZodiac,
                                        label: SZodiac.of(context)
                                            .yourClientSessionHistoryWillAppearHereZodiac,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      return RefreshIndicator(
                        onRefresh: zodiacSessionsCubit.refreshChatsList,
                        child: const CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                                hasScrollBody: false, child: SizedBox()),
                          ],
                        ),
                      );
                    }
                  }),
                  if (isOnline)
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: AppErrorWidget(
                        errorMessage: appError.getMessage(context),
                        close: zodiacSessionsCubit.clearErrorMessage,
                      ),
                    )
                ],
              );
            })),
          ),
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
