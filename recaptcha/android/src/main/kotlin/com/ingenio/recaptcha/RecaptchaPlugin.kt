package com.ingenio.recaptcha

import androidx.lifecycle.lifecycleScope

import com.google.android.recaptcha.Recaptcha
import com.google.android.recaptcha.RecaptchaAction
import com.google.android.recaptcha.RecaptchaClient
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.launch

/** RecaptchaPlugin */
class RecaptchaPlugin: FlutterPlugin, ActivityAware, RecaptchaApi {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var activity: FlutterActivity? = null
    private var recaptchaClient: RecaptchaClient? = null

    override fun initialize(siteKey: String, callback: (Result<String>) -> Unit){
          activity!!.lifecycleScope.launch{
          Recaptcha.getClient(activity!!.application, siteKey)
                  .onSuccess { client ->
                    recaptchaClient = client
                    callback(Result.success("success"))
                  }
                  .onFailure { exception ->
                    callback(Result.failure(exception))
                  }
        }
    }

    override fun execute(recaptchaCustomAction: String, callback: (Result<String>) -> Unit) {
        if(recaptchaClient != null) {
            activity!!.lifecycleScope.launch {
                recaptchaClient!!.execute(RecaptchaAction.custom(recaptchaCustomAction))
                        .onSuccess { token ->
                            callback(Result.success(token))
                        }
                        .onFailure { exception ->
                            callback(Result.failure(exception))
                        }
            }
        }else{
            callback(Result.failure(Exception("Recaptcha client isn't initialized")))
        }
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding){
        activity = activityPluginBinding.activity as FlutterActivity
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        RecaptchaApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        RecaptchaApi.setUp(binding.binaryMessenger, null)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
