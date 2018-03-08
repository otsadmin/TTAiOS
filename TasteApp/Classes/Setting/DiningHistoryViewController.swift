//
//  DiningHistoryViewController.swift
//  TasteApp
//
//  Created by Lalit Mohan on 3/9/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import AVFoundation


extension String
{
    func trimString() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}


class DiningHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    // for no data alert
    let titleRecommendation = UILabel()
    let AddToBank = UIButton(type: .custom)
    
    var venue = [[String:Any]]()
    var venue1: [[String: Any]] = [[String: Any]]()
    var cuisineName = [[String:String]]()
    var tableView:UITableView!
    var NextLoad = true
    var size  = 20
    var pageNo = 1
    var strCuisine = ""
    var  TotalRowsWithPages = 20
    var rowsWhichAreChecked = [NSIndexPath]()
    let numberOfPlaces = 2.0
    var  isloading  = true
    var maxRow = 0
    let myNotification = Notification.Name(rawValue:"NotificationDiningUserProfile")
    var isDinningUserProfileScreen:Bool = false
    var isUserProfileScreen:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        self.titleRecommendation.isHidden = true
        AddToBank.isHidden = true
        tableView.isHidden = false
        
        // setUpView()//code commented as its create a 40 records calling twice
        
    }
    
    func goBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
        
        super.viewWillAppear(animated)
        let myNotification = Notification.Name(rawValue:"NotificationDiningUserProfile")
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchDinningNotification)
        self.view.isUserInteractionEnabled = false
       /* let manager = NetworkReachabilityManager(host: "www.google.com")
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            print("network reachable \(manager!.isReachable)")
            
            if manager!.isReachable != true
            {
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
            }
            else
            {
                
                //SVProgressHUD.show()
                if self.isDinningUserProfileScreen{
                    self.isDinningUserProfileScreen =  false
                    self.isUserProfileScreen = false
                    self.view.isUserInteractionEnabled = true
                    print(self.pageNo)
                    
                }
                else{
                    self.loadTableViewData()
                }
                
            }
        }
 
        
        manager?.startListening()
       */
        
        if Reachability.isConnectedToNetwork() == true
        {
            //SVProgressHUD.show()
            if self.isDinningUserProfileScreen{
                self.isDinningUserProfileScreen =  false
                self.isUserProfileScreen = false
                self.view.isUserInteractionEnabled = true
                print(self.pageNo)
                
            }
            else{
                self.loadTableViewData()
            }

            
        }
        else{
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            
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
    // MARK: CATCH NOTIFICATION WHEN NEW NOTIFICATION RECIEVED
    func catchDinningNotification(notification:Notification) -> Void {
        // print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? Bool
            else {
                print("No userInfo  in notification")
                return
        }
        self.isDinningUserProfileScreen = message
        // print("value is ",self.cuisines)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        if self.isUserProfileScreen{
            self.isUserProfileScreen = false
        }
        else{
            self.view.isUserInteractionEnabled = true
            self.venue1.removeAll()
            self.tableView.reloadData()
            self.pageNo = 1
            self.isUserProfileScreen = false
            self.isDinningUserProfileScreen = false
            let nc1 = NotificationCenter.default
            nc1.removeObserver(self, name: myNotification, object: nil)

        }
        super.viewWillDisappear(animated)
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
            make.top.equalTo(42)
        }
        
        
        let crossButton = UIButton(type: .custom)
        self.view.addSubview(crossButton)
        crossButton.addTarget(self, action: #selector(self.jumpToTransactionForm), for: .touchUpInside)
        crossButton.snp.makeConstraints { (make) in
            make.top.equalTo(35)
            make.right.equalTo(-30)
            make.width.equalTo(30)
            make.height.equalTo(30)
           // make.centerY.equalTo(titleLabel.snp.centerY)
        }
        crossButton.setImage(UIImage(named:"ic_add_bigger"), for: .normal)
        
        
        
        let titleSubLabel =  UILabel()
        titleSubLabel.text = "Dining History"
        titleSubLabel.textAlignment = .center
        titleSubLabel.numberOfLines = 2
        titleSubLabel.font = UIFont(name: K_Font_Color_Light, size: 23)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleSubLabel)
        titleSubLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        let alertLabel =  UILabel()
        alertLabel.text = "Transactions may take 2-3 days to appear"
        alertLabel.textAlignment = .center
        alertLabel.numberOfLines = 2
        alertLabel.font = UIFont(name: K_Font_Color_Light, size: 15)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
           // make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
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
        tableView.separatorColor = UIColor.gray
        //tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.view.snp.bottom).offset(-40)
            make.top.equalTo(titleSubLabel.snp.bottom).offset(25)
        }
        tableView.tableFooterView = UIView()
        
        
        self.titleRecommendation.isHidden = false
        self.titleRecommendation.text = "We do not have enough data to show the transactions for you. Please try adding more bank accounts in settings section."
        self.titleRecommendation.textAlignment = .center
        self.titleRecommendation.numberOfLines = 4
        self.titleRecommendation.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(self.titleRecommendation)
        self.titleRecommendation.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(titleSubLabel.snp.bottom).offset(250)
            //                make.centerX.equalTo(self.view)
            //                make.centerY.equalTo(self.view)
        }
        AddToBank.backgroundColor = UIColor.black
        AddToBank.addTarget(self, action: #selector(self.AddAccount), for: .touchUpInside)
        AddToBank.setTitle("ADD ACCOUNT", for: .normal)
        AddToBank.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(AddToBank)
        AddToBank.snp.makeConstraints { (make) in
            //            make.bottom.equalTo(self.view.snp.bottom).offset(-150)
            make.height.equalTo(50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo( self.titleRecommendation.snp.bottom).offset(30)
            //topRecommendationLabel.snp.bottom
        }

        
        
    }
    func AddAccount(_ sender: UIButton) {
        
       
        if Reachability.isConnectedToNetwork() == true
        {
            let vc = BanksListViewController()
            vc.screenName = "bankaccount"
            self.navigationController?.pushViewController(vc, animated: false)
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
    
    // MARK: ADD NEW TRANSACTION MANUALLY
    func jumpToTransactionForm()
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:"TransactionViewController")
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

        
        
    }
    
    // MARK: GET ALL THE TRANSACTION
    func loadTableViewData()
    {
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            delayWithSeconds(1.0)
            {
                
                
                // let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"page":self.pageNo] as [String : Any]
                let singelton = SharedManager.sharedInstance
                
                //  print(singelton.loginId,self.pageNo)
                let parameters = ["user_id":singelton.loginId ,"page":self.pageNo] as [String : Any]
                // print("default user id is \(UserDefaults.standard.string(forKey: "user_id")!) that")
                // print("page no is \(self.pageNo)")
                
                print(parameters)
                DataManager.sharedManager.getDietHistory(params: parameters, completion: { (response) in
                    if let dataDic = response as? [[String:Any]]
                    {
                        self.venue = dataDic  // data load from server in venue array
                        // print(self.venue)
                        
                        if (self.venue.count > 0)
                        {
                            // added by ranjit
                            self.titleRecommendation.isHidden = true
                            self.AddToBank.isHidden = true
                            self.tableView.isHidden = false

                            self.venue1.append(contentsOf: self.venue)
                            self.isloading = false
                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                        }
                            
                        else
                        {
                            
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                            if self.venue1.count <= 0{
                                // added by ranjit
                                self.titleRecommendation.isHidden = false
                                self.AddToBank.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            
                            //                            let alert = UIAlertController(title: "Taste", message:"Data not found",preferredStyle: UIAlertControllerStyle.alert)
                            //                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            //                                UIAlertAction in
                            //                                NSLog("OK Pressed")
                            //                            }
                            //                            alert.addAction(okAction)
                            //                            self.present(alert, animated: true, completion: nil)
                            
                            //return
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
                        //                         self.tableView.reloadData()
                        //                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                    }
                })
            }
            
        }
            
        else
        {
            
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            self.view.isUserInteractionEnabled = true
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
    }//end function
    
    //function to convert date
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return venue1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "diningCell")
        
        self.tableView.separatorColor = UIColor.gray
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let indexpathcount  = indexPath.row
        // print("indexpath count is \(indexpathcount)")
        
        
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont(name: K_Font_Color, size: 18)
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.right.equalTo(-10)
            make.centerY.equalTo(cell.contentView).offset(-10)
            //make.top.equalTo(2)
        }
        
        //textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        textLabel.text =  venue1[indexPath.row]["name"] as? String
        
        let sublabel = UILabel()
        cell.contentView.addSubview(sublabel)
        sublabel.font = UIFont(name: K_Font_Color_Regular, size:15)
        sublabel.textAlignment = .left
        sublabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(textLabel.snp.bottom).offset(2)
            make.right.equalTo(-10)
        }
        let includedExcludedlabel = UILabel()
        cell.contentView.addSubview(includedExcludedlabel)
        includedExcludedlabel.textAlignment = .left
        includedExcludedlabel.font = UIFont(name: K_Font_Color_Regular, size:15)
        includedExcludedlabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(sublabel.snp.bottom).offset(2)
            make.right.equalTo(-10)
        }

        //code commented
        
      /*  let strDate = venue1[indexPath.row]["post_date"] as? String
        //let trimStr = strDate?.trim()
        // print(strDate)
        let name = strDate
        let index = name?.index((name?.startIndex)!, offsetBy:12)
        let substring = name?.substring(to:index!)
 */
        // end of code commented
        
        //  print("substring issss \(substring!)")
        //  print(substring!)
        //        let newdate = substring
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "YYYY-MM-DD"
        //        let date = dateFormatter.date(from:substring! )
        //
        //        dateFormatter.dateFormat = "MMM-DD-YYYY"
        //        let goodDate = dateFormatter.string(from: date!)
        //        let trimmedString = goodDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //        print("Trimmed string is \(trimmedString)")
        
        //        if let array = venue1[indexPath.row]["cuisine"] as? [Any]
        //        {
        //            if let firstObject = array.first
        //            {
        //                strCuisine = firstObject as! String
        //                // access individual object in array
        //                print("first element is \(firstObject)")
        //            }
        //        }
        if let array = venue1[indexPath.row]["cuisine"] as? [Any]
        {
            if array.count > 0{
                if let first = array[0] as? String{
                    strCuisine = first
                }
                else{
                    strCuisine = ""
                }
            }
        }
        else{
            strCuisine = ""
        }
        var substring = ""
        if let strDate = venue1[indexPath.row]["post_date"] as? String{
            substring = strDate
            
        }
        if let quantity = venue1[indexPath.row]["amount"] as? NSNumber
        {
            let tempValue = Double(quantity)
            
            let y = Double(round(1000*tempValue)/1000)
            
            let b:String = String(format:"%.02f", y)
            
            
         //   sublabel.text = String(format:"%@ $%@ %@",substring!,b,strCuisine)
            if substring.characters.count > 0{
                sublabel.text = String(format:"%@ $%@ %@",substring,b,strCuisine)
            }
            else{
                sublabel.text = String(format:"$%@ %@",b,strCuisine)
            }
            
        }
        else if let quantity = venue1[indexPath.row]["amount"] as? String
            
        {
            let tampValue = Double(quantity)
            
            let y = Double(round(1000*tampValue!)/1000)
            
            let b:String = String(format:"%.02f", y)
            
           // sublabel.text = String(format:"%@ $%@ %@",substring!,b,strCuisine)
            if substring.characters.count > 0{
                sublabel.text = String(format:"%@ $%@ %@",substring,b,strCuisine)
            }
            else{
                sublabel.text = String(format:"$%@ %@",b,strCuisine) 
            }
            
        }
        
        
        
        let isDietSelected = venue1[indexPath.row]["add_to_dinning_history"] as! String
        
        if isDietSelected == "yes"
        {
            
            //            let checkImage = UIImage(named: "account_delete")
            //            let checkmark = UIImageView(image: checkImage)
            //            cell.accessoryView = checkmark
            let cellAudioButton = UIButton(type: .custom)
            cellAudioButton.frame = CGRect(x: 0, y: 0, width: 38.5, height: 38.5)
            cellAudioButton.addTarget(self, action: #selector(DiningHistoryViewController.accessoryButtonTapped(sender:)), for: .touchUpInside)
            cellAudioButton.setImage(UIImage(named: "ic_add"), for: .normal)
            cellAudioButton.contentMode = .scaleAspectFit
            cellAudioButton.tag = indexPath.row
            cell.accessoryView = cellAudioButton as UIView
            includedExcludedlabel.textColor = UIColor(red: 84/255.0, green: 174/255.0, blue: 81/255.0, alpha: 1.0)            
            includedExcludedlabel.text = "(Included in Profile)"
            
        }
        else
        {
            
            //            let checkImage = UIImage(named: "ic_add")
            //            let checkmark = UIImageView(image: checkImage)
            //            cell.accessoryView = checkmark
            let cellAudioButton = UIButton(type: .custom)
            cellAudioButton.frame = CGRect(x: 0, y: 0, width: 38.5, height: 38.5)
            cellAudioButton.addTarget(self, action: #selector(DiningHistoryViewController.accessoryButtonTapped(sender:)), for: .touchUpInside)
            cellAudioButton.setImage(UIImage(named: "ic_addExcluded"), for: .normal)
            cellAudioButton.contentMode = .scaleAspectFit
            cellAudioButton.tag = indexPath.row
            cell.accessoryView = cellAudioButton as UIView
             includedExcludedlabel.textColor = UIColor.red
            includedExcludedlabel.text = "(Excluded from Profile)"
            
            
        }
        return cell
    }
    func accessoryButtonTapped(sender : UIButton){
        // print(sender.tag)
        if Reachability.isConnectedToNetwork() == true
        {
        self.view.isUserInteractionEnabled = false
        let location = self.tableView.convert(sender.bounds.origin, from: sender)
        let indexPath = self.tableView.indexPathForRow(at: location)
        let cell = self.tableView.cellForRow(at: indexPath!) as UITableViewCell!
        
        let isDietSelected = venue1[sender.tag]["add_to_dinning_history"] as! String
        
        if isDietSelected == "no"
            
        {
             SVProgressHUD.show()
            let diet_id = self.venue1[sender.tag]["_id"] as? String
            // print("diet_id is that \(diet_id)")
            let serverUIrl = K_DININGHISTORY_URL
            let parameter = ["ID":diet_id!,"option": "yes"]
            //  print("paramter is \(parameter)")
            Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                switch(response.result)
                {
                case.success(_):
                    if let  JSON = response.result.value
                    {
                        // print(JSON)
                        
                        let responseData = JSON as! NSDictionary
                        
                        if responseData.object(forKey: "status") as! String == "success"
                        {
                            SVProgressHUD.dismiss()
                            let checkImage = UIImage(named: "ic_addExcluded")
                            sender.setImage(checkImage, for: .normal)
                            cell?.accessoryView = sender
                            self.rowsWhichAreChecked.append(indexPath! as NSIndexPath)
                            self.venue1[sender.tag]["add_to_dinning_history"] = "yes"
                            self.tableView.reloadRows(at: [indexPath!], with: .fade)
                            let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            self.view.isUserInteractionEnabled = true
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
                            
                            self.view.isUserInteractionEnabled = true
                        }
                        
                    }
                        
                    else
                    {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        // print(response)
                    }
                    break
                case.failure(_):
                    SVProgressHUD.dismiss()
                    // print(response.result.error)
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
                       
                    }
                    else{
                        let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    break
                }
            }
        }
            
        else
        {
            
            let refreshAlert = UIAlertController(title: "Taste", message: "Do you want to remove this Transaction.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
              //  print("Handle Ok logic here")
                SVProgressHUD.show()
                let diet_id = self.venue1[sender.tag]["_id"] as? String
                
                //  print("diet_id is that \(diet_id)")
                let serverUIrl = K_DININGHISTORY_URL
                let parameter = ["ID":diet_id!,"option": "no"]
                // print("paramter is \(parameter)")
                Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                    switch(response.result)
                    {
                    case.success(_):
                        if let  JSON = response.result.value
                        {
                            // print(JSON)
                            
                            let responseData = JSON as! NSDictionary
                            
                            if responseData.object(forKey: "status") as! String == "success"
                            {
                                SVProgressHUD.dismiss()
                                self.venue1[sender.tag]["add_to_dinning_history"] = "no"
                                let checkImage = UIImage(named: "ic_add")
                                sender.setImage(checkImage, for: .normal)
                                cell?.accessoryView = sender
                                self.rowsWhichAreChecked.append(indexPath! as NSIndexPath)
                                 self.tableView.reloadRows(at: [indexPath!], with: .fade)
                                let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    NSLog("OK Pressed")
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                                self.view.isUserInteractionEnabled = true
                                
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
                                self.view.isUserInteractionEnabled = true
                            }
                            
                        }
                            
                        else
                        {
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                            // print(response)
                        }
                        break
                    case.failure(_):
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
                            
                        }
                        else{
                            let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }

                        //print(response.result.error)
                        break
                    }
                }
                if let checkedItemIndex = self.rowsWhichAreChecked.index(of: indexPath! as NSIndexPath)
                {
                    self.rowsWhichAreChecked.remove(at: checkedItemIndex)
                    
                }

                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                
               // print("Handle Cancel Logic here")
                //SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
            }))
            
            present(refreshAlert, animated: true, completion: nil)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        SVProgressHUD.show()
       self.isUserProfileScreen = true

        self.view.isUserInteractionEnabled = false

        let location : [String:Any]?
        location = self.venue1[indexPath.row]["location"] as? [String:Any]
        
        if let locAddress=(location?["address"] as? String){
            K_INNERUSER_DATA.Address=locAddress
        }
        else{
            K_INNERUSER_DATA.Address=""
        }
        if let locCity=(location?["city"] as? String){
            K_INNERUSER_DATA.CITY=locCity
        }
        else{
            K_INNERUSER_DATA.CITY=""
        }
        if let locState=(location?["state"] as? String){
            K_INNERUSER_DATA.State=locState
        }
        else{
            K_INNERUSER_DATA.State=""
        }
        
        if let locCountry=(location?["country"] as? String){
            K_INNERUSER_DATA.Country=locCountry
        }
        else{
            K_INNERUSER_DATA.Country=""
        }
        
        if let locZip=(location?["zip"] as? NSNumber){
            K_INNERUSER_DATA.ZIP = locZip.stringValue
        }
        else{
            K_INNERUSER_DATA.ZIP=""
        }
        
        if let locTel = self.venue1[indexPath.row]["tel"] as? String{
            K_INNERUSER_DATA.Phone = locTel
        }
        else{
            K_INNERUSER_DATA.Phone=""
        }
        
        if let locWebsite = self.venue1[indexPath.row]["website"] as?String{
            K_INNERUSER_DATA.Website = locWebsite
        }
        else{
            K_INNERUSER_DATA.Website=""
        }
        
        if let hours = self.venue1[indexPath.row]["hours_display"] as? String{
            K_INNERUSER_DATA.Hours = hours
        }
        else{
            K_INNERUSER_DATA.Hours = ""
        }
        
        if let factual_id = self.venue1[indexPath.row]["factual_id"] as? String{
            K_INNERUSER_DATA.FactualId = factual_id
        }
        else{
            K_INNERUSER_DATA.FactualId = ""
        }
        if let price = self.venue1[indexPath.row]["price"] as? NSNumber
        {
            K_INNERUSER_DATA.Price = String(format:"%@",price)
        }
        
        if let rating = self.venue1[indexPath.row]["rating"] as? NSNumber
        {
            
            K_INNERUSER_DATA.Rating = String(format:"%@",rating)
        }
        print( K_INNERUSER_DATA.Rating)
        if let array = self.venue1[indexPath.row]["cuisine"] as? [Any]
        {
            if array.count > 0{
                if let first = array[0] as? String{
                    strCuisine = first
                }
                else{
                    strCuisine = ""
                }
            }
        }
        else{
            strCuisine = ""
        }
        K_INNERUSER_DATA.CuisinSeleted =  strCuisine
        
        if let resName =   venue1[indexPath.row]["name"] as? String{
            K_INNERUSER_DATA.RestaurantName = resName
        }
        else{
            K_INNERUSER_DATA.RestaurantName = ""
        }
        var coordinate : [String:Any]?
        coordinate = self.venue1[indexPath.row]["coordinates"] as? [String:Any]
        
        if let currentlat=(coordinate?["lat"] as? Double){
            K_INNERUSER_DATA.latvalueNavigate = currentlat
        }else{
            K_INNERUSER_DATA.latvalueNavigate = 0.0
        }
        
        if let currentlon=(coordinate?["lon"] as? Double){
            K_INNERUSER_DATA.longvalueNavigate = currentlon
        }else{
            K_INNERUSER_DATA.longvalueNavigate = 0.0
        }
        self.countGoogleApiHit(index: 0)
        
        
        K_INNERUSER_DATA.placeId = ""
        K_INNERUSER_DATA.Photo_Ref = ""
        
    }
    func countGoogleApiHit(index:Int){
        
        let lat_long = "\(K_INNERUSER_DATA.latvalueNavigate),\( K_INNERUSER_DATA.longvalueNavigate)"
        
        let address =  K_INNERUSER_DATA.RestaurantName + "," +  K_INNERUSER_DATA.Address + "," +   K_INNERUSER_DATA.CITY + "," +   K_INNERUSER_DATA.State + "," + K_INNERUSER_DATA.Country
        let paramString = ["query":address, "location": lat_long, "radius":"500", "type": "restaurant","keyword":"cruise","key":GOOGLE_APIKEY] as [String : Any]
        
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=100&key=\(GOOGLE_APIKEY)"
        let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        
        // print("-------Print Request Url",UrlTrimString)
        
        DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
            if let dataDic = response as? [String:Any]
            {
                
                //  print("Respomse", dataDic)
                
                //         for ResponseCount in responce{
                
                
                if let dataResponce = (response as AnyObject).object(forKey: "results"){
                    
                    let resultArray = dataResponce as! NSArray
                    
                    
                    
                    if resultArray.count > 0 {
                        let arrayDict = resultArray[0] as! NSDictionary
                        var NameOfRest = ""
                        if let Rest_name = arrayDict.object(forKey: "name"){
                            NameOfRest = Rest_name as! String
                            // print("Rest Name is", NameOfRest)
                        }
                        
                        if let photosDict = arrayDict.object(forKey: "photos"){
                            
                            let photosArray = photosDict as! NSArray
                            print(photosArray.count)
                            if  let placeId = arrayDict.object(forKey: "place_id") as? String{
                                K_INNERUSER_DATA.placeId = placeId
                            }
                            else{
                                K_INNERUSER_DATA.placeId = ""
                            }
                            // print("place id is---",placeId)
                            
                            
                            if photosArray.count > 0 {
                                
                                let photoDict = photosArray[0] as! NSDictionary
                                
                                
                                
                                if let photo_reference = photoDict.object(forKey: "photo_reference"){
                                    
                                    
                                    let PhotoRef = photo_reference as! String
                                    //   K_GoogleImagesData.ImagesDataArray.append(PhotoRef)
                                    
                                    
                                    // call this after you update
                                    
                                    
                                    //  print("PhotoRef : \(PhotoRef)")
                                    let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(PhotoRef)&key=\(GOOGLE_APIKEY)")!
                                    K_INNERUSER_DATA.Photo_Ref = String(describing: url)
                                    print(K_INNERUSER_DATA.Photo_Ref )
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    // print("index is",self.self.selectedProfileIndex,cuisineDetail.photo_ref)
                                    
                                    
                                }
                            }
                            else{
                                K_INNERUSER_DATA.Photo_Ref = ""
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        else{
                            
                            //  print("Key Expaire");
                            K_INNERUSER_DATA.Photo_Ref = ""
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            
                        }
                    }
                    else{
                        
                        //  print("Key Expaire");
                        K_INNERUSER_DATA.Photo_Ref = ""
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    
                }
                else{
                    K_INNERUSER_DATA.Photo_Ref = ""
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }
            else
            {
                 SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                self.isUserProfileScreen = false
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
            
        })
        
        
        
    }
    
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
     SVProgressHUD.show()
     self.view.isUserInteractionEnabled = false
     let cell = self.tableView.cellForRow(at: indexPath) as UITableViewCell!
     
     
     let isDietSelected = venue1[indexPath.row]["add_to_dinning_history"] as! String
     
     
     if isDietSelected == "no"
     
     {
     let checkImage = UIImage(named: "account_delete")
     let checkmark = UIImageView(image: checkImage)
     cell?.accessoryView = checkmark
     rowsWhichAreChecked.append(indexPath as NSIndexPath)
     let diet_id = self.venue1[indexPath.row]["_id"] as? String
     
     //  print("diet_id is that \(diet_id)")
     let serverUIrl = K_DININGHISTORY_URL
     let parameter = ["ID":diet_id!,"option": "yes"]
     //  print("paramter is \(parameter)")
     Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
     switch(response.result)
     {
     case.success(_):
     if let  JSON = response.result.value
     {
     // print(JSON)
     
     let responseData = JSON as! NSDictionary
     
     if responseData.object(forKey: "status") as! String == "success"
     {
     SVProgressHUD.dismiss()
     
     self.venue1[indexPath.row]["add_to_dinning_history"] = "yes"
     
     let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
     let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
     UIAlertAction in
     NSLog("OK Pressed")
     }
     alert.addAction(okAction)
     self.present(alert, animated: true, completion: nil)
     self.view.isUserInteractionEnabled = true
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
     
     self.view.isUserInteractionEnabled = true
     }
     
     }
     
     else
     {
     SVProgressHUD.dismiss()
     self.view.isUserInteractionEnabled = true
     // print(response)
     }
     break
     case.failure(_):
     SVProgressHUD.dismiss()
     // print(response.result.error)
     self.view.isUserInteractionEnabled = true
     break
     }
     }
     }
     
     else
     {
     let checkImage = UIImage(named: "ic_add")
     let checkmark = UIImageView(image: checkImage)
     cell?.accessoryView = checkmark
     //rowsWhichAreChecked.append(indexPath as NSIndexPath)
     let diet_id = self.venue1[indexPath.row]["_id"] as? String
     
     // print("diet_id is that \(diet_id)")
     let serverUIrl = K_DININGHISTORY_URL
     let parameter = ["ID":diet_id!,"option": "no"]
     // print("paramter is \(parameter)")
     Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
     switch(response.result)
     {
     case.success(_):
     if let  JSON = response.result.value
     {
     // print(JSON)
     
     let responseData = JSON as! NSDictionary
     
     if responseData.object(forKey: "status") as! String == "success"
     {
     SVProgressHUD.dismiss()
     self.view.isUserInteractionEnabled = true
     self.venue1[indexPath.row]["add_to_dinning_history"] = "no"
     
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
     self.view.isUserInteractionEnabled = true
     }
     
     }
     
     else
     {
     SVProgressHUD.dismiss()
     self.view.isUserInteractionEnabled = true
     // print(response)
     }
     break
     case.failure(_):
     SVProgressHUD.dismiss()
     self.view.isUserInteractionEnabled = true
     //  print(response.result.error)
     break
     }
     }
     if let checkedItemIndex = rowsWhichAreChecked.index(of: indexPath as NSIndexPath)
     {
     rowsWhichAreChecked.remove(at: checkedItemIndex)
     
     }
     
     }
     }
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell , forRowAt indexPath: IndexPath)
    {
        
        if !(indexPath.row + 1 < self.venue1.count) && isloading == false
        {
            if Reachability.isConnectedToNetwork() == true
            {
                isloading = true
                pageNo = pageNo + 1
                if self.venue1.count >= 20{
                    self.loadTableViewData()
                }
                
            }
            else{
                
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
        //  print("indexpath for the last call is \(indexPath.row)")
        
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
