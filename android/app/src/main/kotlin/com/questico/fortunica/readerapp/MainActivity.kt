package com.questico.fortunica.readerapp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.UUID
import android.content.Intent
import androidx.lifecycle.lifecycleScope
import com.adviqo.pigeon.RecaptchaApi
import com.google.android.recaptcha.Recaptcha
import com.google.android.recaptcha.RecaptchaAction
import com.google.android.recaptcha.RecaptchaClient
import com.google.android.recaptcha.RecaptchaException
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private var recaptchaClient: RecaptchaClient? = null

    inner class RecaptchaApiImp: RecaptchaApi {
        override fun initialize(siteKey: String, callback: (Result<String>) -> Unit){
            lifecycleScope.launch {
                Recaptcha.getClient(application, siteKey)
                        .onSuccess { client ->
                            recaptchaClient = client
                            callback(Result.success("success"))
                        }
                        .onFailure { exception ->
                            callback(Result.failure(exception))
                        }
            }
        }

        override fun execute(recaptchaCustomAction: String, callback: (Result<String>) -> Unit)
        {
            if(recaptchaClient != null) {
                lifecycleScope.launch {
                    recaptchaClient!!.execute(RecaptchaAction.custom(recaptchaCustomAction))
                            .onSuccess { token ->
                                callback(Result.success(token))
                            }
                            .onFailure { exception ->
                                callback(Result.failure(exception))
                            }
                }
            }else{
                callback(Result.failure(Exception("Recaptcha client isn't initialized")));
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = context.packageName
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "uuidFromBytes") {
                val deviceUuid = uuidFromBytes()
                result.success(deviceUuid)
            }
        }

        val recaptchaApiImp = RecaptchaApiImp()
        RecaptchaApi.setUp(flutterEngine.dartExecutor.binaryMessenger, recaptchaApiImp);
    }

    override fun onNewIntent(intent : Intent){
        super.onNewIntent(intent)
        setIntent(intent)
    }

    private fun uuidFromBytes(): String? {
        val androidId: String = android.provider.Settings.Secure.getString(contentResolver, android.provider.Settings.Secure.ANDROID_ID)
        val name = androidId.encodeToByteArray()
        return UUID.nameUUIDFromBytes(name).toString()
    }
}

