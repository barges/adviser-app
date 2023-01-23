import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';

class CheckPermissionService {
  static Map<PermissionType, PermissionStatus> permissionStatusesMap = {};

  static Future<bool> handlePermission(
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
      case PermissionType.notification:
        {
          if (Platform.isIOS) {
            await FirebaseMessaging.instance.requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              provisional: false,
              sound: true,
            );
          }
          status = await Permission.notification.request();
        }
    }

    if (permissionStatusesMap[permissionType] == null &&
        status.isPermanentlyDenied) {
      permissionStatusesMap[permissionType] = status;
    }

    if (permissionStatusesMap[permissionType]?.isPermanentlyDenied == true) {
      VoidCallback actionOnOk = (() async {
        await openAppSettings();
        Navigator.pop(context);
      });
      await showOkCancelAlert(
          context: context,
          title: permissionType.getSettingsAlertTitleText(context),
          okText: S.of(context).settings,
          description: permissionType.getSettingsAlertDescriptionText(context),
          actionOnOK: actionOnOk,
          allowBarrierClick: true,
          isCancelEnabled: true);
    }

    permissionStatusesMap[permissionType] = status;
    return status.isGranted;
  }
}

enum PermissionType {
  gallery,
  camera,
  audio,
  notification;

  String getSettingsAlertDescriptionText(BuildContext context) {
    switch (this) {
      case PermissionType.gallery:
      case PermissionType.camera:
        return S
            .of(context)
            .weNeedPermissionToAccessYourCameraAndGallerySoYouCanSendImages;
      case PermissionType.audio:
        return S.of(context).weNeedPermissionToAccessYourMicrophone;
      case PermissionType.notification:
        return S
            .of(context)
            .toEnableNotificationYouLlNeedToAllowNotificationsForReaderAppInYourPhoneSettings;
    }
  }

  String getSettingsAlertTitleText(BuildContext context) {
    switch (this) {
      case PermissionType.gallery:
      case PermissionType.camera:
      case PermissionType.audio:
        return S.of(context).permissionNeeded;
      case PermissionType.notification:
        return S.of(context).notificationsAreDisabled;
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
