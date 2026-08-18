package com.example.invoify;

import android.app.Activity;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.rule.ActivityTestRule;
import androidx.test.runner.lifecycle.ActivityLifecycleMonitorRegistry;
import androidx.test.runner.lifecycle.Stage;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import java.lang.reflect.Field;
import org.junit.Rule;
import org.junit.runner.RunWith;
import org.junit.runner.notification.RunNotifier;
import org.junit.AfterClass;

@RunWith(MainActivityTest.CustomRunner.class)
public class MainActivityTest {
    @Rule
    public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);

    public static class CustomRunner extends FlutterTestRunner {
        public CustomRunner(Class<?> testClass) {
            super(testClass);
        }

                @Override
        public void run(RunNotifier notifier) {
            super.run(notifier);
            // Ensure the instrumentation process ends cleanly.
            try {
                InstrumentationRegistry.getInstrumentation()
                        .finish(Activity.RESULT_OK, new android.os.Bundle());
            } catch (Exception ignored) {
            }
        }
        /** Runs after *all* tests in this class have finished. Guarantees the instrumentation is terminated. */
        @AfterClass
        public static void tearDownInstrumentation() {
            try {
                InstrumentationRegistry.getInstrumentation()
                        .finish(Activity.RESULT_OK, new android.os.Bundle());
            } catch (Exception ignored) {
            }
        }
    }
}
