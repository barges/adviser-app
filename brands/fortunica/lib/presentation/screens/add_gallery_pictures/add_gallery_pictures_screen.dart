import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:fortunica/presentation/screens/add_gallery_pictures/add_gallery_pictures_cubit.dart';
import 'package:fortunica/presentation/screens/add_gallery_pictures/widgets/gallery_images.dart';


class AddGalleryPicturesScreen extends StatelessWidget {
  const AddGalleryPicturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddGalleryPicturesCubit(
        fortunicaGetIt.get<FortunicaUserRepository>(),
        fortunicaGetIt.get<ConnectivityService>(),
        fortunicaGetIt.get<FortunicaCachingManager>(),
      ),
      child: Builder(builder: (context) {
        AddGalleryPicturesCubit addGalleryPicturesCubit =
            context.read<AddGalleryPicturesCubit>();
        return Scaffold(
          key: addGalleryPicturesCubit.scaffoldKey,
          body: SafeArea(
            top: false,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  ScrollableAppBar(
                    title: SFortunica.of(context).addGalleryPicturesFortunica,
                  ),
                  const SliverToBoxAdapter(child: GalleryImages())
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
