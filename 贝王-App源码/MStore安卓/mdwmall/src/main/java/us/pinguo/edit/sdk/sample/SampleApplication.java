package us.pinguo.edit.sdk.sample;

import android.app.Application;

import us.pinguo.edit.sdk.PGEditImageLoader;
import us.pinguo.edit.sdk.base.PGEditSDK;

/**
 * Created by taoli on 14/11/5.
 */
public class SampleApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        PGEditImageLoader.initImageLoader(this);
        PGEditSDK.instance().initSDK(this);
    }
}
