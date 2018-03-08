//
//  FilterAddViewController.swift
//  TasteApp
//
//  Created by Aparna on 3/21/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class FilterAddViewController: UIViewController {
    
    //    @IBOutlet weak var referenceSlider: UISlider!
    //    @IBOutlet weak var lblplacekeep: UILabel!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn222: UIButton!
    @IBOutlet weak var btn333: UIButton!
    
    @IBOutlet weak var btn1Label: UILabel!
    @IBOutlet weak var btn2Label: UILabel!
    @IBOutlet weak var btn3Label: UILabel!
    
    var tag :Int = 0
    var arrFilter = [[String:Any]]()
    var filterName :String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //        self.navigationItem.setHidesBackButton(true, animated:true);
        btn11.backgroundColor = UIColor.darkGray
        btn11.layer.cornerRadius = 15
        btn11.layer.borderWidth = 1
        btn222.layer.cornerRadius = 15
        btn222.layer.borderWidth = 1
        btn333.layer.cornerRadius = 15
        btn333.layer.borderWidth = 1
        
        let myColor : UIColor = UIColor.clear
        btn11.layer.borderColor = myColor.cgColor
        btn222.layer.borderColor = myColor.cgColor
        btn333.layer.borderColor = myColor.cgColor
        
        btn1Label.backgroundColor = UIColor.darkGray
        btn2Label.backgroundColor = UIColor.darkGray
        btn3Label.backgroundColor = UIColor.darkGray
        
       // initializeView()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    @IBAction func sliderAction(_ sender: UISlider)
    //    {
    //        lblplacekeep.text=String(referenceSlider.value)
    //    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        
        
        if sender == btn11 {
            btn11.backgroundColor = UIColor.darkGray
            btn333.backgroundColor = UIColor.clear
            btn222.backgroundColor = UIColor.clear
            btn1Label.backgroundColor = UIColor.darkGray
            btn2Label.backgroundColor = UIColor.darkGray
            btn3Label.backgroundColor = UIColor.darkGray
            //            btn333.isHidden=true
            //            btn222.isHidden=true
            
        } else if sender == btn222
        {
            btn222.backgroundColor = UIColor.darkGray
            btn11.backgroundColor = UIColor.clear
            btn333.backgroundColor = UIColor.clear
            btn2Label.backgroundColor = UIColor.darkGray
            btn1Label.backgroundColor = UIColor.darkGray
            btn3Label.backgroundColor = UIColor.darkGray
            //            btn333.isHidden=true
            //            btn222.isHidden=true
            
        } else if sender == btn333
        {
            btn333.backgroundColor = UIColor.darkGray
            btn11.backgroundColor = UIColor.clear
            btn222.backgroundColor = UIColor.clear
            btn3Label.backgroundColor = UIColor.darkGray
            btn1Label.backgroundColor = UIColor.darkGray
            btn2Label.backgroundColor = UIColor.darkGray
            //            btn333.isHidden=true
            //            btn222.isHidden=true
            
        }
        
        
        
    }
    
    
    func initializeView()
        
        
    {
        SVProgressHUD.show()
        
        
        delayWithSeconds(1.0)
        {
            
            SVProgressHUD.show()
            
            //let parameter = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"type":"simple"]
            
            //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"type":"simple"]
            let singelton = SharedManager.sharedInstance
           
            let parameters = ["user_id":singelton.loginId,"type":"simple"]
            print("paramter is \(parameters)")
            
            
            DataManager.sharedManager.getSetting(params: parameters, completion: { (response) in
                
                if let dataDic = response as? [[String:Any]]
                {
                    
                    self.arrFilter = dataDic
                    
                    if self.arrFilter.count > 0
                    {
                        let positionOb = self.arrFilter[0]
                        print(positionOb)
                        if let companyDict = positionOb["setting"] as? [String:Any]
                        {
                            print(companyDict)
                            
                            
                            let dict = companyDict["simple"] as? [String:Any]
                            
                            
                            self.filterName = dict?["filter"] as! String
                            print("name is filetr is \(self.filterName)")
                            
                            self.loadData()
                        }
                        
                    }
                        
                        
                    else
                        
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    
                }
                
                
                
            })
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
            }
        }
        
        
        
        
        
    }
    
    
    func loadData ()
        
    {
        if self.filterName == "PLACE_I_GO_ALL_TIME"
            
        {
            //            btn11.isHidden = true
            //            btn222.isHidden = true
            //            btn333.isHidden = false
            btn333.backgroundColor = UIColor.gray
            btn11.backgroundColor = UIColor.clear
            btn222.backgroundColor = UIColor.clear
            
            btn3Label.backgroundColor = UIColor.darkGray
            btn1Label.backgroundColor = UIColor.darkGray
            btn2Label.backgroundColor = UIColor.darkGray
        }
            
            
        else if self.filterName == "LESS_THEN_$20"
        {
            
            //            btn11.isHidden = true
            //            btn222.isHidden = false
            //            btn333.isHidden = true
            btn333.backgroundColor = UIColor.clear
            btn11.backgroundColor = UIColor.clear
            btn222.backgroundColor = UIColor.gray
            
            
            btn3Label.backgroundColor = UIColor.darkGray
            btn1Label.backgroundColor = UIColor.darkGray
            btn2Label.backgroundColor = UIColor.darkGray        }
            
        else if self.filterName == "ALL"
        {
            
            //            btn11.isHidden = false
            //            btn222.isHidden = true
            //            btn333.isHidden = true
            btn11.backgroundColor = UIColor.gray
            btn11.backgroundColor = UIColor.clear
            btn222.backgroundColor = UIColor.clear
            
            
            btn3Label.backgroundColor = UIColor.darkGray
            btn1Label.backgroundColor = UIColor.darkGray
            btn2Label.backgroundColor = UIColor.darkGray
        }
    }

    @IBAction func btnUpdateClick(_ sender: Any)
    {
        
        print("clicked")
    }
    
    
    

    
    
    
    
    @IBAction func btnAdvancedAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterSuggestViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController( animated: true)
    }
    
}
