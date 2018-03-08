//
//  FeedbackViewController.swift
//  Taste
//
//  Created by Lalitmohan on 5/30/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedbackViewController: UIViewController
{
    var isFromReview = ""
    var option:String = ""
    var isRating = ""
    var isDetailReview:String = ""
    var hasDetailReview:Bool = false
    var textMessage:String = ""
    var restaurantName:String = ""
    var detailFeedbackOption = [String:Any]()
    @IBOutlet weak var txtEat: UITextField!
    
    
    @IBOutlet weak var txtTotal: UITextField!
    
    
    @IBOutlet weak var txtPeople: UITextField!
    
    
    @IBOutlet weak var txtService: UITextField!
    
    
    @IBOutlet weak var txtReturing: UITextField!
    @IBOutlet weak var restaurantText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantText.text = K_INNERUSER_DATA.RestaurantName
        
        txtEat.layer.cornerRadius = 3.0
        txtEat.layer.borderWidth = 2.0
        txtEat.layer.borderColor = UIColor.black.cgColor
        
        txtTotal.layer.cornerRadius = 3.0
        txtTotal.layer.borderWidth = 2.0
        txtTotal.layer.borderColor = UIColor.black.cgColor
        
        txtPeople.layer.cornerRadius = 3.0
        txtPeople.layer.borderWidth = 2.0
        txtPeople.layer.borderColor = UIColor.black.cgColor
        
        txtService.layer.cornerRadius = 3.0
        txtService.layer.borderWidth = 2.0
        txtService.layer.borderColor = UIColor.black.cgColor
        
        txtReturing.layer.cornerRadius = 3.0
        txtReturing.layer.borderWidth = 2.0
        txtReturing.layer.borderColor = UIColor.black.cgColor
        if self.hasDetailReview{
            print(detailFeedbackOption)
            if let Eat = detailFeedbackOption["WHAT_DID_YOU_EAT"] as? String{
                self.txtEat.text = Eat
            }
            if let Total = detailFeedbackOption["HOW_MUCH_WAS_THE_TOTAL"] as? String{
                txtTotal.text = Total
            }
            
            if let People = detailFeedbackOption["HOW_MANY_PEOPLE_WERE_THERE"] as? String{
                txtPeople.text = People
            }
            if let Service = detailFeedbackOption["HOW_WAS_THE_SERVICE"] as? String{
                txtService.text = Service
            }
            if let Returning = detailFeedbackOption["WILL_YOU_BE_RETURNING"] as? String{
                txtReturing.text = Returning
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any)
    {
        
        self.reviewApiHit()
        
        /*   if txtEat.text!.isEmpty || txtTotal.text!.isEmpty || (txtPeople.text?.isEmpty)! || (txtService.text?.isEmpty)! || (txtReturing.text?.isEmpty)!
         {
         let alert = UIAlertController(title: "Taste", message:"Please fill all the fields.", preferredStyle: UIAlertControllerStyle.alert)
         let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
         UIAlertAction in
         NSLog("OK Pressed")
         }
         alert.addAction(okAction)
         self.present(alert, animated: true, completion: nil)
         return
         }
         
         else
         
         {
         self.reviewApiHit()
         }
         */
        
    }
    
    @IBAction func btnSkipClicked(_ sender: Any){
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        
//        for aViewController:UIViewController in viewControllers {
//            if aViewController.isKind(of: InnerCircleUserViewController.self) {
//                //_ = self.navigationController?.popToViewController(aViewController, animated: true)
//                self.reviewApiHit()
//            }
//        }
        self.reviewApiHit()
    }
    
    func reviewApiHit()
    {
        if Reachability.isConnectedToNetwork() == true
        {
            
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        let singelton = SharedManager.sharedInstance
        
        let parameter = ["user_id":singelton.loginId,"factual_id":K_INNERUSER_DATA.FactualId,"rate":self.isRating,"option":self.option,"has_detail_review":self.isDetailReview,"message":self.textMessage,"what_did_you_eat":txtEat.text!,"how_much_was_the_total":txtTotal.text!,"how_many_people_were_there":txtPeople.text!,"how_was_the_service":txtService.text!,"will_you_be_returning":txtReturing.text!] as [String : Any]
        print(parameter)
        
        DataManager.sharedManager.ReviewEntrySubmit(params:
        parameter) { (response) in
            
            
            if let dataDic = response as? String
            {
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if dataDic == ""{
                    if Reachability.isConnectedToNetwork() != true
                    {
                        let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else{
                        let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                    }
                }
                else{
                    let alert = UIAlertController(title: "Taste", message:dataDic, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        
                        for aViewController:UIViewController in viewControllers {
                            if aViewController.isKind(of: InnerCircleUserViewController.self) {
                                _ = self.navigationController?.popToViewController(aViewController, animated: true)
                            }
                            if aViewController.isKind(of: NotificatioinsViewController.self) {
                                _ = self.navigationController?.popToViewController(aViewController, animated: true)
                            }
                            
                        }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return

                }
                
            }
            else{
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
            }
            
        }
     }
    else
        {
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
    }
    
    
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: TEXTFILED DELEGATE METHOD
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
