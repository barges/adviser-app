import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

Future<void> showPickImageAlert(
    {required BuildContext context,
    required ValueChanged<File> setImage,
    ValueChanged<List<File>>? setMultiImage,
    VoidCallback? cancelOnTap,
    bool mounted = true}) async {
  ImageSource? source;

  if (Platform.isAndroid) {
    source = await Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Get.back(result: ImageSource.gallery),
            child: Container(
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              width: Get.width,
              child: Center(
                  child: Text(
                S.of(context).chooseFromGallery,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(result: ImageSource.camera),
            child: Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              width: Get.width,
              child: Center(
                  child: Text(
                S.of(context).takeAPhoto,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              if (cancelOnTap != null) {
                cancelOnTap();
              }
            },
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: Text(S.of(context).cancel,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Get.theme.primaryColor,
                    )),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
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
                  onPressed: () => Get.back(result: ImageSource.camera),
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    S.of(context).chooseFromGallery,
                  ),
                  onPressed: () => Get.back(result: ImageSource.gallery),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Get.back();
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
  if (mounted &&
      ((source != null && setMultiImage == null) ||
          (source == ImageSource.camera && setMultiImage != null))) {
    await _pickImage(context, source!, setImage);
  } else if (mounted &&
      source == ImageSource.gallery &&
      setMultiImage != null) {
    await _pickMultiImage(context, source!, setMultiImage);
  }
}

Future<void> _pickImage(BuildContext context, ImageSource imageSource,
    ValueChanged<File> setImage) async {
  await _handlePermissions(context, imageSource);
  File? image;
  final ImagePicker picker = ImagePicker();
  final XFile? photoFile = await picker.pickImage(source: imageSource);
  if (photoFile?.path != null) {
    image = File(photoFile!.path);
  }
  if (image != null) {
    setImage(image);
  }
}

Future<void> _pickMultiImage(BuildContext context, ImageSource imageSource,
    ValueChanged<List<File>> setMultiImage) async {
  await _handlePermissions(context, imageSource);
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

Future<void> _handlePermissions(
    BuildContext context, ImageSource source) async {
  switch (source) {
    case ImageSource.camera:
      {
        await Permission.camera.request();
      }
      break;
    case ImageSource.gallery:
      {
        if (Platform.isIOS) {
          await Permission.photos.request();
        } else {
          await Permission.storage.request();
        }
      }
      break;
  }
}
