
package im.shimo.safeare;


import android.content.res.Resources;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class RNSafeAreaModule extends ReactContextBaseJavaModule {
    private static int mNavigationBarHeight = 0;

    static {
        Resources resources = Resources.getSystem();
        int resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android");
        if (resourceId > 0) {
            mNavigationBarHeight = resources.getDimensionPixelSize(resourceId);
        }
    }

    public RNSafeAreaModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNSafeArea";
    }

    @ReactMethod
    public int getRootSafeArea() {
        return mNavigationBarHeight;
    }

}
