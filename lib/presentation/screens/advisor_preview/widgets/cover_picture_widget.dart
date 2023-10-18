import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/assets/assets.gen.dart';
import '../../../../themes/app_colors_light.dart';
import '../../../common_widgets/app_image_widget.dart';
import '../advisor_preview_cubit.dart';

class CoverPictureWidget extends StatelessWidget {
  const CoverPictureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdvisorPreviewCubit advisorPreviewCubit =
        context.read<AdvisorPreviewCubit>();
    if (advisorPreviewCubit.userProfile.coverPictures?.isNotEmpty == true) {
      return AppImageWidget(
        uri: Uri.parse(
          advisorPreviewCubit.userProfile.coverPictures?.firstOrNull ?? '',
        ),
        height: 150.0,
        memCacheHeight: 150,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        color: AppColorsLight.background,
        child: Center(
          child: SvgPicture.asset(Assets.vectors.placeholderCoverImage.path),
        ),
      );
    }
  }
}
