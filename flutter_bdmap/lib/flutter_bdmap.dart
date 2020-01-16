import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BDMapView extends StatelessWidget {
  final MapViewController controller;
  final Function() onViewCreated;

  BDMapView({Key key, @required this.controller, this.onViewCreated});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: "BDMapView",
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: "BDMapView",
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Center(child: Text("不支持的平台"));
  }

  _onPlatformViewCreated(int viewId) {
    this.controller?._methodChannel =
        new MethodChannel("com.shingohu/bdmap_" + viewId.toString());
    this.onViewCreated?.call();
  }
}

///地图标记点信息
class MarkerInfo {
  String userId;
  String headUrl;
  String title;
  String subTitle;
  double longitude; //经度
  double latitude; //纬度

  MarkerInfo({
    @required this.userId,
    @required this.headUrl,
    @required this.title,
    @required this.subTitle,
    @required this.latitude,
    @required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'title': title,
      'headUrl': headUrl,
      "subTitle": subTitle,
      "longitude": longitude,
      "latitude": latitude,
    };
  }
}

class MapViewController {
  MethodChannel _channel;
  Function(String id) _onMarkerClick;

  set _methodChannel(MethodChannel channel) {
    _channel = channel;
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onMarkerClick") {
        if (_onMarkerClick != null) {
          _onMarkerClick.call(call.arguments);
        }
      }
    });
  }

  set onMarkerClick(onMarkerClick) {
    this._onMarkerClick = onMarkerClick;
  }

  dispose() {
    _channel.setMethodCallHandler(null);
    _channel = null;
    _onMarkerClick = null;
  }

  showMarkers(List<MarkerInfo> markerInfos) {
    _channel
        .invokeMethod("showMarkers", {"markerInfos": json.encode(markerInfos)});
  }
}
