//
//  BDMapView.swift
//  flutter_bdmap
//
//  Created by 胡杰 on 2020/1/15.
//

import UIKit
import Flutter




class BDMapView: NSObject,FlutterPlatformView {
    
    var _channel:FlutterMethodChannel?;
    
    var _mapView:UIView?;
   
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?,binaryMessenger messenger: FlutterBinaryMessenger) {
        super.init()
        _channel = FlutterMethodChannel.init(name: "com.shingohu/bdmap_\(viewId)", binaryMessenger: messenger)
        weak var weakSelf = self
        _channel?.setMethodCallHandler { (call, resulet) in
            if(call.method == "showMarkers"){
                let dic =  call.arguments as! Dictionary<String,Any>
                let markerInfosJson:String = dic["markerInfos"] as! String

                weakSelf?.showMarkerInfos(markerInfos:  weakSelf?.parseMarkerInfos(markerInfosJson: markerInfosJson) ?? [])

            }
        }
        
        BDMap.share()?.onMarkerClick = { userId in
    
            weakSelf?.onMarkerInfoClick(userId: userId!)
        }
        _mapView = BDMap.share()?.createMapView(frame)

        
        
    }
    
    
    
    func showMarkerInfos(markerInfos:Array<MarkerInfo>){
        if(markerInfos.count>0 && _mapView != nil){
            
            BDMap.share()?.show(markerInfos)
            
        }
        
        
    }
    
    func onMarkerInfoClick(userId:String){
        _channel?.invokeMethod("onMarkerClick", arguments: userId)
    }
    
    
    func parseMarkerInfos(markerInfosJson:String) -> Array<MarkerInfo>{
        let decoder = JSONDecoder()
        guard let markerInfos = try? decoder.decode([MarkerInfo].self, from: markerInfosJson.data(using: String.Encoding.utf8) ?? Data.init()) else { return [] }
        
        return markerInfos
        
        
    }
    
    func view() -> UIView {
        return _mapView!;
    }
    
    
    deinit {
        print("MapView销毁")
        _channel?.setMethodCallHandler(nil)
        _channel = nil
        _mapView = nil
        BDMap.share()?.destoryMapView()
        
    }
    
}
