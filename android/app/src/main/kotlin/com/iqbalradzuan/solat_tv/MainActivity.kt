package com.iqbalradzuan.solat_tv

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/solat_tv"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "postWakeScreen") {
                val status = postWakeScreen()

                if (status) {
                    result.success(status)
                }
            } else if (call.method == "getGitTag") {
                val gitTag = getGitTag()

                if (gitTag != "") {
                    result.success(gitTag)
                }
            } else if (call.method == "getGitHash") {
                val gitHash = getGitHash()

                if (gitHash != "") {
                    result.success(gitHash)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun postWakeScreen(): Boolean {
        if (VERSION.SDK_INT >= VERSION_CODES.O_MR1) {
            this.setTurnScreenOn(true)
        }

        return true
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }

    private fun getGitTag(): String {
        val gitTag: String
        gitTag = BuildConfig.GitTag

        return gitTag
    }

    private fun getGitHash(): String {
        val gitHash: String
        gitHash = BuildConfig.GitHash

        return gitHash
    }
}
