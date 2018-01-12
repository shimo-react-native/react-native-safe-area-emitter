
package im.shimo.safeare;


import android.content.res.Resources;
import android.os.Build;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

/**
 * 调用此方法，主题不能设置为fitsSystemWindow = true;
 * 此方法调用后 应用为全屏(NavigationBar还是存在)，透明状态栏
 */
public class RNSafeAreaModule extends ReactContextBaseJavaModule {
    private static int STATUS_BAR_HEIGHT = 0;

    static {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Resources resources = Resources.getSystem();
            int resourceId = resources.getIdentifier("status_bar_height", "dimen", "android");
            if (resourceId > 0) {
                STATUS_BAR_HEIGHT = resources.getDimensionPixelSize(resourceId);
            }
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
        return STATUS_BAR_HEIGHT;
    }

}
