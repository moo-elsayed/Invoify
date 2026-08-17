package com.example.invoify

import dev.flutter.plugins.integration_test.IntegrationTestPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Register IntegrationTestPlugin BEFORE other plugins (especially Firebase)
        // to ensure its MethodChannel is set up before Firebase background threads
        // can starve the main Looper on Firebase Test Lab devices.
        flutterEngine.plugins.add(IntegrationTestPlugin())
        super.configureFlutterEngine(flutterEngine)
    }
}
