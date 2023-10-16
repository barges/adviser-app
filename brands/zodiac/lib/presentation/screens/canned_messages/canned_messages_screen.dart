import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/canned_messages_body_widget.dart';

const verticalInterval = 24.0;
const scrollPositionToShowMessages = 620.0;

class CannedMessagesScreen extends StatelessWidget {
  const CannedMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => zodiacGetIt.get<CannedMessagesCubit>(),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).cannedMessagesZodiac,
        ),
        body: Builder(builder: (context) {
          final (bool, bool) record = context.select(
              (CannedMessagesCubit cubit) => (
                    cubit.state.dataFetched,
                    cubit.state.alreadyTriedToFetchData
                  ));

          final (bool dataFetched, bool alreadyTriedToFetchData) = record;

          if (dataFetched) {
            return const CannedMessagesBodyWidget();
          } else {
            if (alreadyTriedToFetchData) {
              return RefreshIndicator(
                onRefresh: () => context.read<CannedMessagesCubit>().loadData(),
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
              final bool isOnline = context.select((MainCubit cubit) =>
                  cubit.state.internetConnectionIsAvailable);
              if (isOnline) {
                return const SizedBox.expand();
              } else {
                return const CustomScrollView(slivers: [
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoConnectionWidget(),
                        ],
                      )),
                ]);
              }
            }
          }
        }),
      ),
    );
  }
}
