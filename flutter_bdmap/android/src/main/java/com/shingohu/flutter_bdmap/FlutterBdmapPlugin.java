package com.shingohu.flutter_bdmap;

import android.content.Context;

import androidx.annotation.NonNull;

import com.baidu.mapapi.SDKInitializer;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterBdmapPlugin
 */
public class FlutterBdmapPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    FlutterPluginBinding flutterPluginBinding;


    public FlutterBdmapPlugin() {

    }

    public FlutterBdmapPlugin(Context context) {
        initMap(context);
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.shingohu/bdmap");
        channel.setMethodCallHandler(new FlutterBdmapPlugin(flutterPluginBinding.getApplicationContext()));
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.shingohu/bdmap");
        channel.setMethodCallHandler(new FlutterBdmapPlugin(registrar.context()));
        registrar.platformViewRegistry().registerViewFactory("BDMapView", new BDMapViewFactory(registrar.activity(), registrar.messenger()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }


    private void initMap(Context context) {
        //在使用SDK各组件之前初始化context信息，传入ApplicationContext
        SDKInitializer.initialize(context);

    }


    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("BDMapView", new BDMapViewFactory(binding.getActivity(), flutterPluginBinding.getBinaryMessenger()));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
