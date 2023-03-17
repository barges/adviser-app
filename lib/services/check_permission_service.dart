import 'dart:io';

import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
class CheckPermissionService {
   final GlobalCachingManager _cacheManager;

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
            NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              provisional: false,
              sound: true,
            );
            status =
            settings.authorizationStatus == AuthorizationStatus.authorized
                ? PermissionStatus.granted
                : PermissionStatus.permanentlyDenied;
          } else {
            status = await Permission.notification.request();
            if (!status.isGranted) {
              status = PermissionStatus.permanentlyDenied;
            }
          }
        }
        break;
    }

    if (needShowSettings &&
        status.isPermanentlyDenied
        &&
        permissionStatusesMap[permissionType.name] != null
    ) {
      VoidCallback actionOnOk = (() async {
        await openAppSettings();
      });
      await showOkCancelAlert(
          context: context,
          title: permissionType.getSettingsAlertTitleText(context),
          okText: SFortunica.of(context).settingsFortunica,
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
        return SFortunica
            .of(context)
            .weNeedPermissionToAccessYourCameraAndGallerySoYouCanSendImagesFortunica;
      case PermissionType.audio:
        return SFortunica.of(context).weNeedPermissionToAccessYourMicrophoneFortunica;
      case PermissionType.notification:
        return SFortunica
            .of(context)
            .toEnableNotificationYoullNeedToAllowNotificationsInYourFortunica;
    }
  }

  String getSettingsAlertTitleText(BuildContext context) {
    switch (this) {
      case PermissionType.gallery:
      case PermissionType.camera:
      case PermissionType.audio:
        return SFortunica.of(context).permissionNeededFortunica;
      case PermissionType.notification:
        return SFortunica.of(context).notificationsAreDisabledFortunica;
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
