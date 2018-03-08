//
//  SettingViewController.swift
//  TasteApp
//
//  Created by Anuj Singh on 3/6/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,MFMailComposeViewControllerDelegate
{
    
//    var texts = ["Edit Diet",
//                 "Edit Dining History",
//                 "Edit Bank Account"]
    var texts = ["Edit Dining History",
                 "Edit Bank Account","Support"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpView()
    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func setUpView()
        
        
    {
        
        
        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "SETTINGS"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 22)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
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
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.view.snp.centerY).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
        tableView.tableFooterView = UIView()
        
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(self.goLoginScreen), for: .touchUpInside)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(2)
            make.height.equalTo(50)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
    }
    
    func goLoginScreen()
    {
        
            /* let bankCount = UserDefaults.standard.string(forKey: "bankcount")!
        
        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        
        let defaults = UserDefaults.standard
        defaults.set(bankCount, forKey: "bankcount")
        defaults.synchronize()
        */
        let singelton = SharedManager.sharedInstance
        singelton.refeshRecommendation = "yes"
        let parameters = ["user_id":singelton.loginId]
        DataManager.sharedManager.logout(params: parameters , completion: { (response) in
            
            
            if let dataDic = response as? [[String:Any]]
            {
                
                
            }
            
            
        })

//        singelton.latValueInitial = 0.0
//        singelton.longValueInitial = 0.0
        self.deleteUserProfileData()

        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func deleteUserProfileData()  {
        let plistFileName = "data.plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0] as NSString
        let plistPath = documentPath.appendingPathComponent(plistFileName)
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        dict.removeAllObjects()

        //writing to Data.plist
        dict.write(toFile: plistPath, atomically: false)
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return texts.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(cell.contentView)
        }
        
        textLabel.font = UIFont(name: K_Font_Color, size: 17)
        textLabel.text = texts[indexPath.row]
        
        let line = UIView()
        cell.contentView.addSubview(line)
        line.backgroundColor = UIColor.black
        line.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
            make.right.equalTo(0)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let indexPath = tableView.indexPathForSelectedRow
        
//        if indexPath?.row == 0
//        {
////            let vc = EditDietViewController()
////            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if indexPath?.row == 0
        {
            
           let vc = DiningHistoryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier:"TransactionViewController") as! TransactionViewController
//            
//            self.navigationController?.pushViewController(vc, animated: true)

            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "FilterAddViewController")
//            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        else if indexPath?.row == 1
        
        {
            let vc = BankAccountViewController()
            self.navigationController?.pushViewController(vc, animated: true)

            
        }
        
        else if indexPath?.row == 2
        
        {
            
            self.sendEmail()
        }
        
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // added by Ranjit 9 Oct
    
    func sendEmail() {
        
        // Country: United States
        //
        // Device: iPhone 9
        //
        // iOS Version: 11.0.3
        //
        // Taste Version: 4.5.6 Build 2017.10.17.00.20.1
        //
        // User Info: ansfnv01938 (id tag)
        //
        // Date:
        //
        // Thank you.
        //
        // Taste
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Taste Version: (version)")
        }
        let currentLocale : NSLocale = NSLocale.init(localeIdentifier : NSLocale.current.identifier)
        let countryName : String? = currentLocale.displayName(forKey: NSLocale.Key.countryCode, value: NSLocale.current.regionCode ?? "US")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
       // let userEmail = ""
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        let result = formatter.string(from: date)
        
        if MFMailComposeViewController.canSendMail(){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@thetasteapp.com"])
            composeVC.setSubject("Taste Feedback")
            composeVC.setMessageBody("Hello,\n Please describe your problems/suggestions for the Taste team below. Our customer service team will get back to you as promptly as possible.\n\n\n\n Device Information:\n\n Country: \(String(describing: countryName!))\nDevice: \(UIDevice.current.name)\niOS Version: \(UIDevice.current.systemVersion)\nTaste Version: \(String(describing: version!))\n User Info: \( K_CURRENT_USER.email)\nDate: \(result)\n\nThank you\nTaste", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Sorry!", message:"Mail Service not available", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                //NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
    }
    
//    func sendEmail() {
//        
//        if MFMailComposeViewController.canSendMail(){
//            let composeVC = MFMailComposeViewController()
//            composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
//            // Configure the fields of the interface.
//            composeVC.setToRecipients(["support@thetasteapp.com"])
//            composeVC.setSubject("Hello!")
//            composeVC.setMessageBody("Hello this is my message body!", isHTML: false)
//            // Present the view controller modally.
//            self.present(composeVC, animated: true, completion: nil)
//
//        }
//        else{
//            let alert = UIAlertController(title: "Sorry!", message:"Mail Service not available", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//                //NSLog("OK Pressed")
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//
//        }
//     }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        print("\((result))")
        print("\(String(describing: error?.localizedDescription))")
        controller.dismiss(animated: true, completion: nil)
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
