//
//  QuestionViewController.swift
//  Taste
//
//  Created by Lalit Mohan on 24/04/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AVFoundation


extension String {
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

class QuestionViewController: UIViewController,UITextFieldDelegate
{
    //MARK: DECLARE VARIABLE
    
    var question = [[String:Any]]()
    var x :Double = 4.0
    var myTextField: UITextField!
    var myImageView: UIImageView!
    var verticalength : Double = 0.0
    var field = [[String:Any]]()
    var myArray = [[String: AnyObject]]()
    var ProviderAccID : String = ""
    var myIntenalArray = [[String:AnyObject]]()
    
    var someDict = [String:AnyObject?]()
    var someDict1 = [String:AnyObject?]()
    var someDict2 = [String:AnyObject?]()
    var someDict3 = [String:AnyObject?]()
    var someDict4 = [String:AnyObject?]()
    var textCount :Int = 0
    var jsonStrigBody:String = ""
    var providerAccountNo :String = ""
    var QuestionAnswerArray = [BankCredential]()
    
    //added code
    var bank:[String:Any]?
    var userIDField:UITextField!
    var passtextField:UITextField!
    var arrData = [[String:Any]]()
    var imageLogo :String = ""
    var replaced:String = ""
    var providerAccountID : String = ""
    var apiHitProcessToUpdate : Bool = false
    var provider_ID : Int = 0
    var bankAdded:Bool = false
    var isUpdate:Bool =  false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBAction func btnLoginTapped(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork() == true
        {
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        for number in 0..<(self.question.count)
        {
            
            K_BANKCREDENTIAL_DATA.idQuestion = (self.question[number]["id"] as! String?)!
            K_BANKCREDENTIAL_DATA.fieldRowChoice = (self.question[number]["fieldRowChoice"] as! String?)!
            K_BANKCREDENTIAL_DATA.form = (self.question[number]["form"] as! String?)!
            K_BANKCREDENTIAL_DATA.label = (self.question[number]["label"] as! String?)!
            
            
            print(self.scrollView.subviews.count)
            field = (self.question[number]["field"] as? [[String:Any]])!
            if let txtField = self.scrollView.viewWithTag(number + 1) as? UITextField {
                
                self.field[0]["value"] =  txtField.text!
            }
            
            someDict["id"] = K_BANKCREDENTIAL_DATA.idQuestion as AnyObject??
            someDict["label"] = K_BANKCREDENTIAL_DATA.label as AnyObject??
            someDict["fieldRowChoice"] =  K_BANKCREDENTIAL_DATA.fieldRowChoice as AnyObject??
            someDict["form"] = K_BANKCREDENTIAL_DATA.form as AnyObject??
            
            
            
            
            someDict["field"] = self.field as AnyObject??
            print(someDict)
            myArray.append(someDict as [String : AnyObject])
            
        }
        someDict2["mfaTimeout"] = K_BANKCREDENTIAL_DATA.mfaTimeout as AnyObject??
        someDict2["formType"] = K_BANKCREDENTIAL_DATA.formType as AnyObject??
        someDict2["row"] = myArray as AnyObject??
        someDict3["provider_account_id"] = self.ProviderAccID as AnyObject??
        someDict3["login_form"] = someDict2 as AnyObject??
        someDict4["providerAccount"] =  someDict3 as AnyObject??
        
        
        
        print(someDict2)
        let jsonData = try! JSONSerialization.data(withJSONObject: someDict4, options:JSONSerialization.WritingOptions.prettyPrinted)
        
        
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
        {
            
            jsonStrigBody = JSONString
        }
        
        
        // print(jsonStrigBody)
        
        
        
        
        
        
        
        
        // let param = ["user_id":UserDefaults.standard.string(forKey:"user_id")!,"provider_account_id":(self.ProviderAccID),"body" : jsonStrigBody] as [String : Any]
        let singelton = SharedManager.sharedInstance
        singelton.loginId = K_CURRENT_USER.login_Id
        print("is is ",self.providerAccountID)
        let param = ["user_id": singelton.loginId,"provider_account_id":(self.ProviderAccID),"body" : jsonStrigBody] as [String : Any]
        
        
        print("paramter is \(param)")
        
        print("parameter for api hit is \(param)")
        print(jsonStrigBody)
        
        
        
        DataManager.sharedManager.bankMFA_LOGIN_CHALLENGE(params: param, completion: { (response) in
             self.view.isUserInteractionEnabled = true
            if let dataDic = response as? [[String:Any]]
            {
                
                
                self.arrData = dataDic
                if self.arrData.count == 0
                {
                    SVProgressHUD.dismiss()
                    var messageText:String = "Bank added successfully"
                    if self.isUpdate == true{
                        messageText = "Bank updated successfully"
                    }
                    let alert = UIAlertController(title: "Taste", message:messageText, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.moveToNextController()
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return}
                else
                {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Taste", message:"Network Error", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            else if let dataResponse = response as? String
            {
                let strString = dataResponse
               // print("string in banklogin when bank added \(strString)")
                
                //                if strString.contains("listing")
                //                {
                //                    self.bankAdded = true
                //
                //                }
                self.bankAdded = true
                
              //  print("response is \(dataResponse)")
                SVProgressHUD.dismiss()
                
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
                
                let alert = UIAlertController(title: "Taste", message:dataResponse, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    if self.bankAdded
                    {
                        self.moveToNextController()
                        
                    }
                    else
                    {
                        self.apiHitProcessToUpdate = false
                        print("api value \(  self.apiHitProcessToUpdate)")
                        NSLog("OK Pressed")
                        
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
                
                
                
                /*
                 let str = K_USER_DATA.loginTry
                 
                 
                 if str == "yes"
                 {
                 SVProgressHUD.dismiss()
                 let alert = UIAlertController(title: "Taste", message:"Try again", preferredStyle: UIAlertControllerStyle.alert)
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
                 let strString = dataResponse
                 print("string in banklogin when bank added \(strString)")
                 
                 if strString.contains("listing")
                 {
                 self.bankAdded = true
                 
                 }
                 
                 
                 print("response is \(dataResponse)")
                 SVProgressHUD.dismiss()
                 let alert = UIAlertController(title: "Taste", message:dataResponse, preferredStyle: UIAlertControllerStyle.alert)
                 let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                 UIAlertAction in
                 if self.bankAdded
                 {
                 self.moveToNextController()
                 
                 }
                 else
                 {
                 self.apiHitProcessToUpdate = false
                 print("api value \(  self.apiHitProcessToUpdate)")
                 NSLog("OK Pressed")
                 
                 }
                 }
                 alert.addAction(okAction)
                 self.present(alert, animated: true, completion: nil)
                 return
                 }*/
            }
                
            else if let dataDic = response as? [String:Any]
            {
                let provideAcc = dataDic["providerAccount"] as? [String:Any]
                if ((provideAcc) != nil)
                    
                {
                    if let provideAccID = provideAcc?["provider_account_id"] as? IntegerLiteralType
                    {
                        print("proviuder account is \(provideAccID)")
                        self.providerAccountID = "\(provideAccID)"
                        // self.providerAccountID = provideAccID
                    }
                    
                }
                
                if let loginform = provideAcc?["login_form"] as? [String:Any]
                {
                    let mfaTimeout = loginform["mfaTimeout"] as! Int
                    K_BANKCREDENTIAL_DATA.mfaTimeout = String(mfaTimeout)
                    let formType = loginform["formType"] as! String
                    K_BANKCREDENTIAL_DATA.formType = formType
                    print("mfa time out is \( K_BANKCREDENTIAL_DATA.mfaTimeout) and form type is \( K_BANKCREDENTIAL_DATA.formType)")
                    
                    
                    if let dietArr = loginform["row"] as? [[String:Any]]
                    {
                        SVProgressHUD.dismiss()
                        self.arrData = dietArr
                        self.moveToQuestionController()
                        
                    }
                    
                    
                }
            }
            DispatchQueue.main.async
                {
                    SVProgressHUD.dismiss()
                     self.view.isUserInteractionEnabled = true
                    
            }
            
        })
        
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
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if question.count > 0
        {
            print("array count is \(question.count)")
        }
        print("Providet account id is \(ProviderAccID) that")
        if K_BANKCREDENTIAL_DATA.formType == "image"{
            self.setupViewCaptcha()
        }
        else{
            self.setupView()
        }
        
        
        scrollView.contentSize = CGSize(width: 375, height: 541)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
    func setupViewCaptcha()
    {
        print( "typ eis ",K_BANKCREDENTIAL_DATA.formType)
        for number in 0..<(self.question.count)
        {
            
            let label = UILabel(frame: CGRect(x: 20, y: x * 8 + 4, width: 300, height: 40.00))
            label.textAlignment = .left
            label.text = self.question[number]["label"] as! String?
            label.numberOfLines = 1
            label.font = UIFont(name: K_Font_Color , size: 16)
            self.scrollView.addSubview(label)
            
            x = x + 4.0
            
            
            K_BANKCREDENTIAL_DATA.idQuestion = (self.question[number]["id"] as! String?)!
            K_BANKCREDENTIAL_DATA.fieldRowChoice = (self.question[number]["fieldRowChoice"] as! String?)!
            K_BANKCREDENTIAL_DATA.form = (self.question[number]["form"] as! String?)!
            K_BANKCREDENTIAL_DATA.label = (self.question[number]["label"] as! String?)!
            
            field = (self.question[number]["field"] as? [[String:Any]])!
            
            // for  digit in 0..<(self.field.count)
            
            // {
            K_BANKCREDENTIAL_DATA.idAnswer = (self.field[0]["id"] as! String?)!
            K_BANKCREDENTIAL_DATA.name =     (self.field[0]["name"] as! String?)!
            
            if self.field[0]["isOptional"] as! Bool{
                K_BANKCREDENTIAL_DATA.Optional = "true"
            }
            else
            {
                K_BANKCREDENTIAL_DATA.Optional = "false"
            }
            
            if self.field[0]["valueEditable"] as! String == "true"  {
                K_BANKCREDENTIAL_DATA.valueEditable = "true"
            }
            else
            {
                K_BANKCREDENTIAL_DATA.valueEditable = "false"
            }
            
            K_BANKCREDENTIAL_DATA.type =  (self.field[0]["type"] as! String?)!
            
            
            verticalength = x*8+10
            print("vertical lenth is \(verticalength)")
            myImageView = UIImageView(frame: CGRect(x: 20, y:x * 8 + 10, width: 335.00, height: 100))
            self.scrollView.addSubview(myImageView)
            myImageView.layer.borderWidth = 2
            myImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            myImageView.layer.cornerRadius = 5.0
            myImageView.contentMode = .scaleAspectFit
            
            let bytes:[UInt8]  = (self.field[0]["image"]) as! [UInt8]
            // var bytes:[UInt8] = [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 130, 0, 0, 0, 22, 8, 6, 0, 0, 0, 12, 244, 68, 168, 0, 0, 0, 1, 115, 82, 71, 66, 0, 174, 206, 28, 233, 0, 0, 0, 4, 103, 65, 77, 65, 0, 0, 177, 143, 11, 252, 97, 5, 0, 0, 0, 9, 112, 72, 89, 115, 0, 0, 14, 196, 0, 0, 14, 196, 1, 149, 43, 14, 27, 0, 0, 3, 212, 73, 68, 65, 84, 104, 67, 237, 153, 61, 139, 20, 65, 16, 134, 55, 17, 253, 3, 114, 127, 224, 208, 204, 64, 228, 18, 3, 19, 21, 19, 35, 217, 200, 204, 15, 48, 19, 228, 48, 50, 242, 76, 12, 245, 2, 99, 47, 55, 88, 83, 65, 220, 76, 48, 57, 19, 49, 220, 95, 224, 125, 120, 34, 126, 224, 120, 207, 65, 141, 53, 189, 213, 85, 189, 238, 172, 176, 210, 5, 195, 206, 77, 87, 87, 247, 84, 189, 245, 118, 213, 220, 160, 169, 82, 61, 112, 232, 129, 65, 245, 66, 245, 0, 30, 168, 64, 168, 56, 56, 242, 64, 5, 66, 5, 66, 5, 66, 197, 192, 31, 15, 12, 142, 29, 63, 209, 228, 174, 209, 232, 101, 199, 87, 147, 201, 36, 171, 139, 141, 55, 227, 113, 179, 122, 234, 180, 171, 115, 110, 109, 173, 217, 217, 217, 53, 99, 112, 241, 210, 229, 169, 185, 216, 244, 246, 88, 50, 134, 93, 145, 18, 125, 79, 231, 230, 173, 219, 217, 253, 47, 51, 176, 92, 32, 156, 92, 89, 233, 188, 219, 189, 245, 245, 16, 8, 219, 219, 239, 27, 230, 69, 206, 76, 157, 246, 112, 99, 99, 106, 14, 78, 71, 230, 13, 94, 159, 64, 96, 47, 218, 222, 50, 7, 95, 239, 221, 5, 2, 47, 77, 96, 17, 178, 56, 10, 48, 217, 139, 192, 36, 81, 240, 158, 111, 109, 181, 251, 176, 178, 30, 102, 233, 43, 139, 75, 128, 192, 187, 161, 39, 87, 196, 108, 226, 23, 15, 8, 223, 70, 47, 154, 131, 7, 247, 155, 253, 27, 215, 155, 79, 103, 86, 59, 23, 207, 24, 67, 71, 203, 175, 253, 189, 230, 235, 179, 39, 157, 235, 199, 187, 183, 13, 23, 250, 123, 195, 171, 71, 118, 248, 229, 111, 158, 91, 130, 221, 207, 119, 239, 52, 59, 231, 207, 154, 107, 179, 6, 107, 137, 132, 64, 128, 202, 145, 167, 155, 155, 97, 112, 5, 8, 232, 91, 25, 174, 193, 129, 227, 113, 38, 0, 179, 156, 206, 49, 84, 2, 132, 89, 51, 50, 7, 208, 52, 203, 217, 151, 7, 102, 253, 174, 233, 30, 126, 126, 252, 208, 6, 44, 5, 128, 245, 55, 65, 101, 14, 66, 96, 83, 29, 43, 152, 90, 231, 251, 235, 87, 237, 22, 176, 19, 233, 235, 185, 2, 196, 16, 8, 165, 103, 191, 232, 105, 167, 64, 237, 158, 51, 1, 217, 181, 225, 112, 74, 7, 16, 105, 241, 108, 244, 5, 4, 246, 66, 112, 229, 138, 128, 239, 49, 130, 100, 109, 9, 8, 68, 103, 247, 202, 133, 44, 16, 34, 59, 4, 94, 196, 2, 1, 207, 96, 32, 139, 153, 176, 13, 248, 90, 32, 224, 136, 156, 195, 117, 198, 122, 122, 105, 150, 144, 85, 158, 190, 181, 158, 117, 254, 70, 199, 140, 55, 158, 218, 155, 199, 150, 204, 245, 106, 4, 178, 211, 10, 28, 52, 205, 24, 23, 247, 150, 14, 99, 22, 35, 136, 46, 129, 204, 101, 59, 64, 128, 238, 83, 187, 28, 31, 233, 209, 147, 234, 0, 220, 22, 8, 81, 6, 136, 19, 60, 61, 139, 46, 75, 106, 11, 177, 205, 113, 97, 117, 20, 243, 4, 175, 111, 32, 68, 93, 131, 21, 12, 28, 157, 138, 197, 26, 204, 205, 29, 13, 114, 116, 96, 199, 2, 3, 243, 172, 140, 103, 29, 97, 3, 126, 249, 219, 154, 223, 2, 129, 5, 162, 2, 73, 186, 136, 92, 96, 114, 231, 38, 52, 90, 18, 204, 180, 93, 45, 169, 17, 116, 129, 103, 221, 75, 231, 81, 98, 43, 98, 22, 93, 183, 228, 142, 36, 11, 8, 60, 75, 37, 167, 103, 1, 1, 6, 209, 98, 129, 136, 121, 127, 115, 36, 9, 59, 116, 128, 16, 177, 130, 156, 221, 179, 2, 129, 151, 136, 90, 79, 198, 115, 242, 47, 106, 4, 214, 240, 186, 34, 41, 110, 163, 154, 164, 132, 158, 177, 1, 101, 167, 20, 157, 99, 132, 20, 72, 86, 230, 151, 50, 130, 102, 7, 125, 223, 1, 66, 196, 10, 146, 17, 139, 0, 66, 238, 35, 19, 123, 138, 170, 119, 93, 228, 165, 247, 227, 195, 2, 80, 23, 118, 158, 173, 40, 17, 116, 75, 59, 11, 35, 16, 112, 221, 38, 114, 111, 213, 8, 60, 183, 24, 161, 20, 8, 95, 30, 63, 10, 107, 4, 169, 37, 210, 22, 117, 10, 8, 57, 103, 80, 221, 71, 244, 234, 181, 84, 81, 59, 233, 101, 90, 201, 177, 18, 209, 122, 180, 119, 230, 35, 81, 167, 83, 242, 49, 105, 150, 246, 77, 3, 130, 190, 126, 30, 32, 48, 223, 90, 155, 35, 3, 144, 88, 44, 196, 250, 204, 153, 2, 2, 206, 176, 40, 178, 36, 171, 254, 7, 32, 148, 116, 58, 105, 123, 155, 130, 56, 151, 241, 94, 27, 40, 140, 49, 15, 16, 216, 199, 172, 107, 3, 2, 10, 209, 129, 20, 88, 250, 101, 96, 5, 93, 120, 105, 54, 64, 79, 198, 104, 13, 245, 189, 215, 91, 243, 37, 49, 87, 216, 201, 71, 171, 28, 43, 48, 47, 93, 43, 183, 7, 235, 185, 174, 63, 188, 226, 82, 214, 231, 61, 162, 34, 52, 250, 178, 136, 115, 115, 25, 168, 1, 129, 142, 238, 8, 184, 151, 234, 94, 126, 211, 175, 143, 100, 183, 238, 6, 244, 7, 41, 222, 1, 102, 64, 199, 99, 38, 198, 244, 145, 83, 255, 13, 29, 85, 127, 61, 140, 19, 92, 249, 76, 44, 191, 58, 248, 61, 44, 225, 154, 72, 215, 182, 148, 43, 16, 22, 29, 133, 37, 177, 95, 129, 176, 36, 129, 90, 244, 54, 43, 16, 22, 237, 225, 37, 177, 255, 27, 38, 183, 224, 140, 178, 26, 189, 95, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130];
            
            let imageData:NSData = NSData(bytes: bytes, length: bytes.count)
            let image:UIImage = UIImage(data: imageData as Data)!
            myImageView.image  = image
            
            x = x + 15.0
            
            myTextField = UITextField(frame: CGRect(x: 20, y:x * 8 + 10, width: 335.00, height: 40.00));
            
            
            print("my textfiled value is \(myTextField.text)")
            print(K_BANKCREDENTIAL_DATA.value)
            self.scrollView.addSubview(myTextField)
            myTextField.backgroundColor = UIColor.clear
            myTextField.tag = number + 1
            myTextField.delegate = self
            myTextField.borderStyle = UITextBorderStyle.line
            myTextField.resignFirstResponder()
            x = x + 5.0
            
            QuestionAnswerArray.append(K_BANKCREDENTIAL_DATA)
            //  }
            
        }
        
        scrollView.contentSize = CGSize(width: 375, height: verticalength)
        print(scrollView.contentSize)
    }
    
    // MARK: SET ALL USER INTERFACE
    func setupView()
    {
        print( "typ eis ",K_BANKCREDENTIAL_DATA.formType)
        for number in 0..<(self.question.count)
        {
            
            let label = UILabel(frame: CGRect(x: 20, y: x * 8 + 4, width: 300, height: 40.00))
            label.textAlignment = .left
            label.text = self.question[number]["label"] as! String?
            label.numberOfLines = 2
            label.font = UIFont(name: K_Font_Color , size: 16)
            self.scrollView.addSubview(label)
            
            x = x + 4.0
            
            
            K_BANKCREDENTIAL_DATA.idQuestion = (self.question[number]["id"] as! String?)!
            K_BANKCREDENTIAL_DATA.fieldRowChoice = (self.question[number]["fieldRowChoice"] as! String?)!
            K_BANKCREDENTIAL_DATA.form = (self.question[number]["form"] as! String?)!
            K_BANKCREDENTIAL_DATA.label = (self.question[number]["label"] as! String?)!
            
            field = (self.question[number]["field"] as? [[String:Any]])!
            print(field)
            print("question", K_BANKCREDENTIAL_DATA.idQuestion,K_BANKCREDENTIAL_DATA.fieldRowChoice)
            // for  digit in 0..<(self.field.count)
            
            //  {
            K_BANKCREDENTIAL_DATA.idAnswer = (self.field[0]["id"] as! String?)!
            K_BANKCREDENTIAL_DATA.name =     (self.field[0]["name"] as! String?)!
            print(K_BANKCREDENTIAL_DATA.idAnswer, K_BANKCREDENTIAL_DATA.name)
            if self.field[0]["isOptional"] as! Bool{
                K_BANKCREDENTIAL_DATA.Optional = "true"
            }
            else
            {
                K_BANKCREDENTIAL_DATA.Optional = "false"
            }
            
            if self.field[0]["valueEditable"] as! String == "true"  {
                K_BANKCREDENTIAL_DATA.valueEditable = "true"
            }
            else
            {
                K_BANKCREDENTIAL_DATA.valueEditable = "false"
            }
            
            K_BANKCREDENTIAL_DATA.type =  (self.field[0]["type"] as! String?)!
            
            
            verticalength = x*8+10
            print("vertical lenth is \(verticalength)")
            myTextField = UITextField(frame: CGRect(x: 20, y:x * 8 + 10, width: 335.00, height: 40.00));
            
            
            print("my textfiled value is \(myTextField.text)")
            print(K_BANKCREDENTIAL_DATA.value)
            self.scrollView.addSubview(myTextField)
            myTextField.backgroundColor = UIColor.clear
            myTextField.tag = number + 1
            myTextField.delegate = self
            myTextField.borderStyle = UITextBorderStyle.line
            myTextField.resignFirstResponder()
            x = x + 5.0
            
            QuestionAnswerArray.append(K_BANKCREDENTIAL_DATA)
            //}
            
        }
        print(self.field)
        scrollView.contentSize = CGSize(width: 375, height: verticalength)
        print(scrollView.contentSize)
    }
    
    
    //MARK: JUMP TO NEXT CONTROLLER
    func moveToProfileView()
    {
        let vc = ProfileBeingCreatedViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    func moveToNextController()
    {
        let vc = ProfileBeingCreatedViewController()
        let singelton = SharedManager.sharedInstance
        singelton.refeshRecommendation = "yes"
        self.present(vc, animated: true, completion: nil)
//        if self.isUpdate{
//            let tabController = UITabBarController()
//            //            let vc = ExploreRecommendationController()
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ExploreTabViewController")
//            let navVC = UINavigationController(rootViewController: vc)
//            navVC.isNavigationBarHidden = true
//            let vc2 = ProfileViewController()
//            let navVC2 = UINavigationController(rootViewController: vc2)
//            navVC2.isNavigationBarHidden = true
//           // vc2.cuisines = self.cuisines
//            let vc3 = InnerCircleAddedViewController()
//            let navVC3 = UINavigationController(rootViewController: vc3)
//            navVC3.isNavigationBarHidden = true
//            tabController.viewControllers = [navVC,navVC2, navVC3]
//            tabController.tabBar.barStyle = .black
//            //tabController.tabBar.items?[0].selectedImage = UIImage(named: "tab_profile")
//            let image = UIImage(named: "tab_search")?.withRenderingMode(.alwaysOriginal)
//            let image2 = UIImage(named: "homeTaste")?.withRenderingMode(.alwaysOriginal)
//            let image3 = UIImage(named: "tab_user_group")?.withRenderingMode(.alwaysOriginal)
//            
//            tabController.tabBar.items?[0].image = image
//            tabController.tabBar.items?[1].image = image2
//            tabController.tabBar.items?[2].image = image3
//            
//            tabController.tabBar.items?[0].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
//            tabController.tabBar.items?[1].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
//            tabController.tabBar.items?[2].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
//            
//            tabController.selectedIndex = 1
//            // tabController.tabBar.items![0].isEnabled = false
//            
//            self.present(tabController, animated: true, completion: nil)
//        }
//        else{
//            let vc = ProfileBeingCreatedViewController()
//            let singelton = SharedManager.sharedInstance
//            singelton.refeshRecommendation = "yes"
//            self.present(vc, animated: true, completion: nil)
//        }
       
        
    }
    func moveToQuestionController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:"QuestionViewController") as! QuestionViewController
        vc.question = self.arrData
        vc.ProviderAccID = self.providerAccountID
        if K_USER_DATA.bankUpdate == "yes"{
           // self.isUpdate = true
            vc.isUpdate = true
        }
        else{
            //self.isUpdate = false
            vc.isUpdate = false

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: TEXTFILED DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        for textField in self.scrollView.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
