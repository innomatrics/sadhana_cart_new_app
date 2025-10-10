package com.innomatrics.sadhana_cart

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Add any custom initialization here
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        // Example: Initialize other plugins if needed
        // FirebaseMessagingPlugin.registerWith(flutterEngine)
    }
}