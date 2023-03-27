import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:collection/collection.dart';
import 'package:fortunica/data/models/user_info/user_info.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:injectable/injectable.dart';

const String appName = 'Advisor Shared Interface';

abstract class FreshChatService {
  Future<bool> setUpFortunicaFreshChat(FreshChaUserInfo? userInfo);

  Future<void> initFreshChat(bool isDarkMode);

  Stream onRestoreStream();

  Future<String?> getRestoreId();

  void changeLocaleInvite();
}

@Singleton(as: FreshChatService)
class FreshChatServiceImpl extends FreshChatService {
  static const String freshChatId = 'ad263ea2-8218-4618-88bd-220ab8d56e23';
  static const String freshChatKey = 'd77300c3-b490-46f6-86d9-226b4e79c737';
  static const String freshChatDomain = 'msdk.freshchat.com';
  bool _wasInit = false;

  @override
  Future initFreshChat(bool isDarkMode) async {
    Freshchat.init(freshChatId, freshChatKey, freshChatDomain,
        stringsBundle: 'FCCustomLocalizable',
        themeName: isDarkMode ? 'FCDarkTheme.plist' : 'FCTheme.plist');
    _wasInit = true;
  }

  @override
  Future<bool> setUpFortunicaFreshChat(FreshChaUserInfo? userInfo) async {
    if (!_wasInit) {
      throw Exception([
        'Fresh Chat Manager was not init. Pleas use initFreshChat() before setUpFreshChat.'
      ]);
    }

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      deviceId = await androidIdPlugin.getId();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    final String? userId = userInfo?.userId;
    final String restoreId = userInfo?.restoreId ?? await getRestoreId() ?? '';
    final String? profileName = userInfo?.profileName;
    final String? email = userInfo?.email;

    try {
      FreshchatUser freshChatUser = FreshchatUser(userId, restoreId);
      if (profileName != null) {
        freshChatUser.setFirstName(profileName);
      }
      if (email != null) {
        freshChatUser.setEmail(email);
      }

      Freshchat.identifyUser(externalId: userId ?? '', restoreId: restoreId);
      Freshchat.setUser(freshChatUser);

      //Additional params
      var userPropertiesJson = {
        'user_id': userId,
        'device_id': deviceId,
        'app_name': appName,
        'role': 'advisor',
      };
      Freshchat.setUserProperties(userPropertiesJson);

      logger.d(
          'The user for Support page is - name:${freshChatUser.getFirstName()}'
          ', email:${freshChatUser.getEmail()}');

      return true;
    } catch (e) {
      logger.e('ERROR: FreshChatManager.setUpFreshChat: $e');
      return false;
    }
  }

  void sendRegistrationToServer(String token) {
    if (Platform.isAndroid) {
      Freshchat.setNotificationConfig(smallIcon: AppConstants.appPushIcon);
      Freshchat.setPushRegistrationToken(token);
    }
  }

