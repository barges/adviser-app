import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../domain/repositories/fortunica_user_repository.dart';
import '../../../generated/l10n.dart';
import '../../../global.dart';
import '../../../services/connectivity_service.dart';
import '../../common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'add_gallery_pictures_cubit.dart';
import 'widgets/gallery_images.dart';

class AddGalleryPicturesScreen extends StatelessWidget {
  const AddGalleryPicturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddGalleryPicturesCubit(
        globalGetIt.get<FortunicaUserRepository>(),
        globalGetIt.get<ConnectivityService>(),
        globalGetIt.get<FortunicaCachingManager>(),
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
