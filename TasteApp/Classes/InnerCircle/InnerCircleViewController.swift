//
//  InnerCircleViewController.swift
//  TasteApp
//
//  Created by Shubhank on 22/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Contacts
import SVProgressHUD
import Kingfisher
import Alamofire


class InnerCircleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate
{
    
    //    @IBOutlet weak var ContactCollectionView: UICollectionView!
    var ContactCollectionView: UICollectionView!
    
    var results: [CNContact] = []
    var contactName = [[String:Any]]()
    var contactPhoneNo = [String]()
    var contactEmailAddress = [[String]]()
    
    var phoneString:String = ""
    var imageString: UIImage?
    var emailString:String = ""
    
    
    var users = [[String:Any]]()
    var filtering = false
    // var filteredUsers = [[String:Any]]()
    // var filteredUsers : [AnyObject] = []
    let titleLabel = UILabel()
    
    var emailExists = false
    var userProfileArray = [InnerCircleProfile]()
    var phoneContactsArray = [PhoneContacts]()
    var userContactProfileArray = [InnerCircleProfile]()
    var sortedProfileArray = [InnerCircleProfile]()
    var sortedProfileArrayTTA = [InnerCircleProfile]()
    var filteredNONTTAUserProfileArray = [InnerCircleProfile]()
    var filteredTTAUserProfileArray = [InnerCircleProfile]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.ContactCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.view.addSubview(self.ContactCollectionView)
        self.ContactCollectionView?.register(TTAUserCell.self,
                                             forCellWithReuseIdentifier: "TTAUserCell")
        self.ContactCollectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        
        self.ContactCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(134)
            make.bottom.equalTo(-50)
        }
       // self.ContactCollectionView.backgroundColor = UIColor.clear //code commented
        self.ContactCollectionView.backgroundColor = UIColor.groupTableViewBackground // code added
        //        self.ContactCollectionView?.register(PhoneBookUserCell.self,
        //                                                  forCellWithReuseIdentifier: "PhoneBookUserCell")
        
        //self.view.backgroundColor = UIColor.white
        self.view.endEditing(true)
        
        self.ContactCollectionView.delegate = self
        self.ContactCollectionView.dataSource = self
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
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
        
        
        // self.setupView()
        
        
        
        
    }
    
    @IBAction func BackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //                self.ContactCollectionView?.register(TTAUserCell.self,
        //                                              forCellWithReuseIdentifier: "TTAUserCell")
        //                self.ContactCollectionView?.register(PhoneBookUserCell.self,
        //                                                          forCellWithReuseIdentifier: "PhoneBookUserCell")
        
