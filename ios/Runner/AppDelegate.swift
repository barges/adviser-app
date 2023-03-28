import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let freshchatSdkPlugin = FreshchatSdkPlugin()
    if freshchatSdkPlugin.isFreshchatNotification(userInfo)
    {
        freshchatSdkPlugin.handlePushNotification(userInfo)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

          let freshchatSdkPlugin = FreshchatSdkPlugin()
          freshchatSdkPlugin.setPushRegistrationToken(deviceToken)
    }
}
