//
//  MarkerInfoView.swift
//  flutter_bdmap
//
//  Created by 胡杰 on 2020/1/16.
//

import UIKit
import Kingfisher

@objc open class MarkerInfoView: UIView {
    
    let width = 100
    let height = 40
    @objc open var headerUrl:String?
    @objc open var userId:String?

    public override init(frame: CGRect) {
        
        super.init(frame: frame)
       
        
    }
    
    @objc open func initSubView(headerUrl:String,userId:String,title:String,subTitle:String)  {
        self.userId = userId
        self.headerUrl = headerUrl
        self.backgroundColor = UIColor.white
            
        
        let headIV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: height, height: height))
        
        let url = URL(string: headerUrl)
        headIV.kf.setImage(with: url)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 43, y: 0, width: 53, height: 20))
        
       
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        
        let subtitleLabel = UILabel.init(frame: CGRect.init(x: 43, y: 20, width: 53, height: 20))
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        
       
        subtitleLabel.text = subTitle
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.adjustsFontSizeToFitWidth = true
        
        
        self.addSubview(headIV)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        
      
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
