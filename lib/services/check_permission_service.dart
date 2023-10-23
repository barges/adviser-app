import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_constants.dart';
import '../data/cache/caching_manager.dart';
import '../generated/l10n.dart';
import '../presentation/common_widgets/ok_cancel_alert.dart';

@singleton
class CheckPermissionService {
  final CachingManager _cacheManager;

  CheckPermissionService(this._cacheManager);

  Future<bool> handlePermission(
      BuildContext context, PermissionType permissionType,
      {bool needShowSettings = true}) async {
    PermissionStatus status;
    Map<String, dynamic> permissionStatusesMap =
        _cacheManager.getFirstPermissionStatusesRequestsMap();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

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
            final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            if (androidInfo.version.sdkInt >=
                AppConstants.androidSdkVersion33) {
              status = await Permission.photos.request();
            } else {
              status = await Permission.storage.request();
            }
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
        status.isPermanentlyDenied &&
        permissionStatusesMap[permissionType.name] != null) {
      VoidCallback actionOnOk = (() async {
        await openAppSettings();
      });
      // ignore: use_build_context_synchronously
      await showOkCancelAlert(
          context: context,
          title: permissionType.getSettingsAlertTitleText(context),
          okText: SFortunica.of(context).settings,
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
        return SFortunica.of(context)
            .weNeedPermissionToAccessYourCameraAndGallerySoYouCanSendImages;
      case PermissionType.audio:
        return SFortunica.of(context).weNeedPermissionToAccessYourMicrophone;
      case PermissionType.notification:
        return SFortunica.of(context)
            .toEnableNotificationYoullNeedToAllowNotificationsInYour;
    }
  }

  String getSettingsAlertTitleText(BuildContext context) {
    switch (this) {
      case PermissionType.gallery:
      case PermissionType.camera:
      case PermissionType.audio:
        return SFortunica.of(context).permissionNeeded;
      case PermissionType.notification:
        return SFortunica.of(context).notificationsAreDisabled;
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
