//
//  EditProfileFilterViewController.swift
//  TasteApp
//
//  Created by Anuj Singh on 3/8/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class EditProfileFilterViewController: UIViewController
{

    
    let step:Float=10
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        setUpView()
        
    
    }
    
    func goBack()
    {
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func jumpToAdvanceView()
    {
        
    }
    

    
    func setUpView()
    {
        
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "background-2")
//        self.view.addSubview(imageView)
//        imageView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
        
        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "SETTINGS"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_Font_Color_Regular, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(38)
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        
        let btnAdvance = UIButton(type: .custom)
        btnAdvance.backgroundColor = UIColor.black
        btnAdvance.titleLabel?.font = UIFont(name: K_Font_Color, size: 12)!
        btnAdvance.addTarget(self, action: #selector(self.jumpToAdvanceView), for: .touchUpInside)
        btnAdvance.setTitle("ADVANCED", for: .normal)
        btnAdvance.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(btnAdvance)
        btnAdvance.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            
        }
        
        
        let titleCenterText =  UILabel()
        titleCenterText.text = "Filter out any of the places you do not want in your dining analytics"
        titleCenterText.textAlignment = .center
        titleCenterText.numberOfLines = 3
        titleCenterText.font = UIFont(name: K_Font_Color, size: 20)
        self.view.addSubview(titleCenterText)
        titleCenterText.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(btnAdvance.snp.bottom).offset(10)
        }
        
        let btnUpdate = UIButton(type: .custom)
        btnUpdate.backgroundColor = UIColor.black
        //button.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        btnUpdate.setTitle("UPDATE", for: .normal)
        btnUpdate.setTitleColor(UIColor.white, for: .normal)
        btnUpdate.layer.cornerRadius = 4
        self.view.addSubview(btnUpdate)
        btnUpdate.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.height.equalTo(50)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        
      
        
    }//EndSetUPView
    
    func sliderValueDidChange(_ sender:UISlider!)
    {
        print("Slider value changed")
        
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        print("Slider step value \(Int(roundedStepValue))")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
