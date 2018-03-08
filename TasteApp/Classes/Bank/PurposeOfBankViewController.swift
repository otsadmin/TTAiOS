//
//  PurposeOfBankViewController.swift
//  TasteApp
//
//  Created by Shubhank on 27/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class PurposeOfBankViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    func setupView() {
        //        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "splash_bg")
        //        self.view.addSubview(imageView)
        //        imageView.snp.makeConstraints { (make) in
        //            make.edges.equalTo(self.view)
        //        }
        
        
        
        for family in UIFont.familyNames {
            let sName: String = family as String
            print("family: \(sName)")
            
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
        
        self.view.backgroundColor = UIColor.white
        
        //        let logoImageView = UIImageView()
        //        logoImageView.image = UIImage(named: "logo-transprent")
        //        self.view.addSubview(logoImageView)
        //        logoImageView.snp.makeConstraints { (make) in
        //            make.width.equalTo(480 * 0.5)//330
        //            make.height.equalTo(520 * 0.5)
        //            make.centerX.equalTo(self.view)
        //            make.centerY.equalTo(self.view).offset(-40)
        //        }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            //  make.top.equalTo(40)
            make.width.equalTo(490 * 0.5)//330
            make.height.equalTo(580 * 0.5)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-20)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "T A S T E"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 3
        titleLabel.font = UIFont(name: K_Font_Color_Regular, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
        }
        
        
        
        //        let backButton = UIButton(type: .custom)
        //        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        //        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        //        self.view.addSubview(backButton)
        //        backButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(20)
        //            make.width.equalTo(40)
        //            make.height.equalTo(40)
        //            make.centerY.equalTo(titleLabel.snp.centerY)
        //        }
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.setTitle("CONTINUE", for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(64)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        button.addTarget(self, action: #selector(self.continueTapped), for: .touchUpInside)
        
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name:"Roboto-Thin", size: 20)
        textView.isEditable = false
        textView.textAlignment = .justified
        textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to ma\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to ma"
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(button.snp.top).offset(-10)
        }
    }
    
    func continueTapped()
    {
        
        
        
        if(UserDefaults.standard .bool(forKey: "isLogin"))
        {
            let vc = ProfileBeingCreatedViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else
            
        {
            let vc = BanksListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    
    func goBack()
    {
        
        _ =  self.navigationController?.popViewController(animated: true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
