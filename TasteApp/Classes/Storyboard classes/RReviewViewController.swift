//
//  RReviewViewController.swift
//  Taste
//
//  Created by Ranjit Singh on 29/11/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD

class RReviewViewController: UIViewController {

    var fromGoogle = ""
    var recieveDataDict = [String:Any]()
    var restaurantName:String? = ""
    // ibOutlets declaration
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lbltagName: UILabel!
    
    @IBOutlet weak var ratingbyGoogle: CosmosView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var lblUserdesignation: UILabel!
    @IBOutlet weak var descriptiontextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(recieveDataDict)
        print(restaurantName)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        if fromGoogle == "no" {
             self.setDataOnView()
        }
        else{
            self.setDataOnViewForGoogle()
        }
    }
    
    // MARK: - SET ALL VIEW ON USER INTERFACE

    func setDataOnView() -> Void {
        
        self.lblUserdesignation.isHidden = false
        if let resName = restaurantName {
            lblRestaurantName.text = resName
        }
        var profileDict = recieveDataDict["user_profile"] as? [String:Any]
        if let userFName = profileDict?["firstname"] as? String{
            lblUsername.text = userFName
        }
        if let userLName = profileDict?["lastname"] as? String
        {
            lblUsername.text = lblUsername.text!+" "+userLName
        }
        if let userDesg = profileDict?["designation"] as? String{
            lblUserdesignation.text = userDesg
        }
        if let imageURL = profileDict?["image"] as? String{
            if (imageURL.characters.count) > 0
            {
                userImageView.layer.borderWidth = 1
                userImageView.layer.masksToBounds = false
                userImageView.layer.cornerRadius = 75/2
                userImageView.clipsToBounds = true
                userImageView.sd_setImage(with: URL(string: K_IMAGE_BASE_URL + imageURL), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
            }
        }
        if let  rating =  recieveDataDict["rate"] as? String{
            self.ratingbyGoogle.isHidden = true
            self.ratingImageView.isHidden = false
            if rating.hasPrefix("yes"){
                ratingImageView.image = UIImage(named: "like")
            }
            else{
                ratingImageView.image = UIImage(named: "unlike")
            }
        }
        if let  message =  recieveDataDict["message"] as? String{
            descriptiontextView.text = message
        }
        if let  message =  recieveDataDict["option"] as? String{
            lbltagName.text = message
        }
        
        // enable and disable flag icon
        if let  flagged =  recieveDataDict["is_user_flagged"] as? String{
            
            if flagged == "no"{
                
                if let  userId =  recieveDataDict["user_id"] as? String{
                    
                    if userId != K_CURRENT_USER.login_Id{
                        self.rateBtn.isHidden = false
                    }
                    else
                    {
                        self.rateBtn.isHidden = true
                    }
                }
            }
            else{
                self.rateBtn.isHidden = true
            }
            
        }
        
        

        
    }
    
    func setDataOnViewForGoogle() -> Void {
        
        self.lblUserdesignation.isHidden = true
        if let resName = restaurantName {
            lblRestaurantName.text = resName
        }
        
        if let userFName = recieveDataDict["author_name"] as? String{
            lblUsername.text = userFName
        }

        if let imageURL = recieveDataDict["profile_photo_url"] as? String{
            if (imageURL.characters.count) > 0
            {
                userImageView.layer.borderWidth = 1
                userImageView.layer.masksToBounds = false
                userImageView.layer.cornerRadius = 75/2
                userImageView.clipsToBounds = true
                userImageView.sd_setImage(with: URL(string:imageURL), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
            }
        }
        if let  rating =  recieveDataDict["rating"] as? String{
            
                print(rating)
                ratingImageView.image = UIImage(named: "like")
        }
        
        if let  message =  recieveDataDict["text"] as? String{
            descriptiontextView.text = message
        }

        if let user_rating = recieveDataDict["rating"]{
            
            self.ratingbyGoogle.isHidden = false
            self.ratingImageView.isHidden = true
            
            let Rating = user_rating as? NSNumber
            
            
            // print("PhotoRef : \(Rating)")
            //        InnerCircleGoogleReview.titleRatingValue.text = Rating?.stringValue
            self.ratingbyGoogle.rating = Rating as! Double
            self.ratingbyGoogle.settings.updateOnTouch = false
            self.ratingbyGoogle.settings.starMargin = 2
            self.ratingbyGoogle.settings.starSize = 15
        }

        // enable and disable flag icon
        self.rateBtn.isHidden = true
        
    }
    
    @IBAction func backBtmPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - MAKE A COMMENT AS FLAGGED
    @IBAction func FlagBtnPressed(_ sender: Any) {
        
        self.postflag()
    }
    func postflag()->Void{
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            
            let parameter = ["user_id":K_CURRENT_USER.login_Id,"factual_id":recieveDataDict["factual_id"] ?? "","rate_id":recieveDataDict["_id"] ?? "", "flag_value":"yes"] as [String : Any]
            print(parameter)
            
            DataManager.sharedManager.postFlag(params: parameter) { (response) in
                
                if let dataDic = response as? [String:Any]
                {
                    print(dataDic)
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    
                    let alert = UIAlertController(title: "Inappropriate", message:"This comment has been flagged for Taste review. Thank you" , preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.rateBtn.isHidden = true
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return

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
 
}