//        let manager = NetworkReachabilityManager(host: "www.google.com")
//        manager?.listener = { status in
//            
//            
//            print("Network Status Changed: \(status)")
//            print("network reachable \(manager!.isReachable)")
//            
//            if manager!.isReachable != true
//            {
//                
//                SVProgressHUD.dismiss()
//            }
//            else
//            {
//                self.GetContact()
//                self.setupView()
//               // SVProgressHUD.show()
//               
//                
//            }
//        }
//        
//        
//        manager?.startListening()
        
        self.titleLabel.isHidden = true
        filtering = false

        
        if Reachability.isConnectedToNetwork() == true
        {
            self.GetContact()
            self.setupView()
            
        }
        else{
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
        self.view.isUserInteractionEnabled = true
        self.titleLabel.isHidden = true
        self.users.removeAll()
        self.emailString = ""
        // self.filteredUserProfileArray.removeAll()
        self.filteredTTAUserProfileArray.removeAll()
        self.filteredNONTTAUserProfileArray.removeAll()
        self.sortedProfileArrayTTA.removeAll()
        self.sortedProfileArray.removeAll()
        self.userProfileArray.removeAll()
        self.phoneContactsArray.removeAll()
        self.userContactProfileArray.removeAll()
        self.results.removeAll()
        self.ContactCollectionView.reloadData()
        super.viewWillDisappear(animated)
    }
    
    
    
    
    func setupView()
    {
        SVProgressHUD.show() //code added
         self.view.isUserInteractionEnabled = false //code added
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        //        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        //        let titleLabel = UILabel()
        //        titleLabel.text = "ADD TO CIRCLE"
        //        titleLabel.textAlignment = .center
        //        titleLabel.numberOfLines = 2
        //        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 24)
        //        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        //        self.view.addSubview(titleLabel)
        //        titleLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(20)
        //            make.right.equalTo(-20)
        //            make.top.equalTo(40)
        //        }
        
        
        var textField = UITextField()
        // textField = UITextField(frame: CGRectMake(20.0, 30.0, 100.0, 33.0))
        
        textField.delegate = self
        self.view.addSubview(textField)
        textField.backgroundColor = UIColor.black
        textField.layer.cornerRadius = 8
        textField.textColor = UIColor.white
        //textField.text = "Search"
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(85)
            make.height.equalTo(45)
            
            
            //            make.left.equalTo(10)
            //            make.right.equalTo(-10)
            //            make.height.equalTo(40)
            //            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            
        }
        
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        textField.leftViewMode = .always
        let str = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.attributedPlaceholder = str
        textField.returnKeyType = UIReturnKeyType.search
        
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "ic_search")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        textField.leftViewMode = .always
        textField.leftView = leftView
        
        //   let flowLayout = UICollectionViewFlowLayout()
        
        
        //        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        //        collectionView.backgroundColor = UIColor.clear
        //        self.view.addSubview(collectionView)
        //        collectionView.dataSource = self
        //        collectionView.delegate = self
        //        collectionView.register(UICollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        //
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhonebookCell") // iske baad line lagani hai
        //        collectionView.snp.makeConstraints { (make) in
        //            make.left.equalTo(15)
        //            make.right.equalTo(-15)
        //           // make.bottom.equalTo(0)
        //            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
        //            make.top.equalTo(textField.snp.bottom).offset(10)
        //        }
        
        
        
        
        
        
        if self.emailString.count > 0 {
            
        // let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"phone_nos":self.phoneString,"emails":self.emailString]
        let singelton = SharedManager.sharedInstance
      //  print(singelton.loginId)
        let parameters = ["user_id": singelton.loginId,"phone_nos":self.phoneString,"emails":self.emailString]
        
      //  print("phone",self.phoneString)
        // print("emai",self.emailString,parameters)
      //  print("pa is",parameters)
        DataManager.sharedManager.getInnerCircleUser(params: parameters, completion:
            { (response) in
                
                //simulator me nhi chalta ?
                
                
                if let dataDic = response as? [[String:Any]]
                {
                   // print(dataDic)
                    self.users = dataDic
                    
                    
                    if self.users.count > 0
                    {
                        
                        self.loadUserData()
                    }
                        
                    else
                    {
                        SVProgressHUD.dismiss()
                        self.loadUserData()
                        
                        
                    }
                }
                    
                    
                else
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
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
        
        
        }
        else
        {
            SVProgressHUD.dismiss() //code added
            self.view.isUserInteractionEnabled = true
            self.titleLabel.isHidden = false
            self.titleLabel.text = "You have no contacts in your inner circle so far."
            self.titleLabel.textAlignment = .center
            self.titleLabel.numberOfLines = 2
            self.titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.view.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view)
            }

        }
        
        
        //        let crossButton = UIButton(type: .custom)
        //        self.view.addSubview(crossButton)
        //        crossButton.addTarget(self, action: #selector(self.popToPreviousScreen), for: .touchUpInside)
        //
        //        crossButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(10)
        //            make.width.equalTo(30)
        //            make.height.equalTo(30)
        //            make.centerY.equalTo(titleLabel.snp.centerY)
        //        }
        //        crossButton.setImage(UIImage(named:"ic_back"), for: .normal)
    }
    func loadUserData() {
        
        var profile:[String:Any]?
        for var i in 0..<self.users.count {  // user array server response
            let userProfile  = InnerCircleProfile()
            profile = self.users[i]["profile"] as? [String:Any]
            if let id =  self.users[i]["_id"] as? String{
                userProfile.id = id
            }
            
            if let fName = profile?["firstname"] as? String{
                if let lastName = profile?["lastname"] as? String{
                    userProfile.firstName = fName + " " + lastName
                }
                else{
                    userProfile.firstName = fName
                }
                
            }
            if let company_name = profile?["company_name"] as? String{
                userProfile.companyName = company_name
            }
            if   let imageUrl = profile?["image"] as? String{
                if (imageUrl.characters.count) > 0
                {
                    userProfile.imageUrl = K_IMAGE_BASE_URL + imageUrl
                }
            }
            if let email = profile?["email"] as? String{
                userProfile.email = email
            }
            for phoneUpdate in userProfileArray{
                if(phoneUpdate.email == userProfile.email){
                    emailExists = true
                }
            }
            
            if(!emailExists){
                userProfileArray.append(userProfile)
            }
            emailExists=false
           // print("Data is deval ", userProfile.email)
           // print("Data is ", userProfileArray)
            
        }
        if self.emailString.count > 0
        {
            self.emailString = String( self.emailString.characters.dropLast(1))
            
        }
        let emailArray =  self.emailString.components(separatedBy: ",")  // phone book arry
       // print(emailArray.count)
        
        for email in emailArray{
            var isFound = false
            for user in self.userProfileArray{
                if user.email.localizedCaseInsensitiveContains(email)
                {
                    
                    
                    
                    
                    
                    isFound = true
                    user.isEmailFound = true
                    break
                }
            }
            if !isFound{
                let userProfile  = InnerCircleProfile()
                userProfile.isEmailFound = false
                userProfile.email = email
                userProfile.id = ""
                userProfile.firstName = ""
                userProfile.companyName = ""
                userProfile.imageUrl = ""
                //                for item in contactName
                //                {
                //                    if let itemName = item["Email"]{
                //                        if (itemName as AnyObject).localizedCaseInsensitiveContains( userProfile.email){
                //                            if let itemName = item["Name"]{
                //                                userProfile.firstName = itemName as! String
                //                            }
                //                        }
                //                    }
                //
                //
                //
                //                }
                var phoneContacts = PhoneContacts()
                for phone in phoneContactsArray{
                    phoneContacts = phone
                   // print(phoneContacts.emailPhone,"name",phoneContacts.firstName)
                    if phoneContacts.emailPhone.localizedCaseInsensitiveContains(email) {
                        userProfile.firstName = phoneContacts.firstName
                        userProfile.email = phoneContacts.emailPhone
                        userProfile.thumbImage = phoneContacts.image
                    }
                    
                    
                    
                }
                
                
                for phoneUpdate in userContactProfileArray{
                    
                    if(phoneUpdate.email == userProfile.email){
                        emailExists = true
                    }
                }
                
                if(!emailExists){
                    userContactProfileArray.append(userProfile)
                }
                emailExists=false
            }
        }
        
        //  self.userProfileArray.append(contentsOf: self.userContactProfileArray)
        let userProfileN  = InnerCircleProfile()
        //  self.userProfileArray.sorted(by: { $0.firstName > $1.firstName })
        self.sortedProfileArray = self.userContactProfileArray.sorted(by: { (img0: InnerCircleProfile, img1: InnerCircleProfile) -> Bool in
            return img0.firstName < img1.firstName
        })
        self.sortedProfileArrayTTA = self.userProfileArray.sorted(by: { (img0: InnerCircleProfile, img1: InnerCircleProfile) -> Bool in
            return img0.firstName < img1.firstName
        })
        
        //        let _profile = InnerCircleProfile()
        //        _profile.firstName = "Adasx"
        //        _profile.companyName = "Abcsd"
        //        sortedProfileArrayTTA.append(_profile)
        //        print("name---", self.sortedProfileArray)
        //        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        //        var sortedResults: NSArray = phoneUpdate.sortedArrayUsingDescriptors([descriptor])
        
        //        let swiftArray = self.userProfileArray as AnyObject as! [String]
        //        var sortedArray = swiftArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        //
        //        print("Sorted Array According to Name",sortedArray)
        
        if self.sortedProfileArray.count > 0{
            self.ContactCollectionView.reloadData()
        }
        else if self.sortedProfileArrayTTA.count > 0{
            self.ContactCollectionView.reloadData()
        }
        //            self.titleLabel.isHidden = false
        //            self.titleLabel.text = "You have no contacts that can be added in inner circle."
        //            self.titleLabel.textAlignment = .center
        //            self.titleLabel.numberOfLines = 2
        //            self.titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
        //            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        //            self.view.addSubview(self.titleLabel)
        //            self.titleLabel.snp.makeConstraints { (make) in
        //                make.left.equalTo(0)
        //                make.right.equalTo(0)
        //                make.centerX.equalTo(self.view)
        //                make.centerY.equalTo(self.view)
        //            }
        // }
        //        for user in self.userProfileArray{
        //            print(user.firstName,user.companyName,user.id,user.email,user.isEmailFound,user.imageUrl)
        //        }
        
    }
    func popToPreviousScreen()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if (filtering) {
        //            return filteredUsers.count;
        //        }
        //        return users.count
        for user in self.sortedProfileArrayTTA{
           // print("TTA USER  Data-------",user)
            
        }
        
        
        
        
        //        if (filtering) {
        //            return filteredTTAUserProfileArray.count;
        //        }
        
        if section == 0 {
            if filtering
            {
                return filteredTTAUserProfileArray.count
            }
            else{
                return sortedProfileArrayTTA.count
            }
            
            // return 10
            
        }
        else {
            if filtering{
                return filteredNONTTAUserProfileArray.count
            }
            else{
                return sortedProfileArray.count
            }
            
            // return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width * 0.46, height: self.view.frame.size.width * 0.55)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TTAUserCell", for: indexPath) as! TTAUserCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.76)
        if indexPath.section == 0{
            
            //  cell.backgroundColor = UIColor(white: 1, alpha: 0.76)
            
            //        for view in cell.subviews {
            //            view.removeFromSuperview()
            //        }
            
            var user = InnerCircleProfile()
            if filtering{
                user  = self.filteredTTAUserProfileArray[indexPath.row]
            }
            else{
                user  = sortedProfileArrayTTA[indexPath.row]
            }
           // print("usercontact--,",user.firstName)
            // cell.Plusbtn.removeTarget(self, action: #selector(btnAction), for: .touchUpInside)
            cell.Plusbtn.isHidden = false
            cell.Plusbtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            
            cell.Plusbtn.tag = indexPath.row
            cell.layer.cornerRadius = 4.0
            cell.Plusbtn.setImage(UIImage (named:"ic_plus_blue"), for: .normal)
            //ruk  run karata hu
            // kya hua ?
            cell.TTAUsrName?.text = user.firstName
            cell.LabelCompanyname?.text = user.companyName
            
            //            cell.TTAUserImage.layer.cornerRadius = cell.TTAUserImage.frame.width/2.0
            //             cell.TTAUserImage.clipsToBounds = true
            let imageUrl = user.imageUrl
            
            if (imageUrl.characters.count) > 0
            {
                
                cell.TTAUserImage?.kf.setImage(with: URL(string:imageUrl))
            }
                
            else
            {
                cell.TTAUserImage?.image = UIImage(named:"TasteInnerCircleIcon")
                
            }
            
            return cell
        }
        else{
            //            let cellPhonebook = collectionView.dequeueReusableCell(withReuseIdentifier: "PhoneBookUserCell", for: indexPath) as! PhoneBookUserCell
            //            for view in cellPhonebook.subviews {
            //                view.removeFromSuperview()
            //            }
            var user = InnerCircleProfile()
            if filtering{
                user  = self.filteredNONTTAUserProfileArray[indexPath.row]
            }
            else{
                user  = sortedProfileArray[indexPath.row]
            }
           // print("phonecontact--,",user.firstName)
            cell.layer.cornerRadius = 4.0
            
            // added by Ranjit hide this code
            
//            cell.Plusbtn .setImage(UIImage (named:"ic_plus"), for: .normal)
//            //  cell.Plusbtn.removeTarget(self, action: #selector(btnAction), for: .touchUpInside)
//            cell.Plusbtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
//            cell.Plusbtn.tag = indexPath.row
            
            cell.Plusbtn.isHidden = true
            
            cell.TTAUsrName?.text = user.firstName
            //cell.LabelCompanyname.text = user.companyName
            cell.LabelCompanyname.text = user.email
            //            cell.TTAUserImage.layer.cornerRadius = cell.TTAUserImage.frame.width/2.0
            //            cell.TTAUserImage.clipsToBounds = true
            let imageUrl = user.thumbImage
            if (imageUrl != nil) {
                cell.TTAUserImage?.image = imageUrl
            }else{
                
                cell.TTAUserImage?.image = UIImage(named:"TasteInnerCircleIcon")
            }
            
            
            
            return cell
            
            
        }
        
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //        if collectionView == self.ContactCollectionView {
        ////            if section == 0 {
        ////                return CGSize.zero
        ////            }
        //            return CGSize(width: self.view.frame.size.width, height: 35)
        //
        //        }
        
        if section == 0 {
            
            if filtering {
                if filteredTTAUserProfileArray.count > 0{
                    return CGSize(width: self.view.frame.size.width, height: 35)
                }else{
                    return CGSize.zero
                }
            }else{
                if sortedProfileArrayTTA.count > 0
                {
                    return CGSize(width: self.view.frame.size.width, height: 35)
                }
                else{
                    return CGSize.zero
                }
            }
        }else{
            if filtering {
                
                if filteredNONTTAUserProfileArray.count > 0{
                    return CGSize(width: self.view.frame.size.width, height: 35)
                }else{
                    return CGSize.zero
                }
                
            }else{
                
                
                
                if sortedProfileArray.count > 0{
                    return CGSize(width: self.view.frame.size.width, height: 35)
                }
                else{
                    return CGSize.zero
                }
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView != self.ContactCollectionView {
            return UICollectionReusableView()
        }
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            var headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath as IndexPath) as? UICollectionReusableView
            for view in (headerView?.subviews)! {
                view.removeFromSuperview()
            }
            if (headerView==nil) {
                
                headerView = UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
                
            }
            if indexPath.section == 0{
                
                if sortedProfileArrayTTA.count > 0{
                    let codedLabel:UILabel = UILabel()
                    codedLabel.frame = CGRect(x: 10, y: 3, width: 100, height: 20)
                 //   codedLabel.textAlignment = .center
                    codedLabel.text = "TTA USER"
                    codedLabel.numberOfLines=1
                    codedLabel.textColor=UIColor.black
                    codedLabel.font=UIFont.systemFont(ofSize: 16)
                   // print("TTA CAlling Method")
                    //   codedLabel.backgroundColor=UIColor.lightGray
                    headerView?.addSubview(codedLabel)
                    let Line:UILabel = UILabel()
                    Line.frame = CGRect(x: 0, y: 20, width: 77, height: 1)
                   // Line.textAlignment = .center
                   // Line.text = "TTA USER"
                    Line.numberOfLines=1
                    Line.textColor=UIColor.black
                    Line.font=UIFont.systemFont(ofSize: 16)
                   // print("TTA CAlling Method")
                    Line.backgroundColor=UIColor.black
                    codedLabel.addSubview(Line)
                }
                
                
            }else{
                let codedLabel:UILabel = UILabel()
                codedLabel.frame = CGRect(x: 10, y: 3, width: 150, height: 20)
             //   codedLabel.textAlignment = .center
                codedLabel.text = "PHONE BOOK USER"
                codedLabel.numberOfLines=1
                codedLabel.textColor=UIColor.black
                codedLabel.font=UIFont.systemFont(ofSize: 16)
                //  codedLabel.backgroundColor=UIColor.lightGray
                headerView?.addSubview(codedLabel)
                let Line:UILabel = UILabel()
                Line.frame = CGRect(x: 0, y: 20, width: 150, height: 1)
               // Line.textAlignment = .center
               // Line.text = "TTA USER"
                Line.numberOfLines=1
                Line.textColor=UIColor.black
                Line.font=UIFont.systemFont(ofSize: 16)
               // print("TTA CAlling Method")
                Line.backgroundColor=UIColor.black
                codedLabel.addSubview(Line)
               // print("Phone CAlling Method")
            }
            
            headerView?.backgroundColor = UIColor.clear;
            return headerView!
            
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    if Reachability.isConnectedToNetwork() == true
    {
        self.view.isUserInteractionEnabled = false
        if (filtering)
        {
            if  indexPath.section == 0  {
                
                let singelton = SharedManager.sharedInstance
                let user = self.filteredTTAUserProfileArray[indexPath.row]
                K_INNERUSER_DATA.FriendIdGlobal = user.id
                self.HitNotificationInviteStatus(frindId: user.id, userID:singelton.loginId )
                
                
            }else{
                //let user = self.filteredNONTTAUserProfileArray[indexPath.row]
               // print(user.firstName)
              //  self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
                
                let user = self.filteredNONTTAUserProfileArray[indexPath.row]
                let profile = UserProfileViewController()
                profile.screenName = "Invite"
                profile.firstName = user.firstName
                profile.userEmail = user.email
                if let thumbImage = user.thumbImage{
                    profile.thumbImage = thumbImage
                }
                else{
                    profile.thumbImage = UIImage.gif(name: "TasteInnerCircleIcon")
                }
                
                profile.phoneBookUser = "phonebookUser"
                self.navigationController?.pushViewController(profile, animated: true)

                
            }
        }
        else
        {
            
            if indexPath.section == 0{
                let singelton = SharedManager.sharedInstance
                let user = self.sortedProfileArrayTTA[indexPath.row]
                K_INNERUSER_DATA.FriendIdGlobal = user.id
                self.HitNotificationInviteStatus(frindId: user.id, userID:singelton.loginId)
                
            }else{
                
                
                
                let user = self.sortedProfileArray[indexPath.row]
//                print(user.firstName)
//                self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
                
//                // added by Ranjit 9 Oct replace the above code by below
//                
               // let user = self.sortedProfileArray[indexPath.row]
                let profile = UserProfileViewController()
                profile.screenName = "Invite"
                profile.firstName = user.firstName
                profile.userEmail = user.email
                if let thumbImage = user.thumbImage{
                    profile.thumbImage = thumbImage
                }
                else{
                    profile.thumbImage = UIImage.gif(name: "TasteInnerCircleIcon")
                }
                
                profile.phoneBookUser = "phonebookUser"
                self.navigationController?.pushViewController(profile, animated: true)
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
    
    /*
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
     
     // print("Section",indexPath.section)
     
     if (filtering)
     {
     
     if  indexPath.section == 0  {
     let user = self.filteredTTAUserProfileArray[indexPath.row]
     if user.isEmailFound == true{
     self.view.endEditing(true)
     
     let profile = UserProfileViewController()
     
     // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
     profile.friendId = user.id
     profile.screenName = "Invite"
     self.navigationController?.pushViewController(profile, animated: true)
     }
     else{
     self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
     }
     
     }else{
     let user = self.filteredNONTTAUserProfileArray[indexPath.row]
     if user.isEmailFound == true{
     self.view.endEditing(true)
     
     let profile = UserProfileViewController()
     
     // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
     profile.friendId = user.id
     profile.screenName = "Invite"
     self.navigationController?.pushViewController(profile, animated: true)
     }
     else{
     self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
     }
     
     }
     }
     else
     {
     
     if indexPath.section == 0{
     let singelton = SharedManager.sharedInstance
     let user = self.sortedProfileArrayTTA[indexPath.row]
     
     
     if user.isEmailFound == true{
     K_INNERUSER_DATA.FriendIdGlobal = user.id
     self.HitNotificationInviteStatus(frindId: user.id, userID:singelton.loginId )
     
     //                let profile = UserProfileViewController()
     //                profile.screenName = "Invite"
     //                profile.friendId = user.id
     //                self.navigationController?.pushViewController(profile, animated: true)
     }
     else{
     self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
     }
     
     
     }else{
     
     let singelton = SharedManager.sharedInstance
     let user = self.sortedProfileArray[indexPath.row]
     
     
     if user.isEmailFound == true{
     K_INNERUSER_DATA.FriendIdGlobal = user.id
     self.HitNotificationInviteStatus(frindId: user.id, userID:singelton.loginId )
     
     //                let profile = UserProfileViewController()
     //                profile.screenName = "Invite"
     //                profile.friendId = user.id
     //                self.navigationController?.pushViewController(profile, animated: true)
     }
     else{
     self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
     }
     
     
     }
     
     }
     
     
     
     
     }
     */
    
    
    
    func HitNotificationInviteStatus(frindId:String , userID:String)  {
        
        let parameter = ["user_id" :userID, "friend_id":frindId]
       // print(parameter)
        DataManager.sharedManager.notificationInviteStatus(params: parameter) { (response) in
            
            
            
          //  print("Invite Status Response",response)
            if let dataDic = response as? [String:Any]
                
            {
                if let valData  = dataDic["data"] as? String {
                    
                   // print("message---",dataDic)
                    if valData == "SEND_BY_STRANGER"{     //Done
                        K_INNERUSER_DATA.requestStatus = ""
                        let profile = NotificationsUserProfileViewController()
                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        // profile.friendId = id as String
                        
                        
                        
                        
                        profile.screenName = ""
                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "SEND_BY_USER"{
                        let profile = UserProfileViewController()
                        profile.screenName = "Invite"
                        //  profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        profile.phoneBookUser = "friend"
                        self.navigationController?.pushViewController(profile, animated: true)
                        
                        
                        //                        let profile = NotificationsUserProfileViewController()
                        //                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        //                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        //                        K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        //
                        //                        profile.screenName = ""
                        //                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "REQUEST_NOT_SEND"{           //Done
                        
                        let profile = UserProfileViewController()
                        profile.screenName = "Invite"
                        //  profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        self.navigationController?.pushViewController(profile, animated: true)
                        //
                        // let profile = NotificationsUserProfileViewController()
                        // profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        // profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        // K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        // profile.friendId = id as String
                        
                        // profile.screenName = ""
                        // self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "REQUEST_APPROVED"{      // Done
                        
                        // Open The User Profile Screen
                        let profile = UserAddedProfileViewController()
                        profile.screenName = "InviteAdded"
                        //  print("Data is profile ",profileDict)
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        profile.userObjId =  K_INNERUSER_DATA.UserIdGlobal
                        //            profile.friendId = self.users[indexPath.row]["fnd_obj"] as! String
                        //            profile.userObjId  = self.users[indexPath.row]["user_obj"] as! String
                        self.navigationController?.pushViewController(profile, animated: true)
                        //                        let profile = NotificationsUserProfileViewController()
                        //                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        //                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        //                        K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        //                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        //                        // profile.friendId = id as String
                        //                        profile.screenName = ""
                        //                        //    self.navigationController?.pushViewController(profile, animated: true)
                    }
                    
                    
                    
                    //                    let profile = NotificationsUserProfileViewController()
                    //                    profile.userObjectId = userId
                    //                    profile.friendId = self.stranger_Id
                    //                    // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                    //                    // profile.friendId = id as String
                    //
                    //
                    //
                    //
                    //                    profile.screenName = ""
                    //                    self.navigationController?.pushViewController(profile, animated: true)
                }
                else{
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true

                }
            }
            else{
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
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
            
        }
        
        
        
        
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize.init(width: (self.view.frame.size.width * 0.5) - 25, height: 200)
    //
    //    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.emailString.count > 0{
            
            self.titleLabel.isHidden = true
            filtering = true
            
            delayWithSeconds(0.5) {
                self.filter(text: textField.text!)
            }
        }
        else{
            self.titleLabel.isHidden = false
        }
       
        
        return true
    }
    
    func filter (text:String) {
        // var user = InnerCircleProfile()
        filteredTTAUserProfileArray.removeAll()
        filteredNONTTAUserProfileArray.removeAll()
        
        if (text.characters.count == 0) {
            //filteredUserProfileArray.append(self.userProfileArray)
            filtering = false
            self.ContactCollectionView.reloadData()
            return;
        }
        
        
        for user in self.sortedProfileArrayTTA
        {
            
            if user.firstName.localizedCaseInsensitiveContains(text)
            {
                filteredTTAUserProfileArray.append(user)
            }
            else if user.companyName.localizedCaseInsensitiveContains(text)
            {
                filteredTTAUserProfileArray.append(user)
            }
            else  if user.email.localizedCaseInsensitiveContains(text)
            {
                filteredTTAUserProfileArray.append(user)
            }
            
        }
        for user1 in self.sortedProfileArray
        {
          //  print("FIRST NAME IS====",user1.firstName)
            if user1.firstName.localizedCaseInsensitiveContains(text)
            {
                filteredNONTTAUserProfileArray.append(user1)
            }
            else if user1.companyName.localizedCaseInsensitiveContains(text)
            {
                filteredNONTTAUserProfileArray.append(user1)
            }
            else  if user1.email.localizedCaseInsensitiveContains(text)
            {
                filteredNONTTAUserProfileArray.append(user1)
            }
            
        }
        
        //        for TestArray in self.filteredUserProfileArray
        //        {
        //
        //            print("FIRST NAME IS====",TestArray.firstName)
        //        }
        //
        
        
        
        
        //            let results = personData.filter({ person in
        //                if let firstname = person["firstname"] as? String, lastname = person["lastname"] as? String, query = searchController.searchBar.text {
        //                    return firstname.rangeOfString(query, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch]) != nil || lastname.rangeOfString(query, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch]) != nil
        //                }
        //                return false
        //            })
        
        
        self.ContactCollectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func btnAction(sender: UIButton) {
        //print(sender.tag)
        self.view.isUserInteractionEnabled = false
        if (filtering)
        {
            
            if let cell = sender.superview?.superview as? TTAUserCell {
                let indexPath = self.ContactCollectionView.indexPath(for: cell)
                if indexPath?.section == 0{
                    let singelton = SharedManager.sharedInstance
                    let user = self.filteredTTAUserProfileArray[sender.tag]
                    K_INNERUSER_DATA.FriendIdGlobal = user.id
                    self.HitNotificationInviteStatus(frindId: user.id, userID:singelton.loginId )
                    
                }
                else{
                    let user = self.filteredNONTTAUserProfileArray[sender.tag]
                   // print(user.firstName)
                    self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
                }
            }
            
            
        }
        else
        {
            
            //  let user = self.userProfileArray[sender.tag]
            if let cell = sender.superview?.superview as? TTAUserCell {
                let indexPath = self.ContactCollectionView.indexPath(for: cell)
                if indexPath?.section == 0{
                    let singelton = SharedManager.sharedInstance
                    let user = self.sortedProfileArrayTTA[sender.tag]
                    K_INNERUSER_DATA.FriendIdGlobal = user.id
                    self.HitNotificationInviteStatus(frindId: user.id, userID:singelton.loginId )
                    
                }
                else{
                    let user = self.sortedProfileArray[sender.tag]
                  //  print(user.firstName)
                    self.inviteEmail(friendName: user.firstName, senderName: K_CURRENT_USER.name, friendEmail: user.email)
                }
            }
            
            
        }
        
    }
    
    
    func GetContact()
    {
        var contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataKey,
                CNContactThumbnailImageDataKey,
                CNContactImageDataAvailableKey] as [Any]
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                   // print("Results Is",results)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            var i = 0
            for item in results
            {
                
                
                var content = Dictionary<String,Any>()
                //name
                content.updateValue(item.givenName, forKey: "Name")
                
                
                
                //   content.updateValue(item.imageData, forKey: "Image")
                //end name
                
                
                //phone no
                var phoneNo : String = ""
                
                if  item.phoneNumbers.count > 0 {
                    
                    phoneNo = (item.phoneNumbers[0].value ).value(forKey: "digits") as! String
                  //  print(phoneNo)
                    content.updateValue (phoneNo, forKey: "Phone")
                }
                
                var UserImage: UIImage?
                
                
                
                
                //end phone no
                
                //email
                for email in item.emailAddresses{
                    var phoneContacts = PhoneContacts()
                    
                    
                    if let fullName = CNContactFormatter.string(from: item, style: .fullName){
                        phoneContacts.firstName = fullName
                    }
                    else{
                        phoneContacts.firstName = item.givenName
                    }
                    phoneContacts.phone = phoneNo
                    
                    if item.isKeyAvailable(CNContactImageDataKey) {
                        if let contactImageData = item.thumbnailImageData {
                            
                            UserImage = UIImage(data:contactImageData)
                          //  print("image--------- \(UserImage)")
                            content.updateValue (UserImage!, forKey: "imageUser")
                            phoneContacts.image = UserImage
                            
                            
                        } else {
                          //  print("No image available")
                         //   print("image---------ELSE \(UserImage)")
                        }
                    } else {
                      //  print("No Key image available")
                    }
                    
                    if let emailValue = email.value as? String{
                      //  print("name is",emailValue,item.givenName)
                        phoneContacts.emailPhone = emailValue
                        // phoneContacts.email.append(phoneContacts)
                        phoneContactsArray.append(phoneContacts)
                      //  print(phoneContacts.firstName,phoneContacts.emailPhone)
                        
                    }
                    
                }
                content.updateValue(((item.emailAddresses.first?.value) as? String ) ??
                    "gmail", forKey: "Email")
                
                // end email
                
                contactName.append(content)
                
               // print("item list is \(item)that")
                
                
                i = i+1
            }
            var phoneContacts = PhoneContacts()
            for phone in phoneContactsArray{
                phoneContacts = phone
                emailString += String(format:"%@,",phoneContacts.emailPhone )
            }
            
            for item in contactName
            {
                
                if let itemName = item["Phone"]
                {
                    
                    phoneString += String(format:"%@,",itemName as! String)
                    
                    
                    
                    
                   // print(itemName)
                }
                if let itemimage = item["imageUser"]
                {
                    
                    //     imageString += String(format:"%@,",itemimage as! String)
                    
                    
                    
                    
                  //  print("Image name----------",itemimage)
                }
                
                
                
            }
            
            
            /*   let string1 = "8527647575"
             
             
             phoneString += String(format:"%@,",string1 )
             
             print("print string of phone is \(phoneString)that")
             */
            
            return results
        }()
        
    }
    
    func inviteEmail(friendName: String,senderName:String,friendEmail:String)  {
        
        if Reachability.isConnectedToNetwork() == true
        {
        self.view.isUserInteractionEnabled = false
        SVProgressHUD.show()
        
        // let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"phone_nos":self.phoneString,"emails":self.emailString]
        let singelton = SharedManager.sharedInstance
       // print(singelton.loginId)
        let parameters = ["fnd_name": friendName,"sender_name":senderName,"fnd_email":friendEmail]
       // print(parameters)
        
        DataManager.sharedManager.inviteEmail(params: parameters, completion:
            { (response) in
                
                
                
                if let message = response as? String
                {
                   // print(message)
                    
                    SVProgressHUD.dismiss()
                    if message == ""{
                        self.view.isUserInteractionEnabled = true
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
                        let alert = UIAlertController(title: "Taste", message:message, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                         self.view.isUserInteractionEnabled = true
                        return
                            
                        
                    }
                    
                }
                    
                else
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    if Reachability.isConnectedToNetwork() != true
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
                
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                }
                
        })
        
        
         }
        else
        {
            self.view.isUserInteractionEnabled = true
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
    
    
    
}

