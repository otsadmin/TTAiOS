//
//  FilterViewController.swift
//  TasteApp
//
//  Created by Anuj Singh on 3/7/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController
{

    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpView()
        
    }
    
    func setUpView()
    {
       
        
        //let titleLabel = UILabel()
        //titleLabel.text = "EXPLORE"
        //titleLabel.textAlignment = .center
        //titleLabel.numberOfLines = 2
       // titleLabel.font = UIFont(name: "MyanmarSangamMN-Bold", size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
       // self.view.addSubview(titleLabel)
        //titleLabel.snp.makeConstraints { (make) in
           // make.left.equalTo(20)
           // make.right.equalTo(-20)
            //make.top.equalTo(40)
       // }

        titleLabel.text = "EXPLORE"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_Font_Color_Bold, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                        
        
        
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
