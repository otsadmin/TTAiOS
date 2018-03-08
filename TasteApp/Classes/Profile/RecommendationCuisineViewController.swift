//
//  RecommendationCuisineViewController.swift
//  Taste
//
//  Created by Asish Pant on 20/07/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import Alamofire
import CoreLocation
import GoogleMaps

class RecommendationCuisineViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    var lat : Double = 0.0
    var long  : Double =  0.0
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    var cuisineName = ""
    var cityName = ""
    var mapView:GMSMapView!
    var whiteBarView:UIView!
    var mapWrapperView:UIView!
    var cuisinesFilter = [[String:Any]]()
    var cuisinesPageFilter = [[String:Any]]()
    var coordinate : [String:Any]?
    let newPin = MKPointAnnotation()
    var nameRestaurant:String = ""
    var address:String = ""
    var city : String = ""
    var stateString = ""
    var countryString = ""
    var filterName = ""
    var hitWithName = false
    var annotationArray = [[String:Any]]()
    var latValue : Double = 0.0
    var longValue : Double = 0.0
    var latValueRestaurant : Double = 0.0
    var longValueRestaurant : Double = 0.0
    var j = 0
    var cuisineArray = [ProfileCuisineFilter]()
    var addressString = ""
    var cityString = ""
    var pageNo = 1
    var  isloading  = true
    var maxRow = 0
    let tableView = UITableView()
     var ProfileImagesArray = [ProfileImages]()
    var PhotoRefArray = [[String:Any]]()
    var PlaceIdArray = [[String:Any]]()
    var selectedProfileIndex = 0
     //var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        delayWithSeconds(2.5) {
            self.locationManager?.startUpdatingLocation()
             self.mapView.delegate = self //code updated by mohit
        }
        
        
        locationManager?.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager?.location

            //  print(currentLocation?.coordinate.latitude)// code comment
            // print(currentLocation?.coordinate.longitude) // code comment
        }
        
        // Do any additional setup after loading the view.
        
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            //print("Internet Connection Available!")
            
            // added by ranjit 9 OCT
            print("Internet Connection Available!")
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
            
            self.locationManager?.startUpdatingLocation()
        }
        else
        {
            
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                //NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        self.setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
//        let manager = NetworkReachabilityManager(host: "www.google.com")
//        manager?.listener = { status in
//            // print("Network Status Changed: \(status)")
//            // print("network reachable \(manager!.isReachable)")
//            
//            if manager!.isReachable != true
//            {
//                
//                SVProgressHUD.dismiss()
//                self.view.isUserInteractionEnabled = true
//            }
//            else
//            {
//                //SVProgressHUD.show()
//                // self.loadTableViewData()
//                
//                
//            }
//        }
//        manager?.startListening()
        
        
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        // self.cuisinesFilter.removeAll()
        super.viewWillDisappear(animated)
    }
    
    
    
    func goBack() {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "PROFILE"
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
        //        let settingsButton = UIButton(type: .custom)
        //        settingsButton.setImage(UIImage(named:"ic_setting"), for: .normal)
        //        self.view.addSubview(settingsButton)
        //        settingsButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(10)
        //            make.centerY.equalTo(titleLabel.snp.centerY)
        //            make.width.equalTo(30)
        //            make.height.equalTo(30)
        //        }
        //        settingsButton.addTarget(self, action: #selector(self.settingsTapped), for: .touchUpInside)
        
        
//        let notifButton = UIButton(type: .custom)
//        notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
//        self.view.addSubview(notifButton)
//        notifButton.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
        let titleCuisine = UILabel()
        titleCuisine.text = cuisineName
        //titleCuisine.font = UIFont(name:K_Font_Color,size:23)
        titleCuisine.font = UIFont(name:K_Font_Color_Light,size:23)
        
        titleCuisine.textAlignment = .center
        self.view.addSubview(titleCuisine)
        titleCuisine.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(100)
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
        
        
        self.view.addSubview(self.tableView)
        self.tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            //make.bottom.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            make.top.equalTo(titleCuisine.snp.bottom).offset(25)
        }
        self.tableView.tableFooterView = UIView()
        //Border Color of TableView
        
        self.tableView.layer.masksToBounds = true
        self.tableView.layer.borderColor = UIColor.clear.cgColor
        self.tableView.layer.borderWidth = 2.0
        
        //Corner Radius
        
        self.tableView.layer.cornerRadius = 10
        self.tableView.layer.masksToBounds = true
        
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
        mapButton1.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)
        
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
//        mapView.mapType = MKMapType.standard
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
        
      //  // Or, if needed, we can position map in the center of the view
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
        
        
        let titleLabel2 = UILabel()
        titleLabel2.text = "PROFILE"
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
        
        
        
