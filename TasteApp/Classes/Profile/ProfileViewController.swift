//
//  ProfileViewController.swift
//  TasteApp
//
//  Created by Shubhank on 20/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import MapKit
import AddressBook
import SVProgressHUD
import GoogleMaps
import Firebase
import Mixpanel
extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
}

class ProfileViewController: UIViewController,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    // added for drop down
    let topRecommendationLabel = UILabel()
    let mapButton1 = UIButton(type: .custom)
    let mapButton = UIButton(type: .custom)
    
    let myNotification = Notification.Name(rawValue:"NotificationRecommendation")
    var locationManager:CLLocationManager?
    var locationLabel:UILabel!
    var underline:UILabel!
    var isDropDowntableShown:Bool = false
    let dropDownTextView = UILabel()
    let dropDownImageView = UIImageView()
    
    var filteredArrayOfBoth = [[String:Any]]()
    var imageURlString : String = ""
    var imageURlStringCrap : String = ""
    let tableView = UITableView()
    let dropDownTableView = UITableView()
    let dropDownbutton = UIButton()
    var dropDownList =  [Any]()
    let notifButton = UIButton(type: .custom)
    var cuisines = [[String:Any]]()
    var cuisinesFilter = [[String:Any]]()
    var restaurants = [[String:Any]]()
    var latValue : Double = 0.0
    var longValue : Double = 0.0
    var mapView:GMSMapView!
    var mapWrapperView:UIView!
    var whiteBarView:UIView!
    var latValueRestaurant : Double = 0.0
    var longValueRestaurant : Double = 0.0
    var nameRestaurant:String = ""
    var addressString = ""
    var cityString = ""
    var stateString = ""
    var countryString = ""
    var annotationArray = [[String:Any]]()
    var PhotoRefArray = [[String:Any]]()
    var annotationGetImagesArray = [[String:Any]]()
    var ProfileImagesArray = [ProfileImages]()
    let designationLabel = UILabel()
    let CompanyLabel = UILabel()
    let nameLabel = UILabel()
    
    var selectedProfileIndex = 0
    var selectedRestaurantIndex = 0
    var cuisineArray = [ProfileCuisineFilter]()
    var cuisineIndex =  [AnyObject]()
    var arrNotification =  [[String:Any]]()
    let titleLabel = UILabel()
    let titleRecommendation = UILabel()
    let AddToBank = UIButton(type: .custom)
    var AnnotationArraymapData = [ProfileCuisineFilter]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        self.titleRecommendation.isHidden = true
        AddToBank.isHidden = true
        dropDownList = ["0.5","1","2","5","10"]
        // print("current bank id is \(K_CURRENT_USER.bank_id)")
        
        // Do any additional setup after loading the view.
        self.setupView()
        self.mapView?.isMyLocationEnabled = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        self.mapView?.delegate = self
        
        
        //        delayWithSeconds(2.5) {
        //            self.locationManager?.startUpdatingLocation()
        //        }
        
        self.getAnnotationArray(recieveAllArray: self.cuisines as [[String:Any]])
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        //        self.setupView()
        //        self.mapView?.isMyLocationEnabled = true
        //        locationManager = CLLocationManager()
        //        locationManager?.delegate = self
        //        locationManager?.requestWhenInUseAuthorization()
        //        self.locationManager?.startUpdatingLocation()
        //        self.mapView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        let singelton = SharedManager.sharedInstance
        singelton.refeshRecommendation = "no"
        
        self.tabBarController?.selectedIndex =  1
        self.NotificationMethod()
        // self.loadMap()
        
    }
    
    //TODO: USER ARRAY TO SHOW PIN RECIEVED FROM THE PREVIOUS CLASS
    func getAnnotationArray(recieveAllArray:[[String:Any]])->Void{
        // for var i  in 0..<self.cuisines.count
        
        print(recieveAllArray)
        for var i in 0..<recieveAllArray.count{
            if let result = recieveAllArray[i]["result"] as? Array<Dictionary<String,Any>>{
                for j in 0..<result.count{
                    if result.count > 0
                    {
                        if  let restaurant  = result[j]["restaurant"] as? Dictionary<String,Any> {
                            print(restaurant)
                            if let restName  = restaurant["name"] as? String
                            {
                                self.nameRestaurant = restName
                            }
                            else{
                                self.nameRestaurant = ""
                            }
                            if let restName  = restaurant["locality"] as? String
                            {
                                //textRestaurant.text = restName
                                self.cityString = restName
                            }
                            else{
                                //textRestaurant.text  = ""
                                self.cityString = ""
                            }
                            print(restaurant["latitude"])
                            if let currentlat = restaurant["latitude"] as? Double{
                                self.latValueRestaurant = currentlat
                            }else{
                                self.latValueRestaurant=0.0
                            }
                            print(restaurant["longitude"])
                            if let currentlon = restaurant["longitude"] as? Double{
                                self.longValueRestaurant = currentlon
                            }else{
                                self.longValueRestaurant = 0.0
                            }
                            
                            // let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
                            let singelton = SharedManager.sharedInstance
                            let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
                            let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude: self.longValueRestaurant)
                            
                            // let distanceInMeters = coordinate1.distance(from: coordinate2)
                            //  let finaldist =  distanceInMeters / 1609.344
                            
                            
                            var content = Dictionary<String,Any>()
                            content.updateValue(self.latValueRestaurant, forKey: "latvalue")
                            content.updateValue(self.longValueRestaurant, forKey: "longvalue")
                            content.updateValue(self.nameRestaurant, forKey: "nameValue")
                            content.updateValue(self.cityString , forKey: "cityValue")
                            
                            self.annotationArray.append(content)
                        }
                        else{
                        }
                        
                    }
                }
                
            }
        }
        
    }
    //    override func viewDidDisappear(_ animated: Bool) {
    //            mapView?.delegate = nil
    //            mapView?.removeFromSuperview()
    //            mapView = nil
    //            if mapWrapperView != nil{
    //                mapWrapperView.removeFromSuperview()
    //                mapWrapperView = nil
    //            }
    //
    //    }
    
    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        self.NotificationMethod()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = 1
        
    }
    
     // MARK: CATCH NOTIFICATION WHEN LOCATION CHANGES
    func catchNotification(notification:Notification) -> Void {
        // print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? [[String:Any]]
            else {
                print("No userInfo recommendation in notification")
                return
        }
        // print("value is ",self.cuisines,message)
        self.titleRecommendation.isHidden = true
        self.cuisines.removeAll()
        self.cuisineIndex.removeAll()
        self.selectedProfileIndex = 0
        self.selectedRestaurantIndex = 0
        self.cuisines = message
        self.annotationArray.removeAll()
        self.getAnnotationArray(recieveAllArray: self.cuisines as [[String:Any]])
        self.refreshRecommendation()
        // print("value is ",self.cuisines)
        
    }
     // MARK: REFRESH RECOMMENDATION WHEN LOCATION CHANGES
    
    func refreshRecommendation(){
        SVProgressHUD.show()
        // print("current user is \(K_CURRENT_USER.name)")
        self.view.isUserInteractionEnabled = false //code added
        self.view.backgroundColor = UIColor.white
        
        // let titleLabel = UILabel()
        titleLabel.text = "H O M E"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.top.equalTo(40)
        }
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named:"ic_setting"), for: .normal)
        self.view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        settingsButton.addTarget(self, action: #selector(self.settingsTapped), for: .touchUpInside)
        
        // added by ranjit 17 jan
        
        //        let notifButton = UIButton(type: .custom)
        //        notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
        //        self.view.addSubview(notifButton)
        //        notifButton.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
        //            make.width.equalTo(40)
        //            make.height.equalTo(40)
        //        }
        //        notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        
        let userImageView = UIImageView()
        userImageView.backgroundColor = UIColor.gray
        self.view.addSubview(userImageView)
        userImageView.layer.cornerRadius = 60
        userImageView.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        userImageView.clipsToBounds = true
        
        if K_CURRENT_USER.image_url.characters.count > 0
        {
            
            let size = CGSize(width: 1500, height: 1500)
            let processImage = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
            
            
            //            imageURlString = K_CURRENT_USER.image_url
            //
            //            print("imageurl string is \(imageURlString)")
            //
            //            imageURlStringCrap = imageURlString.chopPrefix(68)
            //
            //             print("imageurl string is \(imageURlStringCrap)")
            
            userImageView.kf.setImage(with:URL(string:K_CURRENT_USER.image_url), placeholder: UIImage(named: "placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
            
            
            // userImageView.kf.setImage(with: URL(string:K_CURRENT_USER.image_url))
        }
        else
        {
            
            userImageView.kf.setImage(with: URL(string:"http://www.iaimhealthcare.com/images/doctor/no-image.jpg"))
        }
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showProfileAnalytics)))
        
        //   let nameLabel = UILabel()
        nameLabel.text = ""
        if (K_CURRENT_USER.name.characters.count > 0) {
            nameLabel.text = K_CURRENT_USER.name.capitalized
        }
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        nameLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 30)
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(19)
            // make.centerY.equalTo(userImageView).offset(-30)//change here
            make.top.equalTo(userImageView.snp.top)
            make.right.equalTo(-10)
        }
        
        //  let designationLabel = UILabel()
        designationLabel.text = ""
        if (K_CURRENT_USER.designation.characters.count > 0) {
            designationLabel.text = K_CURRENT_USER.designation
        }
        else
        {
            designationLabel.text = ""
        }
        designationLabel.numberOfLines = 2
        designationLabel.adjustsFontSizeToFitWidth = true
        designationLabel.minimumScaleFactor = 0.2
        designationLabel.font = UIFont(name:  K_Font_Color, size: 13)
        self.view.addSubview(designationLabel)
        designationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(19)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.width.equalTo(180)
            // make.bottom.equalTo(analyticsButton.snp.top).offset(-6)
            //make.right.equalTo(-10)
            
        }
        
        CompanyLabel.text = ""
        if (K_CURRENT_USER.company.characters.count > 0)
        {
            
            //CompanyLabel.text =  String(format:" at %@",K_CURRENT_USER.company)  //K_CURRENT_USER.company
            CompanyLabel.text = K_CURRENT_USER.company
            
        }
        else
        {
            CompanyLabel.text = ""
        }
        CompanyLabel.numberOfLines = 1
        CompanyLabel.adjustsFontSizeToFitWidth = true
        CompanyLabel.minimumScaleFactor = 0.2
        CompanyLabel.font = UIFont(name:  K_Font_Color, size: 13)
        
        self.view.addSubview(CompanyLabel)
        CompanyLabel.snp.makeConstraints { (make) in
            //make.left.equalTo(designationLabel.snp.right).offset(20)
            make.top.equalTo(designationLabel.snp.bottom).offset(2)
            make.left.equalTo(userImageView.snp.right).offset(19)
            make.width.equalTo(180)
        }
        
        
        
        let analyticsButton = UIButton(type: .custom)
        self.view.addSubview(analyticsButton)
        analyticsButton.backgroundColor = UIColor.black
        analyticsButton.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(19)
            make.top.equalTo(CompanyLabel.snp.bottom).offset(10)//30
            make.width.equalTo(150)
            make.height.equalTo(36)
        }
        analyticsButton.titleLabel?.font = UIFont(name: K_Font_Color_Bold, size: 14)
        analyticsButton.setTitle("DINING PROFILE", for: .normal)
        analyticsButton.setTitleColor(UIColor.white, for: .normal)
        analyticsButton.addTarget(self, action: #selector(self.viewAnalytics), for: .touchUpInside)
        analyticsButton.backgroundColor = UIColor.black
        analyticsButton.layer.cornerRadius = 5
        analyticsButton.layer.borderWidth = 1
        analyticsButton.layer.borderColor = UIColor.black.cgColor
        
        
        //        locationLabel = UILabel()
        //        locationLabel.text = "Searching Location...."
        //        locationLabel.textAlignment = .center
        //        locationLabel.sizeToFit()
        //        locationLabel.font = UIFont(name:K_Font_Color, size: 20)
        //        self.view.addSubview(locationLabel)
        //        locationLabel.snp.makeConstraints { (make) in
        //            //make.left.equalTo(tasteICon.snp.right).offset(14)
        //            make.top.equalTo(userImageView.snp.bottom).offset(20)
        //            //make.right.equalTo(-10)
        //            //make.width.equalTo(100)
        //            make.centerX.equalTo(self.view)
        //        }
        //
        //        underline = UILabel()
        //        underline.textColor = UIColor .black
        //        underline.backgroundColor = UIColor .black
        //        underline.textAlignment = .center
        //        underline.sizeToFit()
        //        locationLabel.addSubview(underline)
        //        underline.snp.makeConstraints { (make) in
        //            //make.left.equalTo(tasteICon.snp.right).offset(14)
        //            make.top.equalTo(locationLabel.snp.bottom).offset(1)
        //            make.right.equalTo(-10)
        //            make.width.equalTo(locationLabel.snp.width)
        //            make.height.equalTo(1)
        //            make.centerX.equalTo(self.view)
        //        }
        
        
        
        let tasteICon = UIButton(type: .custom)
        tasteICon.setImage(UIImage(named:"logo"), for: .normal)
        self.view.addSubview(tasteICon)
        tasteICon.snp.makeConstraints { (make) in
            make.left.equalTo(locationLabel.snp.left).offset(-20)
            make.top.equalTo(userImageView.snp.bottom).offset(24)
            make.width.equalTo(14)
            make.height.equalTo(20)
        }
        let topRecommendationLabel = UILabel()
        topRecommendationLabel.text = ""
        topRecommendationLabel.textAlignment = .center
        topRecommendationLabel.font = UIFont(name:K_Font_Color, size: 20)
        self.view.addSubview(topRecommendationLabel)
        topRecommendationLabel.snp.makeConstraints { (make) in
            // make.left.equalTo(42) //25
            make.top.equalTo(locationLabel.snp.bottom).offset(12)//
            make.width.equalTo(170)
            make.centerX.equalTo(self.view)
        }
        
        
        //        let dropButton = UIButton(type: .custom)
        //        dropButton.setImage(UIImage(named:"dropdown_arrow_down"), for: .normal)
        //        self.view.addSubview(dropButton)
        //        dropButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(topRecommendationLabel.snp.right).offset(5)
        //            //make.centerY.equalTo(titleLabel.snp.centerY)
        //            make.centerY.equalTo(topRecommendationLabel.snp.centerY)
        //            make.width.equalTo(30)
        //            make.height.equalTo(30)
        //        }
        
        
        
        
        //                let lineView = UIView()
        //                self.view.addSubview(lineView)
        //                lineView.backgroundColor = UIColor.black
        //                lineView.snp.makeConstraints { (make) in
        //                    make.left.equalTo(topRecommendationLabel.snp.right).offset(5)//10
        //                    make.height.equalTo(20)
        //                    make.width.equalTo(1)
        //                    make.top.equalTo(userImageView.snp.bottom).offset(20)//
        //                }
        
        //                locationLabel = UILabel()
        //                locationLabel.text = "NYC"
        //                locationLabel.textAlignment = .left
        //                self.view.addSubview(locationLabel)
        //                locationLabel.snp.makeConstraints { (make) in
        //                    make.left.equalTo(lineView.snp.right).offset(5)//10
        //                    make.top.equalTo(userImageView.snp.bottom).offset(20)
        //                     make.right.equalTo(-15)
        //        }
        
        
        
        
        //        locationLabel = UILabel()
        //        locationLabel.text = "NYC"
        //        locationLabel.textAlignment = .center
        //        self.view.addSubview(locationLabel)
        //        locationLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(25)
        //            make.top.equalTo(userImageView.snp.bottom).offset(14)
        //            make.width.equalTo(70)
        //        }
        //
        //        let lineView = UIView()
        //        self.view.addSubview(lineView)
        //        lineView.backgroundColor = UIColor.black
        //        lineView.snp.makeConstraints { (make) in
        //            make.left.equalTo(locationLabel.snp.right).offset(15)
        //            make.height.equalTo(20)
        //            make.width.equalTo(1)
        //            make.top.equalTo(userImageView.snp.bottom).offset(14)
        //        }
        //
        //        let topRecommendationLabel = UILabel()
        //        topRecommendationLabel.text = "Recommendations"
        //        topRecommendationLabel.textAlignment = .center
        //        self.view.addSubview(topRecommendationLabel)
        //        topRecommendationLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(lineView.snp.right).offset(15)
        //            make.top.equalTo(userImageView.snp.bottom).offset(14)
        //            make.right.equalTo(-15)
        //        }
        
        
        // let tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.separatorColor = UIColor.clear
        // self.tableView.delegate = self
        // self.tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            //make.width.equalTo(self.view.snp.width).offset(-10)
            make.width.equalTo(self.view.snp.width).offset(0)
            make.top.equalTo(topRecommendationLabel.snp.bottom).offset(15)
        }
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.showsVerticalScrollIndicator = false
        
        let mapButton1 = UIButton(type: .custom)
        mapButton1.setImage(UIImage(named:"map_location_tranparent"), for: .normal)
        mapButton1.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        self.view.addSubview(mapButton1)
        mapButton1.snp.makeConstraints { (make) in
            
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            if UIScreen.main.nativeBounds.height == 2436{
                make.bottom.equalTo(-90)
            }else{
                make.bottom.equalTo(-50)
            }
           // make.bottom.equalTo(-50)
            
        }
        self.view.addSubview(mapButton1)
        
        mapWrapperView = UIView()
        self.view.addSubview(mapWrapperView)
        mapWrapperView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        mapWrapperView.isHidden = true
        
        
        mapView = GMSMapView()
        mapWrapperView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(80)
            make.bottom.equalTo(40)
            
        }
        mapView.center = view.center
        whiteBarView = UIView()
        mapWrapperView.addSubview(whiteBarView)
        whiteBarView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(80)
        }
        whiteBarView.backgroundColor = UIColor.white
        whiteBarView.layer.shadowColor = UIColor.darkGray.cgColor
        whiteBarView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        whiteBarView.layer.shadowRadius = 1.0
        whiteBarView.layer.shadowOpacity = 0.3
        
        let settingsButtonWrapper = UIButton(type: .custom)
        settingsButtonWrapper.setImage(UIImage(named:"ic_back"), for: .normal)
        mapWrapperView.addSubview(settingsButtonWrapper)
        settingsButtonWrapper.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        settingsButtonWrapper.addTarget(self, action: #selector(self.hideMapped), for: .touchUpInside)
        let titleLabel2 = UILabel()
        titleLabel2.text = "H O M E"
        titleLabel2.textAlignment = .center
        titleLabel2.numberOfLines = 2
        titleLabel2.font = UIFont(name: K_FONT_COLOR_Alethia , size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        mapWrapperView.addSubview(titleLabel2)
        titleLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(whiteBarView).offset(10)
        }
        let mapButton = UIButton(type: .custom)
        mapButton.setImage(UIImage(named:"map_area"), for: .normal)
        mapWrapperView.addSubview(mapButton)
        mapButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            if UIScreen.main.nativeBounds.height == 2436{
                make.bottom.equalTo(-90)
            }else{
                make.bottom.equalTo(-50)
            }
           // make.bottom.equalTo(-50)
        }
        mapButton.addTarget(self, action: #selector(self.hideMap), for: .touchUpInside)
        
        let tabBar = UIView()
        tabBar.backgroundColor = UIColor(white: 0.4, alpha: 0.9)
        self.view.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(30)
        }
        if self.cuisines.count > 0 {
            
            for var i  in 0..<self.cuisines.count
            {
                if  let result = self.cuisines[i]["result"] as? Array<Dictionary<String,Any>>
                {     for var j  in 0..<result.count{
                    if let result = self.cuisines[i]["result"] as? Array<Dictionary<String,Any>>{
                        if result.count > 0
                        {
                            topRecommendationLabel.text = "Recommendations"
                            if  let restaurant  = result[j]["restaurant"] as? Dictionary<String,Any> {
                                if let restName  = restaurant["name"] as? String
                                {
                                    
                                    self.nameRestaurant = restName
                                }
                                else{
                                    
                                    self.nameRestaurant = ""
                                }
                                if let restName  = restaurant["locality"] as? String
                                {
                                    //textRestaurant.text = restName
                                    self.cityString = restName
                                }
                                else{
                                    //textRestaurant.text  = ""
                                    self.cityString = ""
                                }
                                if let locCountry = restaurant["country"] as? String{
                                    self.countryString = locCountry
                                }
                                else{
                                    self.countryString = ""
                                }
                                
                                if let locState = restaurant["region"] as? String{
                                    self.stateString = locState
                                }
                                else{
                                    self.stateString = ""
                                }
                                if let locAddress = restaurant["address"] as? String{
                                    self.addressString = locAddress
                                }
                                else{
                                    self.addressString = ""
                                }
                                if let currentlat = restaurant["latitude"] as? Double{
                                    self.latValueRestaurant = currentlat
                                }else{
                                    self.latValueRestaurant=0.0
                                }
                                if let currentlon = restaurant["longitude"] as? Double{
                                    self.longValueRestaurant = currentlon
                                }else{
                                    self.longValueRestaurant = 0.0
                                }
                                // var content = Dictionary<String,Any>()
                                //name
                                
                                var cusineDetail = ProfileCuisineFilter()
                                cusineDetail.restaurantName = self.nameRestaurant
                                cusineDetail.address = self.addressString
                                cusineDetail.city = self.cityString
                                cusineDetail.state = self.stateString
                                cusineDetail.country = self.countryString
                                cusineDetail.latitudeValue = self.latValueRestaurant
                                cusineDetail.longitudeValue = self.longValueRestaurant
                                cusineDetail.photo_ref = ""
                                cusineDetail.Placeid = ""
                                // content.updateValue(cusineDetail, forKey: "restaurant")
                                self.cuisineArray.append(cusineDetail)
                                //  print(cusineDetail.restaurantName)
                                //print(self.cuisineArray.count)
                            }
                        }
                        // self.countGoogleApiHit(index:self.selectedProfileIndex)
                    }
                    }
                }
                else{
                    topRecommendationLabel.text = ""
                    
                }
                self.cuisineIndex.insert(self.cuisineArray as AnyObject, at: i)
                self.cuisineArray.removeAll()
                
            }
            topRecommendationLabel.isHidden = false
            self.dropDownTextView.isHidden = false  // added by ranjit 27
            self.dropDownImageView.isHidden = false
            AddToBank.isHidden = true
        }
        else{
            mapButton1.isHidden = true
            mapButton.isHidden = true
            topRecommendationLabel.text = ""
            topRecommendationLabel.isHidden = true
            self.dropDownTextView.isHidden = true  // added by ranjit 27
            self.dropDownImageView.isHidden = true
            AddToBank.isHidden = false
            self.titleRecommendation.isHidden = false
            self.titleRecommendation.text = "We do not have enough data to show the recommendations for you. Please try adding more bank accounts in settings section."
            self.titleRecommendation.textAlignment = .center
            self.titleRecommendation.numberOfLines = 4
            self.titleRecommendation.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.view.addSubview(self.titleRecommendation)
            self.titleRecommendation.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(topRecommendationLabel.snp.bottom).offset(140)
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
        //        if self.cuisineArray.count > 0 {
        //            self.countGoogleApiHit(index:self.selectedProfileIndex)
        //        }
        //        for var j  in 0..<self.cuisineIndex.count{
        //            print(self.cuisineIndex[j])
        //            var restaurantArray = self.cuisineIndex[j]
        //            if restaurantArray.count > 0{
        //                var cusineDetail = ProfileCuisineFilter()
        //
        //                self.countGoogleApiHit(cIndex: self.selectedProfileIndex, restaurantIndex: self.selectedRestaurantIndex)
        //            }
        ////            for user in restaurantArray as! [ProfileCuisineFilter]{
        ////                var cusineDetail = ProfileCuisineFilter()
        ////                cusineDetail = user
        ////                //  if self.cuisineArray.count > 0 {
        ////
        ////                //Stuff Here
        ////               // self.countGoogleApiHit(index:self.selectedProfileIndex,cuisineDetails: cusineDetail)
        ////
        ////                break
        ////
        ////
        ////                // }
        ////            }
        //        }
        self.view.isUserInteractionEnabled = true //code added
        
        
        //  self.view.isUserInteractionEnabled = true //code added
        
        dropDownTextView.backgroundColor = UIColor.white
        //        dropDownTextView.layer.borderWidth = 0.5
        //        dropDownTextView.layer.cornerRadius = 2.0
        //        dropDownTextView.layer.borderColor = UIColor.darkGray.cgColor
        dropDownTextView.textColor = UIColor.black
        dropDownTextView.textAlignment = NSTextAlignment.center
        dropDownTextView.font = UIFont(name:K_Font_Color, size: 17)
        
        self.view.addSubview(dropDownTextView)
        //dropDownTextView.text = K_CURRENT_USER.selected_miles
        if K_CURRENT_USER.selected_miles == "0.5" || K_CURRENT_USER.selected_miles == "1"{
            dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Mile"
        }
        else{
            dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Miles"
        }
        
        dropDownTextView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(202)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        self.view.bringSubview(toFront: dropDownTextView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropDownBtnPressed))
        dropDownTextView.isUserInteractionEnabled = true
        dropDownTextView.addGestureRecognizer(tap)
        //dropDownTextView.addTarget(self, action: #selector(self.cuisinesTapped), for: .touchUpInside)
        
        // underline label
        
        //        underline = UILabel()
        //        underline.textColor = UIColor .black
        //        underline.backgroundColor = UIColor .black
        //        underline.textAlignment = .center
        //        underline.sizeToFit()
        //        self.view.addSubview(underline)
        //        underline.snp.makeConstraints { (make) in
        //            make.left.equalTo(280)
        //            make.top.equalTo(titleLabel.snp.bottom).offset(230)
        //            make.width.equalTo(80)
        //            make.height.equalTo(1)
        //        }
        //  drop down image view
        
        dropDownImageView.image = UIImage.init(named: "dropdown")
        // dropDownImageView.contentMode = .center
        // underline.textColor = UIColor .black
        // underline.backgroundColor = UIColor .black
        // underline.textAlignment = .center
        // underline.sizeToFit()
        
        self.view.addSubview(dropDownImageView)
        dropDownImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(212)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        self.view.addSubview(self.dropDownTableView)
        self.dropDownTableView.separatorColor = UIColor.darkGray
        self.dropDownTableView.delegate = self
        self.dropDownTableView.dataSource = self
        self.dropDownTableView.tag = 123
        dropDownTableView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(230)
            make.width.equalTo(80)
            make.height.equalTo(0)
        }
        self.tableView.bringSubview(toFront: self.dropDownTableView)
        self.dropDownTableView.backgroundColor = UIColor.lightGray
        self.dropDownTableView.showsVerticalScrollIndicator = false
        self.isDropDowntableShown = false
        
        self.countGoogleApiHit()
        self.locationManager?.startUpdatingLocation()
    }
    
     // MARK: SET ALL THE USER INTERFACE WHICH IS VISIBLE ON THE SCREEN
    func setupView() {
        SVProgressHUD.show()
        // print("current user is \(K_CURRENT_USER.name)")
        self.view.isUserInteractionEnabled = false//code added
        self.view.backgroundColor = UIColor.white
        
        // let titleLabel = UILabel()
        titleLabel.text = "H O M E"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.top.equalTo(40)
        }
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named:"ic_setting"), for: .normal)
        self.view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        settingsButton.addTarget(self, action: #selector(self.settingsTapped), for: .touchUpInside)
        
        // added by Ranjit 17 Jan
        
        //        notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
        //        self.view.addSubview(notifButton)
        //        notifButton.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
        //            make.width.equalTo(35)
        //            make.height.equalTo(35)
        //        }
        //        notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        
        var userImageViewLProfile = UIImageView()
        userImageViewLProfile.backgroundColor = UIColor.gray
        self.view.addSubview(userImageViewLProfile)
        userImageViewLProfile.layer.cornerRadius = 60
        userImageViewLProfile.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        userImageViewLProfile.clipsToBounds = true
        
        if K_CURRENT_USER.image_url.characters.count > 0
        {
            
            let size = CGSize(width: 1500, height: 1500)
            let processImage = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
            
            
            //            imageURlString = K_CURRENT_USER.image_url
            //
            //            print("imageurl string is \(imageURlString)")
            //
            //            imageURlStringCrap = imageURlString.chopPrefix(68)
            //
            //             print("imageurl string is \(imageURlStringCrap)")
            
            //            userImageView.kf.setImage(with:URL(string:K_CURRENT_USER.image_url), placeholder: UIImage(named: "placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
            
            userImageViewLProfile.sd_setImage(with: URL(string: K_CURRENT_USER.image_url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
            
            //            if let url = NSURL(string: K_CURRENT_USER.image_url) {
            //                if let data = NSData(contentsOf: url as URL) {
            //                    userImageViewLProfile.image = UIImage(data: data as Data)
            //                }
            //            }
            
            
            // userImageView.kf.setImage(with: URL(string:K_CURRENT_USER.image_url))
        }
        else
        {
            
            userImageViewLProfile.kf.setImage(with: URL(string:"http://www.iaimhealthcare.com/images/doctor/no-image.jpg"))
        }
        userImageViewLProfile.isUserInteractionEnabled = true
        userImageViewLProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showProfileAnalytics)))
        
        //  let nameLabel = UILabel()
        nameLabel.text = ""
        if (K_CURRENT_USER.name.characters.count > 0) {
            
            
            nameLabel.text = K_CURRENT_USER.name.capitalized
        }
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        nameLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 30)
        //  nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageViewLProfile.snp.right).offset(19)
            // make.centerY.equalTo(userImageView).offset(-30)//change here
            make.top.equalTo(userImageViewLProfile.snp.top)
            make.right.equalTo(-10)
        }
        
        //  let designationLabel = UILabel()
        designationLabel.text = ""
        if (K_CURRENT_USER.designation.characters.count > 0) {
            designationLabel.text = K_CURRENT_USER.designation
        }
        else
        {
            designationLabel.text = ""
        }
        designationLabel.numberOfLines = 2
        designationLabel.adjustsFontSizeToFitWidth = true
        designationLabel.minimumScaleFactor = 0.2
        designationLabel.font = UIFont(name:  K_Font_Color, size: 13)
        self.view.addSubview(designationLabel)
        designationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageViewLProfile.snp.right).offset(19)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.width.equalTo(180)
            // make.bottom.equalTo(analyticsButton.snp.top).offset(-6)
            //make.right.equalTo(-10)
            
        }
        
        CompanyLabel.text = ""
        if (K_CURRENT_USER.company.characters.count > 0)
        {
            
            //CompanyLabel.text =  String(format:" at %@",K_CURRENT_USER.company)  //K_CURRENT_USER.company
            CompanyLabel.text = K_CURRENT_USER.company
            
        }
        else
        {
            CompanyLabel.text = ""
        }
        CompanyLabel.numberOfLines = 1
        CompanyLabel.adjustsFontSizeToFitWidth = true
        CompanyLabel.minimumScaleFactor = 0.2
        CompanyLabel.font = UIFont(name:  K_Font_Color, size: 13)
        
        self.view.addSubview(CompanyLabel)
        CompanyLabel.snp.makeConstraints { (make) in
            //make.left.equalTo(designationLabel.snp.right).offset(20)
            make.top.equalTo(designationLabel.snp.bottom).offset(2)
            make.left.equalTo(userImageViewLProfile.snp.right).offset(19)
            make.width.equalTo(180)
        }
        
        
        
        let analyticsButton = UIButton(type: .custom)
        self.view.addSubview(analyticsButton)
        analyticsButton.backgroundColor = UIColor.black
        analyticsButton.snp.makeConstraints { (make) in
            make.left.equalTo(userImageViewLProfile.snp.right).offset(19)
            make.top.equalTo(CompanyLabel.snp.bottom).offset(10)//30
            make.width.equalTo(150)
            make.height.equalTo(36)
        }
        analyticsButton.titleLabel?.font = UIFont(name: K_Font_Color_Bold, size: 14)
        analyticsButton.setTitle("DINING PROFILE", for: .normal)
        analyticsButton.setTitleColor(UIColor.white, for: .normal)
        analyticsButton.addTarget(self, action: #selector(self.viewAnalytics), for: .touchUpInside)
        analyticsButton.backgroundColor = UIColor.black
        analyticsButton.layer.cornerRadius = 5
        analyticsButton.layer.borderWidth = 1
        analyticsButton.layer.borderColor = UIColor.black.cgColor
        
        
        locationLabel = UILabel()
        locationLabel.text = "Searching Location...."
        locationLabel.textAlignment = .center
        locationLabel.sizeToFit()
        locationLabel.font = UIFont(name:K_Font_Color, size: 20)
        self.view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (make) in
            //make.left.equalTo(tasteICon.snp.right).offset(14)
            make.top.equalTo(userImageViewLProfile.snp.bottom).offset(20)
            //make.right.equalTo(-10)
            //make.width.equalTo(100)
            make.centerX.equalTo(self.view)
        }
        
        //        // added by ranjit 10 Oct
        //
        //        dropDownButton = UIButton()
        //        dropDownButton.titleLabel?.text = "0.5"
        //        dropDownButton.titleLabel?.textAlignment = .center
        //        dropDownButton.titleLabel?.font = UIFont(name:K_Font_Color, size: 20)!
        //        self.view.addSubview(dropDownButton)
        //        locationLabel.snp.makeConstraints { (make) in
        //            //make.left.equalTo(tasteICon.snp.right).offset(14)
        //            make.top.equalTo(locationLabel.snp.bottom).offset(20)
        //            //make.right.equalTo(-10)
        //            //make.width.equalTo(100)
        //            make.centerX.equalTo(self.view)
        //        }
        
        underline = UILabel()
        underline.textColor = UIColor .black
        underline.backgroundColor = UIColor .black
        underline.textAlignment = .center
        underline.sizeToFit()
        locationLabel.addSubview(underline)
        underline.snp.makeConstraints { (make) in
            //make.left.equalTo(tasteICon.snp.right).offset(14)
            make.top.equalTo(locationLabel.snp.bottom).offset(1)
            make.right.equalTo(-10)
            make.width.equalTo(locationLabel.snp.width)
            make.height.equalTo(1)
            make.centerX.equalTo(self.view)
        }
        let locationTap = UIButton(type: .custom)
        // locationTap.backgroundColor = UIColor.black
        locationTap.addTarget(self, action: #selector(self.exploreScreen), for: .touchUpInside)
        self.view.addSubview(locationTap)
        locationTap.snp.makeConstraints { (make) in
            //  make.left.equalTo(locationTap.snp.left)
            make.top.equalTo(locationLabel.snp.top).offset(0)
            make.width.equalTo(self.view.frame.size.width)
            make.height.equalTo(locationLabel.snp.height)
            make.centerX.equalTo(self.view)
        }
        
        
        let tasteICon = UIButton(type: .custom)
        tasteICon.setImage(UIImage(named:"logo"), for: .normal)
        self.view.addSubview(tasteICon)
        tasteICon.snp.makeConstraints { (make) in
            make.left.equalTo(locationLabel.snp.left).offset(-20)
            make.top.equalTo(userImageViewLProfile.snp.bottom).offset(24)
            make.width.equalTo(14)
            make.height.equalTo(20)
        }
        let topRecommendationLabel = UILabel()
        topRecommendationLabel.text = ""
        topRecommendationLabel.textAlignment = .center
        topRecommendationLabel.font = UIFont(name:K_Font_Color, size: 20)
        self.view.addSubview(topRecommendationLabel)
        topRecommendationLabel.snp.makeConstraints { (make) in
            // make.left.equalTo(42) //25
            make.top.equalTo(locationLabel.snp.bottom).offset(12)//
            make.width.equalTo(170)
            make.centerX.equalTo(self.view)
        }
        
        
        //        let dropButton = UIButton(type: .custom)
        //        dropButton.setImage(UIImage(named:"dropdown_arrow_down"), for: .normal)
        //        self.view.addSubview(dropButton)
        //        dropButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(topRecommendationLabel.snp.right).offset(5)
        //            //make.centerY.equalTo(titleLabel.snp.centerY)
        //            make.centerY.equalTo(topRecommendationLabel.snp.centerY)
        //            make.width.equalTo(30)
        //            make.height.equalTo(30)
        //        }
        
        
        
        
        //                let lineView = UIView()
        //                self.view.addSubview(lineView)
        //                lineView.backgroundColor = UIColor.black
        //                lineView.snp.makeConstraints { (make) in
        //                    make.left.equalTo(topRecommendationLabel.snp.right).offset(5)//10
        //                    make.height.equalTo(20)
        //                    make.width.equalTo(1)
        //                    make.top.equalTo(userImageView.snp.bottom).offset(20)//
        //                }
        
        //                locationLabel = UILabel()
        //                locationLabel.text = "NYC"
        //                locationLabel.textAlignment = .left
        //                self.view.addSubview(locationLabel)
        //                locationLabel.snp.makeConstraints { (make) in
        //                    make.left.equalTo(lineView.snp.right).offset(5)//10
        //                    make.top.equalTo(userImageView.snp.bottom).offset(20)
        //                     make.right.equalTo(-15)
        //        }
        
        
        
        
        //        locationLabel = UILabel()
        //        locationLabel.text = "NYC"
        //        locationLabel.textAlignment = .center
        //        self.view.addSubview(locationLabel)
        //        locationLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(25)
        //            make.top.equalTo(userImageView.snp.bottom).offset(14)
        //            make.width.equalTo(70)
        //        }
        //
        //        let lineView = UIView()
        //        self.view.addSubview(lineView)
        //        lineView.backgroundColor = UIColor.black
        //        lineView.snp.makeConstraints { (make) in
        //            make.left.equalTo(locationLabel.snp.right).offset(15)
        //            make.height.equalTo(20)
        //            make.width.equalTo(1)
        //            make.top.equalTo(userImageView.snp.bottom).offset(14)
        //        }
        //
        //        let topRecommendationLabel = UILabel()
        //        topRecommendationLabel.text = "Recommendations"
        //        topRecommendationLabel.textAlignment = .center
        //        self.view.addSubview(topRecommendationLabel)
        //        topRecommendationLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(lineView.snp.right).offset(15)
        //            make.top.equalTo(userImageView.snp.bottom).offset(14)
        //            make.right.equalTo(-15)
        //        }
        
        
        // let tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.separatorColor = UIColor.clear
        // self.tableView.delegate = self
        // self.tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            //make.width.equalTo(self.view.snp.width).offset(-10)
            make.width.equalTo(self.view.snp.width).offset(0)
            make.top.equalTo(topRecommendationLabel.snp.bottom).offset(15)
        }
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.showsVerticalScrollIndicator = false
        
        let mapButton1 = UIButton(type: .custom)
        mapButton1.setImage(UIImage(named:"map_location_tranparent"), for: .normal)
        mapButton1.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        self.view.addSubview(mapButton1)
        mapButton1.snp.makeConstraints { (make) in
            
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            
            if UIScreen.main.nativeBounds.height == 2436{
               make.bottom.equalTo(-90)
            }else{
                make.bottom.equalTo(-50)
            }
//            if UIDevice().userInterfaceIdiom == .phone {
//                switch UIScreen.main.nativeBounds.height {
//                case 1136:
//                    print("iPhone 5 or 5S or 5C")
//                case 1334:
//                    print("iPhone 6/6S/7/8")
//                case 1920, 2208:
//                    print("iPhone 6+/6S+/7+/8+")
//                case 2436:
//                    print("iPhone X")
//                default:
//                    print("unknown")
//                }
//            }
//            make.bottom.equalTo(-50)
            
        }
        self.view.addSubview(mapButton1)
        
        mapWrapperView = UIView()
        self.view.addSubview(mapWrapperView)
        mapWrapperView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        mapWrapperView.isHidden = true
        
        
        mapView = GMSMapView()
        mapWrapperView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(80)
            make.bottom.equalTo(40)
            
        }
        mapView.center = view.center
        whiteBarView = UIView()
        mapWrapperView.addSubview(whiteBarView)
        whiteBarView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(80)
        }
        whiteBarView.backgroundColor = UIColor.white
        whiteBarView.layer.shadowColor = UIColor.darkGray.cgColor
        whiteBarView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        whiteBarView.layer.shadowRadius = 1.0
        whiteBarView.layer.shadowOpacity = 0.3
        
        let settingsButtonWrapper = UIButton(type: .custom)
        settingsButtonWrapper.setImage(UIImage(named:"ic_back"), for: .normal)
        mapWrapperView.addSubview(settingsButtonWrapper)
        settingsButtonWrapper.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        settingsButtonWrapper.addTarget(self, action: #selector(self.hideMapped), for: .touchUpInside)
        let titleLabel2 = UILabel()
        titleLabel2.text = "H O M E"
        titleLabel2.textAlignment = .center
        titleLabel2.numberOfLines = 2
        titleLabel2.font = UIFont(name: K_FONT_COLOR_Alethia , size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        mapWrapperView.addSubview(titleLabel2)
        titleLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(whiteBarView).offset(10)
        }
        let mapButton = UIButton(type: .custom)
        mapButton.setImage(UIImage(named:"map_area"), for: .normal)
        mapWrapperView.addSubview(mapButton)
        mapButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            if UIScreen.main.nativeBounds.height == 2436{
                make.bottom.equalTo(-90)
            }else{
                make.bottom.equalTo(-50)
            }
           // make.bottom.equalTo(-50)
        }
        mapButton.addTarget(self, action: #selector(self.hideMap), for: .touchUpInside)
        
        let tabBar = UIView()
        tabBar.backgroundColor = UIColor(white: 0.4, alpha: 0.9)
        self.view.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(30)
        }
        if self.cuisines.count > 0 {
            
            for var i  in 0..<self.cuisines.count
            {
                if  let result = self.cuisines[i]["result"] as? Array<Dictionary<String,Any>>
                {     for var j  in 0..<result.count{
                    if let result = self.cuisines[i]["result"] as? Array<Dictionary<String,Any>>{
                        if result.count > 0
                        {
                            topRecommendationLabel.text = "Recommendations"
                            if  let restaurant  = result[j]["restaurant"] as? Dictionary<String,Any> {
                                if let restName  = restaurant["name"] as? String
                                {
                                    
                                    self.nameRestaurant = restName
                                }
                                else{
                                    
                                    self.nameRestaurant = ""
                                }
                                if let restName  = restaurant["locality"] as? String
                                {
                                    //textRestaurant.text = restName
                                    self.cityString = restName
                                }
                                else{
                                    //textRestaurant.text  = ""
                                    self.cityString = ""
                                }
                                if let locCountry = restaurant["country"] as? String{
                                    self.countryString = locCountry
                                }
                                else{
                                    self.countryString = ""
                                }
                                
                                if let locState = restaurant["region"] as? String{
                                    self.stateString = locState
                                }
                                else{
                                    self.stateString = ""
                                }
                                if let locAddress = restaurant["address"] as? String{
                                    self.addressString = locAddress
                                }
                                else{
                                    self.addressString = ""
                                }
                                if let currentlat = restaurant["latitude"] as? Double{
                                    self.latValueRestaurant = currentlat
                                }else{
                                    self.latValueRestaurant=0.0
                                }
                                if let currentlon = restaurant["longitude"] as? Double{
                                    self.longValueRestaurant = currentlon
                                }else{
                                    self.longValueRestaurant = 0.0
                                }
                                
                                
                                if let locTel = restaurant["tel"] as? String{
                                    K_INNERUSER_DATA.Phone = locTel
                                }
                                else{
                                    K_INNERUSER_DATA.Phone = ""
                                }
                                if let locWebsite = restaurant["website"] as? String{
                                    K_INNERUSER_DATA.Website = locWebsite
                                }
                                else{
                                    K_INNERUSER_DATA.Website = ""
                                }
                                
                                if let hours = restaurant["hours_display"] as? String{
                                    K_INNERUSER_DATA.Hours = hours
                                }
                                else{
                                    K_INNERUSER_DATA.Hours = ""
                                }
                                
                                if let price = restaurant["price"] as? NSNumber
                                {
                                    K_INNERUSER_DATA.Price = String(format:"%@",price)
                                }
                                
                                if let rating = restaurant["rating"] as? NSNumber
                                {
                                    
                                    K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                                }
                                
                                if let cuisineName = self.cuisines[i]["name"] as? String {
                                    // K_INNERUSER_DATA.CuisineName =  cuisineName
                                    K_INNERUSER_DATA.CuisinSeleted =  cuisineName
                                }
                                else{
                                    K_INNERUSER_DATA.CuisinSeleted = ""
                                }
                                if let factual_id = restaurant["factual_id"] as? String{
                                    K_INNERUSER_DATA.FactualId = factual_id
                                }
                                else{
                                    K_INNERUSER_DATA.FactualId = ""
                                }
                                
                                if let restName  = restaurant["name"] as? String
                                {
                                    K_INNERUSER_DATA.RestaurantName = restName
                                }
                                else{
                                    K_INNERUSER_DATA.RestaurantName  = ""
                                }
                                
                                
                                
                                
                                
                                // var content = Dictionary<String,Any>()
                                //name
                                
                                var cusineDetail = ProfileCuisineFilter()
                                cusineDetail.restaurantName = self.nameRestaurant
                                cusineDetail.address = self.addressString
                                cusineDetail.city = self.cityString
                                cusineDetail.state = self.stateString
                                cusineDetail.country = self.countryString
                                cusineDetail.latitudeValue = self.latValueRestaurant
                                cusineDetail.longitudeValue = self.longValueRestaurant
                                cusineDetail.photo_ref = ""
                                cusineDetail.Placeid = ""
                                cusineDetail.Price = K_INNERUSER_DATA.Price
                                cusineDetail.phone = K_INNERUSER_DATA.Phone
                                cusineDetail.website = K_INNERUSER_DATA.Website
                                cusineDetail.hour = K_INNERUSER_DATA.Hours
                                cusineDetail.cuisineName =  K_INNERUSER_DATA.CuisinSeleted
                                // content.updateValue(cusineDetail, forKey: "restaurant")
                                self.cuisineArray.append(cusineDetail)
                                //  self.AnnotationArraymapData.append(cusineDetail)
                                // print(cusineDetail.restaurantName)
                                //print(self.cuisineArray.count)
                            }
                        }
                        // self.countGoogleApiHit(index:self.selectedProfileIndex)
                    }
                    }
                }
                else{
                    topRecommendationLabel.text = ""
                    
                }
                self.cuisineIndex.insert(self.cuisineArray as AnyObject, at: i)
                self.cuisineArray.removeAll()
            }
            topRecommendationLabel.isHidden = false
            self.dropDownTextView.isHidden = false  // added by ranjit 27
            self.dropDownImageView.isHidden = false
            AddToBank.isHidden = true
        }
        else{
            mapButton1.isHidden = true
            mapButton.isHidden = true
            topRecommendationLabel.isHidden = true
            self.dropDownTextView.isHidden = true  // added by ranjit 27
            self.dropDownImageView.isHidden = true
            AddToBank.isHidden = false
            self.titleRecommendation.isHidden = false
            self.titleRecommendation.text = "We do not have enough data to show the recommendations for you. Please try adding more bank accounts in settings section."
            self.titleRecommendation.textAlignment = .center
            self.titleRecommendation.numberOfLines = 4
            self.titleRecommendation.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.view.addSubview(self.titleRecommendation)
            self.titleRecommendation.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(topRecommendationLabel.snp.bottom).offset(140)
                //                make.centerX.equalTo(self.view)
                //                make.centerY.equalTo(self.view)
            }
            AddToBank.backgroundColor = UIColor.black
            AddToBank.addTarget(self, action: #selector(self.AddAccount), for: .touchUpInside)
            AddToBank.setTitle("ADD ACCOUNT", for: .normal)
            AddToBank.setTitleColor(UIColor.white, for: .normal)
            self.view.addSubview(AddToBank)
            AddToBank.snp.makeConstraints { (make) in
                // make.bottom.equalTo(self.view.snp.bottom).offset(-100)
                make.height.equalTo(50)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(self.titleRecommendation.snp.bottom).offset(30)
            }
            
        }
        //        if self.cuisineArray.count > 0 {
        //            self.countGoogleApiHit(index:self.selectedProfileIndex)
        //        }
        //        for var j  in 0..<self.cuisineIndex.count{
        //            print(self.cuisineIndex[j])
        //            var restaurantArray = self.cuisineIndex[j]
        //            if restaurantArray.count > 0{
        //                var cusineDetail = ProfileCuisineFilter()
        //
        //                self.countGoogleApiHit(cIndex: self.selectedProfileIndex, restaurantIndex: self.selectedRestaurantIndex)
        //            }
        ////            for user in restaurantArray as! [ProfileCuisineFilter]{
        ////                var cusineDetail = ProfileCuisineFilter()
        ////                cusineDetail = user
        ////                //  if self.cuisineArray.count > 0 {
        ////
        ////                //Stuff Here
        ////               // self.countGoogleApiHit(index:self.selectedProfileIndex,cuisineDetails: cusineDetail)
        ////
        ////                break
        ////
        ////
        ////                // }
        ////            }
        //        }
        self.view.isUserInteractionEnabled = true //code added
        
        dropDownTextView.backgroundColor = UIColor.white
        //        dropDownTextView.layer.borderWidth = 0.5
        //        dropDownTextView.layer.cornerRadius = 2.0
        //        dropDownTextView.layer.borderColor = UIColor.darkGray.cgColor
        dropDownTextView.textColor = UIColor.black
        dropDownTextView.textAlignment = NSTextAlignment.center
        dropDownTextView.font = UIFont(name:K_Font_Color, size: 17)
        self.view.addSubview(dropDownTextView)
        if K_CURRENT_USER.selected_miles == "0.5" || K_CURRENT_USER.selected_miles == "1"{
            dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Mile"
        }
        else{
            dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Miles"
        }
        // dropDownTextView.text = K_CURRENT_USER.selected_miles
        dropDownTextView.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.top.equalTo(titleLabel.snp.bottom).offset(202)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        self.view.bringSubview(toFront: dropDownTextView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropDownBtnPressed))
        dropDownTextView.isUserInteractionEnabled = true
        dropDownTextView.addGestureRecognizer(tap)
        //dropDownTextView.addTarget(self, action: #selector(self.cuisinesTapped), for: .touchUpInside)
        
        // underline label
        
        //        underline = UILabel()
        //        underline.textColor = UIColor .black
        //        underline.backgroundColor = UIColor .black
        //        underline.textAlignment = .center
        //        underline.sizeToFit()
        //        self.view.addSubview(underline)
        //        underline.snp.makeConstraints { (make) in
        //            make.left.equalTo(280)
        //            make.top.equalTo(titleLabel.snp.bottom).offset(230)
        //            make.width.equalTo(80)
        //            make.height.equalTo(1)
        //        }
        
        //  drop down image view
        
        dropDownImageView.image = UIImage.init(named: "dropdown")
        // dropDownImageView.contentMode = .center
        // underline.textColor = UIColor .black
        // underline.backgroundColor = UIColor .black
        // underline.textAlignment = .center
        // underline.sizeToFit()
        self.view.addSubview(dropDownImageView)
        dropDownImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(212)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        
        self.view.addSubview(self.dropDownTableView)
        self.dropDownTableView.separatorColor = UIColor.darkGray
        self.dropDownTableView.delegate = self
        self.dropDownTableView.dataSource = self
        self.dropDownTableView.tag = 123
        dropDownTableView.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.top.equalTo(titleLabel.snp.bottom).offset(230)
            make.width.equalTo(80)
            make.height.equalTo(0)
        }
        self.tableView.bringSubview(toFront: self.dropDownTableView)
        self.dropDownTableView.backgroundColor = UIColor.lightGray
        self.dropDownTableView.showsVerticalScrollIndicator = false
        self.isDropDowntableShown = false
        // self.setView(view: self.dropDownTableView, hidden: true,height: 0)
        //self.dropDownTableView.isHidden = true
        
        self.countGoogleApiHit()
    }
    
    func dropDownBtnPressed(sender:UITapGestureRecognizer) -> Void {
        
        self.hideShowDropDown(isShown: isDropDowntableShown)
    }
    
    func AddAccount() {
        
        
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
    
    
    
    func countGoogleApiHit(){
        
        //        if self.cuisineArray.count <= index {
        //            SVProgressHUD.dismiss()
        //            return
        //        }
        
        var cuisineDetail = ProfileCuisineFilter()
        //  print(self.selectedProfileIndex,self.selectedRestaurantIndex,self.cuisineIndex.count)
        if self.cuisineIndex.count > self.selectedProfileIndex{
            
            var restaurantArray = [ProfileCuisineFilter]()
            if let restaurants = self.cuisineIndex[self.selectedProfileIndex] as? [ProfileCuisineFilter]{
                restaurantArray = restaurants
                //  print(restaurantArray.count)
                if restaurantArray.count > self.selectedRestaurantIndex{
                    
                    cuisineDetail = restaurantArray[ self.selectedRestaurantIndex]
                    self.selectedRestaurantIndex += 1
                    //  print( cuisineDetail.restaurantName)
                }
                else{
                    //  print("count is less")
                    self.selectedProfileIndex += 1
                    self.selectedRestaurantIndex = 0
                    // print(self.selectedProfileIndex,self.selectedRestaurantIndex)
                    if self.cuisineIndex.count >  self.selectedProfileIndex{
                        if let restaurants = self.cuisineIndex[self.selectedProfileIndex] as? [ProfileCuisineFilter]{
                            restaurantArray = restaurants
                            if restaurantArray.count > self.selectedRestaurantIndex{
                                
                                cuisineDetail = restaurantArray[ self.selectedRestaurantIndex]
                                self.selectedRestaurantIndex += 1
                                //  print( cuisineDetail.restaurantName)
                            }
                            
                        }
                    }
                    else{
                        //      SVProgressHUD.dismiss()
                        //                        self.tableView.delegate = self
                        //                        self.tableView.dataSource = self
                        return
                    }
                    
                }
                
            }
            else{
                SVProgressHUD.dismiss()
                //                self.tableView.delegate = self
                //                self.tableView.dataSource = self
                return
            }
            
        }
        else{
            SVProgressHUD.dismiss()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            return
        }
        //  var cuisineDetail = ProfileCuisineFilter()
        // cuisineDetail = cuisineArray[self.selectedProfileIndex]
        
        let lat_long = "\(cuisineDetail.latitudeValue),\(cuisineDetail.longitudeValue)"
        // let address = "\(cuisineDetail.cuisineName)+\(cuisineDetail.city)"
        let address = cuisineDetail.restaurantName + "," + cuisineDetail.address + "," + cuisineDetail.city + "," + cuisineDetail.state + "," + cuisineDetail.country
        let paramString = ["query":address, "location": lat_long, "radius":"500", "type": "restaurant","keyword":"cruise","key":GOOGLE_APIKEY] as [String : Any]
        // print(paramString)
        
        
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=100&key=\(GOOGLE_APIKEY)"
        let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        
        // print("-------Print Request Url",UrlTrimString)
        
        DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
            if let dataDic = response as? [String:Any]
            {
                
                // print("Respomse", dataDic)
                
                //         for ResponseCount in responce{
                
                // self.tableView .reloadData()
                
                if let dataResponce = (response as AnyObject).object(forKey: "results"){
                    
                    let resultArray = dataResponce as! NSArray
                    
                    var contentRes = Dictionary<String,Any>()
                    contentRes.updateValue(resultArray, forKey: "RefResults")
                    
                    //       self.RestaurantResultArray.append(contentRes)
                    if resultArray.count > 0 {
                        
                        
                        
                        let arrayDict = resultArray[0] as! NSDictionary
                        var NameOfRest = ""
                        if let Rest_name = arrayDict.object(forKey: "name"){
                            NameOfRest = Rest_name as! String
                            // print("Rest Name is", NameOfRest)
                        }
                        
                        if let photosDict = arrayDict.object(forKey: "photos"){
                            
                            let photosArray = photosDict as! NSArray
                            
                            let placeId = arrayDict.object(forKey: "place_id")
                            
                            // print("place id is---",placeId)
                            cuisineDetail.Placeid = placeId as! String
                            var contentPlaceId = Dictionary<String,Any>()
                            contentPlaceId.updateValue(placeId!, forKey: "placeid")
                            
                            //    self.PlaceIdArray.append(contentPlaceId)
                            
                            
                            if photosArray.count > 0 {
                                
                                let photoDict = photosArray[0] as! NSDictionary
                                
                                
                                
                                if let photo_reference = photoDict.object(forKey: "photo_reference"){
                                    
                                    
                                    let PhotoRef = photo_reference as! String
                                    
                                    // print("PhotoRef : \(PhotoRef)")
                                    let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(PhotoRef)&key=\(GOOGLE_APIKEY)")!
                                    cuisineDetail.photo_ref = String(describing: url)
                                    //  print("index is",self.self.selectedProfileIndex,cuisineDetail.photo_ref)
                                    self.AnnotationArraymapData.append(cuisineDetail)
                                    
                                    // self.selectedRestaurantIndex += 1
                                    self.countGoogleApiHit()
                                    // self.countGoogleApiHit(index: self.selectedProfileIndex)
                                    self.tableView.delegate = self
                                    self.tableView.dataSource = self
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        else{
                            // print("Key Expaire");
                            cuisineDetail.photo_ref = ""
                            self.AnnotationArraymapData.append(cuisineDetail)
                            // self.selectedProfileIndex += 1
                            // self.selectedRestaurantIndex += 1
                            self.countGoogleApiHit()
                        }
                    }
                    else{
                        // print("Key Expaire");
                        cuisineDetail.photo_ref = ""
                        self.AnnotationArraymapData.append(cuisineDetail)
                        //self.selectedProfileIndex += 1
                        // self.selectedRestaurantIndex += 1
                        self.countGoogleApiHit()
                        
                    }
                    
                }
                
                
            }
            
        })
        
        
        
        //        SVProgressHUD.dismiss()
        
        
    }
    
    
    
    func scaledImage(_ image: UIImage, maximumWidth: CGFloat) -> UIImage
    {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    /* func getRecommendation() {
     
     //self.readJson()
     SVProgressHUD.show()
     
     let singelton = SharedManager.sharedInstance
     let latitude = "42.738957"
     let longitude = "-73.677594"
     let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude]
     print(parameters)
     DataManager.sharedManager.getRecommendation(params: parameters) { (responseObj) in
     print(responseObj)
     if let dataDic = responseObj as? Array<Dictionary<String,Any>>{
     self.cuisines = dataDic
     SVProgressHUD.dismiss()
     print(self.cuisines)
     }
     
     }
     }*/
    func mapButtonClicked()
        
    {
        // Analytics.logEvent("recommendation_map_pressed", parameters:nil) added by RAnjit 24 Jan
        
        if annotationArray.count == 0{
            return
        }
        SVProgressHUD.show()
        // SVProgressHUD.dismiss()
        
        self.view.isUserInteractionEnabled = true
        
        self.showPin()
        mapWrapperView.isHidden = false
        underline.isHidden = true
        self.dropDownImageView.isHidden = true
        
    }
    func hideMap() {
        self.mapWrapperView.isHidden = true
        self.dropDownTextView.isHidden = false
        self.isDropDowntableShown = false
        // self.dropDownTableView.isHidden = true
        self.setView(view: self.dropDownTableView, hidden: false,height: 0)
        underline.isHidden = false
        self.dropDownImageView.isHidden = false
        
    }
    func hideMapped()
        
    {
        self.mapWrapperView.isHidden = true
        self.dropDownTextView.isHidden = false
        self.isDropDowntableShown = false
        // self.dropDownTableView.isHidden = true
        self.setView(view: self.dropDownTableView, hidden: false,height: 0)
        underline.isHidden = false
        self.dropDownImageView.isHidden = false
        
    }
    func showPin()
    {
        self.mapView?.clear()
        self.dropDownTextView.isHidden = true
        self.isDropDowntableShown = false
        // self.dropDownTableView.isHidden = true
        self.setView(view: self.dropDownTableView, hidden: false,height: 0)
        SVProgressHUD.dismiss()
        
        
        let sydney = GMSCameraPosition.camera(withLatitude: annotationArray  [0] ["latvalue"] as! Double,
                                              longitude: annotationArray [0] ["longvalue"] as! Double,
                                              zoom: 13.0)
        mapView?.camera = sydney
        for location in annotationArray {
            //  print("----",annotationArray);
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
            marker.title = location["nameValue"] as? String
            marker.snippet = location["cityValue"] as? String
            marker.icon = UIImage(named:"map-markar")!
            marker.map = mapView
            
            
            self.locationManager?.startUpdatingLocation()
            
            
        }
        
    }
    
    
    
    
    func settingsTapped()
    {
        
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.dropDownTableView {
            return  dropDownList.count
        }
        return self.cuisines.count
        // return self.PhotoRefArray.count
        // return self.cuisineArray.count
        
    }
    func hideShowDropDown(isShown:Bool) -> Void {
        if isShown{
            self.isDropDowntableShown = false
            // self.dropDownTableView.isHidden = true
            self.setView(view: self.dropDownTableView, hidden: false,height: 0)
        }
        else{
            self.isDropDowntableShown = true
            //  self.dropDownTableView.isHidden = false
            self.setView(view: self.dropDownTableView, hidden: true,height: 150)
        }
    }
    //    func setView(view: UIView, hidden: Bool) {
    //        UIView.transition(with: view, duration: 2, options: .transitionCrossDissolve, animations: { _ in
    //            view.isHidden = hidden
    //        }, completion: nil)
    //    }
    
    func setView(view: UIView, hidden: Bool,height:Float) {
        UIView.transition(with: view, duration: 0.50, options: .transitionCrossDissolve, animations: { _ in
            //view.isHidden = hidden
            view.frame.size.height = CGFloat(height)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.dropDownTableView {
            return 30
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.dropDownTableView {
            let dropDownCell = UITableViewCell(style: .default, reuseIdentifier: "Ranjit")
            dropDownCell.selectionStyle = UITableViewCellSelectionStyle.none
            dropDownCell.backgroundColor = UIColor.black
            if indexPath.row == 0 || indexPath.row == 1{
                dropDownCell.textLabel?.text = (dropDownList[indexPath.row] as! String)+" "+"Mile"
            }
            else{
                dropDownCell.textLabel?.text = (dropDownList[indexPath.row] as! String)+" "+"Miles"
            }
            dropDownCell.textLabel?.textColor = UIColor.white
            dropDownCell.textLabel?.textAlignment = NSTextAlignment.center
            dropDownCell.textLabel?.font = UIFont(name:K_Font_Color, size: 13)
            // for fulll width of separator
            dropDownCell.preservesSuperviewLayoutMargins = false
            dropDownCell.separatorInset = UIEdgeInsets.zero
            dropDownCell.layoutMargins = UIEdgeInsets.zero
            return dropDownCell
            
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let scrollView = UIScrollView()
        scrollView.tag = indexPath.row
        
        //for adding scroll
        cell.contentView.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(0)
            make.bottom.equalTo(-2)
            //  make.width.equalTo(cell.contentView.snp.width).offset(-90)
            make.width.equalTo(cell.contentView.snp.width).offset(-95)
            make.top.equalTo(0)
        }
        scrollView.backgroundColor = UIColor.clear
        scrollView.layer.cornerRadius = 5
        scrollView.flashScrollIndicators()
        
        
        // for dynamically adding images
        var myImages =  ["dummy-img01", "dummy-img02", "dummy-img03"]
        let imageWidth: CGFloat = 260
        let imageHeight: CGFloat = 110
        var xPosition: CGFloat = 10
        var scrollViewContentSize: CGFloat = 0
        
        var count  = 0
        if  let result = self.cuisines[indexPath.row]["result"] as? Array<Dictionary<String,Any>>{
            count = result.count
        }
        for var i  in 0..<count {
            
            let textRestaurant = UILabel()
            let textDistance = UILabel()
            let textCuisine = UILabel()
            let viewInnerCircleImage = UIView()
            let userImageView = UIImageView()
            
            let myImage:UIImage = UIImage(named: myImages[i])!
            let myImageView:UIImageView = UIImageView()
            var cuisineDetail = ProfileCuisineFilter()
            
            
            var restaurantArray = [ProfileCuisineFilter]()
            if let restaurants = self.cuisineIndex[indexPath.row] as? [ProfileCuisineFilter]{
                restaurantArray = restaurants
                // print(restaurantArray.count)
                if restaurantArray.count > i{
                    
                    cuisineDetail = restaurantArray[ i]
                    //   if cuisineDetail.photo_ref.characters.count > 0 {
                    myImageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "bg.png"))
                    //   }
                    //                    for user in self.AnnotationArraymapData{
                    //                        if user.restaurantName.localizedCaseInsensitiveContains(cuisineDetail.restaurantName)
                    //                        {
                    //                             self.AnnotationArraymapData.append(cuisineDetail)
                    //                        }
                    //                    }
                }
                
            }
            //  print(scrollView.frame.origin.y)
            myImageView.frame.size.width = imageWidth
            myImageView.contentMode = UIViewContentMode.scaleAspectFill
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = scrollViewContentSize
            myImageView.frame.origin.y = scrollView.frame.origin.y
            //   myImageView.backgroundColor = UIColor.gray
            myImageView.alpha = 0.7
            myImageView.layer.cornerRadius = 5
            myImageView.tag = i
            myImageView.layer.masksToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            myImageView.isUserInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            
            // Added By Mohit
            
            let viewOverLay = UIView()
            viewOverLay.backgroundColor = UIColor.black
            viewOverLay.alpha = 0.60
            viewOverLay.frame.size.width = imageWidth
            viewOverLay.frame.size.height = imageHeight
            viewOverLay.frame.origin.x = scrollViewContentSize
            viewOverLay.frame.origin.y = scrollView.frame.origin.y
            // view.numberOfLines = 1
            // view.adjustsFontSizeToFitWidth = true
            // view.minimumScaleFactor = 0.2
            // view.font = UIFont(name:K_Font_Color,size:24)
            // view.textColor = UIColor.white
            viewOverLay.tag = i
            viewOverLay.layer.cornerRadius = 5
            
            let ViewtapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab_view(ViewtapGestureRecognizer:)))
            viewOverLay.isUserInteractionEnabled = true
            viewOverLay.addGestureRecognizer(ViewtapGestureRecognizer)
            
            
            // for label
            
            textRestaurant.frame.size.width = 260
            textRestaurant.frame.size.height = 40
            textRestaurant.frame.origin.x = scrollViewContentSize + 10
            textRestaurant.frame.origin.y = scrollView.frame.origin.y + 20
            
            
            textCuisine.frame.size.width = 260
            textCuisine.frame.size.height = 20
            textCuisine.frame.origin.x = scrollViewContentSize + 10
            textCuisine.frame.origin.y = scrollView.frame.origin.y + 60
            if let cuisnetext = self.cuisines[indexPath.row]["name"] as? String{
                textCuisine.text = cuisnetext
            }
            else{
                textCuisine.text = ""
            }
            
            textDistance.frame.size.width = 150
            textDistance.frame.size.height = 20
            textDistance.frame.origin.x = scrollViewContentSize + 10
            textDistance.frame.origin.y = scrollView.frame.origin.y + 82
            
            
            
            
            var imageUrl :String = ""
            
            viewInnerCircleImage.frame.size.width = 230
            viewInnerCircleImage.frame.size.height = 25
            viewInnerCircleImage.frame.origin.x = scrollViewContentSize + 35
            viewInnerCircleImage.frame.origin.y = scrollView.frame.origin.y + 75
            viewInnerCircleImage.backgroundColor = UIColor.clear
            
            //            let reviewImageView = UIImageView()
            //
            //            reviewImageView.backgroundColor = UIColor.gray
            //
            //            reviewImageView.layer.cornerRadius = 15
            //            reviewImageView.frame.size.width = 30
            //            reviewImageView.frame.size.height = 30
            //            reviewImageView.frame.origin.x = scrollViewContentSize + 190
            //            reviewImageView.frame.origin.y = scrollView.frame.origin.y + 75
            //            reviewImageView.clipsToBounds = true
            
            //             let ratingButton = UIButton(type: .custom)
            //            ratingButton.backgroundColor = UIColor.red
            //            ratingButton.frame.size.width = 30
            //                        ratingButton.frame.size.height = 30
            //                        ratingButton.frame.origin.x = scrollViewContentSize + 190
            //                        ratingButton.frame.origin.y = scrollView.frame.origin.y + 75
            //                        ratingButton.clipsToBounds = true
            
            
            scrollView.addSubview(myImageView)
            scrollView.addSubview(viewOverLay)
            scrollView.addSubview(textRestaurant)
            scrollView.addSubview(textCuisine)
            scrollView.addSubview(textDistance)
            
            //  var userImageView = UIImageView()
            if let result = self.cuisines[indexPath.row]["result"] as? Array<Dictionary<String,Any>>{
                if result.count > 0{
                    if  let review  = result[i]["review"] as? NSArray{
                        
                        //  var myVar: Int = Int(scrollViewContentSize) + 240
                        var myVar: Int =  225
                        for var j in 0..<review.count{
                            if let photoDict = review[j] as? NSDictionary{
                                if let profile  = photoDict["user_profile"] as? NSDictionary{
                                    if let image = profile["image_thumb"] as? String{
                                        
                                        if image.characters.count > 0 {
                                            imageUrl = K_IMAGE_BASE_URL + image
                                            
                                        }else{
                                            imageUrl = ""
                                            
                                        }
                                        //                                        if (imageUrl.characters.count) > 0
                                        //                                        {
                                        
                                        let spacer: CGFloat = 2
                                         let userImageView = UIImageView()
                                        userImageView.backgroundColor = UIColor.black
                                        // self.view.addSubview(userImageView)
                                        userImageView.layer.cornerRadius = 12
                                        userImageView.frame.size.width = 25
                                        userImageView.frame.size.height = 25
                                        userImageView.frame.origin.x = (CGFloat(myVar))
                                        // userImageView.frame.origin.y = scrollView.frame.origin.y + 75
                                        userImageView.frame.origin.y = 75
                                        userImageView.clipsToBounds = true
                                        
                                        //                                             userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "like"))
                                        //  userImageView.image = UIImage(named:"TasteInnerCircleIcondefault.png")
                                        if imageUrl.characters.count > 0
                                        {
                                            userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "TasteInnerCircleIcondefault.png"))
                                        }
                                        else{
                                            userImageView.image = UIImage(named:"TasteInnerCircleIcondefault.png")
                                            
                                        }
                                        
                                        //  userImageView.kf.setImage(with: URL(string:imageUrl))
                                         viewOverLay.addSubview(userImageView)//code commented
                                        //myImageView.addSubview(userImageView)//code commented
                                        
                                        //scrollView.addSubview(userImageView)
                                        myVar -= 25
                                        
                                        
                                        //   }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                }
                
            }
            
            
            
            
            // textDistance.text = "1.2 Miles"
            
            //parsing restaurant data and label
            
            if let result = self.cuisines[indexPath.row]["result"] as? Array<Dictionary<String,Any>>{
                if result.count > 0
                {
                    if  let restaurant  = result[i]["restaurant"] as? Dictionary<String,Any> {
                        if let restName  = restaurant["name"] as? String
                        {
                            textRestaurant.text = restName
                            self.nameRestaurant = restName
                        }
                        else{
                            textRestaurant.text  = ""
                            self.nameRestaurant = ""
                        }
                        if let restName  = restaurant["locality"] as? String
                        {
                            //textRestaurant.text = restName
                            self.cityString = restName
                        }
                        else{
                            //textRestaurant.text  = ""
                            self.cityString = ""
                        }
                        if let currentlat = restaurant["latitude"] as? Double{
                            self.latValueRestaurant = currentlat
                        }else{
                            self.latValueRestaurant=0.0
                        }
                        if let currentlon = restaurant["longitude"] as? Double{
                            self.longValueRestaurant = currentlon
                        }else{
                            self.longValueRestaurant = 0.0
                        }
                        
                        // let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
                        let singelton = SharedManager.sharedInstance
                        let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
                        let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude: self.longValueRestaurant)
                        
                        let distanceInMeters = coordinate1.distance(from: coordinate2)
                        let finaldist =  distanceInMeters / 1609.344
                        
                        
                        textDistance.text = String(format:"%.1f", finaldist) + " Miles"
                        var content = Dictionary<String,Any>()
                        content.updateValue(self.latValueRestaurant, forKey: "latvalue")
                        content.updateValue(self.longValueRestaurant, forKey: "longvalue")
                        content.updateValue(self.nameRestaurant, forKey: "nameValue")
                        content.updateValue(self.cityString , forKey: "cityValue")
                        
                        // self.annotationArray.append(content)
                        
                    }
                    else{
                        textRestaurant.text  = ""
                        textDistance.text = ""
                    }
                    
                }
            }
            // let result = self.cuisines[indexPath.row]["result"] as! Array<Dictionary<String,Any>>
            
            
            //end label
            
            let spacer: CGFloat = 5
            scrollViewContentSize  = imageWidth + spacer + scrollViewContentSize
            scrollView.contentSize = CGSize(width: scrollViewContentSize, height: imageHeight)
            
            
//            scrollView.addSubview(myImageView)
//            scrollView.addSubview(viewOverLay)
//            //   myImageView.layer.cornerRadius = 5
//            scrollView.addSubview(textRestaurant)
//            scrollView.addSubview(textCuisine)
//            scrollView.addSubview(textDistance)
//            scrollView.addSubview(userImageView)
            
            // scrollView.addSubview(viewInnerCircleImage)
            
            textRestaurant.textColor = UIColor.white
            textRestaurant.numberOfLines = 1
            textRestaurant.adjustsFontSizeToFitWidth = true
            textRestaurant.minimumScaleFactor = 0.2
            
            textRestaurant.font = UIFont(name:K_Font_Color_Regular,size:24)
            
            textCuisine.textColor = UIColor.white
            // textCuisine.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            textCuisine.font = UIFont(name:K_Font_Color,size:18)
            
            textDistance.textColor = UIColor.white
            textDistance.font = UIFont(name:K_Font_Color,size:18)
            
            
            
            
        }
        
        
        
        //for cuisine images
        let cusineImageView = UIImageView()
        cell.contentView.addSubview(cusineImageView)
        
        var isLogo = true
        if let name =  self.cuisines[indexPath.row]["name"] as? String{
            
            if name.hasPrefix("Middle Eastern") || name.hasSuffix("Mediterranean"){
                if let image  = UIImage(named: "Middle Eastern Mediterranean"){
                    cusineImageView.image = image
                }
                else
                {
                    cusineImageView.image = UIImage(named: "taste_logo")
                    isLogo = false
                }
                
            }
            else if name.hasPrefix("European") || name.hasSuffix("Continental"){
                if let image  = UIImage(named: "European Continental"){
                    cusineImageView.image = image
                }
                else
                {
                    cusineImageView.image = UIImage(named: "taste_logo")
                    isLogo = false
                }
                
            }
            else if name.hasPrefix("South American") || name.hasSuffix("Latin"){
                if let image  = UIImage(named: "South American"){
                    cusineImageView.image = image
                }
                else
                {
                    cusineImageView.image = UIImage(named: "taste_logo")
                    isLogo = false
                }
                
            }
            else if let image  = UIImage(named:name){
                cusineImageView.image = image
            }
            else
            {
                cusineImageView.image = UIImage(named: "taste_logo")
                isLogo = false
            }
            
        }
        else
        {
            cusineImageView.image = UIImage(named: "taste_logo")
            isLogo = false
        }
        
        if isLogo{
            cusineImageView.snp.makeConstraints { (make) in
                make.left.equalTo(25)
                // make.right.equalTo(0)
                //make.bottom.equalTo(-10)
                make.width.equalTo( 50)
                make.height.equalTo(50)
                make.top.equalTo(10)
            }
        }
        else{
            cusineImageView.snp.makeConstraints { (make) in
                make.left.equalTo(25)
                // make.right.equalTo(0)
                //make.bottom.equalTo(-10)
                make.width.equalTo( 46)
                make.height.equalTo(46)
                make.top.equalTo(10)
            }
        }
        
        //cusineImageView.image = UIImage(named: "American")
        cusineImageView.clipsToBounds = true
        cusineImageView.contentMode = UIViewContentMode.scaleAspectFit
        //        cusineImageView.layer.borderWidth = 3
        //        cusineImageView.layer.cornerRadius = 3.0
        //        cusineImageView.layer.borderColor = UIColor.black.cgColor
        cusineImageView.clipsToBounds = true
        
        
        //imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.8)
        
        
        
        //        let notifButton1 = UIButton(type: .custom)
        //        notifButton1.setImage(UIImage(named:"map_location_tranparent"), for: .normal)
        //        cell.contentView.addSubview(notifButton1)
        //        notifButton1.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.width.equalTo(40)
        //            make.height.equalTo(40)
        //            make.bottom.equalTo(-10)
        //        }
        //
        //        notifButton1.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        //        notifButton1.tag = indexPath.row
        
        
        
        let cuisineLabel = UILabel()
        cuisineLabel.text = ""
        
        cuisineLabel.text =  self.cuisines[indexPath.row]["name"] as? String
        // cuisineLabel.text =  "Medditarrean/Middle East"
        cuisineLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        cuisineLabel.font = UIFont(name: K_Font_Color_Bold, size: 9)
        //cuisineLabel.font = UIFont.bo
        cuisineLabel.textAlignment = .center
        //cuisineLabel.sizeToFit()
        cuisineLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cuisineLabel.numberOfLines = 2;
        cell.contentView.addSubview(cuisineLabel)
        cuisineLabel.snp.makeConstraints { (make) in
            //  make.left.equalTo(290)
            make.left.equalTo(0)
            // make.right.equalTo(0)
            
            make.width.equalTo( 100)
            make.height.equalTo(40)
            make.top.equalTo(cusineImageView.snp.bottom).offset(2)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-2)
            // make.centerX.equalTo(cusineImageView)
            
        }
        
        let cuisineClick = UIButton()
        cuisineClick.tag = indexPath.row
        cell.contentView.addSubview(cuisineClick)
        cuisineClick.snp.makeConstraints { (make) in
            //make.left.equalTo(300)
            make.left.equalTo(0)
            //make.right.equalTo(0)
            //make.bottom.equalTo(-10)
            make.width.equalTo( 60)
            make.height.equalTo(100)
        }
        
        cuisineClick.addTarget(self, action: #selector(self.cuisinesTapped), for: .touchUpInside)
        
        //        let textLabel = UILabel()
        //        textLabel.textColor = UIColor.black
        //        cell.contentView.addSubview(textLabel)
        //        textLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(50)
        //            make.right.equalTo(-20)
        //            make.centerY.equalTo(cell.contentView)
        //        }
        //        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        //textLabel.text = "Jim's China"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.dropDownTableView {
            
            self.filteredArrayOfBoth.removeAll()
            self.hideShowDropDown(isShown: isDropDowntableShown)
            
            
            
            //            let singelton = SharedManager.sharedInstance
            //            singelton.refeshRecommendation = "yes"
            
            self.getAdminRecommendation(mileStr:dropDownList[indexPath.row] as! String)
            //self.getRecommendation()
            
        }
    }
     // MARK: SAVE USER PROFILE DATA
    func saveUserProfileData(firstName:String, lastName:String,companyName:String, designation: String, email: String, userId: String, linkedinId: String, imageUrl:String,selected_miles:String)  {
        let plistFileName = "data.plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0] as NSString
        let plistPath = documentPath.appendingPathComponent(plistFileName)
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        //saving values
        dict.setObject(firstName, forKey:  "firstName" as NSCopying)
        dict.setObject(lastName, forKey:  "lastName" as NSCopying)
        dict.setObject(companyName, forKey:  "companyName" as NSCopying)
        dict.setObject(designation, forKey:  "designation" as NSCopying)
        dict.setObject(email, forKey:  "email" as NSCopying)
        dict.setObject(userId, forKey:  "userId" as NSCopying)
        dict.setObject(linkedinId, forKey:  "linkedinId" as NSCopying)
        dict.setObject(imageUrl, forKey:  "imageUrl" as NSCopying)
        dict.setObject(selected_miles, forKey:  "selected_miles" as NSCopying)
        
        
        //dict.removeObject(forKey: "firstName")
        
        //writing to Data.plist
        dict.write(toFile: plistPath, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: plistPath)
        // print("Saved Data.plist file is --> \(resultDictionary?.description)")
        
    }
    
     // MARK: CHECK WHETHER RECOMMENDATION CAN BE GENERATED OR NOT ON THE SPECIFIED LOCATION
    func checkRecomedation(mileStr:String, arrOfDict:[[String:Any]]) {
        
        //        let manager = Alamofire.SessionManager.default
        //        manager.session.configuration.timeoutIntervalForRequest = 30
        
        //SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        let latitude = singelton.latValueInitial
        let longitude = singelton.longValueInitial
        
        let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"miles":mileStr] as [String : Any]
        print(parameters)
        if Reachability.isConnectedToNetwork() == true
        {
            DataManager.sharedManager.checkRecomendationGet(params: parameters) { (responseObj) in
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                //  print(responseObj)
                if let dataDic = responseObj as? NSDictionary{
                    var resltArr = NSDictionary()
                    resltArr = dataDic
                    //print(resltArr)
                    if (resltArr["data"] as? Bool)!{
                        self.getRecommendation(selctedMiles: mileStr)
                    }
                    else{
                        
                        
                        if arrOfDict.count == 0{
                            
                            let alert = UIAlertController(title: "Taste", message:R_DO_NOT_HAVE_RECOMMENDATION, preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            return
                            
                            
                        }else{
                            
                            K_CURRENT_USER.selected_miles = mileStr
                            
                            self.saveUserProfileData(firstName:  K_CURRENT_USER.name, lastName: K_CURRENT_USER.lname, companyName:  K_CURRENT_USER.company, designation: K_CURRENT_USER.designation, email:  K_CURRENT_USER.email, userId:  K_CURRENT_USER.login_Id, linkedinId: K_CURRENT_USER.user_id, imageUrl: K_CURRENT_USER.image_url, selected_miles:K_CURRENT_USER.selected_miles)
                            
                            
                            if K_CURRENT_USER.selected_miles == "0.5" || K_CURRENT_USER.selected_miles == "1"{
                                self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Mile"
                            }
                            else{
                                self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Miles"
                            }
                            self.annotationArray.removeAll()
                            self.reloadRecommendationData(resultArr: arrOfDict as NSArray)
                            self.getAnnotationArray(recieveAllArray: arrOfDict as [[String:Any]])

                        }
                    }
                }
                else{
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
                        
                        K_CURRENT_USER.selected_miles = mileStr
                        
                        self.saveUserProfileData(firstName:  K_CURRENT_USER.name, lastName: K_CURRENT_USER.lname, companyName:  K_CURRENT_USER.company, designation: K_CURRENT_USER.designation, email:  K_CURRENT_USER.email, userId:  K_CURRENT_USER.login_Id, linkedinId: K_CURRENT_USER.user_id, imageUrl: K_CURRENT_USER.image_url, selected_miles:K_CURRENT_USER.selected_miles)
                        
                        if K_CURRENT_USER.selected_miles == "0.5" || K_CURRENT_USER.selected_miles == "1"{
                            self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Mile"
                        }
                        else{
                            self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Miles"
                        }
                        self.annotationArray.removeAll()
                        self.reloadRecommendationData(resultArr: arrOfDict as NSArray)
                        self.getAnnotationArray(recieveAllArray: arrOfDict as [[String:Any]])
                        
                    }
                }
            }
            
        }
        else
        {
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
     // MARK: GET THE ADMIN RECOMMENDATION FROM ADMIN PANEL
    func getAdminRecommendation(mileStr:String){
        
        SVProgressHUD.show()
        
        let singelton = SharedManager.sharedInstance
        let latitude = singelton.latValueInitial
        let longitude = singelton.longValueInitial
        let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"refresh":singelton.refeshRecommendation,"miles":K_CURRENT_USER.selected_miles] as [String : Any]
        
        if Reachability.isConnectedToNetwork() == true
        {
            DataManager.sharedManager.getAdminRecommendation(params: parameters) { (responseObj) in
                print(responseObj)
                if let dataDic = responseObj as? [String:Any]{
                    print(dataDic)
                    self.filteredArrayOfBoth = dataDic["data"] as! [[String : Any]]
                    
                    let miles = String.localizedStringWithFormat("%@", dataDic["user_selected_miles"] as! CVarArg )
                    K_CURRENT_USER.selected_miles = miles
                    print(self.filteredArrayOfBoth)
                    
                    self.checkRecomedation(mileStr: mileStr, arrOfDict: self.filteredArrayOfBoth)
                    
                    //                    if singelton.refeshRecommendation == "no"{
                    //                        let nc = NotificationCenter.default
                    //                        let myNotification = Notification.Name(rawValue:"NotificationRecommendation")
                    //                        nc.post(name:myNotification,
                    //                                object: nil,
                    //                                userInfo:["message":self.cuisines])
                    //                    }
                    //                    else{
                    //                        self.loadData()
                    //                    }
                }
                else{
                    self.checkRecomedation(mileStr: mileStr, arrOfDict: self.filteredArrayOfBoth)
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
    
     // MARK: GET THE RECOMMENDATION WHEN MILES FILTRATION IS PERFORMED
    func getRecommendation(selctedMiles:String) {
        
        //        let manager = Alamofire.SessionManager.default
        //        manager.session.configuration.timeoutIntervalForRequest = 30
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        let latitude = singelton.latValueInitial
        let longitude = singelton.longValueInitial
        
        let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"refresh":"yes","miles":selctedMiles] as [String : Any]
        // let parameters = ["user_id":singelton.loginId,"lat":"40.7127","long":"-74.005941"] as [String : Any]
        // print(parameters)
        if Reachability.isConnectedToNetwork() == true
        {
            DataManager.sharedManager.getRecommendation(params: parameters) { (responseObj) in
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                //  print(responseObj)
                if let dataDic = responseObj as? [String:Any]{
                    var resltArr = [[String:Any]]()
                    resltArr = dataDic["data"] as! [[String : Any]]
                    
                    for dic in resltArr {
                        self.filteredArrayOfBoth.append(dic)
                    }
                    let miles = String.localizedStringWithFormat("%@", dataDic["user_selected_miles"] as! CVarArg )
                    K_CURRENT_USER.selected_miles = miles
                    
                    self.saveUserProfileData(firstName:  K_CURRENT_USER.name, lastName: K_CURRENT_USER.lname, companyName:  K_CURRENT_USER.company, designation: K_CURRENT_USER.designation, email:  K_CURRENT_USER.email, userId:  K_CURRENT_USER.login_Id, linkedinId: K_CURRENT_USER.user_id, imageUrl: K_CURRENT_USER.image_url, selected_miles:K_CURRENT_USER.selected_miles)
                    
                    
                    if K_CURRENT_USER.selected_miles == "0.5" || K_CURRENT_USER.selected_miles == "1"{
                        self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Mile"
                    }
                    else{
                        self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Miles"
                    }
                    self.annotationArray.removeAll()
                    self.reloadRecommendationData(resultArr: self.filteredArrayOfBoth as NSArray)
                    self.getAnnotationArray(recieveAllArray: self.filteredArrayOfBoth as [[String:Any]])
                }
                else{
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
                        
                        if self.filteredArrayOfBoth.count == 0{
                            
                            let alert = UIAlertController(title: "Taste", message:R_DO_NOT_HAVE_RECOMMENDATION, preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            return

                            
                        }else{
                            
                            K_CURRENT_USER.selected_miles = selctedMiles
                            
                            self.saveUserProfileData(firstName:  K_CURRENT_USER.name, lastName: K_CURRENT_USER.lname, companyName:  K_CURRENT_USER.company, designation: K_CURRENT_USER.designation, email:  K_CURRENT_USER.email, userId:  K_CURRENT_USER.login_Id, linkedinId: K_CURRENT_USER.user_id, imageUrl: K_CURRENT_USER.image_url, selected_miles:K_CURRENT_USER.selected_miles)
                            
                            if K_CURRENT_USER.selected_miles == "0.5" || K_CURRENT_USER.selected_miles == "1"{
                                self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Mile"
                            }
                            else{
                                self.dropDownTextView.text = K_CURRENT_USER.selected_miles+" "+"Miles"
                            }
                            self.annotationArray.removeAll()
                            self.reloadRecommendationData(resultArr: self.filteredArrayOfBoth as NSArray)
                            self.getAnnotationArray(recieveAllArray: self.filteredArrayOfBoth as [[String:Any]])

                        }
                        
                    }
                }
                
            }
            
        }
        else
        {
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
    
     // MARK: RELOAD RECOMMENDATION DATA
    func reloadRecommendationData(resultArr:NSArray) -> Void {
        self.cuisines.removeAll()
        self.cuisineIndex.removeAll()
        self.selectedProfileIndex = 0
        self.selectedRestaurantIndex = 0
        
        self.cuisines = resultArr as! [[String : Any]]
        
        if self.cuisines.count > 0 {
            
            for var i  in 0..<self.cuisines.count
            {
                if  let result = self.cuisines[i]["result"] as? Array<Dictionary<String,Any>>
                {     for var j  in 0..<result.count{
                    if let result = self.cuisines[i]["result"] as? Array<Dictionary<String,Any>>{
                        if result.count > 0
                        {
                            topRecommendationLabel.text = "Recommendations"
                            if  let restaurant  = result[j]["restaurant"] as? Dictionary<String,Any> {
                                if let restName  = restaurant["name"] as? String
                                {
                                    
                                    self.nameRestaurant = restName
                                }
                                else{
                                    
                                    self.nameRestaurant = ""
                                }
                                if let restName  = restaurant["locality"] as? String
                                {
                                    //textRestaurant.text = restName
                                    self.cityString = restName
                                }
                                else{
                                    //textRestaurant.text  = ""
                                    self.cityString = ""
                                }
                                if let locCountry = restaurant["country"] as? String{
                                    self.countryString = locCountry
                                }
                                else{
                                    self.countryString = ""
                                }
                                
                                if let locState = restaurant["region"] as? String{
                                    self.stateString = locState
                                }
                                else{
                                    self.stateString = ""
                                }
                                if let locAddress = restaurant["address"] as? String{
                                    self.addressString = locAddress
                                }
                                else{
                                    self.addressString = ""
                                }
                                if let currentlat = restaurant["latitude"] as? Double{
                                    self.latValueRestaurant = currentlat
                                }else{
                                    self.latValueRestaurant=0.0
                                }
                                if let currentlon = restaurant["longitude"] as? Double{
                                    self.longValueRestaurant = currentlon
                                }else{
                                    self.longValueRestaurant = 0.0
                                }
                                
                                
                                if let locTel = restaurant["tel"] as? String{
                                    K_INNERUSER_DATA.Phone = locTel
                                }
                                else{
                                    K_INNERUSER_DATA.Phone = ""
                                }
                                if let locWebsite = restaurant["website"] as? String{
                                    K_INNERUSER_DATA.Website = locWebsite
                                }
                                else{
                                    K_INNERUSER_DATA.Website = ""
                                }
                                
                                if let hours = restaurant["hours_display"] as? String{
                                    K_INNERUSER_DATA.Hours = hours
                                }
                                else{
                                    K_INNERUSER_DATA.Hours = ""
                                }
                                
                                if let price = restaurant["price"] as? NSNumber
                                {
                                    K_INNERUSER_DATA.Price = String(format:"%@",price)
                                }
                                
                                if let rating = restaurant["rating"] as? NSNumber
                                {
                                    
                                    K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                                }
                                
                                if let cuisineName = self.cuisines[i]["name"] as? String {
                                    // K_INNERUSER_DATA.CuisineName =  cuisineName
                                    K_INNERUSER_DATA.CuisinSeleted =  cuisineName
                                }
                                else{
                                    K_INNERUSER_DATA.CuisinSeleted = ""
                                }
                                if let factual_id = restaurant["factual_id"] as? String{
                                    K_INNERUSER_DATA.FactualId = factual_id
                                }
                                else{
                                    K_INNERUSER_DATA.FactualId = ""
                                }
                                
                                if let restName  = restaurant["name"] as? String
                                {
                                    K_INNERUSER_DATA.RestaurantName = restName
                                }
                                else{
                                    K_INNERUSER_DATA.RestaurantName  = ""
                                }
                                
                                
                                
                                
                                
                                // var content = Dictionary<String,Any>()
                                //name
                                
                                var cusineDetail = ProfileCuisineFilter()
                                cusineDetail.restaurantName = self.nameRestaurant
                                cusineDetail.address = self.addressString
                                cusineDetail.city = self.cityString
                                cusineDetail.state = self.stateString
                                cusineDetail.country = self.countryString
                                cusineDetail.latitudeValue = self.latValueRestaurant
                                cusineDetail.longitudeValue = self.longValueRestaurant
                                cusineDetail.photo_ref = ""
                                cusineDetail.Placeid = ""
                                cusineDetail.Price = K_INNERUSER_DATA.Price
                                cusineDetail.phone = K_INNERUSER_DATA.Phone
                                cusineDetail.website = K_INNERUSER_DATA.Website
                                cusineDetail.hour = K_INNERUSER_DATA.Hours
                                cusineDetail.cuisineName =  K_INNERUSER_DATA.CuisinSeleted
                                // content.updateValue(cusineDetail, forKey: "restaurant")
                                self.cuisineArray.append(cusineDetail)
                                //  self.AnnotationArraymapData.append(cusineDetail)
                                // print(cusineDetail.restaurantName)
                                //print(self.cuisineArray.count)
                            }
                        }
                        // self.countGoogleApiHit(index:self.selectedProfileIndex)
                    }
                    }
                }
                else{
                    topRecommendationLabel.text = ""
                    
                }
                self.cuisineIndex.insert(self.cuisineArray as AnyObject, at: i)
                self.cuisineArray.removeAll()
            }
            topRecommendationLabel.isHidden = false
            self.dropDownTextView.isHidden = false  // added by ranjit 27
            self.dropDownImageView.isHidden = false
            
            AddToBank.isHidden = true
        }else{
            self.mapButton1.isHidden = true
            self.mapButton.isHidden = true
            topRecommendationLabel.isHidden = true
            self.dropDownTextView.isHidden = true  // added by ranjit 27
            self.dropDownImageView.isHidden = true
            AddToBank.isHidden = false
            self.titleRecommendation.isHidden = false
            self.titleRecommendation.text = "We do not have enough data to show the recommendations for you. Please try adding more bank accounts in settings section."
            self.titleRecommendation.textAlignment = .center
            self.titleRecommendation.numberOfLines = 4
            self.titleRecommendation.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.view.addSubview(self.titleRecommendation)
            self.titleRecommendation.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(topRecommendationLabel.snp.bottom).offset(140)
                //                make.centerX.equalTo(self.view)
                //                make.centerY.equalTo(self.view)
            }
            AddToBank.backgroundColor = UIColor.black
            AddToBank.addTarget(self, action: #selector(self.AddAccount), for: .touchUpInside)
            AddToBank.setTitle("ADD ACCOUNT", for: .normal)
            AddToBank.setTitleColor(UIColor.white, for: .normal)
            self.view.addSubview(AddToBank)
            AddToBank.snp.makeConstraints { (make) in
                // make.bottom.equalTo(self.view.snp.bottom).offset(-100)
                make.height.equalTo(50)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(self.titleRecommendation.snp.bottom).offset(30)
            }
            
        }
        self.countGoogleApiHit()
        
    }
    
     // MARK: ACTION WHEN PRESS ON LOCATION MARKER ON MAP
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        // print("test",marker.title)
        //   print("Data is ",self.annotationArray)
        
        //        var cuisineDetails = ProfileCuisineFilter()
        //        //var restaurantArray = [ProfileCuisineFilter]()
        //
        //        for var i in 0..<self.AnnotationArraymapData.count{
        //        if let restaurants = self.AnnotationArraymapData[i] as? String{
        //          //  restaurantArray = restaurants
        //            cuisineDetails = restaurants[ i] as? [ProfileCuisineFilter]
        //
        //            print(cuisineDetails.restaurantName)
        //        }
        //
        //        }
        var cuisineDetails = ProfileCuisineFilter()
        for user in self.AnnotationArraymapData{
            cuisineDetails = user
            if cuisineDetails.restaurantName == marker.title{
                //   print("Rest name is",cuisineDetails.restaurantName)
                //  print(cuisineDetails.city)
                K_INNERUSER_DATA.RestaurantName = cuisineDetails.restaurantName
                K_INNERUSER_DATA.cityname = cuisineDetails.city
                K_INNERUSER_DATA.latvalueNavigate = cuisineDetails.latitudeValue
                K_INNERUSER_DATA.longvalueNavigate = cuisineDetails.longitudeValue
                K_INNERUSER_DATA.Address = cuisineDetails.address
                K_INNERUSER_DATA.CITY = cuisineDetails.city
                K_INNERUSER_DATA.State = cuisineDetails.state
                K_INNERUSER_DATA.Country = cuisineDetails.country
                K_INNERUSER_DATA.Photo_Ref = cuisineDetails.photo_ref
                K_INNERUSER_DATA.placeId = cuisineDetails.Placeid
                K_INNERUSER_DATA.Price = cuisineDetails.Price
                K_INNERUSER_DATA.Website = cuisineDetails.website
                K_INNERUSER_DATA.Phone = cuisineDetails.phone
                K_INNERUSER_DATA.CuisinSeleted = cuisineDetails.cuisineName
                //                print(cuisineDetails.latitudeValue)
                //                print(cuisineDetails.longitudeValue)
                //                print(cuisineDetails.address)
                //                print(cuisineDetails.state)
                //                print(cuisineDetails.country)
                //                print(cuisineDetails.photo_ref)
                //                print(cuisineDetails.Placeid)
            }
        }
        
        //         var cusineDetail = ProfileCuisineFilter()
        //        for var i in 0..<self.AnnotationArraymapData.count  {
        //
        //             var cuisineDetail = ProfileCuisineFilter()
        //
        //            print("----",cuisineDetail.restaurantName)
        //
        //            var restaurantArray = [ProfileCuisineFilter]()
        //            if let restaurants = self.AnnotationArraymapData[i] as? [ProfileCuisineFilter]{
        //                restaurantArray = restaurants
        //                print(cuisineDetail.restaurantName)
        //                print(restaurantArray.count)
        //                if restaurantArray.count > i{
        //
        //
        //
        //                }
        //
        //            }
        //
        //
        //
        //
        //            if let name =  annotationArray  [i] ["nameValue"] as? String{
        ////                if name == marker.title {
        ////
        ////
        ////
        ////
        ////                    if let city =  annotationArray  [i] ["cityValue"] {
        ////                        K_INNERUSER_DATA.cityname = city as! String
        ////
        ////                    }
        ////                    if  let name =  annotationArray  [i] ["nameValue"] {
        ////                        K_INNERUSER_DATA.name = name as! String
        ////
        ////                    }
        ////                    let latNavigate =  annotationArray  [i] ["latvalue"] as! Double
        ////                    K_INNERUSER_DATA.latvalueNavigate = latNavigate
        ////
        ////
        ////
        ////                    let longNavigate =  annotationArray  [i] ["longvalue"] as! Double
        ////                    K_INNERUSER_DATA.longvalueNavigate = longNavigate
        ////
        ////
        ////
        ////                    if let Phone_no =  annotationArray  [i] ["user_tel"] {
        ////                        K_INNERUSER_DATA.Phone = Phone_no as! String
        ////                    }else{
        ////
        ////                    }
        ////
        ////                    if let web =  annotationArray  [i] ["user_website"]{
        ////                        K_INNERUSER_DATA.Website = web as! String
        ////
        ////                    }
        ////
        ////                    if let Hour_count =  annotationArray  [i] ["user_hours_display"] {
        ////                        K_INNERUSER_DATA.Hours = Hour_count as! String
        ////
        ////                    }
        ////
        ////                    if let user_add =  annotationArray  [i] ["Address"]{
        ////                        K_INNERUSER_DATA.Address = user_add as! String
        ////
        ////                    }
        ////
        ////                    if let factualID =  annotationArray  [i] ["factualId"] {
        ////                        K_INNERUSER_DATA.FactualId = factualID as! String
        ////
        ////                    }
        ////
        ////
        ////
        ////
        ////                    var cuisineDetail = ProfileCuisineFilter()
        ////                    cuisineDetail = cuisineArray[i]
        ////                    K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
        ////
        ////                    K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
        ////
        ////
        ////                    K_INNERUSER_DATA.RestaurantName = cuisineDetail.restaurantName
        ////
        ////                    K_INNERUSER_DATA.Price = cuisineDetail.Price
        ////                    K_INNERUSER_DATA.Rating = cuisineDetail.rating
        ////
        ////
        ////                    //                    var content = Dictionary<String,Any>()
        ////                    //                    content.updateValue(PhotoRef, forKey: "Photo_Ref")
        ////                    //                    content.updateValue(NameOfRest, forKey: "NameOfRest")
        ////                    //                    self.MarkerClickArray.append(content)
        ////                }
        //
        //            }
        //
        //        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func tab_view(ViewtapGestureRecognizer: UITapGestureRecognizer)
    {
        //   let tapLocation = tapGestureRecognizer.view as! UIScrollView
        // print(tapLocation.tag)
        
        let tappedImage = ViewtapGestureRecognizer.view!
        if let superView = tappedImage.superview {
            
            if let cell = superView.superview?.superview as? UITableViewCell {
                
                let index =  self.tableView.indexPath(for: cell)
                
                if  let result = self.cuisines[(index?.row)!]["result"] as? Array<Dictionary<String,Any>>{
                    if result.count > 0{
                        let restaurant  = result[tappedImage.tag]["restaurant"] as! Dictionary<String,Any>
                        
                        if let locAddress = restaurant["address"] as? String{
                            K_INNERUSER_DATA.Address=locAddress
                        }
                        else{
                            K_INNERUSER_DATA.Address=""
                        }
                        
                        if let locCity = restaurant["locality"] as? String{
                            K_INNERUSER_DATA.CITY = locCity
                        }
                        else{
                            K_INNERUSER_DATA.CITY=""
                        }
                        if let locCountry = restaurant["country"] as? String{
                            K_INNERUSER_DATA.Country = locCountry
                        }
                        else{
                            K_INNERUSER_DATA.Country=""
                        }
                        
                        if let locState = restaurant["region"] as? String{
                            K_INNERUSER_DATA.State = locState
                        }
                        else{
                            K_INNERUSER_DATA.State = ""
                        }
                        if let locZip = restaurant["postcode"] as? NSNumber{
                            K_INNERUSER_DATA.ZIP = locZip.stringValue
                        }
                        else{
                            K_INNERUSER_DATA.ZIP = ""
                        }
                        if let locTel = restaurant["tel"] as? String{
                            K_INNERUSER_DATA.Phone = locTel
                        }
                        else{
                            K_INNERUSER_DATA.Phone = ""
                        }
                        if let locWebsite = restaurant["website"] as? String{
                            K_INNERUSER_DATA.Website = locWebsite
                        }
                        else{
                            K_INNERUSER_DATA.Website = ""
                        }
                        
                        if let hours = restaurant["hours_display"] as? String{
                            K_INNERUSER_DATA.Hours = hours
                        }
                        else{
                            K_INNERUSER_DATA.Hours = ""
                        }
                        
                        if let price = restaurant["price"] as? NSNumber
                        {
                            K_INNERUSER_DATA.Price = String(format:"%@",price)
                        }
                        
                        if let rating = restaurant["rating"] as? NSNumber
                        {
                            
                            K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                        }
                        
                        if let cuisineName = self.cuisines[(index?.row)!]["name"] as? String {
                            K_INNERUSER_DATA.CuisinSeleted = cuisineName
                        }
                        else{
                            K_INNERUSER_DATA.CuisinSeleted = ""
                        }
                        if let factual_id = restaurant["factual_id"] as? String{
                            K_INNERUSER_DATA.FactualId = factual_id
                        }
                        else{
                            K_INNERUSER_DATA.FactualId = ""
                        }
                        
                        if let restName  = restaurant["name"] as? String
                        {
                            K_INNERUSER_DATA.RestaurantName = restName
                        }
                        else{
                            K_INNERUSER_DATA.RestaurantName  = ""
                        }
                        // added by ranjit
                        if let restName  = restaurant["latitude"] as? Double
                        {
                            K_INNERUSER_DATA.latvalueNavigate = restName
                        }
                        else{
                            K_INNERUSER_DATA.latvalueNavigate  = 0.0
                        }
                        
                        if let restName  = restaurant["longitude"] as? Double
                        {
                            K_INNERUSER_DATA.longvalueNavigate = restName
                        }
                        else{
                            K_INNERUSER_DATA.longvalueNavigate  = 0.0
                        }
                        var cuisineDetail = ProfileCuisineFilter()
                        
                        
                        
                        // if self.cuisineIndex.count > self.selectedProfileIndex{
                        
                        var restaurantArray = [ProfileCuisineFilter]()
                        if let restaurants = self.cuisineIndex[(index?.row)!] as? [ProfileCuisineFilter]{
                            restaurantArray = restaurants
                            // print(restaurantArray.count)
                            // if restaurantArray.count > (index?.row)!{
                            
                            cuisineDetail = restaurantArray[tappedImage.tag]
                            if cuisineDetail.photo_ref.characters.count > 0 {
                                K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                                K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                            }
                            else{
                                K_INNERUSER_DATA.Photo_Ref = ""
                                K_INNERUSER_DATA.placeId = ""
                            }
                            //}
                            
                            
                        }
                        else{
                            K_INNERUSER_DATA.Photo_Ref = ""
                            K_INNERUSER_DATA.placeId = ""
                        }
                        
                        
                        //print(tappedImage.tag)
                        // cuisineDetail = cuisineArray[tappedImage.tag]
                        //K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                        //K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                // print(restaurant)
                
                // textLabelImage.text = restaurant["name"] as? String
                
                
                
                
                
                
                
                
            }
        }
    }
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //   let tapLocation = tapGestureRecognizer.view as! UIScrollView
        // print(tapLocation.tag)
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if let superView = tappedImage.superview {
            
            if let cell = superView.superview?.superview as? UITableViewCell {
                
                let index =  self.tableView.indexPath(for: cell)
                
                if  let result = self.cuisines[(index?.row)!]["result"] as? Array<Dictionary<String,Any>>{
                    if result.count > 0{
                        let restaurant  = result[tappedImage.tag]["restaurant"] as! Dictionary<String,Any>
                        
                        if let locAddress = restaurant["address"] as? String{
                            K_INNERUSER_DATA.Address=locAddress
                        }
                        else{
                            K_INNERUSER_DATA.Address=""
                        }
                        
                        if let locCity = restaurant["locality"] as? String{
                            K_INNERUSER_DATA.CITY = locCity
                        }
                        else{
                            K_INNERUSER_DATA.CITY=""
                        }
                        if let locCountry = restaurant["country"] as? String{
                            K_INNERUSER_DATA.Country = locCountry
                        }
                        else{
                            K_INNERUSER_DATA.Country=""
                        }
                        
                        if let locState = restaurant["region"] as? String{
                            K_INNERUSER_DATA.State = locState
                        }
                        else{
                            K_INNERUSER_DATA.State = ""
                        }
                        if let locZip = restaurant["postcode"] as? NSNumber{
                            K_INNERUSER_DATA.ZIP = locZip.stringValue
                        }
                        else{
                            K_INNERUSER_DATA.ZIP = ""
                        }
                        if let locTel = restaurant["tel"] as? String{
                            K_INNERUSER_DATA.Phone = locTel
                        }
                        else{
                            K_INNERUSER_DATA.Phone = ""
                        }
                        if let locWebsite = restaurant["website"] as? String{
                            K_INNERUSER_DATA.Website = locWebsite
                        }
                        else{
                            K_INNERUSER_DATA.Website = ""
                        }
                        
                        if let hours = restaurant["hours_display"] as? String{
                            K_INNERUSER_DATA.Hours = hours
                        }
                        else{
                            K_INNERUSER_DATA.Hours = ""
                        }
                        
                        if let price = restaurant["price"] as? NSNumber
                        {
                            K_INNERUSER_DATA.Price = String(format:"%@",price)
                        }
                        
                        if let rating = restaurant["rating"] as? NSNumber
                        {
                            
                            K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                        }
                        
                        if let cuisineName = self.cuisines[(index?.row)!]["name"] as? String {
                            K_INNERUSER_DATA.CuisinSeleted =  cuisineName
                        }
                        else{
                            K_INNERUSER_DATA.CuisinSeleted = ""
                        }
                        if let factual_id = restaurant["factual_id"] as? String{
                            K_INNERUSER_DATA.FactualId = factual_id
                        }
                        else{
                            K_INNERUSER_DATA.FactualId = ""
                        }
                        
                        if let restName  = restaurant["name"] as? String
                        {
                            K_INNERUSER_DATA.RestaurantName = restName
                        }
                        else{
                            K_INNERUSER_DATA.RestaurantName  = ""
                        }
                        
                        // added by ranjit
                        if let restName  = restaurant["latitude"] as? Double
                        {
                            K_INNERUSER_DATA.latvalueNavigate = restName
                        }
                        else{
                            K_INNERUSER_DATA.latvalueNavigate  = 0.0
                        }
                        
                        if let restName  = restaurant["longitude"] as? Double
                        {
                            K_INNERUSER_DATA.longvalueNavigate = restName
                        }
                        else{
                            K_INNERUSER_DATA.longvalueNavigate  = 0.0
                        }
                        var cuisineDetail = ProfileCuisineFilter()
                        
                        
                        
                        // if self.cuisineIndex.count > self.selectedProfileIndex{
                        
                        var restaurantArray = [ProfileCuisineFilter]()
                        if let restaurants = self.cuisineIndex[(index?.row)!] as? [ProfileCuisineFilter]{
                            restaurantArray = restaurants
                            //  print(restaurantArray.count)
                            // if restaurantArray.count > (index?.row)!{
                            
                            cuisineDetail = restaurantArray[tappedImage.tag]
                            if cuisineDetail.photo_ref.characters.count > 0 {
                                K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                                K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                            }
                            else{
                                K_INNERUSER_DATA.Photo_Ref = ""
                                K_INNERUSER_DATA.placeId = ""
                            }
                            //}
                            
                            
                        }
                        else{
                            K_INNERUSER_DATA.Photo_Ref = ""
                            K_INNERUSER_DATA.placeId = ""
                        }
                        
                        
                        //print(tappedImage.tag)
                        // cuisineDetail = cuisineArray[tappedImage.tag]
                        //K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                        //K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                // print(restaurant)
                
                // textLabelImage.text = restaurant["name"] as? String
                
                
                
                
                
                
                
                
            }
        }
    }
    
     // MARK: GO TO RELATED CUISINE SCREEN
    func cuisinesTapped(sender:UIButton){
        /* let buttonRow = sender.tag
         
         let vc = ProfileCuisineFilterViewController()
         if let cuisineName = self.cuisines[buttonRow]["name"] as? String{
         vc.cuisineName = cuisineName
         vc.filterName = "cuisines"
         self.navigationController?.pushViewController(vc, animated: true)
         }
         */
        
        // print(vc.cuisineName)
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            let buttonRow = sender.tag
            
            let vc = RecommendationCuisineViewController()
            if let cuisineName = self.cuisines[buttonRow]["name"] as? String{
                vc.cuisineName = cuisineName
                //vc.filterName = "cuisines"
                self.navigationController?.pushViewController(vc, animated: true)
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
    func viewNotifications() {
        
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "NotificatioinsViewController") as! NotificatioinsViewController
        //        vc.RecvarrNotification = self.arrNotification
        //
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            let vc = NotificatioinsViewController() as NotificatioinsViewController
            // vc.RecvarrNotification = self.arrNotification
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
    
    func viewAnalytics() {
        //        let vc = AnalyticsViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
        Mixpanel.sharedInstance()?.track("Dining_Profile_Action",
                                         properties: ["Plan" : "Premium"])
        
        Analytics.logEvent("Dining_Profile_Action", parameters: nil)
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RAnalyticViewController") as! RAnalyticViewController
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
    func exploreScreen() {
        // let vc = ExploreRecommendationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExploreTabViewController")
            as! ExploreTabViewController
        vc.screenName = "ProfileView"
        self.tabBarController?.selectedIndex = 0
        // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showProfileAnalytics() {
        // let vc = ProfileAnalyticsViewController()
        //  self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func notificationbutton (){
        
        // added by ranjit 17 jan
        
        //          if K_INNERUSER_DATA.countvalue == 0{
        //            notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
        //
        //        }
        //        else{
        //            notifButton.setImage(UIImage(named:"BellWithRed"), for: .normal)
        //        }
        //        self.view.addSubview(notifButton)
        //        notifButton.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(titleLabel.snp.centerY)
        //            make.width.equalTo(35)
        //            make.height.equalTo(35)
        //        }
        //        notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        //         self.view.isUserInteractionEnabled = true
    }
    
    // MARK: GET THE NOTIFICATION
    func NotificationMethod() {
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
            let singelton = SharedManager.sharedInstance
            //singelton.loginId = K_CURRENT_USER.login_Id
            let parameters = ["user_id":singelton.loginId, "page":"0"] as [String : Any]
            
            
            
            DataManager.sharedManager.getNotification(params: parameters) { (response) in
                
                
                
                if let dataDic = response as?  Array<Dictionary<String,Any>>
                    
                {
                    // print("Notification Data",dataDic)
                    self.arrNotification = dataDic
                    
                    if self.arrNotification.count > 0
                    {
                        self.notificationbutton()
                        // self.viewDidLoad()
                        
                    }
                    else
                    {
                        
                        SVProgressHUD.dismiss()
                        self.notificationbutton()
                        //                    let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
                        //                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        //                        UIAlertAction in
                        //                        NSLog("OK Pressed")
                        //                    }
                        //                    alert.addAction(okAction)
                        //                    self.present(alert, animated: true, completion: nil)
                        //                    return
                        
                        
                    }
                    
                    //                print("notification array is \(self.arrNotification)")
                    //                print("array data is \(self.arrNotification)")
                    
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
                DispatchQueue.main.async {
                    
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
    
    //MARK: Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placeMarks, error) in
            if error == nil {
                if (placeMarks?.count)! > 0 {
                    let pm = placeMarks![0]
                    let strLocality = pm.locality
                    let strState = pm.administrativeArea
                    
                    
                    let strConCat = strLocality!  + "," + " " + strState!
                    //  print("location is",strConCat)
                    self.locationLabel.text = strConCat //pm.locality
                    if let rLatValue = (self.locationManager?.location?.coordinate.latitude){
                        self.latValue = rLatValue
                    }
                    if let rLongVal = (self.locationManager?.location?.coordinate.longitude){
                        self.longValue = rLongVal
                    }
                    
                    
                    //  print(self.latValue,self.longValue)
                }
            }
        }
        
        let location = locations.first
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        self.mapView?.animate(to: camera)
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
}
