//
//  BanksListViewController.swift
//  TasteApp
//
//  Created by Shubhank on 08/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import Kingfisher


class BanksListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK:DECLARE VARIABLE
    
    var banks = [[String:Any]]()
    var userData = [[String:Any]]()
    let images = ["america-bank-logo", "ic_american_exp", "ic_bank_of_america", "ic_capital-one-bank" ,"ic_chase_bank" , "ic_citi_bank" , "ic_citizens_bank"]
    let texts = ["AMERICAN EXPRESS", "AMERICA", "BANK OF AMERICA", "CAPITAL ONE" ,"CHASE BANK" , "CITI BANK" , "CITIZENS BANK"]
    var tableView:UITableView!
    var filtering = false
    var filteredBanks = [[String:Any]]()
    var  isloading  = true
    var replaced : String?
    var screenName :String?
    let textFieldSearch = UITextField()
    var isTop10:Bool = true
    // let titleEmpty = UILabel()
    let myFavconImages =  ["American-Express", "Bank-of-america-icon","Barclays", "citi-Icon","Capital-One-Icon", "Chase-icon", "discover-icon","synchrony-icon", "US-Bank-Icon", "Wells-Fargo"]
    // MARK: VIEW METHOD
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
//        if ((UserDefaults.standard.string(forKey: "bankcount")) != nil)
//            
//        {
//            
//            K_USER_DATA.bankCount = UserDefaults.standard.string(forKey: "bankcount")!
//            print("BANK COUNT IN LOGIN SCREEN \(K_USER_DATA.bankCount)")
//            
//            let count:Int =  Int(K_USER_DATA.bankCount)!
//            
//            if (count > 0)
//            {
//                let vc = ProfileBeingCreatedViewController()
//                let navVC = UINavigationController(rootViewController: vc)
//                navVC.isNavigationBarHidden = true
//                self.present(navVC, animated: false, completion: nil)
//            }
//        }
        
   
        
        self.setupView()
        self.view.endEditing(true)
      
        
        
        
        
        // Do any additional setup after loading the view.
       // SVProgressHUD.show()
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
        }
        else
        {
            SVProgressHUD.dismiss()
            
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }}
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
//        self.banks.removeAll()
//        self.tableView.reloadData()
        
        super.viewWillAppear(animated)
      /*  let manager = NetworkReachabilityManager(host: "www.google.com")
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            print("network reachable \(manager!.isReachable)")
            if manager!.isReachable != true
            {
                SVProgressHUD.dismiss()
            }
            else
            {
               
            }
        }
        manager?.startListening()
 */
        if Reachability.isConnectedToNetwork() == true
        {
           
        }
        else
        {
            SVProgressHUD.dismiss()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        // self.titleEmpty.isHidden = true
    self.view.isUserInteractionEnabled = true
       super.viewWillDisappear(animated)
    }
    
    // MARK:GO BACK METHOD
    
    func goBack() {
             self.tabBarController?.tabBar.isHidden = false
        
        _ =   self.navigationController?.popViewController(animated: true)
    }
    
   // MARK:SETUP VIEW
    
    func setupView() {
        
          SVProgressHUD.show()
        
       
        let titleLabel = UILabel()
        titleLabel.text = "S E L E C T\n Y O U R   B A N K"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia , size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
        }
        
        if screenName == "bankaccount"
        {
            
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
        }
       
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.backgroundColor = UIColor.white
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            //  make.top.equalTo(40)
            make.width.equalTo(590 * 0.5)//490
            make.height.equalTo(680 * 0.5)//580
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(12)
        }
        
        
        //let textField = UITextField()
        textFieldSearch.delegate = self
        self.view.addSubview(textFieldSearch)
        textFieldSearch.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        textFieldSearch.backgroundColor = UIColor.black
        textFieldSearch.layer.cornerRadius = 8
        textFieldSearch.textColor = UIColor.white
        
        //ic_search
        //textField.text = "Search"
        textFieldSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        textFieldSearch.leftViewMode = .always
        let str = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textFieldSearch.attributedPlaceholder = str
        textFieldSearch.returnKeyType = UIReturnKeyType.search
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "ic_search")
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        textFieldSearch.leftViewMode = .always
        textFieldSearch.leftView = leftView
        //textField.leftView = UIImageView(image: UIImage(named: "ic_search"))
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(0)
            make.top.equalTo(textFieldSearch.snp.bottom).offset(10)
        }
        tableView.tableFooterView = UIView()
       
       

       
        self.loadTableViewData()
        }
    
    
       
   
