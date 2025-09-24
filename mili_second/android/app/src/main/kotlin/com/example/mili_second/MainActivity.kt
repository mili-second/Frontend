package com.example.mili_second


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.os.Process
import android.provider.Settings

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.mili_second/usagestats"

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun requestUsageStatsPermission() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        startActivity(intent)
    }

    // ⭐ 수정된 부분: 시작 및 종료 시간을 인자로 받도록 변경
    private fun getUsageStatsData(startTime: Long, endTime: Long): List<Map<String, Any>> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        // 인자로 받은 시간 범위를 그대로 사용
        val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
        val events = mutableListOf<Map<String, Any>>()
        val event = UsageEvents.Event()

        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event)
            val eventMap = mapOf(
                "packageName" to event.packageName,
                "timeStamp" to event.timeStamp,
                "eventType" to event.eventType
            )
            events.add(eventMap)
        }

        return events
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getUsageStats") {
                if (hasUsageStatsPermission()) {
                    // ⭐ 수정된 부분: Flutter에서 전달한 인자(startTime, endTime)를 추출
                    val startTime = call.argument<Long>("startTime")
                    val endTime = call.argument<Long>("endTime")

                    if (startTime != null && endTime != null) {
                        val usageData = getUsageStatsData(startTime, endTime)
                        result.success(usageData)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Start and end times must be provided.", null)
                    }
                } else {
                    requestUsageStatsPermission()
                    result.error("PERMISSION_DENIED", "Usage stats permission is not granted.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}