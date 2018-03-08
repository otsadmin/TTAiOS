//
//  AddDietViewController.swift
//  TasteApp
//
//  Created by Lalit Mohan on 3/15/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire


protocol MyProtocol {
    func setResultOfBusinessLogic(valueSent: String)
}
class AddDietViewController: UIViewController,UITextFieldDelegate
{
    var dietData = [[String:Any]]()
  
     var delegate:MyProtocol?
    
    let images = ["ic_uncheck", "ic_uncheck", "ic_uncheck", "ic_uncheck" ,"ic_uncheck" , "ic_uncheck" , "ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck"]
    var userDietField:UITextField!
     var tableView:UITableView!
    var master_Diet_Data = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpView()
    }
    
    
    func goBackToPreviousController()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func addNewDiet()
    {
        print(userDietField.text!)
        let diet = userDietField.text!
        if diet.isEmpty
        {
            let alert = UIAlertController(title: "Taste", message:"Please Enter the Diet Name.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let serverUIrl = K_DIETLIST_URL
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"diet_name":diet,"checked":"true"]
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id": singelton.loginId,"diet_name":diet,"checked":"true"]
        
        Alamofire.request(serverUIrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result)
            {
            case.success(_):
                
                if let  JSON = response.result.value
                {
                    print(JSON)
                    
                    let responseData = JSON as! NSDictionary
                    
                    if responseData.object(forKey: "status") as! String == "success"
                    {
                        let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    else
                    {
                        
                        let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                else
                {
                    print(response)
                }
                
                break
                
            case.failure(_):
                print(response.result.error)
                break
            }
        }
        
    }
  
    func setUpView()
    {
       self.view.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "ADD DIET"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_Font_Color_Bold , size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(20)
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBackToPreviousController), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        let titleSubLabel =  UILabel()
        titleSubLabel.text = "Please Select New Diet"
        titleSubLabel.textAlignment = .center
        titleSubLabel.numberOfLines = 2
        titleSubLabel.font = UIFont(name: K_Font_Color , size: 18)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleSubLabel)
        titleSubLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        userDietField = UITextField()
        userDietField.delegate = self
        //userIDField.text = "User ID"
//        let attributedPlaceholder = NSAttributedString(string: "Please Enter Diet Name", attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)])
        //userDietField.attributedPlaceholder = attributedPlaceholder
        //userDietField.borderStyle = .none
        self.view.addSubview(userDietField)
        userDietField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(titleSubLabel.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        userDietField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        userDietField.leftViewMode = .always
        
        userDietField.layer.cornerRadius = 8.0
        userDietField.layer.masksToBounds = true
        userDietField.layer.borderColor = UIColor( red: 169/255, green: 169/255, blue:169/255, alpha: 1.0 ).cgColor
        userDietField.layer.borderWidth = 2.0

        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(self.addNewDiet), for: .touchUpInside)
        button.setTitle("SUBMIT", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(userDietField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        let defaults = UserDefaults.standard
        defaults.setValue(userDietField.text, forKey: "getDietName")
        defaults.synchronize()
        
        
      delegate?.setResultOfBusinessLogic(valueSent: userDietField.text!)
//
        
        
    }//EndSetUpVFiew
    
    
    
    
    //MARK: Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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







