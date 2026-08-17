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
            try {
                InstrumentationRegistry.getInstrumentation().runOnMainSync(() -> {
                    try {
                        Field ruleField = FlutterTestRunner.class.getDeclaredField("rule");
                        ruleField.setAccessible(true);
                        Object ruleObj = ruleField.get(this);
                        if (ruleObj instanceof ActivityTestRule) {
                            Activity activity = ((ActivityTestRule<?>) ruleObj).getActivity();
                            if (activity != null && !activity.isFinishing()) {
                                activity.finish();
                            }
                        }
                    } catch (Exception ignored) {
                    }

                    for (Stage stage : new Stage[]{Stage.RESUMED, Stage.PAUSED, Stage.STARTED, Stage.STOPPED}) {
                        for (Activity activity : ActivityLifecycleMonitorRegistry.getInstance().getActivitiesInStage(stage)) {
                            if (activity != null && !activity.isFinishing()) {
                                activity.finish();
                            }
                        }
                    }
                });
            } catch (Exception ignored) {
            }

            try {
                Thread.sleep(500);
            } catch (InterruptedException ignored) {
            }

            try {
                InstrumentationRegistry.getInstrumentation().finish(Activity.RESULT_OK, new android.os.Bundle());
            } catch (Exception ignored) {
            }
        }
    }
}
