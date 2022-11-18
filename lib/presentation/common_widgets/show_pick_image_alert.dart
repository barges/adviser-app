import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';

Future<void> showPickImageAlert(
    {required BuildContext context,
    required ValueChanged<File> setImage,
    ValueChanged<List<File>>? setMultiImage,
    VoidCallback? cancelOnTap,
    bool mounted = true}) async {
  ImageSource? source;

  if (Platform.isAndroid) {
    source = await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Get.back(result: ImageSource.gallery),
            child: Container(
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                S.of(context).chooseFromGallery,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(result: ImageSource.camera),
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
              Get.back();
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
  String alertTitle = '';
  PermissionStatus status;
  switch (source) {
    case ImageSource.camera:
      {
        status = await Permission.camera.request();
        alertTitle = 'Allow camera';
      }
      break;
    case ImageSource.gallery:
      {
        if (Platform.isIOS) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }
        alertTitle = 'Allow gallery';
      }
      break;
  }
  if (status.isPermanentlyDenied) {
    VoidCallback actionOnOk = (() async {
      await openAppSettings();
      Navigator.pop(context);
    });
    await showOkCancelAlert(
      context,
      alertTitle,
      S.of(context).settings,
      actionOnOk,
    );
  }
}
