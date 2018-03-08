//
//  TermsViewController.swift
//  TasteApp
//
//  Created by Mohit Deval on 05/04/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let url = Bundle.main.url(forResource: "Terms", withExtension: "html")
//        rWebView.loadRequest(URLRequest(url: url!) )
        
        
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
        
//        let logoImageView = UIImageView()
//        logoImageView.image = UIImage(named: "logo-transprent")
//        self.view.addSubview(logoImageView)
//        logoImageView.snp.makeConstraints { (make) in
//            make.width.equalTo(520 * 0.5)//330
//            make.height.equalTo(520 * 0.5)
//            make.centerX.equalTo(self.view)
//            make.centerY.equalTo(self.view).offset(-40)
//        }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            //  make.top.equalTo(40)
            make.width.equalTo(590 * 0.5)//490
            make.height.equalTo(680 * 0.5)//580
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(5)
        }
  
        let titleLabel = UILabel()
        titleLabel.text = "T A S T E"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 3
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 26)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(60)
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
        
        
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
          textView.font = UIFont(name:K_Font_Color_Light, size: 18)
        textView.isEditable = false
        textView.textAlignment = .justified
        textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to ma\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to ma"
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
