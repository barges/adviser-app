import UIKit
import Flutter

struct RecaptchaClientError {
    let message: String
    init(message: String) {
        self.message = message
    }
}

extension RecaptchaClientError: Error {
}
    
private class RecaptchaApiImp: NSObject, RecaptchaApi {
    var recaptchaClient: RecaptchaClient?
    func initialize(siteKey: String, completion: @escaping (Result<String, Error>) -> Void)
    {
        Recaptcha.getClient(siteKey: siteKey) { client, error in
            guard let client = client else {
                completion(.failure(error!))
                return
            }
            self.recaptchaClient = client
            completion(.success(("success")))
        }
    }
    
    func execute(recaptchaCustomAction: String, completion: @escaping (Result<String, Error>) -> Void)
    {
        guard let recaptchaClient = recaptchaClient else {
            completion(.failure(RecaptchaClientError(message:"Recaptcha client isn't initialized")))
          return
        }
        recaptchaClient.execute(RecaptchaAction.init(customAction: recaptchaCustomAction)) { token, error in
          if let token = token {
              completion(.success(token.recaptchaToken))
          } else {
              completion(.failure(error!))
          }
        }
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
