package com.shingohu.flutter_bdmap;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.InfoWindow;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.model.LatLng;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.transition.Transition;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static androidx.core.content.PermissionChecker.PERMISSION_GRANTED;

public class BDMapView implements PlatformView, Application.ActivityLifecycleCallbacks, MethodChannel.MethodCallHandler {

    MapView mapView;
    BaiduMap baiduMap;
    Application application;
    LocationClient mLocationClient;
    MyLocationListener myLocationListener;
    boolean isFirstLocation = true;
    MethodChannel methodChannel;
    Context context;


    public BDMapView(Context activityContext, BinaryMessenger messenger, int viewId) {
        this.context = activityContext;
        this.application = ((Application) (activityContext.getApplicationContext()));
        this.application.registerActivityLifecycleCallbacks(this);
        methodChannel = new MethodChannel(messenger, "com.shingohu/bdmap_" + viewId);
        methodChannel.setMethodCallHandler(this);
        mapView = new MapView(activityContext);
        baiduMap = mapView.getMap();
        baiduMap.setMapType(BaiduMap.MAP_TYPE_NORMAL);
        baiduMap.setMyLocationEnabled(true);
    }


    //请求定位权限
    private void requestLocationPermission() {
        if (Build.VERSION.SDK_INT >= 23 && context != null) { //判断是否为android6.0系统版本，如果是，需要动态添加权限
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                    != PERMISSION_GRANTED) {// 没有权限，申请权限。
                ActivityCompat.requestPermissions((Activity) context, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 200);
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        startLocation(context);
                    }
                }, 10000);
                return;
            }
        }
        startLocation(context);
    }

    //开始定位
    private void startLocation(Context context) {
        if (context == null) {
            return;
        }
        //定位初始化
        mLocationClient = new LocationClient(context.getApplicationContext());
        //通过LocationClientOption设置LocationClient相关参数
        LocationClientOption option = new LocationClientOption();
        option.setOpenGps(true); // 打开gps
        option.setLocationMode(LocationClientOption.LocationMode.Battery_Saving);

        option.setCoorType("bd09ll"); // 设置坐标类型
        option.setScanSpan(30000);

        option.setLocationNotify(true);
        mLocationClient.requestLocation();
        //设置locationClientOption
        mLocationClient.setLocOption(option);

        //注册LocationListener监听器
        myLocationListener = new MyLocationListener();
        mLocationClient.registerLocationListener(myLocationListener);
        //开启地图定位图层
        mLocationClient.start();


    }

    @Override
    public View getView() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                requestLocationPermission();
            }
        }, 1000);
        return mapView;
    }

    @Override
    public void dispose() {
        if (this.application != null) {
            this.application.unregisterActivityLifecycleCallbacks(this);
            this.application = null;
        }
        if (mapView != null) {
            mLocationClient.unRegisterLocationListener(myLocationListener);
            mLocationClient.stop();
            baiduMap.setMyLocationEnabled(false);
            mapView.onDestroy();
            mapView = null;
            baiduMap = null;
            mLocationClient = null;
            myLocationListener = null;
        }

        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }

        this.context = null;
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (mapView != null) {
            mapView.onResume();
        }
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (mapView != null) {
            mapView.onPause();
        }
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(Activity activity) {

    }


    @Override
    public void onActivityStopped(Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (mapView == null) {
            return;
        }

        if (call.method.equals("showMarkers")) {

            Log.e("BDMap", call.arguments.toString());
            //显示人员标记信息
            Map map = (Map) call.arguments;
            String markerInfos = (String) map.get("markerInfos");
            showMarkers(parseMarkerInfos(markerInfos));
        }
    }

    private List<MarkerInfo> parseMarkerInfos(String markerInfosJson) {
        List<MarkerInfo> markerInfos = new ArrayList<>();
        try {
            JSONArray jsonArray = new JSONArray(markerInfosJson);
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                MarkerInfo markerInfo = new MarkerInfo();
                markerInfo.headUrl = jsonObject.getString("headUrl");
                markerInfo.userId = jsonObject.getString("userId");
                markerInfo.title = jsonObject.getString("title");
                markerInfo.subTitle = jsonObject.getString("subTitle");
                markerInfo.latitude = jsonObject.getDouble("latitude");
                markerInfo.longitude = jsonObject.getDouble("longitude");
                markerInfos.add(markerInfo);
            }


        } catch (JSONException e) {
            e.printStackTrace();
        }


        return markerInfos;
    }


    private void showMarkers(List<MarkerInfo> markerInfos) {
        if (baiduMap != null && markerInfos != null && !markerInfos.isEmpty()) {
            baiduMap.clear();
            for (final MarkerInfo info : markerInfos) {
                createInfoWindow(info, new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (methodChannel != null) {
                            methodChannel.invokeMethod("onMarkerClick", info.userId);
                        }
                    }
                });
            }

        }
    }


    private InfoWindow createInfoWindow(MarkerInfo markerInfo, View.OnClickListener clickListener) {
        final View view = View.inflate(mapView.getContext(), R.layout.marker_view, null);

        view.setOnClickListener(clickListener);
        final InfoWindow infoWindow = new InfoWindow(view, new LatLng(markerInfo.latitude, markerInfo.longitude), 0);
        final ImageView headIV = view.findViewById(R.id.headIV);
        TextView titleTV = view.findViewById(R.id.titleTV);
        TextView subTitleTV = view.findViewById(R.id.subTitleTV);
        if (markerInfo.headUrl != null && !markerInfo.headUrl.isEmpty()) {
            Glide.with(mapView.getContext())
                    .asBitmap()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .load(markerInfo.headUrl)
                    .into(new CustomTarget<Bitmap>() {
                        @Override
                        public void onResourceReady(@NonNull Bitmap bitmap, @Nullable Transition<? super Bitmap> transition) {
                            if (headIV != null) {
                                headIV.setImageBitmap(bitmap);
                            }
                            if (baiduMap != null) {
                                baiduMap.showInfoWindow(infoWindow, false);
                            }
                        }

                        @Override
                        public void onLoadCleared(@Nullable Drawable placeholder) {

                        }
                    });


        }
        titleTV.setText(markerInfo.title);
        subTitleTV.setText(markerInfo.subTitle);
        return infoWindow;
    }


    public class MyLocationListener extends BDAbstractLocationListener {
        @Override
        public void onReceiveLocation(BDLocation location) {
            //mapView 销毁后不在处理新接收的位置
            if (location == null || mapView == null) {
                return;
            }
            MyLocationData locData = new MyLocationData.Builder()
                    .accuracy(location.getRadius())
                    // 此处设置开发者获取到的方向信息，顺时针0-360
                    .direction(location.getDirection()).latitude(location.getLatitude())
                    .longitude(location.getLongitude()).build();

            baiduMap.setMyLocationData(locData);


            if (isFirstLocation) {
                isFirstLocation = false;
                MapStatus.Builder builder = new MapStatus.Builder();
                builder.zoom(12.0f)
                        .target(new LatLng(location.getLatitude(), location.getLongitude()));
                baiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
            }

        }
    }
}
