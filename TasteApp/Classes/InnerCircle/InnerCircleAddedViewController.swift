//
//  InnerCircleAddedViewController.swift
//  Taste
//
//  Created by Lalit Mohan on 23/05/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Contacts
class InnerCircleAddedViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate ,UIGestureRecognizerDelegate
{
    var collectionView:UICollectionView!
    var users = [[String:Any]]()
    var sortedProfileArrayTTA = [[String:Any]]()
    var filtering = false
    var filteredUsers = [[String:Any]]()
    var friendId : String = ""
    var propertyFinal : [String:Any]?
    var FinalDataArray = [[String:Any]]()
    var SortedFinalArray = [[String:Any]]()
    let titleLabel = UILabel()
    let button = UIButton(type: .custom)
    let isselect : Bool = false
    var selectedIndex = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("yes we are in the added innner circle")
        
        
        
        
        self.view.backgroundColor = UIColor.white
        self.view.endEditing(true)
        // print("Friend Id from app delegate is \(self.friendId)")
        
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
        
        
    }
    
    
    //    func TabGesture(sender: UILongPressGestureRecognizer) {
    //        print("Please Help!",sender)
    //        selectedIndex = 1000
    //        self.collectionView.reloadData()
    //    }
    
    func TabGesture(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        if let index = indexPath {
            //   print("Please Help!",sender)
            selectedIndex = 1000
            self.collectionView.reloadData()
            
        } else {
            print("Could not find index path")
        }
    }
    
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            var cell = self.collectionView.cellForItem(at: index)
            selectedIndex = index.row
            var indexPaths = [IndexPath]()
            indexPaths.append(index) //"indexPath" ideally get when tap didSelectItemAt or through long press gesture recogniser.
            // print(indexPaths)
            collectionView.reloadItems(at: indexPaths)
            //[self.collectionView .reloadItems(at: [index])]
            // self.collectionView.reloadData()
            // do stuff with your cell, for example print the indexPath
            // print(index.row)
            
        } else {
            // print("Could not find index path")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        selectedIndex = 1000
        self.titleLabel.isHidden = true
        filtering = false
        
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
//                self.setupView()
//                //SVProgressHUD.show()
//                
//            }
//        }
//        
//        
//        manager?.startListening()
        
        if Reachability.isConnectedToNetwork() == true
        {
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
        selectedIndex = 1000
        SVProgressHUD.dismiss()
        self.titleLabel.isHidden = true
        self.users.removeAll()
        self.filteredUsers.removeAll()
        self.FinalDataArray.removeAll()
        self.SortedFinalArray.removeAll()
        self.collectionView.reloadData()
        self.view.isUserInteractionEnabled = true
        
        super.viewWillDisappear(animated)
    }
    
    
    func setupView()
    {
        
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        let titleLabel = UILabel()
        titleLabel.text = "INNER CIRCLE"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
        }
        let textField = UITextField()
        textField.delegate = self
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        textField.backgroundColor = UIColor.black
        textField.layer.cornerRadius = 8
        textField.textColor = UIColor.white
        //textField.text = "Search"
        
        
        
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
        
        let flowLayout = UICollectionViewFlowLayout()
        
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        // collectionView.dataSource = self
        // collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            // make.bottom.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(InnerCircleAddedViewController.handleTap(gestureReconizer:)))
        longPress.minimumPressDuration = 0.50 // 1 second press
        longPress.delegate = self
        collectionView.addGestureRecognizer(longPress)
        
        
        let longPressUncheck = UILongPressGestureRecognizer(target: self, action:#selector(InnerCircleAddedViewController.TabGesture(gestureReconizer:)))
        longPressUncheck.minimumPressDuration = 2.0 // 1 second press
        longPressUncheck.delegate = self
        collectionView.addGestureRecognizer(longPressUncheck)
        
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(InnerCircleAddedViewController.TabGesture(sender:)))
        //        tapGesture.numberOfTapsRequired =  2
        //        tapGesture.delegate = self
        //        collectionView.addGestureRecognizer(tapGesture)
        
        
        
        // delayWithSeconds(1.0)
        // {
        
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!]
        
        
        
        //}//delay end
        
        
        let crossButton = UIButton(type: .custom)
        self.view.addSubview(crossButton)
        crossButton.addTarget(self, action: #selector(self.jumpToInnerCircle), for: .touchUpInside)
        crossButton.snp.makeConstraints { (make) in
            //make.left.equalTo(10)
            make.right.equalTo(-15)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        crossButton.setImage(UIImage(named:"ic_add_bigger"), for: .normal)
        
        
        let BackBtn = UIButton(type: .custom)
        self.view.addSubview(BackBtn)
        BackBtn.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)
        BackBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            // make.right.equalTo(-10)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        BackBtn.setImage(UIImage(named:"ic_back"), for: .normal)
        SVProgressHUD.show()
        self.getUserInnerCircle()
    }
    
    
    
    
    
    
    func BackAction()
    {
        self.tabBarController?.selectedIndex =  1
    }
    
    
    
    
    func jumpToInnerCircle()
    {
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (!granted){
                //

                               DispatchQueue.main.async(execute: {
                                let alert = UIAlertController(title: "Taste", message:"Please allow to read Contacts from Settings.", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    NSLog("OK Pressed")
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                                
                })

            }
            else{
               
                
                DispatchQueue.main.async(execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier:"InnerCircleViewController_ID") as! InnerCircleViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })

            }
        })
        
        
        
        //        let vc  = InnerCircleViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // print("users count is \(users.count)")
        if (filtering) {
            return filteredUsers.count;
        }
        return SortedFinalArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(white: 1, alpha: 0.76)
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        cell.layer.cornerRadius = 4.0
        cell.backgroundColor = UIColor.white
        
        button.setImage(UIImage(named:"ic_cross"), for: .normal)//btn-signin-blue
        cell.addSubview(button)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(30)
            make.width.equalTo(30)
            // make.left.equalTo(135)
            make.right.equalTo(0)
            // make.right.equalTo(0)
        }
        if selectedIndex == indexPath.row{
            button.isHidden = false
        }else{
            button.isHidden = true
        }
        
        let imageView = UIImageView()
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(cell.snp.centerX)
            make.centerY.equalTo(cell.snp.centerY).offset(-15)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = UIColor.lightGray
        imageView.clipsToBounds = true
        
        
        let profile:[String:Any]?
        let profileDetail : [String:Any]?
        if (filtering) {
            let label = UILabel()
            cell.addSubview(label)
            var lName = ""
            var firsName = ""
            if let fName =  self.filteredUsers[indexPath.row]["firstname"] as? String{
                firsName = fName
            }
            if let lastName = self.filteredUsers[indexPath.row]["lastname"] as? String{
                lName = lastName
            }
            label.text = firsName + " " + lName
            // label.text = self.filteredUsers[indexPath.row]["firstname"] as? String
            // print("first name is \(label.text!)")
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.2
            label.font = UIFont(name:  K_Font_Color, size: 17)
            label.textAlignment = .center
            label.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(imageView.snp.bottom).offset(10)
            }
            
            let sublabel = UILabel()
            cell.addSubview(sublabel)
            sublabel.text = self.filteredUsers[indexPath.row]["company_name"] as? String //self.propertyFinal!["company_name"] as? String
            // print("company name is \(sublabel.text!)")
            sublabel.font = UIFont(name:  K_Font_Color, size: 13)
            sublabel.textAlignment = .center
            sublabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(label.snp.bottom).offset(5)
            }
        
            if  let imageUrl = self.filteredUsers[indexPath.row]["image"] as? String{
                if imageUrl.characters.count > 0{
                    imageView.sd_setImage(with: URL(string: K_IMAGE_BASE_URL + imageUrl), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                }
                else{
                    imageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                }
            }
            else{
                imageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
            }
        }
        else
        {
            let label = UILabel()
            cell.addSubview(label)
            //  label.text = self.SortedFinalArray[indexPath.row]["firstname"] as? String
            var lName = ""
            var firsName = ""
            if let fName =  self.SortedFinalArray[indexPath.row]["firstname"] as? String{
                firsName = fName
            }
            if let lastName = self.SortedFinalArray[indexPath.row]["lastname"] as? String{
                lName = lastName
            }
            label.text = firsName + " " + lName
            // print("first name is \(label.text!)")
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.2
            label.font = UIFont(name:  K_Font_Color, size: 17)
            label.textAlignment = .center
            label.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(imageView.snp.bottom).offset(10)
            }
            
            let sublabel = UILabel()
            cell.addSubview(sublabel)
            sublabel.text = self.SortedFinalArray[indexPath.row]["company_name"] as? String //self.propertyFinal!["company_name"] as? String
            // print("company name is \(sublabel.text!)")
            sublabel.font = UIFont(name:  K_Font_Color, size: 13)
            sublabel.textAlignment = .center
            sublabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(label.snp.bottom).offset(5)
            }
            if  let imageUrl = self.SortedFinalArray[indexPath.row]["image"] as? String{
                if imageUrl.characters.count > 0{
                    imageView.sd_setImage(with: URL(string: K_IMAGE_BASE_URL + imageUrl), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                }
                else{
                    imageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                }
            }
            else{
                imageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
            }
            //self.propertyFinal?["image"] as? String
            //  print("image url you got is \(imageUrl!)")
            
            
            //   imageView.sd_setImage(with: URL(string: K_IMAGE_BASE_URL + imageUrl!), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
        }
        
        
        
        //        if let profileDict = profile!["profile"]
        //        {
        //            profileDetail = profileDict as! [String : Any]
        //            self.propertyFinal = profileDetail
        //            print("profile details is \(profileDetail!)")
        //        }
        
        
        
        
        
        //        if (imageUrl?.characters.count)! > 0
        //        {
        //            imageView.kf.setImage(with: URL(string:K_IMAGE_BASE_URL + imageUrl!))
        //        }
        //
        //        else
        //        {
        //
        //
        //            imageView.kf.setImage(with: URL(string:"http://www.iaimhealthcare.com/images/doctor/no-image.jpg"))
        //        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singelton = SharedManager.sharedInstance
        
        if (filtering)
        {
            
            self.view.endEditing(true)
            
           // let profile = UserAddedProfileViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyboard.instantiateViewController(withIdentifier: "RInnerCircleAddedUserProfileVc") as! RInnerCircleAddedUserProfileVc
            
           // profile.screenName = "InviteAdded"
            let profileDict = self.filteredUsers[indexPath.row]["profile_detail"] as? [String:Any]
            if let profileUser = filteredUsers[indexPath.row]["_id"] as? String{
                profile.friendId = profileUser
            }
            profile.userObjId =  singelton.loginId
            //            profile.friendId = self.filteredUsers[indexPath.row]["fnd_obj"] as! String
            //            profile.userObjId  = self.filteredUsers[indexPath.row]["user_obj"] as! String
            
            self.navigationController?.pushViewController(profile, animated: true)
            
        }
        else
        {
            self.SortedFinalArray[indexPath.row]["company_name"] as? String
            //
            
            //let profile = UserAddedProfileViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyboard.instantiateViewController(withIdentifier: "RInnerCircleAddedUserProfileVc") as! RInnerCircleAddedUserProfileVc
            
            //  profile.screenName = "InviteAdded"
            let profileDict = self.users[indexPath.row]["profile_detail"] as? [String:Any]
            print("Data is SortedFinalArray ",SortedFinalArray)
            
            if let profileUser = SortedFinalArray[indexPath.row]["_id"] as? String{
                profile.friendId = profileUser
            }
            profile.userObjId =  singelton.loginId
            //            profile.friendId = self.users[indexPath.row]["fnd_obj"] as! String
            //            profile.userObjId  = self.users[indexPath.row]["user_obj"] as! String
            profile.userObjId =  singelton.loginId
            self.navigationController?.pushViewController(profile, animated: true)
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.view.frame.size.width * 0.5) - 25, height: 200)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.titleLabel.isHidden = true
        filtering = true
        
        delayWithSeconds(0.5) {
            self.filter(text: textField.text!)
        }
        
        return true
    }
    
    
    func filter (text:String) {
        filteredUsers.removeAll()
        
        if (text.characters.count == 0) {
            filteredUsers.append(contentsOf: self.SortedFinalArray)
            self.collectionView.reloadData()
            return;
        }
        // print(self.users.count)
        for numbers in 0..<(self.SortedFinalArray.count){
            // let profileDict = user["profile_detail"] as? [String:Any]
            //  if let profile = profileDict?["profile"] as? [String:Any]{
            //if let username = self.SortedFinalArray[number]
            if let userName = (self.SortedFinalArray[numbers]["firstname"] as? String) {
                if userName.localizedCaseInsensitiveContains(text) {
                    filteredUsers.append(self.SortedFinalArray[numbers])
                }
                else if let userName = self.SortedFinalArray[numbers]["company_name"] as? String {
                    if userName.localizedCaseInsensitiveContains(text) {
                        filteredUsers.append(self.SortedFinalArray[numbers])
                    }
                    
                }
                else if let userName = self.SortedFinalArray[numbers]["email"] as? String {
                    if userName.localizedCaseInsensitiveContains(text) {
                        filteredUsers.append(self.SortedFinalArray[numbers])
                    }
                    
                }
                
            }
            else if let userName = self.SortedFinalArray[numbers]["company_name"] as? String {
                if userName.localizedCaseInsensitiveContains(text) {
                    filteredUsers.append(self.SortedFinalArray[numbers])
                }
                
            }
            
        }
        // }
        self.collectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getUserInnerCircle(){
        
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        
        let parameters = ["user_id":singelton.loginId]
        
        
        DataManager.sharedManager.getInnerCircleUserAdded(params: parameters, completion: { (response) in
            
            
            if let dataDic = response as? [[String:Any]]
            {
                // print(dataDic)
                self.users = dataDic
                // print("users data is \(self.users)")
                // print(self.users.count)
                self.FinalDataArray.removeAll()
                self.SortedFinalArray.removeAll()
                if self.users.count > 0
                {
                    var profile:[String:Any]?
                    var profileDetail : [String:Any]?
                    
                    for number in 0..<(self.users.count){
                        profile = self.users[number]["profile_detail"] as? [String:Any]
                        //  print("DETAILS OF PROFILE",profile)
                        if let profileDict = profile!["profile"]
                        {
                            profileDetail = profileDict as? [String : Any]
                            
                            self.FinalDataArray.append(profileDict as! [String : Any])
                            //      let FirnameKey = self.FinalDataArray!["firstname"] as! String
                            
                            
                            
                            
                        }
                        
                    }
                    // print("DATA VIA",self.FinalDataArray)
                    self.SortedFinalArray = self.FinalDataArray.sorted { ($0["firstname"]! as! String) < ($1["firstname"]! as! String)}
                    
                    // print("----",self.SortedFinalArray)
                    //         profile = self.users[indexPath.row]["profile_detail"] as? [String:Any]
                    self.collectionView.dataSource = self
                    self.collectionView.delegate = self
                    self.collectionView.reloadData()
                }
                    
                else
                {
                    self.collectionView.dataSource = self
                    self.collectionView.delegate = self
                    
                    for v in  self.collectionView.subviews{
                        v.removeFromSuperview()
                    }
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    /*  let alert = UIAlertController(title: "Taste", message:"Data Not Found",preferredStyle: UIAlertControllerStyle.alert)
                     let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                     UIAlertAction in
                     
                     _ = self.navigationController?.popViewController(animated: true)
                     
                     NSLog("OK Pressed")
                     }
                     alert.addAction(okAction)
                     self.present(alert, animated: true, completion: nil)
                     return*/
                    // self.navigationController?.view.makeToast("You have no contacts that can be added in inner circle.", duration: 1.0, position: .center)
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
                    
                    // self.navigationController?.view.makeToast("You have no contacts in your inner circle so far.", duration: 2.0, position: .center)
                    
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
    func removeSubview(){
        print("Start remove sibview")
        if let viewWithTag = self.collectionView.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
    func btnAction(sender: UIButton){
        
        let alert = UIAlertController(title: "Taste", message:"Are you sure you want to delete the user from your inner circle.", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            var inviteID : String = ""
            var inviteName : String = ""
            if (self.filtering)
            {
                
                inviteID = self.filteredUsers[sender.tag]["del_id"] as! String
                let profileDict = self.filteredUsers[sender.tag]["profile_detail"] as? [String:Any]
                //  if let profile = profileDict?["profile"] as? [String:Any]{
                if let userName = self.filteredUsers[sender.tag]["firstname"] as? String {
                    inviteName = userName
                }
                //    }
                
            }
            else
            {
                
                inviteID = self.SortedFinalArray[sender.tag]["del_id"] as! String
                let profileDict = self.users[sender.tag]["profile_detail"] as? [String:Any]
                // if let profile = profileDict?["profile"] as? [String:Any]{
                if let userName = self.SortedFinalArray[sender.tag]["firstname"] as? String {
                    inviteName = userName
                }
            }
            //  }
            
            let parameters = ["user_id": singelton.loginId,"ID":inviteID, "name":inviteName]
            
            //  print(parameters)
            DataManager.sharedManager.getDeleteInnerCircleUser(params: parameters, completion: { (response) in
                
                // print("Response Is,",response)
                if let dataDic = response as? [[String:Any]]
                {
                    // SVProgressHUD.dismiss()
                    self.users = dataDic
                    self.filteredUsers = dataDic
                    
                    
                    if dataDic.count > 0{
                        //  self.FinalDataArray.removeAll()
                        // self.SortedFinalArray.removeAll()
                        self.getUserInnerCircle()
                        // self.collectionView.reloadData()
                    }
                    else
                    {
                        //   self.FinalDataArray.removeAll()
                        //   self.SortedFinalArray.removeAll()
                        self.getUserInnerCircle()
                        //   self.collectionView.reloadData()
                        
                        //                        self.titleLabel.isHidden = false
                        //                        self.titleLabel.text = "You have no contacts in your inner circle so far."
                        //                        self.titleLabel.textAlignment = .center
                        //                        self.titleLabel.numberOfLines = 2
                        //                        self.titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
                        //                        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                        //                        self.view.addSubview(self.titleLabel)
                        //                        self.titleLabel.snp.makeConstraints { (make) in
                        //                            make.left.equalTo(0)
                        //                            make.right.equalTo(0)
                        //                            make.centerX.equalTo(self.view)
                        //                            make.centerY.equalTo(self.view)
                        //                        }
                    }
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    self.checkInternet()
                }
                
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    
                }
                
                
                
            })
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        alert.addAction(NoAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        return
    }
    func checkInternet(){
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
