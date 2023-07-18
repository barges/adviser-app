import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/tile_menu_button.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/information_expansion_panel.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/language_section_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/title_description_part_widget.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          AddServiceCubit(zodiacGetIt.get<ZodiacCachingManager>()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: SimpleAppBar(
          title: SZodiac.of(context).addServiceZodiac,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding,
                    ),
                    child: Column(
                      children: [
                        const TabsWidget(),
                        const SizedBox(
                          height: 24.0,
                        ),
                        InformationExpansionPanel(
                          title: SZodiac.of(context)
                              .moreAboutOfflineServicesZodiac,
                          content: SZodiac.of(context)
                              .thisTypeOfServicesAreNotTimeSensitiveZodiac,
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        TileMenuButton(
                          label: SZodiac.of(context)
                              .duplicateAnExistingServiceZodiac,
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                      ],
                    ),
                  ),
                  const LanguageSectionWidget(),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24.0,
                        ),
                        TitleDescriptionPartWidget(),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
