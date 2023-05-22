import UIKit
import Flutter
import Foundation
    
private class RecaptchaApiImp: NSObject, RecaptchaApi {
    var recaptchaClient: RecaptchaClient?
    func initialize(siteKey: String, completion: @escaping (Result<String, Error>) -> Void)
    {
        Recaptcha.getClient(withSiteKey: siteKey) { client, error in
            guard let client = client else {
                completion(.failure(error!))
                return
            }
            self.recaptchaClient = client
            completion(.success(("success")))
        }
        completion(.success(("success")))
    }
    
    func execute(recaptchaCustomAction: String, completion: @escaping (Result<String, Error>) -> Void)
    {
        completion(.success(("success from ios")))
    }
    
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    let controller = window?.rootViewController as! FlutterViewController
    let recaptchaApiImp = RecaptchaApiImp()
    RecaptchaApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: recaptchaApiImp)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
