package com.shingohu.flutter_bdmap;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BDMapViewFactory extends PlatformViewFactory {

    private Context activityContext;
    private BinaryMessenger messenger;


    public BDMapViewFactory(Context activityContext, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.activityContext = activityContext;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new BDMapView(activityContext, messenger, viewId);
    }
}
