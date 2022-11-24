import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/narrow_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/widgets/customer_session_tile_widget.dart';

class CustomerSessionsScreen extends StatelessWidget {
  const CustomerSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CustomerSessionsCubit(),
        child: Builder(builder: (context) {
          final CustomerSessionsCubit customerSessionsCubit =
              context.read<CustomerSessionsCubit>();
          return Scaffold(

              ///TODO - Replace hardcode!(appbar values)
              appBar: NarrowAppBar(
                title: 'Annette Black',
                zodiac: ZodiacSign.capricorn.imagePath(context),
              ),
              body: Column(
                children: [
                  Builder(builder: (context) {
                    final int currentFilterIndex = context.select(
                        (CustomerSessionsCubit cubit) =>
                            cubit.state.currentFilterIndex);
                    return ListOfFiltersWidget(
                      currentFilterIndex: currentFilterIndex,
                      onTapToFilter: customerSessionsCubit.changeFilterIndex,
                      filters: customerSessionsCubit.filters
                          .map((e) => e.filterName)
                          .toList(),
                    );
                  }),
                  Builder(builder: (context) {
                    List<ChatItem> items = customerSessionsCubit.items;
                    return Expanded(
                      child: CustomScrollView(
                          controller: ScrollController(),
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: ListView.separated(
                                padding: const EdgeInsets.all(
                                    AppConstants.horizontalScreenPadding),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return CustomerSessionListTileWidget(
                                      item: items[index]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(
                                  height: 12.0,
                                ),
                                itemCount: items.length,
                              ),
                            )
                          ]),
                    );
                  }),
                ],
              ));
        }));
  }
}
