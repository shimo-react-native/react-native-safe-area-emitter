

package im.shimo.safeare;


import android.content.res.Resources;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Map;

public class RNSafeAreaModule extends ReactContextBaseJavaModule {
    private static int mNavigationBarHeight = 0;
    private static int mStatusBarHeight = 25;

    public RNSafeAreaModule(ReactApplicationContext reactContext) {
        super(reactContext);
        Resources resources = reactContext.getResources();
        int bottomId = resources.getIdentifier("navigation_bar_height", "dimen", "android");
        if (bottomId > 0) {
            mNavigationBarHeight = resources.getDimensionPixelSize(bottomId);
        }
        int topId = resources.getIdentifier("status_bar_height", "dimen", "android");
        if (topId > 0) {
            mStatusBarHeight = resources.getDimensionPixelSize(topId);
        }
    }

    @Override
    public String getName() {
        return "RNSafeArea";
    }

    @ReactMethod
    public void getRootSafeArea(Promise promise) {
        WritableMap result = Arguments.createMap();
        result.putInt("top", mStatusBarHeight);
        result.putInt("bottom", mNavigationBarHeight);
        result.putInt("left", 0);
        result.putInt("right", 0);
        promise.resolve(result);
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("top", mStatusBarHeight);
        constants.put("bottom", mNavigationBarHeight);
        return constants;
    }

}

