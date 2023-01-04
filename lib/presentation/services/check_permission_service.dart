import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';

class CheckPermissionService {
  static Future<void> handlePermission(
      BuildContext context, PermissionType permissionType) async {
    PermissionStatus status;
    switch (permissionType) {
      case PermissionType.camera:
        {
          status = await Permission.camera.request();
        }
        break;
      case PermissionType.gallery:
        {
          if (Platform.isIOS) {
            status = await Permission.photos.request();
          } else {
            status = await Permission.storage.request();
          }
        }
        break;
      case PermissionType.audio:
        {
          status = await Permission.microphone.request();
        }
        break;
    }

    if (status.isPermanentlyDenied) {
      VoidCallback actionOnOk = (() async {
        await openAppSettings();
        Navigator.pop(context);
      });
      await showOkCancelAlert(
          context: context,
          title: S.of(context).permissionNeeded,
          okText: S.of(context).settings,
          description: permissionType.getSettingsAlertDescriptionText(context),
          actionOnOK: actionOnOk,
          allowBarrierClick: true,
          isCancelEnabled: true);
    }
  }
}

enum PermissionType {
  gallery,
  camera,
  audio;

  String getSettingsAlertDescriptionText(BuildContext context) {
    switch (this) {
      case PermissionType.gallery:
      case PermissionType.camera:
        return S
            .of(context)
            .weNeedPermissionToAccessYourCameraAndGallerySoYouCanSendImages;
      case PermissionType.audio:
        return S.of(context).weNeedPermissionToAccessYourMicrophone;
    }
  }

  static PermissionType getPermissionTypeByImageSource(
      ImageSource imageSource) {
    switch (imageSource) {
      case ImageSource.camera:
        return PermissionType.camera;
      case ImageSource.gallery:
        return PermissionType.gallery;
    }
  }
}
