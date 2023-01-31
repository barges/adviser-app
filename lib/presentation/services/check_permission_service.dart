import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';

class CheckPermissionService {
  final CachingManager _cacheManager;

  CheckPermissionService(this._cacheManager);

  Future<bool> handlePermission(
      BuildContext context, PermissionType permissionType,
      {bool needShowSettings = true}) async {
    PermissionStatus status;
    Map<String, dynamic> permissionStatusesMap =
        _cacheManager.getFirstPermissionStatusesRequestsMap();
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
          if (!status.isGranted) {
            status = PermissionStatus.permanentlyDenied;
          }
        }
        break;
    }

    if (needShowSettings &&
        status.isPermanentlyDenied &&
        permissionStatusesMap[permissionType.name] != null) {
      VoidCallback actionOnOk = (() async {
        await openAppSettings();
        Get.back();
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

    if (status.isPermanentlyDenied) {
      _cacheManager.saveFirstPermissionStatusesRequestsMap(permissionType);
    }

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
            .toEnableNotificationYoullNeedToAllowNotificationsInYour;
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
