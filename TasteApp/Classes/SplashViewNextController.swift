//
//  SplashViewNextController.swift
//  TasteApp
//
//  Created by Anuj Singh on 2/23/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class SplashViewNextController: UIViewController
{
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strButtonName: String!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("index page is ", pageIndex)
        
        self.setupView()
      
        
    }
    
    
    func setupView()
    {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "splash_bg")
//        self.view.addSubview(imageView)
//        imageView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
        
        self.view.backgroundColor = UIColor.white
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.height.equalTo(260)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-40)
            
            
        }

        
        let titleLabel = UILabel()
        titleLabel.text = "T A S T E"
        print(UIFont.fontNames(forFamilyName: K_Font_Color));
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: K_Font_Color_Bold, size: 28)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
           
            make.centerX.equalTo(self.view)
            make.top.equalTo(logoImageView).offset(-100)
          
            
        }
        
        
        let logoBulbImageView = UIImageView()
        logoBulbImageView.image = UIImage(named: "ic_bulb-1")
        self.view.addSubview(logoBulbImageView)
        logoBulbImageView.snp.makeConstraints { (make) in
            make.width.equalTo(100 * 0.5)
            make.height.equalTo(100 * 0.5)
            make.top.equalTo(logoImageView.snp.top).offset(-20)
            make.left.equalTo(logoImageView.snp.left).offset(110)
            
        }
        
        
        let receiveLabel = UILabel()
        receiveLabel.numberOfLines = 5
        //receiveLabel.text = "RECEIVE \n SUGGESTIONS \n FROM YOUR \n DINING HISTORY \n AND TENDENCIES."
        receiveLabel.text = strTitle
        print(UIFont.fontNames(forFamilyName: K_Font_Color ));
        receiveLabel.textAlignment = .center
        receiveLabel.font = UIFont(name:K_Font_Color , size: 22)
        self.view.addSubview(receiveLabel)
        receiveLabel.sizeToFit()
        receiveLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(logoBulbImageView.snp.bottom).offset(16)
        }
               
        let btnNext = UIButton()
        self.view.addSubview(btnNext)
        btnNext.backgroundColor = UIColor.black
        btnNext.setTitle(strButtonName, for: .normal)
        btnNext.setTitleColor(UIColor.white, for: .normal)
        btnNext.layer.cornerRadius = 4
        btnNext.snp.makeConstraints { (make) in
            
            make.width.equalTo(280)
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            
            
        }
        btnNext.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
        let pageController = UIPageControl()
        self.view.addSubview(pageController)
        pageController.snp.makeConstraints { (make) in
            
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-100)
            make.height.equalTo(50)
            
        }
        pageController.numberOfPages = 2
        
       
        if pageIndex == 0
        {
            pageController.currentPage = 1
           pageController.pageIndicatorTintColor = UIColor.black
            
        }
        else if pageIndex == 1
        {
           pageController.currentPage = 2
            pageController.pageIndicatorTintColor = UIColor.white
            pageController.currentPageIndicatorTintColor = UIColor.black
        
        }
        }
    
    
    func nextTapped() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
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
