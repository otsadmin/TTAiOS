//
//  RInnerCircleAddedUserProfileVc.swift
//  Taste
//
//  Created by Ranjit Singh on 04/11/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import PieCharts


class RInnerCircleAddedUserProfileVc: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,PieChartDelegate{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var pieChartCollectionView: UICollectionView!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var friendId : String = ""
    var userObjId : String = ""
    var cuisinePercentageValue:NSArray = NSArray()
    var cityPercentageValue:NSArray = NSArray()
    var cuisineNameValue:NSArray = NSArray()
    var cityNameValue:NSArray = NSArray()
    
    var userProfile = [[String:Any]]()
    var cuisines = [[String:Any]]()
    var cities = [[String:Any]]()
    var graphDataDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getGraphData()
        self.setupView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView() {
        
        
        
        self.view.backgroundColor = UIColor.white
        delayWithSeconds(1.0)
        {
            SVProgressHUD.show()
            
            // let parameter = ["userid":UserDefaults.standard.string(forKey: "user_id")!,"stranger_id": self.friendId as String ]
            //let singelton = SharedManager.sharedInstance
            // singelton.loginId = K_CURRENT_USER.login_Id
            let parameter = ["user_id":self.userObjId,"friend_id": self.friendId as String ]
           // print(self.friendId,parameter)
            DataManager.sharedManager.getInnerCircleUserAddedProfile(params: parameter, completion: { (response) in
                
                if let dataDic = response as? [String:Any]
                    
                {
                  //  print(dataDic)
                    
                    if let profilearr = dataDic["profile"] as? [[String:Any]]
                    {
                        self.userProfile = profilearr
                       // print(self.userProfile.count)
                        
                        
                        if self.userProfile.count > 0 {
                            let positionOb = self.userProfile[0]
                          //  print(positionOb)
                            if let companyDict = positionOb["profile"] as? [String:Any]
                            {
                               // print(companyDict)
                                K_INNERUSER_PROFILE.name = companyDict["firstname"] as! String
                                K_INNERUSER_PROFILE.lastname = companyDict["lastname"] as! String
                                K_INNERUSER_PROFILE.company = companyDict["company_name"] as! String
                                if  let imageUrl = companyDict["image"] as? String{
                                    if imageUrl.characters.count > 0{
                                        K_INNERUSER_PROFILE.image_url = K_IMAGE_BASE_URL + imageUrl
                                        
                                    }
                                    else
                                    {
                                        K_INNERUSER_PROFILE.image_url = ""
                                        
                                    }
                                }
                                else
                                {
                                    K_INNERUSER_PROFILE.image_url = ""
                                    
                                }
                                // K_INNERUSER_PROFILE.image_url = companyDict["image"] as! String
                                
                              //  print("user name is \( K_INNERUSER_PROFILE.name) and company is \(K_INNERUSER_PROFILE.company) and image url is \(K_INNERUSER_PROFILE.image_url)")
                                
                                
                            }
                            
                        }
                        else{
                            K_INNERUSER_PROFILE.name = ""
                            K_INNERUSER_PROFILE.lastname = ""
                            K_INNERUSER_PROFILE.company = ""
                            K_INNERUSER_PROFILE.image_url = ""
                        }
                    }
                    else{
                        K_INNERUSER_PROFILE.name = ""
                        K_INNERUSER_PROFILE.lastname = ""
                        K_INNERUSER_PROFILE.company = ""
                        K_INNERUSER_PROFILE.image_url = ""
                    }
                    if let cuisineArr = dataDic["top_cuisine"] as? [[String:Any]] {
                        self.cuisines = cuisineArr
                        
                    }
                    if let citiesArr = dataDic["top_cities"] as? [[String:Any]] {
                        self.cities = citiesArr
                    }
                    
                }
                else{
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
                    
                    
                    self.loadDataNew()
                    
                    SVProgressHUD.dismiss()
                }
            })
        }
    }//clase setup
    
