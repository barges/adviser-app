import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';

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
              .map((file) => Padding(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: _AttachedPicture(
                      file,
                      onDeletePressed: () async {
                        final bool? isDelete = await showDeleteAlert(
                            context, S.of(context).doYouWantToDeleteImage);
                        if (isDelete!) {
                          chatCubit.deletePicture(file);
                        }
                      },
                      width: 64.0,
                      height: 64.0,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _AttachedPicture extends StatelessWidget {
  final File file;
  final VoidCallback? onDeletePressed;
  final double? width;
  final double? height;
  const _AttachedPicture(
    this.file, {
    Key? key,
    this.onDeletePressed,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7.0, right: 7.0),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(file),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
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
