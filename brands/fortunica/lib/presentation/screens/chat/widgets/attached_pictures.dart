import 'dart:io';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/app_image_widget.dart';
import 'package:fortunica/presentation/common_widgets/show_delete_alert.dart';
import 'package:fortunica/presentation/screens/chat/chat_cubit.dart';

class AttachedPictures extends StatelessWidget {
  const AttachedPictures({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final ChatCubit chatCubit = context.read<ChatCubit>();
        final List<File> attachedPictures =
            context.select((ChatCubit cubit) => cubit.state.attachedPictures);
        return Row(
          children: attachedPictures
              .map(
                (file) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _AttachedPicture(
                    file,
                    onDeletePressed: () async {
                      final bool? isDelete = await showDeleteAlert(
                        context,
                        SFortunica.of(context).doYouWantToDeleteImageFortunica,
                      );
                      if (isDelete == true) {
                        chatCubit.deletePicture(file);
                      }
                    },
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AttachedPicture extends StatelessWidget {
  final File file;
  final VoidCallback? onDeletePressed;

  const _AttachedPicture(
    this.file, {
    Key? key,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 7.0),
          child: AppImageWidget(
            uri: Uri.parse(file.path),
            width: 64.0,
            height: 64.0,
            memCacheHeight: 64,
            radius: AppConstants.buttonRadius,
          ),
        ),
        Positioned(
          right: 0.0,
          top: -7.0,
          child: _DeleteBtn(
            onPressed: onDeletePressed,
          ),
        ),
      ],
    );
  }
}

class _DeleteBtn extends StatelessWidget {
  final VoidCallback? onPressed;

  const _DeleteBtn({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 18.0,
        height: 18.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).hoverColor,
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).canvasColor,
          ),
        ),
        child: Assets.vectors.crossFat.svg(
          fit: BoxFit.none,
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