    override func viewWillAppear(_ animated: Bool) {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.checkForNotification = "RInnerCircleAddedUserProfileVc"
      //  print(self.friendId)
        if Reachability.isConnectedToNetwork() == true
        {
            
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
    
   func loadDataNew()->Void {

    
    profileImageView.backgroundColor = UIColor.gray
    profileImageView.layer.cornerRadius = 60
    profileImageView.clipsToBounds = true
    
    
    
    if K_INNERUSER_PROFILE.image_url.characters.count > 0 {
    
    profileImageView.sd_setImage(with: URL(string: K_INNERUSER_PROFILE.image_url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
    
    //  imageView.kf.setImage(with: URL(string:K_INNERUSER_PROFILE.image_url))
    }
    
    else
    {
    //            let strImage = "https://pbs.twimg.com/profile_images/621727263969558528/lZY2QPTF_200x200.jpg"
    //
    //            imageView.kf.setImage(with: URL(string:strImage))
    
    // imageView.image = UIImage(named: "profile")
    profileImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
    }
    
    

    nameLabel.text =  ""
    
    if K_INNERUSER_PROFILE.name.count > 0
    {
    nameLabel.text  = K_INNERUSER_PROFILE.name
    
    }
    
    nameLabel.font = UIFont(name:  K_Font_Color, size: 26)
    

    companyLabel.text = ""
    if K_INNERUSER_PROFILE.company.count > 0
    {
    companyLabel.text  = K_INNERUSER_PROFILE.company
    
    }
    companyLabel.font = UIFont(name:  K_Font_Color, size: 13)
    
//    let otherSubLabel = UILabel()
//    upperProfileView.addSubview(otherSubLabel)
//    otherSubLabel.snp.makeConstraints { (make) in
//    make.left.equalTo(imageView.snp.right).offset(15)
//    make.top.equalTo(subLabel.snp.bottom).offset(5)
//    }
//    otherSubLabel.text = ""
//    otherSubLabel.font = UIFont(name:  K_Font_Color, size: 13)
//    if screenName == "Invite"{
//    let button = UIButton(type: .custom)
//    button.backgroundColor = UIColor.black
//    button.setTitle("INVITE TO INNER CIRCLE", for: .normal)
//    self.view.addSubview(button)
//    button.snp.makeConstraints { (make) in
//    make.bottom.equalTo(-64)
//    make.height.equalTo(52)
//    make.left.equalTo(10)
//    make.right.equalTo(-10)
//    }
//    button.addTarget(self, action: #selector(self.continueTapped), for: .touchUpInside)
//    
//          }
    
    }
    
    // TODO:COLLECTION VIEW DATA SOURCE METHODS

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 2
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RPieChartCollectionViewCell", for: indexPath) as! RPieChartCollectionViewCell
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        cell.frame.size.width = UIScreen.main.bounds.width
        cell.frame.size.height = collectionView.frame.size.height
        //cell.frame.origin.x = collectionView.frame.origin.x
       // cell.frame.origin.y = collectionView.frame.origin.y
        cell.viewAllButton.tag = indexPath.row
        cell.viewAllButton.addTarget(self, action:#selector(viewAllButtonPressed(_:)), for: .touchUpInside)
        
        cell.button1.tag = indexPath.row
        cell.button1.addTarget(self, action:#selector(view1ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button2.tag = indexPath.row
        cell.button2.addTarget(self, action:#selector(view2ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button3.tag = indexPath.row
        cell.button3.addTarget(self, action:#selector(view3ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button4.tag = indexPath.row
        cell.button4.addTarget(self, action:#selector(view4ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button5.tag = indexPath.row
        cell.button5.addTarget(self, action:#selector(view5ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button6.tag = indexPath.row
        cell.button6.addTarget(self, action:#selector(view6ButtonPressed(_:)), for: .touchUpInside)
        
        
        // auto shrink label
        
      //  print(graphDataDict)
        if indexPath.item == 0 {
            
            cell.topCuisinesLbl.text = "Top Cuisines"
            
            if let cuisineValue:NSArray = graphDataDict["cuisines"] as? NSArray{
               // print(cuisineValue)
                cuisinePercentageValue = cuisineValue.value(forKey: "percentage") as! NSArray
                cuisineNameValue = cuisineValue.value(forKey: "_id") as! NSArray
                
                cell.chartView.layers = [createCustomViewsLayer(), createTextLayer()]
                cell.chartView.delegate = self
                cell.chartView.models = self.createModels(nameArr:cuisineNameValue,percentageArr:cuisinePercentageValue)
                
                if cuisinePercentageValue.count == 0 {
                    
                    cell.view1.isHidden = true
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = true
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = true
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                }
                else if cuisinePercentageValue.count == 1 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                }
                else if cuisinePercentageValue.count == 2 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                }
                else if cuisinePercentageValue.count == 3 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                }
                else if cuisinePercentageValue.count == 4 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                    cell.label4.text = cuisineNameValue[3] as? String
                }
                else if cuisinePercentageValue.count == 5 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                    cell.label4.text = cuisineNameValue[3] as? String
                    cell.label5.text = cuisineNameValue[4] as? String
                }
                else if cuisinePercentageValue.count == 6 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = false
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = false
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = false
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                    cell.label4.text = cuisineNameValue[3] as? String
                    cell.label5.text = cuisineNameValue[4] as? String
                    cell.label6.text = cuisineNameValue[5] as? String
                }
                
            }
            return cell
        }
        else{
            
            cell.topCuisinesLbl.text = "Top Cities"
            if let cuisineValue:NSArray = graphDataDict["cities"] as? NSArray{
              //  print(cuisineValue)
                cityPercentageValue = cuisineValue.value(forKey: "percentage") as! NSArray
                cityNameValue = cuisineValue.value(forKey: "_id") as! NSArray
                
                cell.chartView.layers = [createCustomViewsLayer(), createTextLayer()]
                cell.chartView.delegate = self
                cell.chartView.models = self.createModels(nameArr:cityNameValue,percentageArr:cityPercentageValue)
                
                if cityPercentageValue.count == 0 {
                    
                    cell.view1.isHidden = true
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = true
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = true
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                }
                else if cityPercentageValue.count == 1 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                }
                else if cityPercentageValue.count == 2 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                }
                else if cityPercentageValue.count == 3 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                }
                else if cityPercentageValue.count == 4 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                    cell.label4.text = cityNameValue[3] as? String
                }
                else if cityPercentageValue.count == 5 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                    cell.label4.text = cityNameValue[3] as? String
                    cell.label5.text = cityNameValue[4] as? String
                }
                else if cityPercentageValue.count == 6 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = false
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = false
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = false
                    
                    //cell.label1.text = "Middle Eastern/Mediterranean"
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                    cell.label4.text = cityNameValue[3] as? String
                    cell.label5.text = cityNameValue[4] as? String
                    cell.label6.text = cityNameValue[5] as? String
                }
                
                
            }
            return cell
        }
    }
    func onSelected(slice: PieSlice, selected: Bool) {
       // print("Selected: \(selected), slice: \(slice)")
        let  arrayOfVisibleCell  = pieChartCollectionView.indexPathsForVisibleItems
       // print(arrayOfVisibleCell[0][1])
        
        if arrayOfVisibleCell[0][1] == 0{
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! ProfileCuisineFilterViewController
            
            let vc = ProfileCuisineFilterViewController()
           // vc.arrNotification = self.arrNotification
            // pas data to fetch data
            vc.filterName = "cuisines"
            
            if slice.data.id  != 5{
                vc.cuisineName = cuisineNameValue[slice.data.id] as! String
            }
            else{
                vc.cuisineName = "others"
            }
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
            
            let vc = ProfileCuisineFilterViewController()
           // vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            vc.filterName = "cities"
            
            if slice.data.id  != 5{
                vc.cuisineName = cityNameValue[slice.data.id] as! String
            }
            else{
                vc.cuisineName = "others"
            }
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RViewAllVc") as! RViewAllVc
        //        vc.arrNotification = self.arrNotification
        //            vc.screenName = "cuisines"
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        //
        //        print()
        //        let alert = UIAlertController(title: "selected Index is", message:"\(slice.data.id)", preferredStyle: UIAlertControllerStyle.alert)
        //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //            UIAlertAction in
        //            NSLog("OK Pressed")
        //        }
        //        alert.addAction(okAction)
        //        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Models
    
    fileprivate func createModels(nameArr:NSArray,percentageArr:NSArray) -> [PieSliceModel] {
        if percentageArr.count == 1{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 2{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 3{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 4{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[3] as! Double, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 5{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[3] as! Double, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[4] as! Double, color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0)),
            ]
        }
        else if percentageArr.count == 6{
            
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red: 99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[3] as! Double, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[4] as! Double, color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[5] as! Double, color: UIColor(red: 101.0/255.0, green: 137.0/255.0, blue: 159.0/255.0, alpha: 1.0)),
            ]
        }
        else{
            return [
                PieSliceModel(value: 0, color: UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)),
            ]
            
            
        }

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = pieChartCollectionView.frame.size.width
        pageControl.currentPage = Int(pieChartCollectionView.contentOffset.x / pageWidth)
        pageControl.updateCurrentPageDisplay()
        
        // change the header label
        //        var visibleRect = CGRect()
        //        visibleRect.origin = collectionView.contentOffset
        //        visibleRect.size = collectionView.bounds.size
        //        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        //        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        //        print(visibleIndexPath[1])
        //        if visibleIndexPath[1] == 0 {
        //            topCuisinesLbl.text = "Top Cuisines"
        //        }
        //        else{
        //            topCuisinesLbl.text = "Top Cities"
        //        }
    }
    // MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 100
        settings.hideOnOverflow = true
        viewLayer.settings = settings
        
        // comment to stop the showing images
        
        //  viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 70
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            
            if slice.data.id == 3 || slice.data.id == 0 {
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                    specialTextLabel.text = "views"
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.text = "Custom"
                }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 10, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            }
            
            
            //  src of images: www.freepik.com, http://www.flaticon.com/authors/madebyoliver
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "fish"
                case 1: return "grapes"
                case 2: return "doughnut"
                case 3: return "water"
                case 4: return "chicken"
                case 5: return "beet"
                case 6: return "cheese"
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            
            return container
        }
    }
    
    func view1ButtonPressed(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
//        //vc.arrNotification = self.arrNotification
//        if sender.tag == 0{
//            vc.screenName = "cuisines"
//        }
//        else{
//            vc.screenName = "cities"
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[0] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[0] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view2ButtonPressed(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
//        //vc.arrNotification = self.arrNotification
//        if sender.tag == 0{
//            vc.screenName = "cuisines"
//        }
//        else{
//            vc.screenName = "cities"
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[1] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[1] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view3ButtonPressed(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
//        //vc.arrNotification = self.arrNotification
//        if sender.tag == 0{
//            vc.screenName = "cuisines"
//        }
//        else{
//            vc.screenName = "cities"
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[2] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[2] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view4ButtonPressed(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
//       // vc.arrNotification = self.arrNotification
//        if sender.tag == 0{
//            vc.screenName = "cuisines"
//        }
//        else{
//            vc.screenName = "cities"
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[3] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[3] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view5ButtonPressed(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
//       // vc.arrNotification = self.arrNotification
//        if sender.tag == 0{
//            vc.screenName = "cuisines"
//        }
//        else{
//            vc.screenName = "cities"
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[4] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[4] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
             vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view6ButtonPressed(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
//        //vc.arrNotification = self.arrNotification
//        if sender.tag == 0{
//            vc.screenName = "cuisines"
//        }
//        else{
//            vc.screenName = "cities"
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = "others"
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            // pas data to fetch data
            
            vc.cuisineName = "others"
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.friendId = self.friendId
            vc.screenName = "RInnerCircle"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func viewAllButtonPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RViewAllVc") as! RViewAllVc
        //vc.arrNotification = self.arrNotification
        if sender.tag == 0{
            vc.screenName = "cuisines"
        }
        else{
            vc.screenName = "cities"
        }
        vc.providedId = self.friendId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //TODO: GET GRAPH DATA
    
    func getGraphData() -> Void {
        if Reachability.isConnectedToNetwork() == true{
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
           // let singelton = SharedManager.sharedInstance
            
            //please give suggestion here for entry cuisine 0r city
            
            let parameter = [ "user_id":self.friendId] as [String : Any]
            
            DataManager.sharedManager.getGraphData(params: parameter, completion: { (response) in
                if let dataDic = response as? [String :Any]
                {
                    SVProgressHUD.dismiss()
                 //   print("the graph data is \(dataDic)")
                    self.graphDataDict = dataDic
                    self.pieChartCollectionView.isHidden = false
                    self.pieChartCollectionView.reloadData()
                    self.view.isUserInteractionEnabled = true
                    if self.graphDataDict["cuisines"] is Bool{
                        
                        self.hideAndShowDependOnData(show: false)
                    }else{
                        self.hideAndShowDependOnData(show: true)
                    }
                    
                    
                    //                    pieChartCell.collectionView.isHidden = false
                    //                    pieChartCell.collectionView.reloadData()
                }
                else{
                    SVProgressHUD.dismiss()
                    self.pieChartCollectionView.isHidden = true
                    self.view.isUserInteractionEnabled = true
                }
            }
            )}
        else{
            
            pieChartCollectionView.isHidden = true
        }
        
    }
    

    @IBAction func notificationBtnPressed(_ sender: Any) {
    }

    @IBAction func backBtnPressed(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    func hideAndShowDependOnData(show:Bool) -> Void {
        if show{
            self.pieChartCollectionView.isHidden = false
            self.pageControl.isHidden = false
        }
        else{
            self.pieChartCollectionView.isHidden = true
            self.pageControl.isHidden = true
        }
    }
}
