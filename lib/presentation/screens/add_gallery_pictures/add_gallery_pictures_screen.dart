import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/screens/add_gallery_pictures/add_gallery_pictures_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/add_gallery_pictures/widgets/gallery_images.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class AddGalleryPicturesScreen extends StatelessWidget {
  const AddGalleryPicturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddGalleryPicturesCubit(
        getIt.get<UserRepository>(),
        getIt.get<ConnectivityService>(),
        getIt.get<CachingManager>(),
      ),
      child: Builder(builder: (context) {
        AddGalleryPicturesCubit addGalleryPicturesCubit =
            context.read<AddGalleryPicturesCubit>();
        return Scaffold(
          key: addGalleryPicturesCubit.scaffoldKey,
          drawer: const AppDrawer(),
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
                    title: S.of(context).addGalleryPictures,
                    openDrawer: addGalleryPicturesCubit.openDrawer,
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
