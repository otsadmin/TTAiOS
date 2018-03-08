//
//  EditDietViewController.swift
//  TasteApp
//
//  Created by Anuj Singh on 3/7/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire


class EditDietViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MyProtocol
{
    var arrSelected: Array<String> = []
    var valueSentFromSecondViewController:String?
    var myStringDiet : String = ""
    var dietData = [[String:Any]]()
    var check = false
    var rowsWhichAreChecked = [NSIndexPath]()
    
    var tableView:UITableView!
    // let images = ["ic_uncheck", "ic_uncheck", "ic_uncheck", "ic_uncheck" ,"ic_uncheck" , "ic_uncheck" , "ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck","ic_uncheck"]
    let texts = ["Lactose Intolerant","Glucose Intolerant", "Vegetarian", "Vegan" ,"Peanut Allergies" , "Shellfish Allergies","Scottish","Russian","Sushi","Syrian","Turkish","Uzbek","Portuguese","Polish","Pizza","Pan Asian"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
        
        self.tableView.allowsMultipleSelection = true
    }
    
    
    func btnPrivateClick(sender:UIButton) {
        
        if check
        {
            sender.setImage(UIImage(named:"ic_uncheck"), for: .normal)
            check = false}
        else
        {
            sender.setImage(UIImage(named:"ic_check"), for: .normal)
            check = true
        }
    }
    
    func btnPublicClick(sender:UIButton)
    {
        if check
        {
            sender.setImage(UIImage(named:"ic_uncheck"), for: .normal)
            check = false
        }
        else
        {
            sender.setImage(UIImage(named:"ic_check"), for: .normal)
            check = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        setUpView()
        
        super.viewWillAppear(animated)
    }
    
    func jumpToCustomView()
    {
        
        let vc = AddDietViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUpView()
    {
        
        self.view.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "SETTINGS"
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
        
        let titleSubLabel =  UILabel()
        titleSubLabel.text = "Edit Diet"
        titleSubLabel.textAlignment = .center
        titleSubLabel.numberOfLines = 2
        titleSubLabel.font = UIFont(name: K_Font_Color, size: 18)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleSubLabel)
        titleSubLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        let titleCenterText =  UILabel()
        titleCenterText.text = "Set any dietary restrictions you may have.These settings will not affect your recommandations.This is for your public profile to inform other users."
        titleCenterText.textAlignment = .center
        titleCenterText.numberOfLines = 4
        titleCenterText.font = UIFont(name: K_Font_Color, size: 16)
        
        self.view.addSubview(titleCenterText)
        titleCenterText.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleSubLabel.snp.bottom).offset(20)
        }
        
        let btnPublic = UIButton(type: .custom)
        btnPublic.setImage(UIImage(named:"ic_uncheck"), for: .normal)
        btnPublic.addTarget(self, action: #selector(self.btnPublicClick), for: .touchUpInside)
        self.view.addSubview(btnPublic)
        btnPublic.snp.makeConstraints { (make) in
            make.right.equalTo(-100)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(titleCenterText.snp.bottom).offset(20)
        }
        
        
        let titlePublic = UILabel()
        titlePublic.text = "Public"
        titlePublic.textAlignment = .natural
        titlePublic.numberOfLines = 1
        titlePublic.font = UIFont(name: K_Font_Color_Bold, size: 18)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titlePublic)
        titlePublic.snp.makeConstraints { (make) in
            make.left.equalTo(btnPublic.snp.left).offset(25)
            make.centerY.equalTo(btnPublic.snp.centerY).offset(5)
        }
        
        
        let btnPrivate = UIButton(type: .custom)
        btnPrivate.setImage(UIImage(named:"ic_uncheck"), for: .normal)
        btnPrivate.addTarget(self, action: #selector(self.btnPrivateClick), for: .touchUpInside)
        self.view.addSubview(btnPrivate)
        btnPrivate.snp.makeConstraints { (make) in
            make.centerX.equalTo(btnPublic.snp.centerX)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(btnPublic.snp.bottom).offset(20)
        }
        
        let titlePrivate = UILabel()
        titlePrivate.text = "Private"
        titlePrivate.textAlignment = .natural
        titlePrivate.numberOfLines = 1
        titlePrivate.font = UIFont(name: K_Font_Color_Bold, size: 18)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titlePrivate)
        titlePrivate.snp.makeConstraints { (make) in
            make.left.equalTo(btnPrivate.snp.left).offset(25)
            make.centerY.equalTo(btnPrivate.snp.centerY).offset(5)
        }
        
