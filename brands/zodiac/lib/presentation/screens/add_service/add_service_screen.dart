import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/tile_menu_button.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/information_expansion_panel.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AddServiceCubit(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: SimpleAppBar(
          title: SZodiac.of(context).addServiceZodiac,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  const TabsWidget(),
                  const SizedBox(
                    height: 24.0,
                  ),
                  InformationExpansionPanel(
                    title: SZodiac.of(context).moreAboutOfflineServicesZodiac,
                    content: SZodiac.of(context)
                        .thisTypeOfServicesAreNotTimeSensitiveZodiac,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TileMenuButton(
                    label: SZodiac.of(context).duplicateAnExistingServiceZodiac,
                    onTap: () {},
                  )
                ],
              )),
        ),
      ),
    );
  }
}
