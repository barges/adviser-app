import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(
        zodiacGetIt.get<ZodiacCachingManager>()
      ),
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ScrollableAppBar(
              title: SZodiac.of(context).editProfileZodiac,
            ),
            const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            ),
          ],
        ),),
    );
  }
}