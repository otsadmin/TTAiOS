//
//  TTAUserCell.swift
//  Taste
//
//  Created by Mohit on 9/1/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SnapKit



class TTAUserCell: UICollectionViewCell {
    
    var TTAUsrName: UILabel!
    var TTAUserImage: UIImageView!

    var Plusbtn: UIButton!


    var LabelCompanyname: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("here")
        self.setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
    
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        self.contentView.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
        }
        
        TTAUserImage = UIImageView()
        self.contentView.addSubview(TTAUserImage)
        TTAUserImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        TTAUserImage.layer.cornerRadius = 50
        TTAUserImage.backgroundColor = UIColor.lightGray
        TTAUserImage.clipsToBounds = true
        
        TTAUsrName = UILabel()
        self.contentView.addSubview(TTAUsrName)
        TTAUsrName.snp.makeConstraints { (make) in
            make.top.equalTo(TTAUserImage.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        TTAUsrName.numberOfLines = 1
        TTAUsrName.adjustsFontSizeToFitWidth = true
        TTAUsrName.minimumScaleFactor = 0.2
        TTAUsrName.font = UIFont(name:  K_Font_Color, size: 17)
        TTAUsrName.textAlignment = .center
        
        
        Plusbtn = UIButton(type:.custom)
        self.contentView.addSubview(Plusbtn)
        Plusbtn.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(5)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        Plusbtn.setImage(UIImage(named:"ic_plus_blue"), for: .normal)
        
        
        LabelCompanyname = UILabel()
        self.contentView.addSubview(LabelCompanyname)
        LabelCompanyname.snp.makeConstraints { (make) in
            make.top.equalTo(TTAUsrName.snp.bottom).offset(-2)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        LabelCompanyname.numberOfLines = 1
        LabelCompanyname.adjustsFontSizeToFitWidth = true
        LabelCompanyname.minimumScaleFactor = 0.2
        LabelCompanyname.font = UIFont(name:  K_Font_Color, size: 13)
        LabelCompanyname.textAlignment = .center
        
        
        


    }
    
}
