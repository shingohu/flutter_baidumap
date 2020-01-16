import Flutter
import UIKit




public class SwiftFlutterBdmapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    
    
    let channel = FlutterMethodChannel(name: "flutter_bdmap", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBdmapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
       
    registrar.register(BDMapViewFactory.init(messenger: registrar.messenger()), withId: "BDMapView")
    
    
    //初始化地图SDK
    BDMap.share()?.initMap()
    
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   
    
    
  }
}