        let btnAddCustom = UIButton(type: .custom)
        btnAddCustom.backgroundColor = UIColor.black
        btnAddCustom.titleLabel?.font = UIFont(name: K_Font_Color , size: 14)!
        btnAddCustom.addTarget(self, action: #selector(self.jumpToCustomView), for: .touchUpInside)
        btnAddCustom.setTitle("ADD CUSTOM", for: .normal)
        btnAddCustom.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(btnAddCustom)
        btnAddCustom.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(-100)
            
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
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(btnPublic.snp.right).offset(-40)
            make.bottom.equalTo(btnAddCustom.snp.top).offset(-40)
            make.top.equalTo(titleCenterText.snp.bottom).offset(20)
            
        }
        tableView.tableFooterView = UIView()
        
        delayWithSeconds(1.0) {
            SVProgressHUD.show()
            
           // let UserId = UserDefaults.standard.string(forKey: "user_id")!
            let singelton = SharedManager.sharedInstance
           
             let UserId = singelton.loginId
           // print("the user id is \(UserId)that")
            DataManager.sharedManager.getDietList(params: //["user_id":"QuMKkB5dfR4bZ61ekYpwgBhut4ZOzlD7Al6Gmo2wLwSg0DsXrtPVUGUPZAcd5JnP5KMdhd3HFUsX45-PW0jI7w"])
                
                ["user_id":UserId])
            { (response) in
                
                
                if let dataDic = response as? [String:Any] {
                    if let dietArr = dataDic["diet"] as? [[String:Any]] {
                        self.dietData = dietArr
                    }
                    
                    self.tableView.reloadData()
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
            
        }//SETUPVIEWEND
    }
    
    
    func goBack()
    {
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func setResultOfBusinessLogic(valueSent: String)
    {
        self.valueSentFromSecondViewController = valueSent
        print("valueeeeee \(self.valueSentFromSecondViewController)")
    }
   
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return dietData.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "editDietCell") as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        let imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.centerY.equalTo(cell.contentView)
        }
        
        cell.imageView?.image = UIImage(named: "ic_uncheck")
        imageView.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(-20)
            make.centerY.equalTo(cell.contentView).offset(5)
        }
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.text = self.dietData[indexPath.row]["name"] as? String
        
        
        let isDietSelected = self.dietData[indexPath.row]["checked"] as! String
        
        if isDietSelected == "1"
        {
            cell.imageView?.image = UIImage(named: "ic_check")
            
        }
        else
        {
              cell.imageView?.image = UIImage(named: "ic_uncheck")
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SVProgressHUD.show()
        
        let cell = self.tableView.cellForRow(at: indexPath) as UITableViewCell!
        if(rowsWhichAreChecked.contains(indexPath as NSIndexPath) == false)
        {
            cell?.imageView?.image = UIImage(named:"ic_check")
            rowsWhichAreChecked.append(indexPath as NSIndexPath)
            print("cell has been selected:")
            
            let diet_id = self.dietData[indexPath.row]["_id"] as? String
            
            print("diet_id is that \(diet_id)")
            
               // let UserId = UserDefaults.standard.string(forKey: "user_id")!
            let singelton = SharedManager.sharedInstance
          
             let UserId =  singelton.loginId
                print("diet_id is that \(diet_id)")
                let serverUIrl = K_DIETLIST_URL
                let parameter = ["user_id" : UserId,"diet_id":diet_id!,"checked" : true] as [String : Any]
                Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                    switch(response.result)
                    {
                    case.success(_):
                    if let  JSON = response.result.value
                        {
                            print(JSON)
                            
                            let responseData = JSON as! NSDictionary
                            
                            if responseData.object(forKey: "status") as! String == "success"
                            {
                                SVProgressHUD.dismiss()
                                
                                
                                
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
                                SVProgressHUD.dismiss()
                                
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
                            SVProgressHUD.dismiss()
                            
                            print(response)
                        }
                        break
                        case.failure(_):
                            SVProgressHUD.dismiss()
                        print(response.result.error)
                        break
                    }
                    }
                }
        else
        {
            cell?.imageView?.image = UIImage(named:"ic_uncheck")
            print("cell has been deselected:")
            
            let diet_id = self.dietData[indexPath.row]["_id"] as? String
            
            print("diet_id is that \(diet_id)")
            
           // let UserId = UserDefaults.standard.string(forKey: "user_id")!
            let singelton = SharedManager.sharedInstance
         
            let UserId =  singelton.loginId
            print("diet_id is that \(diet_id)")
             let serverUIrl = K_DIETLIST_URL
            let parameter = ["user_id" : UserId,"diet_id":diet_id!,"checked" : false] as [String : Any]
            Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
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

            if let checkedItemIndex = rowsWhichAreChecked.index(of: indexPath as NSIndexPath)
            {
                
                rowsWhichAreChecked.remove(at: checkedItemIndex)
                
                print("cell has been deselected:")
            }
        }
        
    }
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




