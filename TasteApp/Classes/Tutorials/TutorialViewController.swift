//
//  TutorialViewController.swift
//  TasteApp
//
//  Created by Shubhank on 20/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SnapKit

class TutorialViewController: UIViewController {

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
//        
//        let logoImageView = UIImageView()
//        logoImageView.image = UIImage(named: "logo-transprent")
//        self.view.addSubview(logoImageView)
//        logoImageView.snp.makeConstraints { (make) in
//            make.width.equalTo(330 * 0.5)
//            make.height.equalTo(400 * 0.5)
//            make.centerX.equalTo(self.view)
//            make.centerY.equalTo(self.view).offset(-40)
//        }
        
        self.view.backgroundColor = UIColor.white
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
