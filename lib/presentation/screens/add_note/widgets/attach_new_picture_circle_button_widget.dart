import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/assets/assets.gen.dart';
import '../../../../themes/app_colors.dart';
import '../../../common_widgets/show_pick_image_alert.dart';
import '../add_note_cubit.dart';

class AttachNewPictureCircleButtonWidget extends StatelessWidget {
  const AttachNewPictureCircleButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddNoteCubit addNoteCubit = context.read<AddNoteCubit>();
    return GestureDetector(
      onTap: () {
        showPickImageAlert(
            context: context,
            setImage: addNoteCubit.attachPicture,
            setMultiImage: addNoteCubit.attachMultiPictures);
      },
      child: Container(
        height: 48.0,
        width: 48.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [AppColors.ctaGradient1, AppColors.ctaGradient2]),
        ),
        child: Assets.vectors.gallery.svg(fit: BoxFit.scaleDown),
      ),
    );
  }
}