//        let notifButton1 = UIButton(type: .custom)
//        notifButton1.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
//        mapWrapperView.addSubview(notifButton1)
//        notifButton1.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            // make.top.equalTo(18)  //APARNA CHANGED HERE
//            make.centerY.equalTo(titleLabel.snp.centerY)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
        
        // notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        
        
        
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
            //make.bottom.equalTo(-50)
        }
        mapButton.addTarget(self, action: #selector(self.hideMap), for: .touchUpInside)
        
        self.loadTableViewData()
    }
    
    func loadTableViewData(){
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            
            //please give suggestion here for entry cuisine 0r city
            //print(singelton.loginId,"", self.cuisineName,self.filterName,self.pageNo)
            let parameter = [ "user_id":singelton.loginId,"cuisine":self.cuisineName,"page":self.pageNo] as [String : Any]
           
            DataManager.sharedManager.getRecommendationDetail(params: parameter, completion: { (response) in
                if let dataDic = response as? [[String:Any]]
                {
                    self.cuisinesPageFilter = dataDic
                   // print(dataDic)
                    // self.cuisinesFilter = dataDic
                    
                    //  print("cout is  \(self.cuisinesFilter.count)")//code comment
                    
                    
                    if self.cuisinesPageFilter.count > 0
                    {
                        self.cuisinesFilter.append(contentsOf: self.cuisinesPageFilter)
                        while self.j < self.cuisinesFilter.count
                        {
                            // self.cuisinesFilter.append(contentsOf: self.cuisinesPageFilter)
                          //  print(self.cuisinesFilter.count,self.j)
                            self.isloading = false
                            /* var coordinate : [String:Any]?
                             
                             var location : [String:Any]?
                             
                             coordinate = self.cuisinesFilter[i]["coordinates"] as? [String:Any]
                             location = self.cuisinesFilter[i]["location"] as? [String:Any]
                             
                             //code changed
                             if let locAddress=(location?["address"] as? String){
                             self.addressString=locAddress
                             }
                             else
                             {
                             self.addressString=""
                             }
                             
                             if let locCity=(location?["city"] as? String){
                             self.cityString=locCity
                             }
                             else
                             {
                             self.cityString=""
                             }
                             
                             //code commented
                             
                             //  self.addressString  = (location?["address"] as? String)!
                             // self.cityString = (location?["city"] as? String)!
                             
                             if let currentlat=(coordinate?["lat"] as? Double){
                             self.latValue=currentlat
                             }else{
                             self.latValue=0.0
                             }
                             if let currentlon=(coordinate?["lon"] as? Double){
                             self.longValue=currentlon
                             }else{
                             self.longValue=0.0
                             }
                             */
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
                            
                            if let rating = self.cuisinesFilter[self.j]["rating"] as? NSNumber
                            {
                                
                                K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                            }
                            if let factual_id = self.cuisinesFilter[self.j]["factual_id"] as? String{
                                K_INNERUSER_DATA.FactualId = factual_id
                            }
                            else{
                                K_INNERUSER_DATA.FactualId = ""
                            }

                            
                            
                            
                            
                            
                            //                                        self.latValue = (coordinate?["lat"] as? Double)!
                            //                                        self.longValue = (coordinate?["lon"] as? Double)!
                            
                            //  print("data lat \(self.latValue) long is \(self.longValue)  address is \(self.addressString) cit is \(self.cityString)that")
                            //code end
//                            var content = Dictionary<String,Any>()
//                            content.updateValue(self.latValue, forKey: "latvalue")
//                            content.updateValue(self.longValue, forKey: "longvalue")
//                            content.updateValue(self.nameRestaurant, forKey: "nameValue")
//                            content.updateValue(self.cityString , forKey: "cityValue")
                            //code added by mohit
                            var content = Dictionary<String,Any>()
                            content.updateValue(self.latValue, forKey: "latvalue")
                            content.updateValue(self.longValue, forKey: "longvalue")
                            content.updateValue(self.nameRestaurant, forKey: "nameValue")
                            content.updateValue(self.cityString , forKey: "cityValue")
                            content.updateValue(self.addressString , forKey: "Address")
                            content.updateValue(K_INNERUSER_DATA.Phone , forKey: "user_tel")
                            content.updateValue(K_INNERUSER_DATA.Website , forKey: "user_website")
                            content.updateValue(K_INNERUSER_DATA.Hours , forKey: "user_hours_display")
                            content.updateValue(K_INNERUSER_DATA.FactualId , forKey: "factualId")

                            self.annotationArray.append(content)
                           // print( self.annotationArray.count)
                            
                           // self.annotationArray.append(content)
                            // print( self.annotationArray.count)
                            
//                            let profileData = ProfileImages()
//                            profileData.name = self.nameRestaurant
//                            profileData.city = self.cityString
//                            profileData.latitudeValue = self.latValue
//                            profileData.longitudeValue = self.longValue
//                            profileData.address = ""
//                            profileData.photo_ref = ""
//                            self.ProfileImagesArray.append(profileData)
                            var cusineDetail = ProfileCuisineFilter()
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
                            
                            self.cuisineArray.append(cusineDetail)
                            
                            self.j = self.j + 1
                           // print(self.nameRestaurant, self.latValue,self.longValue)
                        }
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                    }
                    //                        else
                    //                        {
                    //
                    //                            SVProgressHUD.dismiss()
                    //                            self.view.isUserInteractionEnabled = true
                    //                            let alert = UIAlertController(title: "Taste", message:"Data not found",preferredStyle: UIAlertControllerStyle.alert)
                    //                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    //                                UIAlertAction in
                    //                                NSLog("OK Pressed")
                    //                            }
                    //                            alert.addAction(okAction)
                    //                            self.present(alert, animated: true, completion: nil)
                    //                            return
                    //                        }
                    
                    
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
                    self.tableView.reloadData()
                    self.countGoogleApiHit(index:self.selectedProfileIndex)
                    
                    
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
    
     func countGoogleApiHit(index:Int){
       // print(index,self.ProfileImagesArray.count,self.PhotoRefArray.count)
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
        
        
        
        
        
        print("-------Print Request Url",UrlTrimString)
        
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
                           // print("Rest Name is", NameOfRest)
                        }
                        let placeId = arrayDict.object(forKey: "place_id")
                        
                       // print("place id is---",placeId)
                        cuisineDetail.Placeid = placeId as! String
                      //  print(cuisineDetail.Placeid)
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
                                    
                                    
                                    
                                   // print("PhotoRef : \(PhotoRef)")
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
//        print("All photos Reference", self.PhotoRefArray)
//        print("All photos count", self.PhotoRefArray.count)
        /*   for ArrCount in annotationArray {
         
         print("--------Data is",annotationArray.count)
         // self.GoogleApi()
         
         //    if let parameterGoogle = ArrCount as? String{
         
         if let str = ArrCount["latvalue"] as? Double{
         print("Data Val is",str)
         
         
         let lat = ArrCount["latvalue"] as? Double
         let lon = ArrCount["longvalue"] as? Double
         
         let name = ArrCount["nameValue"] as? String
         let city = ArrCount["cityValue"] as? String
         
         
         let lat_long = "\(lat!),\(lon!)"
         let address = "\(name!)+\(city!)"
         
         let paramString = ["query":address, "location": lat_long, "radius":"500", "type": "restaurant","keyword":"cruise","key":"AIzaSyBWZ0-N1ry6uluUKonnKy5c2ECnA6QqfHs"] as [String : Any]
         print(paramString.count)
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
         let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=500&key=AIzaSyCm85ozJlxVBdYdr_GEhsy0Fi7lHvbKvhA"
         let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
         
         
         
         
         
         print("-------Print Request Url",UrlTrimString)
         
         DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
         if let dataDic = response as? [String:Any]
         {
         
         
         
         print("Respomse", dataDic)
         
         //         for ResponseCount in responce{
         
         self.tableView .reloadData()
         
         if let dataResponce = (response as AnyObject).object(forKey: "results"){
         
         let resultArray = dataResponce as! NSArray
         
         var contentRes = Dictionary<String,Any>()
         contentRes.updateValue(resultArray, forKey: "RefResults")
         
         self.RestaurantResultArray.append(contentRes)
         if resultArray.count > 0 {
         
         
         
         let arrayDict = resultArray[0] as! NSDictionary
         var NameOfRest = ""
         if let Rest_name = arrayDict.object(forKey: "name"){
         NameOfRest = Rest_name as! String
         print("Rest Name is", NameOfRest)
         }
         
         if let photosDict = arrayDict.object(forKey: "photos"){
         
         let photosArray = photosDict as! NSArray
         
         let placeId = arrayDict.object(forKey: "place_id")
         
         print("place id is---",placeId)
         
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
         
         //                                                                            for var j in 0..<self.cuisinesFilter.count {
         //                                                                                if let name = self.cuisinesFilter[j]["name"] as? String{
         //                                                                                    if name.localizedCaseInsensitiveContains(NameOfRest) {
         //                                                                                        print("index is ",name,j)
         //                                                                                        print(self.PhotoRefArray.count)
         //                                                                                         //self.PhotoRefArray.insert(content, at:j)
         //                                                                                    }
         //                                                                                }
         //                                                                            }
         
         self.PhotoRefArray.append(content)
         // call this after you update
         self.tableView .reloadData()
         
         
         
         print("PhotoRef : \(PhotoRef)")
         
         }
         }
         }
         }
         else{
         var content = Dictionary<String,Any>()
         content.updateValue("Defoult", forKey: "Photo_Ref")
         
         self.PhotoRefArray.append(content)
         print("Key Expaire");
         
         }
         
         }
         //           self.tableView.reloadData()
         
         }
         
         
         //  }
         })
         //                    MyDuniaConnectionHelper.GetDataFromJson(url: UrlTrimString, paramString: paramString) { (responce, status) in
         //
         //                        self.tableView.reloadData()
         //                         SVProgressHUD.dismiss()
         //                      print("Response is",responce)
         ////                        if let rest_images = resultArray as? [[String : Any]]{
         ////
         ////                            self.RestaurantResultArray.append(contentsOf: rest_images)
         ////                        }
         //               //         for ResponseCount in responce{
         //
         //
         //
         //                            if let dataResponce = responce.object(forKey: "results"){
         //
         //                                let resultArray = dataResponce as! NSArray
         //
         //                                var contentRes = Dictionary<String,Any>()
         //                                contentRes.updateValue(resultArray, forKey: "RefResults")
         //
         //                                self.RestaurantResultArray.append(contentRes)
         //                                if resultArray.count > 0 {
         //
         //
         //
         //                                    let arrayDict = resultArray[0] as! NSDictionary
         //
         //
         //
         //                                    if let photosDict = arrayDict.object(forKey: "photos"){
         //
         //                                        let photosArray = photosDict as! NSArray
         //
         //                                        let placeId = arrayDict.object(forKey: "place_id")
         //
         //                                        print("place id is---",placeId)
         //
         //                                        var contentPlaceId = Dictionary<String,Any>()
         //                                        contentPlaceId.updateValue(placeId!, forKey: "placeid")
         //
         //                                        self.PlaceIdArray.append(contentPlaceId)
         //
         //
         //                                        if photosArray.count > 0 {
         //
         //                                            let photoDict = photosArray[0] as! NSDictionary
         //
         //
         //
         //                                            if let photo_reference = photoDict.object(forKey: "photo_reference"){
         //
         //
         //                                                let PhotoRef = photo_reference as! String
         //                                             //   K_GoogleImagesData.ImagesDataArray.append(PhotoRef)
         //
         //                                                var content = Dictionary<String,Any>()
         //                                                content.updateValue(PhotoRef, forKey: "Photo_Ref")
         //
         //                                                self.PhotoRefArray.append(content)
         //                                                // call this after you update
         //
         //                                                print("PhotoRef : \(PhotoRef)")
         //
         //                                            }
         //                                        }
         //                                    }
         //                            }
         //                                else{
         //                                    var content = Dictionary<String,Any>()
         //                                    content.updateValue("Defoult", forKey: "Photo_Ref")
         //
         //                                    self.PhotoRefArray.append(content)
         //                                    print("Key Expaire");
         //
         //                                }
         //
         //                        }
         //                                                    self.tableView.reloadData()
         //
         //        }
         
         //self.tableView.reloadData()
         
         //                    GoogleImages.GoogleImageManager.GetDataFromGoogleApi(params: parameter, completion: {(response) in
         //                                        if   let dataDicGoogle = response as? [[String:Any]]
         //                                        {
         //                                            print("Data val mohit Google Api",dataDicGoogle)
         //
         //                                            self.loadFirstPhotoForPlace(placeID: "ChIJ98rIiTiuEmsRErGRhS-ILJo")
         //
         //                                        }
         //
         //                                    })
         
         
         }
         //   }
         
         //            GoogleImages.GoogleImageManager.GetDataFromGoogleApi(params: str, completion: {(response) in
         //                if   let dataDicGoogle = response as? [[String:Any]]
         //                {
         //                    print("Data val mohit Google Api",dataDicGoogle)
         //
         //                    self.loadFirstPhotoForPlace(placeID: "ChIJ98rIiTiuEmsRErGRhS-ILJo")
         //
         //                }
         //
         //            })
         
         
         }
         SVProgressHUD.dismiss()
         print("All photos Reference", self.PhotoRefArray)
         print("All photos count", self.PhotoRefArray.count)
         */
        //  self.tableView .reloadData()
        
    }
    
    func hideMapped()
        
    {
        self.mapWrapperView.isHidden = true
        
    }
    
    func viewNotifications() {
        let vc = NotificatioinsViewController() as! NotificatioinsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func settingsTapped()
    {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func showPin()
    {
        
        //        let annotation = MKPointAnnotation()
        //        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
        //        annotation.coordinate = centerCoordinate
        //        annotation.title = address
        //        annotation.subtitle = city
        //        mapView.addAnnotation(annotation)
        
        
        //        content.updateValue(self.latValue, forKey: "latvalue")
        //        content.updateValue(self.longValue, forKey: "longvalue")
        //        content.updateValue(self.addressString, forKey: "addressvalue")
        //        content.updateValue(self.cityString , forKey: "cityValue")
        
//        let sydney = GMSCameraPosition.camera(withLatitude: annotationArray  [0] ["latvalue"] as! Double,
//                                              longitude: annotationArray [0] ["longvalue"] as! Double,
//                                              zoom: 12)
//         mapView.camera = sydney
        for location in annotationArray {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
            marker.title = location["nameValue"] as? String
            marker.snippet = location["cityValue"] as? String
            marker.icon = UIImage(named:"map-markar")!
            marker.map = mapView

           // let annotation = MKPointAnnotation()
            //            annotation.title = location["addressvalue"] as? String
            //            annotation.subtitle = location["cityValue"] as? String
//            annotation.title = location["nameValue"] as? String
//            annotation.subtitle = location["cityValue"] as? String
//            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
//            print(annotation.title,annotation.subtitle,annotation.coordinate)
//            mapView.addAnnotation(annotation)
            
            
            // let location = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double , longitude: location["longvalue"] as! Double)
            
            // let region = MKCoordinateRegionMakeWithDistance(location, 400.0, 400.0)
            
            //  print("set region for each element is \(region)")
            
            //  mapView.setRegion(region, animated: true)
            
            
            
//            let location = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double , longitude: location["longvalue"] as! Double)
//            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//            mapView.setRegion(region, animated: true)
            
            //  print("set region for each element is \(region)")
            
        }
        
    }
    
    //    func zoomToRegion() {
    //
    //        let location = CLLocationCoordinate2D(latitude: lat , longitude: long)
    //
    //        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
    //
    //        mapView.setRegion(region, animated: true)
    //    }
    
    
    func hideMap() {
        self.mapWrapperView.isHidden = true
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(self.cuisinesFilter.count)
      //  return cuisinesFilter.count;
       // return self.PhotoRefArray.count
        return self.cuisineArray.count
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
        
        //cell.imageView?.image = UIImage(named:"dummy-img01")
        //imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.8)
        //        if (cuisineName == "American") {
        //            imageView.image = UIImage(named: "dummy-img01")
        //        }
        //        else if (cuisineName == "Pizza") {
        //            imageView.image = UIImage(named: "dummy-img02")
        //        }
        //        else {
        //            imageView.image = UIImage(named: "dummy-img03")
        //        }
//        let param_val = (PhotoRefArray[indexPath.row] ["Photo_Ref"] as! String)
//        
//        if param_val.localizedCaseInsensitiveContains("Defoult") {
//            imageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "rest_defoutImage"))
//        }else{
//            
//            let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(param_val)&key=AIzaSyBf5p8z9QCBLh2re71V8bo-xB_cpoqcNmU")!
//            print("Url Is Final",url)
//            
//            let bannerUrl = "\(url)"
//            // let bannerUrl = url as? String
//            //  let defoultImageurl = URL(string: "http://159.203.180.90:9090/img/logo_image.gif")
//            
//            imageView.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
//            
//            print("----------",bannerUrl)
//        }
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[indexPath.row]
       // print(cuisineDetail.cuisineName,indexPath.row)
//        if cuisineDetail.photo_ref.count > 0 {
//            imageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
//        }
        //print(cuisineDetail.photo_ref)
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
            make.height.equalTo(40)
            make.top.equalTo(20)
        }
        
        
        
        textRestaurant.text = self.cuisinesFilter[indexPath.row]["name"] as? String
        
        
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
            make.top.equalTo(60)
        }
        
        
      /*  if let cuisineArray = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
            textLabelCuisine.text = cuisineArray[0] as? String
        }
        else{
            textLabelCuisine.text = ""
        }
        */
        
        
        textLabelCuisine.text =  self.cuisineName
        
        let cuisineCoordinates = UILabel()
        // cuisineCoordinates.textColor = UIColor.gray
        cell.contentView.addSubview(cuisineCoordinates)
        cuisineCoordinates.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.top.equalTo(82)
        }
        cuisineCoordinates.textColor = UIColor.white
        cuisineCoordinates.font = UIFont(name:K_Font_Color,size:18)
       // var coordinate : [String:Any]?
       // coordinate = self.cuisinesFilter[indexPath.row]["coordinates"] as? [String:Any]
        if let currentlat = self.cuisinesFilter[indexPath.row]["latitude"] as? Double{
             self.latValueRestaurant = currentlat
        }else{
             self.latValueRestaurant = 0.0
        }
        if let currentlon = self.cuisinesFilter[indexPath.row]["longitude"] as? Double{
            self.longValueRestaurant = currentlon
        }else{
           self.longValueRestaurant = 0.0
        }
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
       // print(self.latValueRestaurant,self.longValueRestaurant)
        // let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
        let singelton = SharedManager.sharedInstance
        let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
        let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude:  self.longValueRestaurant)
       // print(singelton.latValueInitial,singelton.longValueInitial)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        let finaldist =  distanceInMeters / 1609.344
        
        
        cuisineCoordinates.text = String(format:"%.1f", finaldist) + " Miles"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        
        
        


        
       // print(indexPath.row)
                
        
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
        
        //        K_INNERUSER_DATA.Address = (location?["address"] as? String)!
        //        K_INNERUSER_DATA.CITY=(location?["city"] as? String)!
        //        K_INNERUSER_DATA.Country=(location?["country"] as? String)!
        //        K_INNERUSER_DATA.State=(location?["state"] as? String)!
        //        K_INNERUSER_DATA.ZIP=(location?["zip"] as? String)!
        //
        //        K_INNERUSER_DATA.Phone = self.cuisinesFilter[indexPath.row]["tel"] as! String
        //        K_INNERUSER_DATA.Website =   self.cuisinesFilter[indexPath.row]["website"] as! String
        
//        if let price = self.cuisinesFilter[indexPath.row]["price"] as? NSNumber
//        {
//            K_INNERUSER_DATA.Price = String(format:"%@",price)
//        }
//        
//        if let rating = self.cuisinesFilter[indexPath.row]["rating"] as? NSNumber
//        {
//            
//            K_INNERUSER_DATA.Rating = String(format:"%@",rating)
//        }
        
       // K_INNERUSER_DATA.CuisineName = self.cuisineName
         K_INNERUSER_DATA.CuisinSeleted =  self.cuisineName
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
        let latNavigate =  annotationArray  [indexPath.row] ["latvalue"] as! Double
        
        K_INNERUSER_DATA.latvalueNavigate = latNavigate
        
        let longNavigate =  annotationArray  [indexPath.row] ["longvalue"] as! Double
        
        K_INNERUSER_DATA.longvalueNavigate = longNavigate
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[indexPath.row]
        K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
        K_INNERUSER_DATA.Price = cuisineDetail.Price
        K_INNERUSER_DATA.placeId = cuisineDetail.Placeid

      //  print("place" ,K_INNERUSER_DATA.placeId)
        K_INNERUSER_DATA.Rating = cuisineDetail.rating
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
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
           
            if Reachability.isConnectedToNetwork() == true
            {
                isloading = true
                pageNo = pageNo + 1
                if self.cuisinesFilter.count >= 5{
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
    
    
    func mapButtonClicked()
        
    {
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        self.showPin()
        mapWrapperView.isHidden = false
    }
    
    
    func buttonPressed(sender:UIButton!)
    {
        let buttonRow = sender.tag
        //   print("button is Pressed")
        //  print("Clicked Button Row is\(buttonRow)")
        
        var coordinate : [String:Any]?
        
        var location : [String:Any]?
        
        coordinate = self.cuisinesFilter[buttonRow]["coordinates"] as? [String:Any]
        
        location = self.cuisinesFilter[buttonRow]["location"] as? [String:Any]
        
        address = (location?["address"] as? String)!
        city = (location?["city"] as? String)!
        
        //   print("addressss is \(address) and city is \(city)")
        
        
        lat = (coordinate?["lat"] as? Double)!
        long = (coordinate?["lon"] as? Double)!
        
        //  print("data lat \(lat) long is \(long) that")
        
        self.showPin()
        
        // self.zoomToRegion()
        
        mapWrapperView.isHidden = false
        
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
//        print("test",marker.title)
//        print("Data is ",self.annotationArray)
        
        for var i in 0..<self.annotationArray.count  {
            
            if let name =  annotationArray  [i] ["nameValue"] as? String{
                if name == marker.title {
                    
                    
                    
                    
                    let city =  annotationArray  [i] ["cityValue"]
                    K_INNERUSER_DATA.cityname = city as! String
                    let name =  annotationArray  [i] ["nameValue"]
                    K_INNERUSER_DATA.name = name as! String
                    let latNavigate =  annotationArray  [i] ["latvalue"] as! Double
                    K_INNERUSER_DATA.latvalueNavigate = latNavigate
                    let longNavigate =  annotationArray  [i] ["longvalue"] as! Double
                    K_INNERUSER_DATA.longvalueNavigate = longNavigate
                    
                    let Phone_no =  annotationArray  [i] ["user_tel"]
                    K_INNERUSER_DATA.Phone = Phone_no as! String
                    
                    let web =  annotationArray  [i] ["user_website"]
                    K_INNERUSER_DATA.Website = web as! String
                    
                    let Hour_count =  annotationArray  [i] ["user_hours_display"]
                    K_INNERUSER_DATA.Hours = Hour_count as! String
                    
                    let user_add =  annotationArray  [i] ["Address"]
                    K_INNERUSER_DATA.Address = user_add as! String
                    
                    let factualID =  annotationArray  [i] ["factualId"]
                    K_INNERUSER_DATA.FactualId = factualID as! String
                    
                    
                    
                    var cuisineDetail = ProfileCuisineFilter()
                    cuisineDetail = cuisineArray[i]
                    K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                    
                    K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                    
                    
                    K_INNERUSER_DATA.RestaurantName = cuisineDetail.restaurantName
                    
                    K_INNERUSER_DATA.Price = cuisineDetail.Price
                    K_INNERUSER_DATA.Rating = cuisineDetail.rating
                    K_INNERUSER_DATA.CuisinSeleted =  self.cuisineName
                    
                    //                    var content = Dictionary<String,Any>()
                    //                    content.updateValue(PhotoRef, forKey: "Photo_Ref")
                    //                    content.updateValue(NameOfRest, forKey: "NameOfRest")
                    //                    self.MarkerClickArray.append(content)
                }
                
            }
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // added by ranjit 9 OCT
    //Location Manager delegates  commented above code for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // added by ranjit 9 OCT
        self.mapView?.isMyLocationEnabled = true
        let location = locations.first
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager?.stopUpdatingLocation()
        
    }

    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    
    
    
    
}
