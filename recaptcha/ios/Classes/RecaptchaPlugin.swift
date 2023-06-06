import Flutter
import UIKit
import RecaptchaEnterprise

struct RecaptchaClientError {
    let message: String
    init(message: String) {
        self.message = message
    }
}

extension RecaptchaClientError: Error {
}

public class RecaptchaPlugin: NSObject, FlutterPlugin, RecaptchaApi {
  var recaptchaClient: RecaptchaClient?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : RecaptchaApi & NSObjectProtocol = RecaptchaPlugin.init()
    RecaptchaApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

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
