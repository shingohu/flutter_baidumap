//
//  MarkerInfo.swift
//  flutter_bdmap
//
//  Created by 胡杰 on 2020/1/16.
//

import Foundation
@objc open class MarkerInfo :NSObject,Decodable{
    
    @objc open var userId:String = ""
    @objc open var headUrl:String = ""
    @objc open var title:String = ""
    @objc open var subTitle:String = ""
    @objc open var longitude:Double = 0.0//精度
    @objc open var latitude:Double = 0.0//纬度
}
