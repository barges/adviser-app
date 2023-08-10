import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/add_service_body_widget.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AddServiceCubit(
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ZodiacServicesRepository>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<GlobalCachingManager>(),
      ),
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SimpleAppBar(
            title: SZodiac.of(context).addServiceZodiac,
          ),
          body: Builder(builder: (context) {
            final List<ImageSampleModel>? images =
                context.select((AddServiceCubit cubit) => cubit.state.images);
            final List<String>? languagesList = context
                .select((AddServiceCubit cubit) => cubit.state.languagesList);

            if (images != null && languagesList != null) {
              return AddServiceBodyWidget(
                images: images,
                languagesList: languagesList,
              );
            } else {
              final bool internetConnectionIsAvailable = context.select(
                  (MainCubit cubit) =>
                      cubit.state.internetConnectionIsAvailable);
              if (internetConnectionIsAvailable) {
                final bool alreadyTriedToGetImages = context.select(
                    (AddServiceCubit cubit) =>
                        cubit.state.alreadyTriedToGetImages);
                if (alreadyTriedToGetImages) {
                  return RefreshIndicator(
                    onRefresh: context.read<AddServiceCubit>().initializeScreen,
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
            }
          }),
        ),
      ),
    );
  }
}
