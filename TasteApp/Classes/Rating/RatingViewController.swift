//
//  RatingViewController.swift
//  Taste
//
//  Created by Lalitmohan on 5/30/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class RatingViewController: UIViewController,UITextViewDelegate
{
    @IBOutlet weak var btnYesLeading: NSLayoutConstraint!
    @IBOutlet weak var btnYesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonViewImage: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var btnNoHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNoTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var btnNoLeadingConstant: NSLayoutConstraint!
    //    @IBOutlet weak var btnNoTrailingConstant: NSLayoutConstraint!
    //    @IBOutlet weak var btnNoLeadingConstant: NSLayoutConstraint!
    
    //    @IBOutlet weak var btnNoLeading: NSLayoutConstraint!
    //    @IBOutlet weak var heightNoBtn: NSLayoutConstraint!
    //    @IBOutlet weak var heightYesBtn: NSLayoutConstraint!
    //    @IBOutlet weak var btnYesLeading: NSLayoutConstraint!
    
    var NotificationObj : String = ""
    var isFromReview =  ""
    var paramDict = [String : Any]()
    var notify_user_id = ""
    var recieveUserId = ""
    var resto_Name = ""
    
    var buttonSitClick = true
    var buttonQuietBiteClick = true
    var buttonQuietClick = true
    var buttonHIghClassClick = true
    var option:String = ""
    var optionSit :String = ""
    var optionQuiet : String = ""
    var optionHighClass : String = ""
    var optionQuietBite : String = ""
    var isYesClick = true
    var isNoClick = true
    var isRating:String = ""
    var factualID:String = ""
    let CharacterLimit = 140
    var detailFeedbackOption = [String:Any]()
    var isDetailReview:Bool = false
    
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var btnYesClicked: UIButton!
    @IBOutlet weak var btnNoClicked: UIButton!
    @IBOutlet weak var restaurantName: UILabel!
    
    
    @IBOutlet weak var viewRating: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtViewDescription?.layer.borderColor = UIColor.black.cgColor
        txtViewDescription?.layer.borderWidth = 1.0;
        txtViewDescription?.layer.cornerRadius = 5.0;
        // btnYesClicked.isHidden = false
        // btnNoClicked.isHidden = true
        txtViewDescription?.text = "Type Here"
        txtViewDescription?.textColor = UIColor.lightGray
        
        
        self.restaurantName?.text = K_INNERUSER_DATA.RestaurantName
        
        self.isRated()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        if self.NotificationObj == "FromNotification"{
            
            self.restaurantName?.text = self.resto_Name
            DispatchQueue.global().async {
                
                self.paramDict = ["ID":self.notify_user_id,"status":"READED"]
                self.makeReadNOtification(param: self.paramDict)
                print(self.paramDict)
                DispatchQueue.main.async(execute: {
                    
                })
            }


            
        }

    }
    // MARK: - TEXTFIELD DELEGATE METHODS

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        return updatedText.characters.count <= CharacterLimit
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            if textView.text == "Type Here"{
                textView.text = nil
            }
            
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Here"
            textView.textColor = UIColor.lightGray
        }
    }
    @IBAction func RatingYesClicked(_ sender: Any) {
        
        
        if !isNoClick{
            btnNoHeight.constant = 25
            self.btnNoClicked.isHidden = false
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.buttonViewImage.layoutIfNeeded()
            }
            isYesClick = true
            isNoClick = true
        }
        else{
            btnNoHeight.constant = 0
            self.btnNoClicked.isHidden = true
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.buttonViewImage.layoutIfNeeded()
            }
            isYesClick = true
            isNoClick = false
        }
        
        
        
        
    }
    @IBAction func RatingNoClicked(_ sender: Any){
        
        if !isYesClick{
            
            btnYesLeading.constant = 11
            btnYesHeight.constant = 25
            btnYesClicked.isHidden = false
            
            btnNoClicked.isHidden = false
            btnNoHeight.constant = 25
            btnNoLeadingConstant.constant = 22
            btnNoTrailingConstant.constant = 15
            
            
            // btnNoLeadingConstant.constant = 22
            btnNoTrailingConstant.constant = 15
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.buttonViewImage.layoutIfNeeded()
            }
            isYesClick = true
        }
        else
        {
            btnNoLeadingConstant.constant = 0
            btnNoTrailingConstant.constant = 61
            btnNoHeight.constant = 25
            btnNoClicked.isHidden = false
            btnYesClicked.isHidden = true
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.buttonViewImage.layoutIfNeeded()
            }
            isYesClick = false
            
            
        }
        
        
        
        
        
    }
    @IBAction func btnSubmitClicked(_ sender: Any)
    {
        
        if !buttonSitClick
        {
            
            optionSit = "SIT_AND_CHAT" + ","
            
            
        }
        else
        {
            optionSit = ""
            
        }
        if !buttonQuietClick
        {
            optionQuiet  = "QUIET" + ","
            option = option + optionQuiet + ","
        }
        else
        {
            optionQuiet = ""
            
        }
        
        if !buttonQuietBiteClick
        {
            optionQuietBite = "QUICK_BITE" + ","
            
        }
        else
        {
            optionQuietBite = ""
            
        }
        if !buttonHIghClassClick
        {
            optionHighClass = "HIGH_CLASS" + ","
            
        }
        else
        {
            optionHighClass = ""
        }
        
        option = optionSit +  optionQuiet +  optionQuietBite +  optionHighClass
        
        if option.count > 0
        {
            option = String(option.characters.dropLast(1))
            
        }
        print(option) // CharacterView
        if isYesClick{
            isRating = "yes"
        }
        else{
            isRating = "no"
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController")as! FeedbackViewController
        vc.option = self.option
        vc.isRating = self.isRating
        vc.isDetailReview = "yes"
        vc.hasDetailReview = self.isDetailReview
        vc.detailFeedbackOption = self.detailFeedbackOption
        print(self.txtViewDescription.text)
        vc.textMessage = self.txtViewDescription.text
        if vc.textMessage.localizedCaseInsensitiveContains("Type Here") {
            vc.textMessage = ""
        }
        vc.isFromReview = self.isFromReview
        self.navigationController?.pushViewController(vc, animated: true)
        // NSLog("OK Pressed")
        /* let alert = UIAlertController(title: "Taste", message:"Would you like to add more details?", preferredStyle: UIAlertControllerStyle.alert)
         let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
         UIAlertAction in
         self.getRate()
         NSLog("OK Pressed")}
         let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
         UIAlertAction in
         
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController")as! FeedbackViewController
         vc.option = self.option
         vc.isRating = self.isRating
         vc.isDetailReview = "yes"
         print(self.txtViewDescription.text)
         vc.textMessage = self.txtViewDescription.text
         self.navigationController?.pushViewController(vc, animated: true)
         NSLog("OK Pressed")
         }
         alert.addAction(NoAction)
         alert.addAction(yesAction)
         self.present(alert, animated: true, completion: nil)
         return
         
         */
        
        
        
    }
    
    
    @IBOutlet weak var btnSit: UIButton!
    
    @IBOutlet weak var btnQuietBite: UIButton!
    
    
    @IBOutlet weak var btnHIghClass: UIButton!
    @IBOutlet weak var btnQuiet: UIButton!
    
    
    @IBAction func btnSitAnd(_ sender: Any)
    {
        
        if buttonSitClick
        {
            btnSit.backgroundColor = UIColor.black
            btnSit.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonSitClick = false
        }
        else
        {
            btnSit.backgroundColor = UIColor.white
            btnSit.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonSitClick = true
        }
        
        
    }
    
    
    @IBAction func btnQuicBite(_ sender: Any)
    {
        if buttonQuietBiteClick
        {
            btnQuietBite.backgroundColor = UIColor.black
            btnQuietBite.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonQuietBiteClick = false
        }
        else
        {
            btnQuietBite.backgroundColor = UIColor.white
            btnQuietBite.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonQuietBiteClick = true
        }
        
        
    }
    
    
    @IBAction func btnQuiet(_ sender: Any)
    {
        if buttonQuietClick
        {
            btnQuiet.backgroundColor = UIColor.black
            btnQuiet.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonQuietClick = false
        }
        else
        {
            btnQuiet.backgroundColor = UIColor.white
            btnQuiet.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonQuietClick = true
        }
        
        
        
    }
    
    @IBAction func btnHighClass(_ sender: Any)
    {
        if buttonHIghClassClick
        {
            btnHIghClass.backgroundColor = UIColor.black
            btnHIghClass.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonHIghClassClick = false
        }
        else
        {
            btnHIghClass.backgroundColor = UIColor.white
            btnHIghClass.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonHIghClassClick = true
        }
        
        
    }
    
    
    
    
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        if self.NotificationObj == "FromNotification"{
            //  self.dismiss(animated: true, completion: nil)
            let singelton = SharedManager.sharedInstance
            singelton.refeshRecommendation = "yes"
            let app = AppDelegate()
            app.showHome()
            self.NotificationObj = ""
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        // _ = self.navigationController?.popViewController(animated: true)
    }
    
    

    @IBAction func btnReviceClicked(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - GET RATING

    func getRate(){
        
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            
            let singelton = SharedManager.sharedInstance
            if self.txtViewDescription.text.localizedCaseInsensitiveContains("Type Here") {
                self.txtViewDescription.text = ""
            }
            let parameter = ["user_id":singelton.loginId,"factual_id":K_INNERUSER_DATA.FactualId,"rate":self.isRating,"option":self.option,"message":self.txtViewDescription.text] as [String : Any]
            print(parameter)
            
            DataManager.sharedManager.ratingSubmitted(params: parameter) { (response) in
                
                
                if let dataDic = response as? String
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    
                    let alert = UIAlertController(title: "Taste", message:dataDic, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
                else{
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    
                    let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        // NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
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
    // MARK: - CHECK RATED OR NOT

    func isRated(){
        
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            
            let singelton = SharedManager.sharedInstance
            
            let parameter = ["user_id":singelton.loginId,"factual_id":K_INNERUSER_DATA.FactualId] as [String : Any]
            print(parameter)
            
            DataManager.sharedManager.isRated(params: parameter) { (response) in
                
                
                if let responseArray = response as? [[String:Any]]
                {
                    // print(dataDic)
                    if responseArray.count > 0{
                        if let array = responseArray[0] as? [String: Any]
                        {
                            if let rate = array["rate"] as? String{
                                if rate == "yes"{
                                    self.isYesClick = true
                                    
                                    self.isNoClick = true
                                    self.RatingYesClicked(self)
                                }
                                else{
                                    self.isYesClick = true
                                    self.RatingNoClicked(self)
                                }
                            }
                            if let option = array["option"] as? String{
                                let  optionArray = option.components(separatedBy: ",")
                                print(optionArray.count)
                                for option in optionArray{
                                    if option.localizedCaseInsensitiveContains("SIT_AND_CHAT")
                                    {
                                        self.btnSit.backgroundColor = UIColor.black
                                        self.btnSit.setTitleColor(UIColor.white, for: UIControlState.normal)
                                        self.buttonSitClick = false
                                    }
                                    else if option.localizedCaseInsensitiveContains("QUIET")
                                    {
                                        self.btnQuiet.backgroundColor = UIColor.black
                                        self.btnQuiet.setTitleColor(UIColor.white, for: UIControlState.normal)
                                        self.buttonQuietClick = false
                                        
                                    }
                                    else if option.localizedCaseInsensitiveContains("QUICK_BITE")
                                    {
                                        self.btnQuietBite.backgroundColor = UIColor.black
                                        self.btnQuietBite.setTitleColor(UIColor.white, for: UIControlState.normal)
                                        self.buttonQuietBiteClick = false
                                    }
                                    else if option.localizedCaseInsensitiveContains("HIGH_CLASS")
                                    {
                                        self.btnHIghClass.backgroundColor = UIColor.black
                                        self.btnHIghClass.setTitleColor(UIColor.white, for: UIControlState.normal)
                                        self.buttonHIghClassClick = false
                                    }
                                    //                                    else
                                    //                                    {
                                    //                                        self.btnSit.backgroundColor = UIColor.white
                                    //                                        self.btnSit.setTitleColor(UIColor.black, for: UIControlState.normal)
                                    //                                        self.buttonSitClick = true
                                    //
                                    //                                    }
                                    
                                }
                            }
                            if let message = array["message"] as? String{
                                self.txtViewDescription.text = message
                            }
                            if let detailReview = array["has_detail_review"] as? String{
                                
                                if detailReview.localizedCaseInsensitiveContains("yes"){
                                    self.isDetailReview = true
                                    if let detail_option = array["detail_option"] as? [String:Any]{
                                        self.detailFeedbackOption = detail_option
                                    }
                                }
                            }
                        }
                        //                        else{
                        //                            self.btnSit.backgroundColor = UIColor.black
                        //                            self.btnSit.setTitleColor(UIColor.white, for: UIControlState.normal)
                        //                            self.buttonSitClick = false
                        //                        }
                        
                    }
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    
                    
                }
                else{
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    //                    self.btnSit.backgroundColor = UIColor.black
                    //                    self.btnSit.setTitleColor(UIColor.white, for: UIControlState.normal)
                    //                    self.buttonSitClick = false
                    
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
    
    
    func makeReadNOtification(param:[String:Any])->Void{
        Alamofire.request(K_MAKE_NOTIFICATION_READ, method: .put, parameters: param, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")

                        print(parsedData)
                        
                        DispatchQueue.global().async {
                            self.NotificationCountMethod()
                            
                            DispatchQueue.main.async(execute: {
                                
                            })
                        }

                } catch let error as NSError {
                    print(error)
                   // completion("")
                }
                
        }

    }

    func NotificationCountMethod() {
        
        
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
        //let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":self.recieveUserId] as [String : Any]
        print("the parameter is : \(parameters)")
        
        DataManager.sharedManager.getNotificationCount(params: parameters) { (response) in
            
            
            
            if let dataDic = response as?  NSDictionary
                
            {
                let val_count = dataDic["count"] as! NSNumber
                print("BBB",val_count)
                K_INNERUSER_DATA.notificationCount = Int(val_count)
                 //TODO: FOR REMOVING BADGE FOR TEMPORARY  ADDED BY RANJIT 8 FEB
               // UIApplication.shared.applicationIconBadgeNumber = K_INNERUSER_DATA.notificationCount
            }
            DispatchQueue.main.async {
                
            }
            
        }
    }

    
}