// MARK:LOAD TABLE VIEW DATA YODLEE API
    
    func loadTableViewData()
    {
        
         self.view.isUserInteractionEnabled = false
        
        if  Reachability.isConnectedToNetwork() == true
        {
           // delayWithSeconds(4.0) {
              //  SVProgressHUD.show()
                
                
                let singelton = SharedManager.sharedInstance
                
                //["name":"","top":"20","priority":""]
                DataManager.sharedManager.getBankListYodlee(Params:["user_id": singelton.loginId,"name":"","top":"20","priority":""], completion: { (response) in
                    
                    
                    if let bankDict = response as? [String:Any]
                    {
                        if let providerarr =  bankDict["provider"] as? [[String:Any]]
                            
                        {
                            self.banks.removeAll()
                            self.banks = providerarr
                            print(providerarr)
                            self.view.isUserInteractionEnabled = true
                            self.tableView.isUserInteractionEnabled = true
                            self.isTop10 = true
                            //self.titleEmpty.isHidden = true
                            self.tableView.reloadData()
                            //self.loginApiHit()
                        }
                    }
                    else{
                         SVProgressHUD.dismiss()
                         self.view.isUserInteractionEnabled = true
                        self.tableView.isUserInteractionEnabled = true
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

                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                    }
                })
           // }
            
        }
            
        else
        {
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            self.tableView.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.textFieldSearch.resignFirstResponder()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }    
    
    func scaledImage(_ image: UIImage, maximumWidth: CGFloat) -> UIImage
    {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    
    // MARK:LOGIN API
    
    
    func loginApiHit()
    {
        var params = ["is_linkedin_user":"true",
                      "linkedin_key":UserDefaults.standard.string(forKey:"linkedin_id")!,
                      "firstname": UserDefaults.standard.string(forKey:"name")!,
                      "lastname":UserDefaults.standard.string(forKey:"lastname")!,
                      "email":UserDefaults.standard.string(forKey:"email")!,
                      "profile_type" :"public",
                      "has_device_key" : "false"]
        
        
        DataManager.sharedManager.login(params: params , completion: { (response) in
            
            
            if let dataDic = response as? [[String:Any]]
            {
                
                self.userData  = dataDic
            }
            self.loadData()
            
            
            
            DispatchQueue.main.async
                {
                    SVProgressHUD.dismiss()
                    
            }})
        
    }
    
    //MARK :USER LOGIN ID GET HERE
    
    func loadData()
    {
        if  let loginId = self.userData[0]["_id"] as? String{
            K_CURRENT_USER.login_Id = loginId
        }
        else{
             K_CURRENT_USER.login_Id  = ""
        }
        
       // print("login id we get here is  \(loginId!)")
       // let bankCount = (self.userData[0]["total_bank"]) as! Int
        //print("bank count is \(bankCount)")
       /* let defaults = UserDefaults.standard
        defaults.set(loginId!, forKey: "user_id")
        defaults.set(bankCount, forKey: "bankcount")
        defaults.synchronize()
 */
    }
    
    //MARK: TABLEVIEW DELEGATE METHOD
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return banks.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.centerY.equalTo(cell.contentView)
        }
        if isTop10{
            imageView.image = UIImage(named: myFavconImages[indexPath.row])!
        }
        else{
            let imageLogo = banks[indexPath.row]["favicon"] as? String
            //print("\(imageLogo)")
            
            if imageLogo != nil
            {
                
                // replaced = (imageLogo! as String).replacingOccurrences(of:"FAVICON", with: "LOGO")
                //imageView.kf.setImage(with: URL(string:replaced!))
                
                let size = CGSize(width: 60, height: 60)
                let processImage = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
                
                imageView.kf.setImage(with:URL(string:imageLogo!), placeholder: UIImage(named: "placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
                
                
            }
            
            
            imageView.clipsToBounds = true
            //imageView.backgroundColor = UIColor.gray
        }
        
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(-20)
            make.centerY.equalTo(cell.contentView)
        }
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        textLabel.text = banks[indexPath.row]["name"] as? String
        
        
        let textBaseUrlLabel = UILabel()
        textBaseUrlLabel.textColor = UIColor.black
        cell.contentView.addSubview(textBaseUrlLabel)
        textBaseUrlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp.bottom).offset(1)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(-20)
           // make.centerY.equalTo(cell.contentView)
        }
        textBaseUrlLabel.font = UIFont.boldSystemFont(ofSize: 10)
        
        textBaseUrlLabel.text = banks[indexPath.row]["baseUrl"] as? String
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            let vc = BankLoginViewController()
            vc.bank = banks[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
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

        //Crashlytics.sharedInstance().crash()
    }
    
    
     // MARK:TEXTFILED DELEGATE METHOD
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
       
        return true
    }
    
    func filter (text:String)
    {
        if Reachability.isConnectedToNetwork() != true
        {
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            textFieldSearch.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.textFieldSearch.resignFirstResponder()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return

        }
        
       // delayWithSeconds(2.0) {
            
                print("It is come here")
                let singelton = SharedManager.sharedInstance
                DataManager.sharedManager.getBankListYodlee(Params:["user_id": singelton.loginId,"name":text,"top":"","priority":""], completion: { (response) in
                    
                    //self.banks.removeAll()
                    
                    if let bankDict = response as? [String:Any]
                    {
                        if let providerarr =  bankDict["provider"] as? [[String:Any]]
                            
                        {
                            self.banks.removeAll()
                            self.banks = providerarr
                            self.isTop10 = false
                        }
                         self.view.isUserInteractionEnabled = true
                        if self.banks.count > 0
                            {
                          
                              SVProgressHUD.dismiss()
                               

                                self.tableView.isUserInteractionEnabled = true
                                self.textFieldSearch.isUserInteractionEnabled = true
                           // self.titleEmpty.isHidden = true
                            self.tableView.reloadData()
                                
                        print("tableview count is here \(self.banks.count)")
                        }
                    }
                    
                    else
                    {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true

                        //self.banks.removeAll()
                         self.tableView.isUserInteractionEnabled = true
                        self.textFieldSearch.isUserInteractionEnabled = true
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
                       // self.tableView.reloadData()
                       // self.titleEmpty.isHidden = false
//                        let alert = UIAlertController(title: "Taste", message:"", preferredStyle: UIAlertControllerStyle.alert)
//                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                            UIAlertAction in
//                            NSLog("OK Pressed")
//                        }
//                        alert.addAction(okAction)
//                        self.present(alert, animated: true, completion: nil)
//                        return
                        
                        
                    }
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                       SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true

                    }
                })
           // }
    }
    
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
       if (textField.text?.characters.count)! >= 1
       {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        tableView.isUserInteractionEnabled = false
        textFieldSearch.isUserInteractionEnabled = false
       // isTop10 = false
        self.filter(text: textField.text!)
        
       }
        
        else if (textField.text?.characters.count)! == 0
       {
         self.view.isUserInteractionEnabled = false
         tableView.isUserInteractionEnabled = false
        //self.banks.removeAll()
        SVProgressHUD.show()
        
        self.loadTableViewData()
        
        }
        
               
//        else
//       {
//        textField.resignFirstResponder()
//        let alert = UIAlertController(title: "Taste", message:"Enter at least 3 chracters to search bank.", preferredStyle: UIAlertControllerStyle.alert)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            NSLog("OK Pressed")
//            self.view.endEditing(true)
//        }
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//        
//        }
        
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
//    func scaledImage(_ image: UIImage, maximumWidth: CGFloat) -> UIImage
//    {
//        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
//        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
//    }
}
