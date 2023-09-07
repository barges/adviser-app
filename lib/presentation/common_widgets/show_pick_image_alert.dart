// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';

Future<void> showPickImageAlert({
  required BuildContext context,
  required ValueChanged<File> setImage,
  ValueChanged<List<File>>? setMultiImage,
  VoidCallback? cancelOnTap,
}) async {
  ImageSource? source;

  if (Platform.isAndroid) {
    source = await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => context.popForced(ImageSource.gallery),
            child: Container(
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                S.of(context).choosePhotoFromLibrary,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () => context.popForced(ImageSource.camera),
            child: Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                S.of(context).takeAPhoto,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.popForced();
              if (cancelOnTap != null) {
                cancelOnTap();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: Text(S.of(context).cancel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        )),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  } else {
    source = await showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(
                    S.of(context).takeAPhoto,
                  ),
                  onPressed: () => context.popRoot(ImageSource.camera),
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    S.of(context).choosePhotoFromLibrary,
                  ),
                  onPressed: () => context.popRoot(ImageSource.gallery),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  context.popRoot();
                  // Navigator.of(context).pop();
                  if (cancelOnTap != null) {
                    cancelOnTap();
                  }
                },
                child: Text(
                  S.of(context).cancel,
                ),
              ),
            ));
  }
  if ((source != null && setMultiImage == null) ||
      (source == ImageSource.camera && setMultiImage != null)) {
    await _pickImage(context, source!, setImage);
  } else if (source == ImageSource.gallery && setMultiImage != null) {
    await _pickMultiImage(context, source!, setMultiImage);
  }
}

Future<void> _pickImage(BuildContext context, ImageSource imageSource,
    ValueChanged<File> setImage) async {
  await globalGetIt.get<CheckPermissionService>().handlePermission(
      context, PermissionType.getPermissionTypeByImageSource(imageSource));
  File? image;

  if (await _checkForGrantedPermission(imageSource)) {
    final ImagePicker picker = ImagePicker();
    final XFile? photoFile = await picker.pickImage(
      source: imageSource,

      ///Uncomment if we need crop image size
      // maxHeight: 2048.0,
      // maxWidth: 2048.0,
    );
    if (photoFile?.path != null) {
      image = File(photoFile!.path);
    }
  }

  if (image != null) {
    setImage(image);
  }
}

Future<void> _pickMultiImage(BuildContext context, ImageSource imageSource,
    ValueChanged<List<File>> setMultiImage) async {
  await globalGetIt.get<CheckPermissionService>().handlePermission(
      context, PermissionType.getPermissionTypeByImageSource(imageSource));
  List<File> images = List.empty(growable: true);
  final ImagePicker picker = ImagePicker();
  final List<XFile>? photoFiles = await picker.pickMultiImage();
  if (photoFiles != null) {
    for (XFile photoFile in photoFiles) {
      images.add(File(photoFile.path));
    }
  }
  if (images.isNotEmpty) {
    setMultiImage(images);
  }
}

Future<bool> _checkForGrantedPermission(ImageSource imageSource) async {
  return (imageSource == ImageSource.camera &&
          await Permission.camera.status == PermissionStatus.granted) ||
      (Platform.isAndroid &&
          imageSource == ImageSource.gallery &&
          await Permission.storage.status == PermissionStatus.granted) ||
      (Platform.isIOS &&
              imageSource == ImageSource.gallery &&
              await Permission.photos.status == PermissionStatus.granted ||
          await Permission.photos.status == PermissionStatus.limited);
}
