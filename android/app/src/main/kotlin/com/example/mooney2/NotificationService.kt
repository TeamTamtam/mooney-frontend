package com.example.mooney2

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class NotificationService : NotificationListenerService() {

    private fun sendNotificationToFlutter(sbn: StatusBarNotification) {
        val extras = sbn.notification.extras
        val tickerText = sbn.notification.tickerText?.toString() ?: ""
        val title = extras.getCharSequence("android.title")?.toString() ?: ""
        val text = extras.getCharSequence("android.text")?.toString() ?: ""
        val bigText = extras.getCharSequence("android.bigText")?.toString() ?: ""

        val notificationData = HashMap<String, Any?>().apply {
            put("packageName", sbn.packageName)
            put("notificationId", sbn.id)
            put("tickerText", tickerText)
            put("title", title)  // 🔥 알림 제목 추가
            put("text", text)    // 🔥 알림 본문 추가
            put("bigText", bigText)  // 🔥 확장된 본문 추가 (더 많은 내용 포함 가능)
        }

        val engine = FlutterEngineCache.getInstance().get("my_engine_id")
        if (engine == null) {
            Log.e("NotificationService", "No cached FlutterEngine found!")
        } else {
            Log.d("NotificationService", "Using cached FlutterEngine")
            val channel = MethodChannel(engine.dartExecutor.binaryMessenger, "notification_channel")
            channel.invokeMethod("notificationPosted", notificationData)
        }
    }


    // 서비스가 시스템에 연결될 때 호출됨
    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d("NotificationService", "Listener connected. Retrieving active notifications.")
        // 현재 상태바에 남아 있는 모든 알림을 가져와 Flutter로 전달
        val activeNotifications: Array<StatusBarNotification> = getActiveNotifications()
        for (sbn in activeNotifications) {
            sendNotificationToFlutter(sbn)
        }
    }

    // 새로운 알림이 도착할 때 호출됨
    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        sbn?.let {
            sendNotificationToFlutter(it)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        // 필요에 따라 알림 제거 시 처리할 로직 구현
    }
}