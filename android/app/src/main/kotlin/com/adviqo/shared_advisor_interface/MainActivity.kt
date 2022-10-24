package com.adviqo.shared_advisor_interface

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.UUID
import android.content.Intent


class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = context.packageName
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "uuidFromBytes") {
                val deviceUuid = uuidFromBytes()
                result.success(deviceUuid)

            }
        }


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

