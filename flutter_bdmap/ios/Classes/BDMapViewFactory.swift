//
//  BDMapViewFactory.swift
//  flutter_bdmap
//
//  Created by 胡杰 on 2020/1/15.
//

import UIKit
import Flutter



public class BDMapViewFactory :NSObject, FlutterPlatformViewFactory{
    
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BDMapView.init(withFrame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: _messenger!)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    
    var _messenger : FlutterBinaryMessenger?
       
       init(messenger : FlutterBinaryMessenger) {
           super.init()
           
           self._messenger = messenger
           
           
       }
       
    
}
