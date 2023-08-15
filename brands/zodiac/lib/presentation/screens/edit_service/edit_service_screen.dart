import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/service/choose_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/service/discount_for_reorder_slider_widget.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_cubit.dart';
import 'package:zodiac/presentation/screens/edit_service/widgets/languages_part_widget.dart';

class EditServiceScreen extends StatelessWidget {
  final int serviceId;

  const EditServiceScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditServiceCubit(
        serviceId: serviceId,
        servicesRepository: zodiacGetIt.get<ZodiacServicesRepository>(),
        zodiacCachingManager: zodiacGetIt.get<ZodiacCachingManager>(),
      ),
      child: Builder(builder: (context) {
        final EditServiceCubit editServiceCubit =
            context.read<EditServiceCubit>();

        return Scaffold(
          appBar: SimpleAppBar(
            title: SZodiac.of(context).editServiceZodiac,
          ),
          body: Builder(builder: (context) {
            final bool dataFetched = context
                .select((EditServiceCubit cubit) => cubit.state.dataFetched);

            if (dataFetched) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        List<String>? languagesList = context.select(
                            (EditServiceCubit cubit) =>
                                cubit.state.languagesList);
                        if (languagesList != null) {
                          return LanguagesPartWidget(
                            languagesList: languagesList,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final bool discountEnabled = context.select(
                            (EditServiceCubit cubit) =>
                                cubit.state.discountEnabled);
                        final double price = context.select(
                            (EditServiceCubit cubit) => cubit.state.price);
                        final double discount = context.select(
                            (EditServiceCubit cubit) => cubit.state.discount);
                        return DiscountForReorderWidget(
                          discountEnabled: discountEnabled,
                          price: price,
                          discount: discount,
                          onDiscountChanged: editServiceCubit.onDiscountChanged,
                          onDiscountEnabledChanged:
                              editServiceCubit.onDiscountEnabledChanged,
                        );
                      }),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final List<ImageSampleModel>? images = context.select(
                            (EditServiceCubit cubit) => cubit.state.images);
                        final int selectedImageIndex = context.select(
                            (EditServiceCubit cubit) =>
                                cubit.state.selectedImageIndex);
                        final bool showAllImages = context.select(
                            (EditServiceCubit cubit) =>
                                cubit.state.showAllImages);

                        if (images != null) {
                          return ChooseImageWidget(
                            images: images,
                            selectedImageIndex: selectedImageIndex,
                            showAllImages: showAllImages,
                            selectImage: editServiceCubit.selectImage,
                            setShowAllImages: editServiceCubit.setShowAllImages,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ],
                  ),
                ),
              );
            } else {
              final bool alreadyFetchData = context.select(
                  (EditServiceCubit cubit) => cubit.state.alreadyFetchData);

              if (alreadyFetchData) {
                return RefreshIndicator(
                  onRefresh: editServiceCubit.fetchData,
                  child: const CustomScrollView(
                    slivers: [
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
            }
          }),
        );
      }),
    );
  }
}