  /*
static func updateUserInfo() {
		guard let user = ZPUserManager.shared()?.currentUser else {
			return
		}
		let freshUser = FreshchatUser.sharedInstance()
		Freshchat.sharedInstance().identifyUser(withExternalID: "\(user.identifier.intValue)", restoreID: freshUser.restoreID)
		let name: String? = user.name
		if let name = name {
			freshUser.firstName = name
		}
		let email: String? = user.email
		if let email = email {
			freshUser.email = email
		}
		Freshchat.sharedInstance().setUser(freshUser)
		var properties = [String: String]()
		properties["role"] = user.isExpert ? "advisor" : "user"
		properties["brand"] = CurrentEnvironment.packageId
		Freshchat.sharedInstance().setUserProperties(properties)
	}



  private void initSupport() {
    FreshchatUser freshchatUser = Freshchat.getInstance(context).getUser();

    freshchatUser.setFirstName(mainRepository.getUserName());
    freshchatUser.setEmail(mainRepository.getUserEmail());

    try {
        Freshchat.getInstance(context).identifyUser(String.valueOf(mainRepository.getUserId()), null);
        Freshchat.getInstance(context).setUser(freshchatUser);

        Map<String, String> userMeta = new HashMap<String, String>();
        userMeta.put("user_id", String.valueOf(mainRepository.getUserId()));
        userMeta.put("device_id", mainRepository.getDeviceId());
        userMeta.put("app_name", ZodiacApplication.get().getString(R.string.app_name));
        userMeta.put("role", currentRole == UserRole.EXPERT ? "advisor" : "user");
        userMeta.put("brand", mainRepository.getPackage());

        Freshchat.getInstance(context).setUserProperties(userMeta);
    } catch (MethodNotAllowedException ex) {
        ex.printStackTrace();
    }

    FreshchatNotificationConfig notificationConfig = new FreshchatNotificationConfig()
            .setNotificationSoundEnabled(true)
            .setSmallIcon(NotificationHelper.getNotificationIcon())
            .setLargeIcon(NotificationHelper.getNotificationIcon())
            .launchActivityOnFinish(MainActivity.class.getName())
            .setPriority(NotificationCompat.PRIORITY_HIGH);
    Freshchat.getInstance(context).setNotificationConfig(notificationConfig);
}
15:37
private void sendRegistrationToServer(String token) {
    Freshchat.getInstance(getApplicationContext()).setPushRegistrationToken(token);
    new RegistrationManager().sendRegistrationToServer(token);
}


//
//  ZPFreshchat.swift
//  Zodiac Psychics
//
//  Created by Vitalii on 24.02.2020.
//  Copyright © 2020 Zodiac Consulting. All rights reserved.
//

import FirebaseCrashlytics
import UIKit

@objc
class ZPFreshchat: NSObject {
	static func updateUserInfo() {
		guard let user = ZPUserManager.shared()?.currentUser else {
			return
		}
		let freshUser = FreshchatUser.sharedInstance()
		Freshchat.sharedInstance().identifyUser(withExternalID: "\(user.identifier.intValue)", restoreID: freshUser.restoreID)

		let name: String? = user.name
		if let name = name {
			freshUser.firstName = name
		}
		let email: String? = user.email
		if let email = email {
			freshUser.email = email
		}
		Freshchat.sharedInstance().setUser(freshUser)

		var properties = [String: String]()
		properties["role"] = user.isExpert ? "advisor" : "user"
		properties["brand"] = CurrentEnvironment.packageId

		Freshchat.sharedInstance().setUserProperties(properties)
	}

	@objc
	static func configure(with _: UIApplication, option _: [String: Any]? = nil) {
		guard let freshchatAppId = AppConfig.shared.string(forKey: kAppConfigFreshchatAppId),
		      let freshchatAppKey = AppConfig.shared.string(forKey: kAppConfigFreshchatAppKey)
		else {
			return
		}
		let freshchatConfig = FreshchatConfig(appID: freshchatAppId,
		                                      andAppKey: freshchatAppKey)

		freshchatConfig.stringsBundle = "ZPHLLocalization"
		freshchatConfig.themeName = "ZPFCTheme"
		freshchatConfig.domain = "msdk.freshchat.com"
		Freshchat.sharedInstance().initWith(freshchatConfig)
	}

	@objc
	static func registerForRemoteNotifications(with deviceToken: Data) {
		Freshchat.sharedInstance().setPushRegistrationToken(deviceToken)
		let apnsToken = ZPUtils.serializeDeviceToken(deviceToken)
		zpPrint("registerForRemoteNotifications apns token: \(apnsToken ?? "-")")
	}

	@objc
	static func didReceiveNotification(response: [AnyHashable: Any]) {
		if Freshchat.sharedInstance().isFreshchatNotification(response) {
			Freshchat.sharedInstance().handleRemoteNotification(response, andAppstate: UIApplication.shared.applicationState)
		}
	}

	@objc
	static func showConversations(on viewController: UIViewController) {
		updateUserInfo()
		let options = ConversationOptions()
		let tags = conversationsTags

		zpPrint("freshchat conversation tags: \(tags)")

		options.filter(byTags: tags, withTitle: nil)
		Freshchat.sharedInstance().showConversations(viewController, with: options)
	}

	@objc
	static func showFAQs(on viewController: UIViewController) {
		updateUserInfo()
		let options = FAQOptions()
		let type = TagFilterType(rawValue: 2)
		let tags = faqTags

		zpPrint("freshchat FAQ tags: \(tags)")

		options.filter(byTags: tags, withTitle: nil, andType: type)
		options.filterContactUs(byTags: conversationsTags, withTitle: nil)

		options.showContactUsOnFaqScreens = Bundle.isLive
		options.showContactUsOnAppBar = false
		options.showContactUsOnFaqNotHelpful = true

		Freshchat.sharedInstance().showFAQs(viewController, with: options)
	}

	static var conversationsTags: [String] {
		let packageId = CurrentEnvironment.packageId
		return [conversationsTagConfig[packageId] ?? ""]
	}
}

// MARK: FAQ TAGS

private extension ZPFreshchat {
	static var faqTags: [String] {
		ZPUserManager.shared().currentUser.isExpert ? faqAdvisorTags : faqClientTags
	}

	static var faqAdvisorTags: [String] {
		templateFAQAdvisorTags.map { string in
			string.replacingOccurrences(of: "TARGET", with: self.templateTarget)
		}
	}

	static var faqClientTags: [String] {
		templateFAQClientTags.map { string in
			string.replacingOccurrences(of: "TARGET", with: self.templateTarget)
		}
	}

	static var templateTarget: String {
		let packageId = CurrentEnvironment.packageId
		return faqTargetConfig[packageId] ?? ""
	}
}

// MARK: FAQ

private extension ZPFreshchat {
	static var templateFAQAdvisorTags: [String] {
		["general_TARGET_advisor",
		 "payments_TARGET_advisor",
		 "offers_TARGET_advisor",
		 "tips_TARGET_advisor",
		 "techhelp_TARGET_advisor"]
	}

	static var templateFAQClientTags: [String] {
		["general_TARGET_user",
		 "payments_TARGET_user",
		 "refunds_TARGET_user",
		 "offers_TARGET_user",
		 "tips_TARGET_user"]
	}

	static var faqTargetConfig: [String: String] {
		["com.zodiacpsychics.messenger": "zd",
		 "in.zodiacpsychics": "zdin",
		 "com.psiquicos": "ps",
		 "pt.psiquicos": "pspt",
		 "com.redpsiquica": "rp",
		 "com.psychicunion": "pu",
		 "com.modernpsychics": "mp",
		 "com.zodiaclive": "mp"]
	}
}

// MARK: Conversations

private extension ZPFreshchat {
	static var conversationsTagConfig: [String: String] {
		["com.zodiacpsychics.messenger": "support",
		 "in.zodiacpsychics": "zodiacpsychicsin",
		 "com.psiquicos": "soporte",
		 "pt.psiquicos": "psiquicospt",
		 "com.redpsiquica": "redpsiquica",
		 "com.psychicunion": "psychicunion",
		 "com.modernpsychics": "modernpsychics",
		 "com.zodiaclive": "modernpsychics"]
	}
}
   */

  @override
  Stream onRestoreStream() {
    return Freshchat.onRestoreIdGenerated;
  }

  @override
  void changeLocaleInvite() {
    Freshchat.notifyAppLocaleChange();
  }

  @override
  Future<String?> getRestoreId() async {
    FreshchatUser user = await Freshchat.getUser;
    return user.getRestoreId();
  }
}

class FreshChaUserInfo {
  final String? userId;
  final String? restoreId;
  final String? profileName;
  final String? email;

  FreshChaUserInfo({
    this.userId,
    this.restoreId,
    this.profileName,
    this.email,
  });
}
