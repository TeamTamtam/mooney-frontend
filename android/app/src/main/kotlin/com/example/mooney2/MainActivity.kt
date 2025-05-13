package com.example.mooney2

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "notification_permission_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ MethodChannel 설정 (알림 접근 설정 열기용)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "openNotificationSettings") {
                val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        // ✅ FlutterEngine 캐시에 등록 (NotificationService에서 사용 가능)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
    }
}


//package com.example.mooney2
//
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import android.content.Intent
//import android.provider.Settings
//
//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "notification_permission_channel"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//                call, result ->
//            if (call.method == "openNotificationSettings") {
//                // 알림 접근 설정 화면으로 이동
//                val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
//                startActivity(intent)
//                result.success(null)
//            } else {
//                result.notImplemented()
//            }
//        }
//    }
//}