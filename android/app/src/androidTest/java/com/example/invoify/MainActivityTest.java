package com.example.invoify;

import android.app.Activity;
import android.os.Bundle;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.rule.ActivityTestRule;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import org.junit.AfterClass;
import org.junit.Rule;
import org.junit.runner.RunWith;

@RunWith(FlutterTestRunner.class)
public class MainActivityTest {
    @Rule
    public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);

    @AfterClass
    public static void tearDownClass() {
        try {
            InstrumentationRegistry.getInstrumentation().finish(Activity.RESULT_OK, new Bundle());
        } catch (Throwable ignored) {
        }
    }
}