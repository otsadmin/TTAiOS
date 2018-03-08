//
//  ExploreRecommendationController.swift
//  Taste
//
//  Created by Lalit Mohan on 18/05/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import Kingfisher
import MapKit
import CoreLocation
import GoogleMaps

class ExploreRecommendationController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate
{
    
    var banks = [[String:Any]]()
    var userData = [[String:Any]]()
    let texts = ["AMERICAN EXPRESS", "AMERICA", "BANK OF AMERICA", "CAPITAL ONE" ,"CHASE BANK" , "CITI BANK" , "CITIZENS BANK"]
    var tableView:UITableView!
    var filtering = false
    var filteredBanks = [[String:Any]]()
    var  isloading  = true
    var replaced : String?
    var screenName :String?
    let textFieldSearch = UITextField()
    
    var whiteBarView:UIView!
    var mapWrapperView:UIView!
    
    var lat : Double = 0.0
    var long  : Double =  0.0
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    var cuisineName = ""
    var cityName = ""
    var mapView:GMSMapView!
    
    var cuisinesFilter = [[String:Any]]()
    var cuisinesPageFilter = [[String:Any]]()
    var coordinate : [String:Any]?
    let newPin = MKPointAnnotation()
    var nameRestaurant:String = ""
    var address:String = ""
    var city : String = ""
    var stateString = ""
    var countryString = ""
    var postCode:String = ""
    var filterName = ""
    var hitWithName = false
    //var annotationArray = [[String:Any]]()
    var latValue : Double = 0.0
    var longValue : Double = 0.0
    var latValueRestaurant : Double = 0.0
    var longValueRestaurant : Double = 0.0
    var imageView = UIImageView()
    var j = 0
    var cuisineArray = [ProfileCuisineFilter]()
    var addressString = ""
    var cityString = ""
    var pageNo = 1
    var maxRow = 0
    // var ProfileImagesArray = [ProfileImages]()
    var PhotoRefArray = [[String:Any]]()
    var PlaceIdArray = [[String:Any]]()
    var selectedProfileIndex = 0
    var RestaurantResultArray = [[String:Any]]()
    var filteredUserProfileArray = [ProfileCuisineFilter]()
    var annotationArray = [ProfileCuisineFilter]()
    var london: GMSMarker?
    var londonView: UIImageView?
    var optionFilter:String = ""
    var optionPriceFilter :String = ""
    var optionCuisineFilter :String = ""
    var isSearchChange:String = "0"
    var isNotRefresh:Bool = true
    let myNotification = Notification.Name(rawValue:"NotificationExploreFilter")
    let myNotificationNotRefresh = Notification.Name(rawValue:"NotificationExploreRecommendationNotRefresh")
    let titleLabel = UILabel()
    var settingsButton = UIButton(type: .custom)
    let backButton = UIButton(type: .custom)
    var filterButton = UIButton(type: .custom)
    let leftImageView = UIImageView()
    var mapButton1 = UIButton(type: .custom)
    let titleLabel2 = UILabel()
    var settingsButtonWrapper = UIButton(type: .custom)
    var mapButton = UIButton(type: .custom)
    let titleExplore = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("hello")
        
        
    }
    deinit {
        print("hello")
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        let ncRefresh = NotificationCenter.default
        ncRefresh.addObserver(forName:myNotificationNotRefresh, object:nil, queue:nil, using:catchNotificationRefresh)
        print("status",self.isNotRefresh)
        if self.isNotRefresh == true{
            if mapWrapperView != nil{
                if mapView != nil{
                    mapWrapperView.isHidden = true
                    mapView.isHidden = true
                    
                }
            }
            else{
                mapButton1.isHidden = false
            }
        }
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
            if  self.screenName == "ExploreRecommendation"{
              self.isNotRefresh = true
                self.screenName = ""
            }
            else{
                if self.isNotRefresh == true{
                    if self.cuisineArray.count > 0{
                        self.cuisineArray.removeAll()
                        self.filteredUserProfileArray.removeAll()
                        self.cuisinesFilter.removeAll()
                        self.selectedProfileIndex = 0
                        self.PhotoRefArray.removeAll()
                        self.pageNo = 1
                        self.j = 0
                        
                    }
                    self.pageNo = 1
                    self.setupView()
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
    func catchNotification(notification:Notification) -> Void {
        //  print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let optionSource  = userInfo["source"] as? String,
            let optionPrice  = userInfo["price"] as? String,
            let optionCuisine  = userInfo["cuisine"] as? String,
            let optionSearch = userInfo["searchFilter"] as? String
            else {
                // print("No userInfo recommendation in notification")
                return
        }
        self.screenName = ""
        self.optionFilter = optionSource
        self.optionPriceFilter = optionPrice
        self.optionCuisineFilter = optionCuisine
        self.isSearchChange = optionSearch
        //  print("all value is", self.optionFilter, self.optionPriceFilter, self.optionCuisineFilter,self.isSearchChange)
        self.cuisineArray.removeAll()
        self.filteredUserProfileArray.removeAll()
        self.cuisinesFilter.removeAll()
        self.selectedProfileIndex = 0
        self.PhotoRefArray.removeAll()
        self.pageNo = 0
        self.j = 0
        filtering = false
        textFieldSearch.text = ""
        self.titleExplore.isHidden = true
        
        
        
        //self.selectedRestaurantIndex = 0
        // self.setupView()
        //self.loadTableViewData()
    }
    func catchNotificationRefresh(notification:Notification) -> Void {
        //  print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let optionSource  = userInfo["screenName"] as? String
            else {
                //  print("No userInfo recommendation in notification")
                return
        }
        self.screenName = optionSource
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        
        // self.hideMap()
        
        if self.isNotRefresh == true{
            let nc1 = NotificationCenter.default
            nc1.removeObserver(self, name: myNotificationNotRefresh, object: nil)
            self.cuisineArray.removeAll()
            self.filteredUserProfileArray.removeAll()
            self.cuisinesFilter.removeAll()
            self.selectedProfileIndex = 0
            self.PhotoRefArray.removeAll()
            self.pageNo = 0
            self.j = 0
            filtering = false
            textFieldSearch.text = ""
            self.titleExplore.isHidden = true
            self.tableView.removeFromSuperview()

            
            
        }
        else{
            //            if mapWrapperView.isHidden == false{
            //                mapWrapperView.isHidden = true
            //                mapView.isHidden = true
            //            }
            
            if self.isNotRefresh == true{
                tableView.delegate = nil
                tableView.dataSource = nil
                if mapWrapperView != nil{
                    if mapView != nil{
                        mapWrapperView.isHidden = true
                        mapView.isHidden = true
                        
                    }
                }

            }
            let nc = NotificationCenter.default
            nc.removeObserver(self, name: myNotification, object: nil)
        }
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isNotRefresh == true{
            mapView?.delegate = nil
            mapView?.removeFromSuperview()
            mapView = nil
            if mapWrapperView != nil{
                mapWrapperView.removeFromSuperview()
                mapWrapperView = nil
            }
        }
        
        
    }
    func goBack()
    {
          self.screenName = ""
        self.isNotRefresh = true
         self.tabBarController?.selectedIndex =  1
      
       // _ = self.navigationController?.popViewController(animated: true)
       
    }
    
    // MARK:SETUP VIEW
    
    func setupView() {
        
        self.view.backgroundColor = UIColor.white
        
        
        titleLabel.text = "EXPLORE"
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
        
     /*   if screenName == "ProfileView"
        {
            //   let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(named:"ic_back"), for: .normal)
            backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
            self.view.addSubview(backButton)
            backButton.snp.makeConstraints { (make) in
                make.left.equalTo(10)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalTo(titleLabel.snp.centerY)
            }
            
        }
 */
        
    
            backButton.setImage(UIImage(named:"ic_back"), for: .normal)
            backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
            self.view.addSubview(backButton)
            backButton.snp.makeConstraints { (make) in
                make.left.equalTo(10)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalTo(titleLabel.snp.centerY)
            }
            
       
        
        //let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named:"ic_filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(self.goforward), for: .touchUpInside)
        self.view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        
        //let textField = UITextField()
        textFieldSearch.delegate = self
        self.view.addSubview(textFieldSearch)
        textFieldSearch.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
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
        
        // let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "ic_search")
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        textFieldSearch.leftViewMode = .always
        textFieldSearch.leftView = leftView
        //textField.leftView = UIImageView(image: UIImage(named: "ic_search"))
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.separatorColor = UIColor.clear
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            //make.bottom.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            make.top.equalTo(textFieldSearch.snp.bottom).offset(25)
        }
        tableView.tableFooterView = UIView()
        //Border Color of TableView
        
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.clear.cgColor
        tableView.layer.borderWidth = 2.0
        
        //Corner Radius
        
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        
        //  let mapButton1 = UIButton(type: .custom)
        mapButton1.setImage(UIImage(named:"map_location_tranparent"), for: .normal)
        mapButton1.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        self.view.addSubview(mapButton1)
        mapButton1.snp.makeConstraints { (make) in
            /*   make.right.equalTo(self.view.snp.right).offset(-20)
             make.width.equalTo(40)
             make.height.equalTo(40)
             make.top.equalTo(self.view.snp.bottom).offset(-90)
             */
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            make.bottom.equalTo(-50)
            //make.centerY.equalTo(titleCuisine.snp.centerY)
        }
        mapButton1.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        
        
        self.loadTableViewData()
        
    }
    
    func loadTableViewData(){
        
        print("count ------ ",cuisineArray.count)
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            
                        let latitude = singelton.latValueInitial
                        let longitude = singelton.longValueInitial
//            let latitude = "40.7127"
//            let longitude = "-74.005941"
            // let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"page":self.pageNo,"is_filter":"0"] as [String : Any]
            //            if isSearchChange == "0"{
            //                isSearchChange = "0"
            //            }
            //            else{
            //                isSearchChange = "1"
            //            }
            var parameters:[String : Any]
            // let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"page":self.pageNo,"is_filter":"0"] as [String : Any]
            if isSearchChange == "0"{
                parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"page":self.pageNo,"is_filter":isSearchChange] as [String : Any]
            }
            else{
                parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"cuisine":self.optionCuisineFilter,"price":self.optionPriceFilter,"source":self.optionFilter,"page":self.pageNo,"is_filter":isSearchChange] as [String : Any]
            }
            
           //  print("pa---------",parameters)
            DataManager.sharedManager.getExploreDetail(params: parameters, completion: { (response) in
                if let dataDic = response as? [[String:Any]]
                {
                    self.cuisinesPageFilter = dataDic
                    //  print(dataDic)
                    
                    
                    
                    if self.cuisinesPageFilter.count > 0
                    {    // print("asd",self.cuisinesFilter.count)
                        self.cuisinesFilter.append(contentsOf: self.cuisinesPageFilter)
                        // print("------value",self.cuisinesFilter.count,self.j)
                        while self.j < self.cuisinesFilter.count
                        {
                            
                            // print(self.cuisinesFilter.count,self.j)
                            self.isloading = false
                            if let name = self.cuisinesFilter[self.j]["name"] as? String{
                                self.nameRestaurant = name
                            }
                            else
                            {
                                self.nameRestaurant=""
                            }
                            if let locAddress=self.cuisinesFilter[self.j]["address"] as? String{
                                self.addressString=locAddress
                            }
                            else
                            {
                                self.addressString=""
                            }
                            
                            if let locCity=self.cuisinesFilter[self.j]["locality"] as? String{
                                self.cityString=locCity
                            }
                            else
                            {
                                self.cityString=""
                            }
                            if let locCountry = self.cuisinesFilter[self.j]["country"] as? String{
                                self.countryString = locCountry
                            }
                            else{
                                self.countryString = ""
                            }
                            
                            if let locState = self.cuisinesFilter[self.j]["region"] as? String{
                                self.stateString = locState
                            }
                            else{
                                self.stateString = ""
                            }
                            //code commented
                            
                            //  self.addressString  = (location?["address"] as? String)!
                            // self.cityString = (location?["city"] as? String)!
                            
                            if let currentlat = self.cuisinesFilter[self.j]["latitude"] as? Double{
                                self.latValue = currentlat
                            }else{
                                self.latValue=0.0
                            }
                            if let currentlon = self.cuisinesFilter[self.j]["longitude"] as? Double{
                                self.longValue = currentlon
                            }else{
                                self.longValue=0.0
                            }
                            if let price = self.cuisinesFilter[self.j]["price"] as? NSNumber
                            {
                                K_INNERUSER_DATA.Price = String(format:"%@",price)
                            }
                            else{
                                K_INNERUSER_DATA.Price = "0"
                            }
                            
                            if let rating = self.cuisinesFilter[self.j]["rating"] as? NSNumber
                            {
                                
                                K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                            }
                            else{
                                K_INNERUSER_DATA.Rating = "0"
                            }
                            if let factual_id = self.cuisinesFilter[self.j]["factual_id"] as? String{
                                K_INNERUSER_DATA.FactualId = factual_id
                            }
                            else{
                                K_INNERUSER_DATA.FactualId = ""
                            }
                            
                            
                            if let cuisineArr = self.cuisinesFilter[self.j]["cuisine"] as? NSArray{
                                if cuisineArr.count > 0{
                                    if let cuisine = cuisineArr[0] as? String{
                                        self.cuisineName = cuisine
                                    }
                                    else{
                                        self.cuisineName = ""
                                    }
                                }
                                else{
                                    self.cuisineName = ""
                                }
                            }
                            else{
                                self.cuisineName = ""
                            }
                            if let suggestion = self.cuisinesFilter[self.j]["suggestion"] as? [String:Any]{
                                if let by = (suggestion["by"] as? String){
                                    K_INNERUSER_DATA.suggestionBy = by
                                }
                                else{
                                    K_INNERUSER_DATA.suggestionBy = ""
                                }
                                if let urlInner = (suggestion["url"] as? String){
                                    K_INNERUSER_DATA.innerCircleUrl = urlInner
                                }
                                else{
                                    K_INNERUSER_DATA.innerCircleUrl = ""
                                    
                                }
                            }
                            else{
                                K_INNERUSER_DATA.suggestionBy = ""
                                K_INNERUSER_DATA.innerCircleUrl = ""
                                
                            }
                            if let zipCode = self.cuisinesFilter[self.j]["postcode"] as? NSNumber{
                                self.postCode = zipCode.stringValue
                            }
                            else{
                                self.postCode = ""
                            }
                            if let locTel =  self.cuisinesFilter[self.j]["tel"] as? String{
                                
                                K_INNERUSER_DATA.Phone = locTel
                            }
                            else{
                                K_INNERUSER_DATA.Phone=""
                            }
                            if let locWebsite =  self.cuisinesFilter[self.j]["website"] as? String{
                                
                                K_INNERUSER_DATA.Website = locWebsite
                            }
                            else{
                                K_INNERUSER_DATA.Website=""
                            }
                            
                            if let hours =  self.cuisinesFilter[self.j]["hours_display"] as? String{
                                K_INNERUSER_DATA.Hours = hours
                            }
                            else{
                                K_INNERUSER_DATA.Hours = ""
                            }
                            
                            
                            
                            //code added by mohit
                            /*   var content = Dictionary<String,Any>()
                             content.updateValue(self.latValue, forKey: "latvalue")
                             content.updateValue(self.longValue, forKey: "longvalue")
                             content.updateValue(self.nameRestaurant, forKey: "nameValue")
                             content.updateValue(self.cityString , forKey: "cityValue")
                             content.updateValue(self.addressString , forKey: "Address")
                             content.updateValue(K_INNERUSER_DATA.Phone , forKey: "user_tel")
                             content.updateValue(K_INNERUSER_DATA.Website , forKey: "user_website")
                             content.updateValue(K_INNERUSER_DATA.Hours , forKey: "user_hours_display")
                             content.updateValue(K_INNERUSER_DATA.FactualId , forKey: "factualId")
                             content.updateValue(self.cuisineName , forKey: "cuisineName")
                             content.updateValue(K_INNERUSER_DATA.suggestionBy , forKey: "cuisineName")
                             self.annotationArray.append(content)
                             */
                            let cusineDetail = ProfileCuisineFilter()
                            cusineDetail.restaurantName = self.nameRestaurant
                            cusineDetail.address = self.addressString
                            cusineDetail.city = self.cityString
                            cusineDetail.state = self.stateString
                            cusineDetail.country = self.countryString
                            cusineDetail.latitudeValue = self.latValue
                            cusineDetail.longitudeValue = self.longValue
                            cusineDetail.photo_ref = ""
                            cusineDetail.rating = K_INNERUSER_DATA.Rating
                            cusineDetail.Price = K_INNERUSER_DATA.Price
                            cusineDetail.cuisineName = self.cuisineName
                            cusineDetail.suggestionBy = K_INNERUSER_DATA.suggestionBy
                            cusineDetail.FactualId = K_INNERUSER_DATA.FactualId
                            cusineDetail.innerCircleUrl = K_INNERUSER_DATA.innerCircleUrl
                            cusineDetail.phone =  K_INNERUSER_DATA.Phone
                            cusineDetail.hour =  K_INNERUSER_DATA.Hours
                            cusineDetail.website = K_INNERUSER_DATA.Website
                            self.cuisineArray.append(cusineDetail)
                            
                            self.j = self.j + 1
                            //  print(self.nameRestaurant, self.latValue,self.longValue)
                        }
                        // print("count is",self.cuisineArray.count)
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        if self.cuisinesFilter.count > 0{
                            
                        }
                        else{
                            self.view.isUserInteractionEnabled = true
                            self.titleExplore.isHidden = false
                            self.titleExplore.text = "We do not have enough data to show the explore for you. Please try adding suitable filters in filter screen."
                            self.titleExplore.textAlignment = .center
                            self.titleExplore.numberOfLines = 3
                            self.titleExplore.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
                            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                            self.view.addSubview(self.titleExplore)
                            self.titleExplore.snp.makeConstraints { (make) in
                                make.left.equalTo(0)
                                make.right.equalTo(0)
                                // make.top.equalTo(topRecommendationLabel.snp.bottom).offset(140)
                                make.centerX.equalTo(self.view)
                                make.centerY.equalTo(self.view)
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    self.titleExplore.isHidden = false
                    self.titleExplore.text = "We do not have enough data to show the explore for you. Please try adding suitable filters in filter screen."
                    self.titleExplore.textAlignment = .center
                    self.titleExplore.numberOfLines = 3
                    self.titleExplore.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
                    //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                    self.view.addSubview(self.titleExplore)
                    self.titleExplore.snp.makeConstraints { (make) in
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        // make.top.equalTo(topRecommendationLabel.snp.bottom).offset(140)
                        make.centerX.equalTo(self.view)
                        make.centerY.equalTo(self.view)
                    }
                    
                }
                DispatchQueue.main.async {
                    
                   
                  //  print("index value is and count--- ",self.cuisineArray.count)
                    if self.cuisineArray.count > 0 {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        delayWithSeconds(1.5){
                            self.countGoogleApiHit(index:self.selectedProfileIndex)
                        }
                        
                        self.tableView.reloadData()
                    }
                     SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    
                    //                    if (self.filtering){
                    //                        self.filter(text: "")
                    //                    }
                    //                    else{
                    //                        self.countGoogleApiHit(index:self.selectedProfileIndex)
                    //                        //   SVProgressHUD.dismiss()
                    //                        self.tableView.reloadData()
                    //                        self.view.isUserInteractionEnabled = true
                    //                    }
                    
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
    
    func hideMap() {
        if self.cuisinesFilter.count > 0{
            self.titleExplore.isHidden = true
            
        }
        else{
            self.titleExplore.isHidden = false
            
        }
        self.mapWrapperView.isHidden = true
        self.isNotRefresh = true
    }
    
    
    func goBackHideMap()
    {
        mapWrapperView.isHidden = true
    }
    func showPin()
    {
         self.isNotRefresh = true
        mapWrapperView = UIView()
        self.view.addSubview(mapWrapperView)
        mapWrapperView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        mapWrapperView.isHidden = true
        if mapView == nil{
             mapView = GMSMapView()
        }
       
        mapWrapperView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(80)
            make.bottom.equalTo(40)
            
        }
        //        mapView.mapType = MKMapType.standard
        //        mapView.isZoomEnabled = true
        //        mapView.isScrollEnabled = true
        
        //  // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        mapView.delegate = self //code updated by mohit
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
        
        
        // let titleLabel2 = UILabel()
        titleLabel2.text = "EXPLORE"
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
        
        // let settingsButtonWrapper = UIButton(type: .custom)
        settingsButtonWrapper.setImage(UIImage(named:"ic_back"), for: .normal)
        mapWrapperView.addSubview(settingsButtonWrapper)
        settingsButtonWrapper.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        settingsButtonWrapper.addTarget(self, action: #selector(self.hideMap), for: .touchUpInside)
        
        
        
        
        //        let notifButton1 = UIButton(type: .custom)
        //        notifButton1.setImage(UIImage(named:"ic_filter"), for: .normal)
        //        mapWrapperView.addSubview(notifButton1)
        //        notifButton1.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(titleLabel.snp.centerY)
        //            make.width.equalTo(30)
        //            make.height.equalTo(30)
        //        }
        
        // notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        
        
        
        // let mapButton = UIButton(type: .custom)
        mapButton.setImage(UIImage(named:"map_area"), for: .normal)
        mapWrapperView.addSubview(mapButton)
        mapButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            make.bottom.equalTo(-60)
        }
        mapButton.addTarget(self, action: #selector(self.hideMap), for: .touchUpInside)
        
        mapView.clear()
        self.titleExplore.isHidden = true
        
        var cusineDetail = ProfileCuisineFilter()
        if filtering{
            if filteredUserProfileArray.count > 0{
                //                cusineDetail = filteredUserProfileArray[0]
                //                // print(cusineDetail.latitudeValue,cusineDetail.longitudeValue)
                //                let sydney = GMSCameraPosition.camera(withLatitude: cusineDetail.latitudeValue ,
                //                                                      longitude: cusineDetail.longitudeValue ,
                //                                                      zoom: 14)
                //                mapView.camera = sydney
                var bounds = GMSCoordinateBounds()
                
                for location in filteredUserProfileArray {
                    var cusineDetailProfile = ProfileCuisineFilter()
                    cusineDetailProfile = location
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:cusineDetailProfile.latitudeValue, longitude: cusineDetailProfile.longitudeValue)
                    bounds = bounds.includingCoordinate(marker.position)
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 64)
                    
                    
                    marker.title = cusineDetailProfile.restaurantName
                    marker.snippet = cusineDetailProfile.city
                    
                    if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("profile"){
                        marker.icon = UIImage(named:"map-markar")!
                        marker.map = mapView
                        
                    }
                    else if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("company"){
                        marker.icon = UIImage(named:"map_Circle")!
                        marker.map = mapView
                        
                    }
                    else if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("inner circle"){
                        let url = K_IMAGE_BASE_URL + cusineDetailProfile.innerCircleUrl
                        var imageViewForPinMarker : UIImageView
                        imageViewForPinMarker  = UIImageView(frame:CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 80, height: 80)))
                        imageViewForPinMarker.layer.cornerRadius = 40
                        imageViewForPinMarker.layer.masksToBounds = true
                        imageViewForPinMarker.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "rest_defoutImage"))
                        marker.iconView = imageViewForPinMarker
                        marker.tracksViewChanges = true
                        marker.map = mapView
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(50)) {
                        // Code
                        self.mapView.animate(with: update)
                        self.view.isUserInteractionEnabled = true
                        
                        
                    }
                    
                }
                
            }
            
        }
        else{
            if cuisineArray.count > 0{
                //                cusineDetail = cuisineArray[0]
                //                // print(cusineDetail.latitudeValue,cusineDetail.longitudeValue)
                //                let sydney = GMSCameraPosition.camera(withLatitude: cusineDetail.latitudeValue ,
                //                                                      longitude: cusineDetail.longitudeValue ,
                //                                                      zoom: 14)
                //                mapView.camera = sydney
                var bounds = GMSCoordinateBounds()
                
                for location in cuisineArray
                {
                    var cusineDetailProfile = ProfileCuisineFilter()
                    cusineDetailProfile = location
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:cusineDetailProfile.latitudeValue, longitude: cusineDetailProfile.longitudeValue)
                    bounds = bounds.includingCoordinate(marker.position)
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 64)
                    marker.title = cusineDetailProfile.restaurantName
                    marker.snippet = cusineDetailProfile.city
                    
                    if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("profile"){
                        marker.icon = UIImage(named:"map-markar")!
                        marker.map = mapView
                        
                    }
                    else if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("company"){
                        marker.icon = UIImage(named:"map_Circle")!
                        marker.map = mapView
                        
                    }
                    else if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("inner circle"){
                        let url = K_IMAGE_BASE_URL + cusineDetailProfile.innerCircleUrl
                        var imageViewForPinMarker : UIImageView
                        imageViewForPinMarker  = UIImageView(frame:CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 50, height: 50)))
                        imageViewForPinMarker.layer.cornerRadius = 25
                        imageViewForPinMarker.layer.masksToBounds = true
                        imageViewForPinMarker.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "rest_defoutImage"))
                        marker.iconView = imageViewForPinMarker
                        marker.tracksViewChanges = true
                        marker.map = mapView
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(50)) {
                        // Code
                        self.mapView.animate(with: update)
                        self.view.isUserInteractionEnabled = true
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
    func goforward()
    {
        
        
        self.isNotRefresh = true
        //self.screenName = "FilterScreen"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExploreFilterViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func mapButtonClicked()
        
    {
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        self.showPin()
        mapWrapperView.isHidden = false
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  return cuisinesFilter.count;
        // return self.PhotoRefArray.count
        if (filtering) {
            return filteredUserProfileArray.count;
        }
        //print("Email Data",userProfileArray)
        return cuisineArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04"]
        let imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 5
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(0)
        }
        var cuisineDetail =  ProfileCuisineFilter()
        if filtering{
            cuisineDetail  = self.filteredUserProfileArray[indexPath.row]
        }
        else{
            cuisineDetail  = cuisineArray[indexPath.row]
            //            print("indexPath.row",indexPath.row)
            //            if self.cuisineArray.count <= indexPath.row {
            //                print(indexPath.row,self.cuisineArray.count)
            //                return cell
            //            }
            //            else{
            //                cuisineDetail  = cuisineArray[indexPath.row]
            //
            //            }
            
        }
        
        //        var cuisineDetail = ProfileCuisineFilter()
        //        cuisineDetail = cuisineArray[indexPath.row]
        //        print(cuisineDetail.cuisineName,indexPath.row)
        //        if cuisineDetail.photo_ref.count > 0 {
        //            imageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
        //        }
        // print(cuisineDetail.photo_ref)
        // if cuisineDetail.photo_ref.characters.count > 0 {
        imageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
        // }
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        
        
        //Map transparent button
        
        
        //        let notifButton1 = UIButton(type: .custom)
        //        notifButton1.setImage(UIImage(named:"map_location_tranparent"), for: .normal)
        //        cell.contentView.addSubview(notifButton1)
        //        notifButton1.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.width.equalTo(40)
        //            make.height.equalTo(40)
        //            make.bottom.equalTo(-10)
        //        }
        //       // notifButton1.addTarget(self, action: "buttonPressed:", for: UIControlEvents.touchUpInside)
        //         notifButton1.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        //        notifButton1.tag = indexPath.row
        
        /*   let textLabelImage = UILabel()
         textLabelImage.textColor = UIColor.white
         textLabelImage.numberOfLines = 1
         textLabelImage.adjustsFontSizeToFitWidth = true
         textLabelImage.minimumScaleFactor = 0.2
         textLabelImage.font = UIFont(name:K_Font_Color,size:24)
         textLabelImage.textColor = UIColor.white
         
         cell.contentView.addSubview(textLabelImage)
         textLabelImage.snp.makeConstraints { (make) in
         make.left.equalTo(16)
         make.width.equalTo(340)
         make.height.equalTo(40)
         make.top.equalTo(15)
         }
         // textLabelImage.font = UIFont(name:K_Font_Color,size:24)
         
         
         textLabelImage.text = self.cuisinesFilter[indexPath.row]["name"] as? String
         
         // print( textLabelImage.text)
         let textLabel = UILabel()
         textLabel.textColor = UIColor.white
         cell.contentView.addSubview(textLabel)
         textLabel.snp.makeConstraints { (make) in
         make.left.equalTo(50)
         make.right.equalTo(-20)
         make.centerY.equalTo(cell.contentView)
         }
         textLabel.font = UIFont(name:K_Font_Color,size:22)
         //textLabel.text = "Jim's China"
         */
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.50
        // view.numberOfLines = 1
        // view.adjustsFontSizeToFitWidth = true
        // view.minimumScaleFactor = 0.2
        // view.font = UIFont(name:K_Font_Color,size:24)
        // view.textColor = UIColor.white
        cell.contentView.addSubview(view)
        view.layer.cornerRadius = 5
        view.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(0)
        }
        
        let textRestaurant = UILabel()
        textRestaurant.numberOfLines = 1
        textRestaurant.adjustsFontSizeToFitWidth = true
        textRestaurant.minimumScaleFactor = 0.2
        textRestaurant.font = UIFont(name:K_Font_Color,size:24)
        textRestaurant.textColor = UIColor.white
        cell.contentView.addSubview(textRestaurant)
        textRestaurant.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(340)
            make.height.equalTo(35)
            make.top.equalTo(10)
        }
        
        
        textRestaurant.text = cuisineDetail.restaurantName
        
        
        
        //        if let restaurant = self.cuisinesFilter[indexPath.row]["name"] as? String{
        //            textRestaurant.text = restaurant
        //        }
        //        else{
        //            textRestaurant.text = ""
        //        }
        
        
        
        
        
        //text cuisine text
        
        let textLabelCuisine = UILabel()
        textLabelCuisine.numberOfLines = 1
        textLabelCuisine.adjustsFontSizeToFitWidth = true
        textLabelCuisine.minimumScaleFactor = 0.2
        textLabelCuisine.font = UIFont(name:K_Font_Color,size:18)
        textLabelCuisine.textColor = UIColor.white
        cell.contentView.addSubview(textLabelCuisine)
        textLabelCuisine.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(350)
            make.height.equalTo(20)
            make.top.equalTo(45)
        }
        
        
        /*  if let cuisineArray = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
         textLabelCuisine.text = cuisineArray[0] as? String
         }
         else{
         textLabelCuisine.text = ""
         }
         */
        
        textLabelCuisine.text = cuisineDetail.cuisineName
        //        if let cuisineArr = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
        //            if cuisineArr.count > 0{
        //                if let cuisine = cuisineArr[0] as? String{
        //                    textLabelCuisine.text = cuisine
        //                }
        //                else{
        //                    textLabelCuisine.text = ""
        //                }
        //
        //            }
        //            else{
        //                textLabelCuisine.text = ""
        //            }
        //        }
        //        else{
        //            textLabelCuisine.text = ""
        //        }
        
        let cuisineCoordinates = UILabel()
        // cuisineCoordinates.textColor = UIColor.gray
        cell.contentView.addSubview(cuisineCoordinates)
        cuisineCoordinates.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.top.equalTo(65)
        }
        cuisineCoordinates.textColor = UIColor.white
        cuisineCoordinates.font = UIFont(name:K_Font_Color,size:18)
        // var coordinate : [String:Any]?
        // coordinate = self.cuisinesFilter[indexPath.row]["coordinates"] as? [String:Any]
        //        if let currentlat = self.cuisinesFilter[indexPath.row]["latitude"] as? Double{
        //            self.latValueRestaurant = currentlat
        //
        //        }else{
        //            self.latValueRestaurant = 0.0
        //        }
        //        if let currentlon = self.cuisinesFilter[indexPath.row]["longitude"] as? Double{
        //            self.longValueRestaurant = currentlon
        //        }else{
        //            self.longValueRestaurant = 0.0
        //        }
        self.latValueRestaurant = cuisineDetail.latitudeValue
        self.longValueRestaurant = cuisineDetail.longitudeValue
        
        //        if let currentlat=(coordinate?["lat"] as? Double){
        //            self.latValueRestaurant = currentlat
        //        }else{
        //            self.latValueRestaurant = 0.0
        //        }
        //
        //        if let currentlon=(coordinate?["lon"] as? Double){
        //            self.longValueRestaurant = currentlon
        //        }else{
        //            self.longValueRestaurant = 0.0
        //        }
        //  print(self.latValueRestaurant,self.longValueRestaurant)
        // let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
        let singelton = SharedManager.sharedInstance
        let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
        let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude:  self.longValueRestaurant)
        //  print(singelton.latValueInitial,singelton.longValueInitial)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        let finaldist =  distanceInMeters / 1609.344
        
        
        cuisineCoordinates.text = String(format:"%.1f", finaldist) + " Miles"
        
        
        let textLabelSuggestion = UILabel()
        textLabelSuggestion.numberOfLines = 1
        textLabelSuggestion.adjustsFontSizeToFitWidth = true
        textLabelSuggestion.minimumScaleFactor = 0.2
        textLabelSuggestion.font = UIFont(name:K_Font_Color,size:18)
        textLabelSuggestion.textColor = UIColor.white
        textLabelSuggestion.text = "Suggested by"
        cell.contentView.addSubview(textLabelSuggestion)
        textLabelSuggestion.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(85)
        }
        
        let textLabelSuggestionValue = UILabel()
        textLabelSuggestionValue.numberOfLines = 1
        textLabelSuggestionValue.adjustsFontSizeToFitWidth = true
        textLabelSuggestionValue.minimumScaleFactor = 0.2
        textLabelSuggestionValue.font = UIFont(name:K_Font_Color,size:18)
        textLabelSuggestionValue.textColor = UIColor.white
        //        if let suggestion = self.cuisinesFilter[indexPath.row]["suggestion"] as? [String:Any]{
        //            if let by = (suggestion["by"] as? String){
        //                textLabelSuggestionValue.text = by
        //            }
        //            else{
        //                textLabelSuggestionValue.text = ""
        //            }
        //        }
        //        else{
        //            textLabelSuggestionValue.text = ""
        //        }
        textLabelSuggestionValue.text = cuisineDetail.suggestionBy
        
        cell.contentView.addSubview(textLabelSuggestionValue)
        textLabelSuggestionValue.snp.makeConstraints { (make) in
            make.left.equalTo(120)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(85)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if filtering{
            var cusineDetails = ProfileCuisineFilter()
            cusineDetails = filteredUserProfileArray[indexPath.row]
            K_INNERUSER_DATA.Address = cusineDetails.address
            K_INNERUSER_DATA.CITY = cusineDetails.city
            K_INNERUSER_DATA.Country = cusineDetails.country
            K_INNERUSER_DATA.State = cusineDetails.state
            K_INNERUSER_DATA.ZIP = cusineDetails.PostCode
            K_INNERUSER_DATA.Phone = cusineDetails.phone
            K_INNERUSER_DATA.Website = cusineDetails.website
            K_INNERUSER_DATA.Hours = cusineDetails.hour
          //  K_INNERUSER_DATA.CuisineName = cusineDetails.cuisineName
            K_INNERUSER_DATA.CuisinSeleted = cusineDetails.cuisineName
            K_INNERUSER_DATA.FactualId = cusineDetails.FactualId
            K_INNERUSER_DATA.RestaurantName = cusineDetails.restaurantName
            K_INNERUSER_DATA.latvalueNavigate = cusineDetails.latitudeValue
            K_INNERUSER_DATA.longvalueNavigate = cusineDetails.longitudeValue
            K_INNERUSER_DATA.Photo_Ref = cusineDetails.photo_ref
            K_INNERUSER_DATA.Price = cusineDetails.Price
            K_INNERUSER_DATA.placeId = cusineDetails.Placeid
            K_INNERUSER_DATA.Rating = cusineDetails.rating
          
            /*  if let locAddress = self.cuisinesFilter[indexPath.row]["address"] as? String{
             K_INNERUSER_DATA.Address = locAddress
             }
             else{
             K_INNERUSER_DATA.Address=""
             }
             if let locCity = self.cuisinesFilter[indexPath.row]["locality"] as? String{
             K_INNERUSER_DATA.CITY=locCity
             }
             else{
             K_INNERUSER_DATA.CITY=""
             }
             if let locCountry = self.cuisinesFilter[indexPath.row]["country"] as? String{
             K_INNERUSER_DATA.Country=locCountry
             }
             else{
             K_INNERUSER_DATA.Country=""
             }
             
             if let locState = self.cuisinesFilter[indexPath.row]["region"] as? String{
             K_INNERUSER_DATA.State=locState
             }
             else{
             K_INNERUSER_DATA.State=""
             }
             if let locZip =  self.cuisinesFilter[indexPath.row]["postcode"] as? NSNumber
             {
             K_INNERUSER_DATA.ZIP = locZip.stringValue
             }
             else{
             K_INNERUSER_DATA.ZIP=""
             }
             if let locTel =  self.cuisinesFilter[indexPath.row]["tel"] as? String{
             
             K_INNERUSER_DATA.Phone = locTel
             }
             else{
             K_INNERUSER_DATA.Phone=""
             }
             if let locWebsite =  self.cuisinesFilter[indexPath.row]["website"] as? String{
             
             K_INNERUSER_DATA.Website = locWebsite
             }
             else{
             K_INNERUSER_DATA.Website=""
             }
             
             if let hours =  self.cuisinesFilter[indexPath.row]["hours_display"] as? String{
             K_INNERUSER_DATA.Hours = hours
             }
             else{
             K_INNERUSER_DATA.Hours = ""
             }
             
             if let cuisineArr = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
             if cuisineArr.count > 0{
             if let cuisine = cuisineArr[0] as? String{
             K_INNERUSER_DATA.CuisineName = cuisine
             }
             else{
             K_INNERUSER_DATA.CuisineName = ""
             }
             
             
             }
             else{
             K_INNERUSER_DATA.CuisineName = ""
             }
             }
             else{
             K_INNERUSER_DATA.CuisineName = ""
             }
             
             
             
             if let factual_id = self.cuisinesFilter[indexPath.row]["factual_id"] as? String{
             K_INNERUSER_DATA.FactualId = factual_id
             }
             else{
             K_INNERUSER_DATA.FactualId = ""
             }
             
             if let restName  = self.cuisinesFilter[indexPath.row]["name"] as? String
             {
             K_INNERUSER_DATA.RestaurantName = restName
             }
             else{
             K_INNERUSER_DATA.RestaurantName  = ""
             }
             
             //        if let PhotoValue = (self.PhotoRefArray[indexPath.row] ["Photo_Ref"] as? String){
             //            K_INNERUSER_DATA.Photo_Ref = PhotoValue
             //        }
             //
             //
             //        if let Place = (self.PlaceIdArray[indexPath.row] ["placeid"] as? String) {
             //            //            let Place_Id = (self.PlaceIdArray[indexPath.row] ["placeid"] as! String)
             //            K_INNERUSER_DATA.placeId = Place
             //        }
             //        let latNavigate =  annotationArray  [indexPath.row] ["latvalue"] as! Double
             //
             
             var cuisineDetail = ProfileCuisineFilter()
             cuisineDetail = cuisineArray[indexPath.row]
             K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
             K_INNERUSER_DATA.Price = cuisineDetail.Price
             K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
             
             print("place" ,K_INNERUSER_DATA.placeId)
             K_INNERUSER_DATA.Rating = cuisineDetail.rating
             */
             self.isNotRefresh = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if let locAddress = self.cuisinesFilter[indexPath.row]["address"] as? String{
                K_INNERUSER_DATA.Address = locAddress
            }
            else{
                K_INNERUSER_DATA.Address=""
            }
            if let locCity = self.cuisinesFilter[indexPath.row]["locality"] as? String{
                K_INNERUSER_DATA.CITY=locCity
            }
            else{
                K_INNERUSER_DATA.CITY=""
            }
            if let locCountry = self.cuisinesFilter[indexPath.row]["country"] as? String{
                K_INNERUSER_DATA.Country=locCountry
            }
            else{
                K_INNERUSER_DATA.Country=""
            }
            
            if let locState = self.cuisinesFilter[indexPath.row]["region"] as? String{
                K_INNERUSER_DATA.State=locState
            }
            else{
                K_INNERUSER_DATA.State=""
            }
            if let locZip =  self.cuisinesFilter[indexPath.row]["postcode"] as? NSNumber
            {
                K_INNERUSER_DATA.ZIP = locZip.stringValue
            }
            else{
                K_INNERUSER_DATA.ZIP=""
            }
            if let locTel =  self.cuisinesFilter[indexPath.row]["tel"] as? String{
                
                K_INNERUSER_DATA.Phone = locTel
            }
            else{
                K_INNERUSER_DATA.Phone=""
            }
            if let locWebsite =  self.cuisinesFilter[indexPath.row]["website"] as? String{
                
                K_INNERUSER_DATA.Website = locWebsite
            }
            else{
                K_INNERUSER_DATA.Website=""
            }
            
            if let hours =  self.cuisinesFilter[indexPath.row]["hours_display"] as? String{
                K_INNERUSER_DATA.Hours = hours
            }
            else{
                K_INNERUSER_DATA.Hours = ""
            }
            
            if let cuisineArr = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
                if cuisineArr.count > 0{
                    if let cuisine = cuisineArr[0] as? String{
                      K_INNERUSER_DATA.CuisinSeleted = cuisine
                    }
                    else{
                       K_INNERUSER_DATA.CuisinSeleted = ""
                    }
                    
                    
                }
                else{
                    K_INNERUSER_DATA.CuisinSeleted = ""
                }
            }
            else{
                K_INNERUSER_DATA.CuisinSeleted = ""
            }
            
            
            
            if let factual_id = self.cuisinesFilter[indexPath.row]["factual_id"] as? String{
                K_INNERUSER_DATA.FactualId = factual_id
            }
            else{
                K_INNERUSER_DATA.FactualId = ""
            }
            
            if let restName  = self.cuisinesFilter[indexPath.row]["name"] as? String
            {
                K_INNERUSER_DATA.RestaurantName = restName
            }
            else{
                K_INNERUSER_DATA.RestaurantName  = ""
            }
            
            //        if let PhotoValue = (self.PhotoRefArray[indexPath.row] ["Photo_Ref"] as? String){
            //            K_INNERUSER_DATA.Photo_Ref = PhotoValue
            //        }
            //
            //
            //        if let Place = (self.PlaceIdArray[indexPath.row] ["placeid"] as? String) {
            //            //            let Place_Id = (self.PlaceIdArray[indexPath.row] ["placeid"] as! String)
            //            K_INNERUSER_DATA.placeId = Place
            //        }
            //        let latNavigate =  annotationArray  [indexPath.row] ["latvalue"] as! Double
            //
            //        K_INNERUSER_DATA.latvalueNavigate = latNavigate
            //
            //        let longNavigate =  annotationArray  [indexPath.row] ["longvalue"] as! Double
            //
            //        K_INNERUSER_DATA.longvalueNavigate = longNavigate
            var cuisineDetail = ProfileCuisineFilter()
            cuisineDetail = cuisineArray[indexPath.row]
            K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
            K_INNERUSER_DATA.Price = cuisineDetail.Price
            K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
            
            //  print("place" ,K_INNERUSER_DATA.placeId)
            K_INNERUSER_DATA.Rating = cuisineDetail.rating
            self.isNotRefresh = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.isNotRefresh = false
        if filtering{
            for detail in self.filteredUserProfileArray{
                var cusineDetailProfile = ProfileCuisineFilter()
                cusineDetailProfile = detail
                if cusineDetailProfile.restaurantName == marker.title
                {
                    K_INNERUSER_DATA.cityname = cusineDetailProfile.city
                    K_INNERUSER_DATA.State = cusineDetailProfile.state
                  //  K_INNERUSER_DATA.name = cusineDetailProfile.cuisineName
                     K_INNERUSER_DATA.CuisinSeleted = cusineDetailProfile.cuisineName
                    K_INNERUSER_DATA.latvalueNavigate = cusineDetailProfile.latitudeValue
                    K_INNERUSER_DATA.longvalueNavigate = cusineDetailProfile.longitudeValue
                    K_INNERUSER_DATA.Phone = cusineDetailProfile.phone
                    K_INNERUSER_DATA.Website = cusineDetailProfile.website
                    K_INNERUSER_DATA.Hours = cusineDetailProfile.hour
                    K_INNERUSER_DATA.Address = cusineDetailProfile.address
                    K_INNERUSER_DATA.FactualId = cusineDetailProfile.FactualId
                    K_INNERUSER_DATA.Photo_Ref = cusineDetailProfile.photo_ref
                    K_INNERUSER_DATA.placeId = cusineDetailProfile.Placeid
                    K_INNERUSER_DATA.RestaurantName = cusineDetailProfile.restaurantName
                    K_INNERUSER_DATA.Price = cusineDetailProfile.Price
                    K_INNERUSER_DATA.Rating = cusineDetailProfile.rating
                    
                }
                
            }
        }
        else
        {
            for detail in self.cuisineArray
            {
                var cusineDetailProfile = ProfileCuisineFilter()
                cusineDetailProfile = detail
                if cusineDetailProfile.restaurantName == marker.title
                {
                    K_INNERUSER_DATA.cityname = cusineDetailProfile.city
                    K_INNERUSER_DATA.State = cusineDetailProfile.state
                   // K_INNERUSER_DATA.name = cusineDetailProfile.cuisineName
                    K_INNERUSER_DATA.CuisinSeleted = cusineDetailProfile.cuisineName
                    K_INNERUSER_DATA.latvalueNavigate = cusineDetailProfile.latitudeValue
                    K_INNERUSER_DATA.longvalueNavigate = cusineDetailProfile.longitudeValue
                    K_INNERUSER_DATA.Phone = cusineDetailProfile.phone
                    K_INNERUSER_DATA.Website = cusineDetailProfile.website
                    K_INNERUSER_DATA.Hours = cusineDetailProfile.hour
                    K_INNERUSER_DATA.Address = cusineDetailProfile.address
                    K_INNERUSER_DATA.FactualId = cusineDetailProfile.FactualId
                    K_INNERUSER_DATA.Photo_Ref = cusineDetailProfile.photo_ref
                    K_INNERUSER_DATA.placeId = cusineDetailProfile.Placeid
                    K_INNERUSER_DATA.RestaurantName = cusineDetailProfile.restaurantName
                    K_INNERUSER_DATA.Price = cusineDetailProfile.Price
                    K_INNERUSER_DATA.Rating = cusineDetailProfile.rating
                    
                }
                
            }
            
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.isNotRefresh = false
        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell , forRowAt indexPath: IndexPath)
    {
        
        /* let lastElement = self.cuisinesFilter.count - 1
         print("indexpath for the last call is \(indexPath.row + 1)", lastElement)
         if !isloading && indexPath.row  == lastElement
         {
         isloading = true
         pageNo = pageNo + 1
         if self.cuisinesFilter.count >= 5 && self.maxRow > 4
         {
         self.maxRow = 0
         
         self.loadTableViewData()
         }
         
         
         }
         self.maxRow = self.maxRow + 1
         print("indexpath for the last call is \(indexPath.row)")
         */
        //        let lastElement = self.cuisinesFilter.count
        //
        //        print("daat",self.cuisinesFilter.count)
        //        print("lastelement is is ", lastElement)
        //         print("roe is ",self.maxRow)
        //        if !isloading && self.maxRow  > lastElement
        //        {
        //                    self.maxRow = 0
        //                    pageNo = pageNo + 1
        //                    isloading = true
        //
        //                    self.loadTableViewData()
        //
        //
        //
        //        }
        //        self.maxRow = self.maxRow + 1
        let lastElement = self.cuisinesFilter.count
        if  !(indexPath.row + 1 < lastElement)  && isloading == false
        {
            isloading = true
            pageNo = pageNo + 1
            if self.cuisinesFilter.count >= 20{
                isSearchChange = "0" // not updating explore filter
                self.loadTableViewData()
            }
            
            
        }
        //  print("indexpath for the last call is \(indexPath.row)")
        
    }
    // MARK:TEXTFILED DELEGATE METHOD
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //self.titleLabel.isHidden = true
        filtering = true
        self.isNotRefresh = true
        delayWithSeconds(0.5) {
            self.filter(text: textField.text!)
        }
        
        return true
    }
    
    func filter (text:String) {
        // var user = InnerCircleProfile()
        filteredUserProfileArray.removeAll()
        
        if (text.characters.count == 0) {
            //filteredUserProfileArray.append(self.userProfileArray)
            filtering = false
            self.tableView.reloadData()
            return;
        }
        
        
        for user in self.cuisineArray
        { var cusineDetail = ProfileCuisineFilter()
            cusineDetail = user
            //  print("tyytyt",cusineDetail.restaurantName,cusineDetail.cuisineName)
            if cusineDetail.cuisineName.localizedCaseInsensitiveContains(text)
            {
                filteredUserProfileArray.append(cusineDetail)
            }
            else if cusineDetail.restaurantName.localizedCaseInsensitiveContains(text)
            {
                filteredUserProfileArray.append(cusineDetail)
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    //func filter (text:String)
    //    {
    //        delayWithSeconds(4.0) {
    //
    //            print("It is come here")
    //            DataManager.sharedManager.getBankListYodlee(Params:["name":text,"top":"","priority":""], completion: { (response) in
    //
    //                self.banks.removeAll()
    //
    //                if let bankDict = response as? [String:Any]
    //                {
    //                    if let providerarr =  bankDict["provider"] as? [[String:Any]]
    //
    //                    {
    //                        self.banks = providerarr
    //                    }
    //
    //                    if self.banks.count > 0
    //                    {
    //
    //                        SVProgressHUD.dismiss()
    //                        self.tableView.isScrollEnabled = true
    //                        self.tableView.allowsSelection = true
    //                        self.textFieldSearch.isUserInteractionEnabled = true
    //
    //                        print("tableview count is here \(self.banks.count)")
    //                    }
    //                }
    //
    //                else
    //                {
    //                    SVProgressHUD.dismiss()
    //                    let alert = UIAlertController(title: "Taste", message:"Try again", preferredStyle: UIAlertControllerStyle.alert)
    //                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
    //                        UIAlertAction in
    //                        NSLog("OK Pressed")
    //                    }
    //                    alert.addAction(okAction)
    //                    self.present(alert, animated: true, completion: nil)
    //                    return
    //
    //
    //                }
    //                DispatchQueue.main.async {
    //                    self.tableView.reloadData()
    //                    SVProgressHUD.dismiss()
    //                }
    //            })
    //        }}
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //        if (textField.text?.characters.count)! > 3
        //        {
        //            SVProgressHUD.show()
        //            self.tableView.isScrollEnabled = false
        //            self.tableView.allowsSelection = false
        //            textFieldSearch.isUserInteractionEnabled = false
        //            self.filter(text: textField.text!)
        //
        //        }
        //
        //        else if (textField.text?.characters.count)! == 0
        //        {
        //            self.banks.removeAll()
        //            SVProgressHUD.show()
        //
        //
        //        }
        
        
        textField.resignFirstResponder()
        return true
    }
    
    func countGoogleApiHit(index:Int){
        //   print(index,self.PhotoRefArray.count)
        if self.cuisineArray.count <= index {
            SVProgressHUD.dismiss()
            return
        }
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[self.selectedProfileIndex]
        // let profileData = self.ProfileImagesArray[self.selectedProfileIndex]
        //            let lat = profileData.latitudeValue
        //            let lon = profileData.longitudeValue
        //
        //            let name = profileData.name
        //            let city = profileData.city
        
        let lat_long = "\(cuisineDetail.latitudeValue),\(cuisineDetail.longitudeValue)"
        // let address = "\(cuisineDetail.cuisineName)+\(cuisineDetail.city)"
        let address = cuisineDetail.restaurantName + "," + cuisineDetail.address + "," + cuisineDetail.city + "," + cuisineDetail.state + "," + cuisineDetail.country
        let paramString = ["query":address, "location": lat_long, "radius":"100", "type": "restaurant","keyword":"cruise","key":GOOGLE_APIKEY] as [String : Any]
        // print(paramString)
        // Attach Credit Card By krish AIzaSyBf5p8z9QCBLh2re71V8bo-xB_cpoqcNmU
        //AIzaSyBEnLvlTUqZ6dtC9zsgBOQ7nGj8f60vWfU
        
        // AIzaSyCljFU99JMokpxVF7HeiC5pd-xv_g_K9Y4
        //let finalParam = paramString[0]["location"]
        //      print(paramString)
        //  AIzaSyCAgXgLuxmTOHn3ZIq5oJDmxQEep8vWZSU    AIzaSyAddgvNRIZUZOTHXIfbHO7Hp8lBLwh-0W8
        //AIzaSyCm85ozJlxVBdYdr_GEhsy0Fi7lHvbKvhA //using
        //   AIzaSyBWZ0-N1ry6uluUKonnKy5c2ECnA6QqfHs
        //AIzaSyCAtwlpNYCaCnkro25MpQ6c8Xq9jEg9CZk
        //  AIzaSyAddgvNRIZUZOTHXIfbHO7Hp8lBLwh-0W8
        //KEY NEW AIzaSyCAtwlpNYCaCnkro25MpQ6c8Xq9jEg9CZk
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=500&key=\(GOOGLE_APIKEY)"
        let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        
        
        
        
        //  print("-------Print Request Url",UrlTrimString)
        
        DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
            if let dataDic = response as? [String:Any]
            {
                
                // print("Respomse", dataDic)
                
                //         for ResponseCount in responce{
                
                self.tableView .reloadData()
                
                if let dataResponce = (response as AnyObject).object(forKey: "results"){
                    
                    let resultArray = dataResponce as! NSArray
                    
                    var contentRes = Dictionary<String,Any>()
                    contentRes.updateValue(resultArray, forKey: "RefResults")
                    
                    //    self.RestaurantResultArray.append(contentRes)
                    if resultArray.count > 0 {
                        
                        
                        
                        let arrayDict = resultArray[0] as! NSDictionary
                        var NameOfRest = ""
                        if let Rest_name = arrayDict.object(forKey: "name"){
                            NameOfRest = Rest_name as! String
                            //  print("Rest Name is", NameOfRest)
                        }
                        let placeId = arrayDict.object(forKey: "place_id")
                        
                        // print("place id is---",placeId)
                        cuisineDetail.Placeid = placeId as! String
                        // print(cuisineDetail.Placeid)
                        if let photosDict = arrayDict.object(forKey: "photos"){
                            
                            let photosArray = photosDict as! NSArray
                            
                            
                            var contentPlaceId = Dictionary<String,Any>()
                            contentPlaceId.updateValue(placeId!, forKey: "placeid")
                            
                            self.PlaceIdArray.append(contentPlaceId)
                            
                            
                            if photosArray.count > 0 {
                                
                                let photoDict = photosArray[0] as! NSDictionary
                                
                                
                                
                                if let photo_reference = photoDict.object(forKey: "photo_reference"){
                                    
                                    
                                    let PhotoRef = photo_reference as! String
                                    //   K_GoogleImagesData.ImagesDataArray.append(PhotoRef)
                                    
                                    var content = Dictionary<String,Any>()
                                    content.updateValue(PhotoRef, forKey: "Photo_Ref")
                                    content.updateValue(NameOfRest, forKey: "NameOfRest")
                                    
                                    
                                    
                                    self.PhotoRefArray.append(content)
                                    // call this after you update
                                    
                                    
                                    
                                    //  print("PhotoRef : \(PhotoRef)")
                                    let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(PhotoRef)&key=\(GOOGLE_APIKEY)")!
                                    cuisineDetail.photo_ref = String(describing: url)
                                    //  print("index is",self.self.selectedProfileIndex,cuisineDetail.photo_ref)
                                    
                                    self.selectedProfileIndex += 1
                                    self.countGoogleApiHit(index: self.selectedProfileIndex)
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        else
                        {
                            self.selectedProfileIndex += 1
                            self.countGoogleApiHit(index: self.selectedProfileIndex)
                            self.tableView.reloadData()
                            
                        }
                    }
                    else{
                        var content = Dictionary<String,Any>()
                        content.updateValue("Defoult", forKey: "Photo_Ref")
                        
                        self.PhotoRefArray.append(content)
                        //  print("Key Expaire");
                        cuisineDetail.photo_ref = ""
                        self.selectedProfileIndex += 1
                        self.countGoogleApiHit(index: self.selectedProfileIndex)
                        self.tableView.reloadData()
                        
                    }
                    
                }
                //           self.tableView.reloadData()
                
            }
            
        })
        
        
        // }
        //}
        SVProgressHUD.dismiss()
        // print("All photos Reference", self.PhotoRefArray)
        //  print("All photos count", self.PhotoRefArray.count)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}



















