
package im.shimo.safeare;


import android.content.res.Resources;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

/**
 * 调用此方法，主题不能设置为fitsSystemWindow = true;
 * 此方法调用后 应用为全屏(NavigationBar还是存在)，透明状态栏
 */
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
