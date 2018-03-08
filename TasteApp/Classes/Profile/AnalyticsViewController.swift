//
//  AnalyticsViewController.swift
//  TasteApp
//
//  Created by Shubhank on 21/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CoreLocation
class AnalyticsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate
{
    
    var cuisines = [[String:Any]]()
    var cities = [[String:Any]]()
    var titleLabel:UILabel!
    var cuisineCount :Float = 0.0
    var cityCount :Float = 0.0
    var loopNumber:Int = 15
    let citySliderLabel3 = UILabel()
    let citySlider3 = RPCircularProgress()
    var slider = RPCircularProgress()
    let toprecentHeading = UILabel()
     var ProfileImagesArray = [ProfileImages]()
     var PlaceIdArray = [[String:Any]]()
    var PhotoRefArray = [[String:Any]]()
    var annotationArray = [[String:Any]]()
     var nameRestaurant:String = ""
    var selectedProfileIndex = 0
    var f = 0.0,f1 = 0.0,f2 = 0.0
     let BellBtn = UIButton(type: .custom)
    var c = 0.0,c1 = 0.0,c2 = 0.0
    var arrNotification =  [[String:Any]]()
    var latValue : Double = 0.0
    var longValue : Double = 0.0
    var latValueRestaurant : Double = 0.0
    var longValueRestaurant : Double = 0.0
    var locationManager:CLLocationManager?
    // var i = 0
    var cuisinesFilter = [[String:Any]]()
    var cuisinesPageFilter = [[String:Any]]()
    var addressString = ""
    var cityString = ""
    var stateString = ""
    var countryString = ""
    var pageNo = 1
    var  isloading  = true
    var maxRow = 0
     var j = 0
    let tableView = UITableView()
     var cuisineArray = [ProfileCuisineFilter]()
    var GetCuisineName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if Reachability.isConnectedToNetwork() == true
        {
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
                NSLog("OK Pressed")
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
        self.NotificationMethod()
         NotificationCenter.default.addObserver(self, selector: #selector(AnalyticsViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        let manager = NetworkReachabilityManager(host: "www.google.com")
        manager?.listener = { status in
            
            
            print("Network Status Changed: \(status)")
            print("network reachable \(manager!.isReachable)")
            
            if manager!.isReachable != true
            {
                
                SVProgressHUD.dismiss()
            }
            else
            {
                //self.setupView()
                
                
            }
        }
        manager?.startListening()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        super.viewWillDisappear(animated)
    }
    

    func GoNotification() {
        let vc = NotificatioinsViewController() as NotificatioinsViewController
      //  vc.RecvarrNotification = self.arrNotification
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    func goBack() {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        titleLabel = UILabel()
        titleLabel.text = "DINING PROFILE"
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
        
        
        
        BellBtn.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
        BellBtn.addTarget(self, action: #selector(self.GoNotification), for: .touchUpInside)
        self.view.addSubview(BellBtn)
        BellBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        SVProgressHUD.show()
        
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"limit":"5","offset":""]
        let singelton = SharedManager.sharedInstance
        
        let parameters = ["user_id":singelton.loginId,"limit":"5","offset":""]
       // print(singelton.loginId)
        DataManager.sharedManager.getAnalytics(params: parameters) { (responseObj) in
            // print(responseObj)
            if let dataDic = responseObj as? [String:Any] {
                if let cuisineArr = dataDic["cuisines"] as? [[String:Any]] {
                    self.cuisines = cuisineArr
                    
                }
                    
                else
                {
                    
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        // NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
                
                if let citiesArr = dataDic["cities"] as? [[String:Any]] {
                    self.cities = citiesArr
                }
                
                
                
                self.loadData()
            }
            
            SVProgressHUD.dismiss()
        }
        self.getRecentTaste()
    }
    
    func getRecentTaste(){
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            
            //please give suggestion here for entry cuisine 0r city
            
            let parameter = [ "user_id":singelton.loginId,"page":self.pageNo] as [String : Any]
            
            DataManager.sharedManager.getRecentTaste(params: parameter, completion: { (response) in
                if let dataDic = response as? [[String:Any]]
                {
                    self.cuisinesPageFilter = dataDic
                   
                    if self.cuisinesPageFilter.count > 0
                    {
                        self.cuisinesFilter.append(contentsOf: self.cuisinesPageFilter)
                        while self.j < self.cuisinesFilter.count
                        {
                            // self.cuisinesFilter.append(contentsOf: self.cuisinesPageFilter)
                           // print(self.cuisinesFilter.count)
                            self.isloading = false
                            var coordinate : [String:Any]?
                            
                            var location : [String:Any]?
                            
                            coordinate = self.cuisinesFilter[self.j]["coordinates"] as? [String:Any]
                            location = self.cuisinesFilter[self.j]["location"] as? [String:Any]
                            
                            if let cuisineName = self.cuisinesFilter[self.j]["cuisine"] as? NSArray{
                                if cuisineName.count > 0{
                                    if let cuisinGet = cuisineName[0] as? String{
                                        self.GetCuisineName = cuisinGet
                                    }
                                    else
                                    {
                                        self.GetCuisineName=""
                                    }
                                }
                                
                            }
                            else{
                                self.GetCuisineName=""
                            }
                            
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
                            if let locCountry=(location?["country"] as? String){
                               self.countryString = locCountry
                            }
                            else{
                               self.countryString = ""
                            }
                            
                            if let locState=(location?["state"] as? String){
                                 self.stateString = locState
                            }
                            else{
                                self.stateString = ""
                            }
                            if let name = self.cuisinesFilter[self.j]["name"] as? String{
                                self.nameRestaurant = name
                            }
                            else
                            {
                                self.nameRestaurant=""
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
                            
                            //code end
                            var content = Dictionary<String,Any>()
                            content.updateValue(self.latValue, forKey: "latvalue")
                            content.updateValue(self.longValue, forKey: "longvalue")
                            content.updateValue(self.nameRestaurant, forKey: "nameValue")
                            content.updateValue(self.cityString , forKey: "cityValue")
                            content.updateValue(self.addressString , forKey: "Address")
                            content.updateValue(self.GetCuisineName , forKey: "GetCuisine")

                            self.annotationArray.append(content)
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
                        }
                    

                        
                        
                        
                        self.isloading = false
                       // print("Print Data is", dataDic)
                    }
                   // print(dataDic)
                    
                    
                }
                else{
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                }
                DispatchQueue.main.async {
                  //  print("Get Array from Response",self.cuisinesFilter)
                     self.countGoogleApiHit(index:self.selectedProfileIndex)
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
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
      //  print(index,self.ProfileImagesArray.count,self.PhotoRefArray.count)
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
      //  print(paramString)
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
                
             //   print("Respomse", dataDic)
                
                //         for ResponseCount in responce{
                
                self.tableView .reloadData()
                
                if let dataResponce = (response as AnyObject).object(forKey: "results"){
                    
                    let resultArray = dataResponce as! NSArray
                    
                    var contentRes = Dictionary<String,Any>()
                    contentRes.updateValue(resultArray, forKey: "RefResults")
                    
                  //  self.RestaurantResultArray.append(contentRes)
                    if resultArray.count > 0 {
                        
                        
                        
                        let arrayDict = resultArray[0] as! NSDictionary
                        var NameOfRest = ""
                        if let Rest_name = arrayDict.object(forKey: "name"){
                            NameOfRest = Rest_name as! String
                         //   print("Rest Name is", NameOfRest)
                        }
                        let placeId = arrayDict.object(forKey: "place_id")
                        cuisineDetail.Placeid = placeId as! String
                        if let photosDict = arrayDict.object(forKey: "photos"){
                            
                            let photosArray = photosDict as! NSArray
                            
//                            let placeId = arrayDict.object(forKey: "place_id")
//                             cuisineDetail.Placeid = placeId as! String
//                            print("place id is---",placeId)
                            
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
                                   // print("index is",self.self.selectedProfileIndex,cuisineDetail.photo_ref)
                                    
                                    self.selectedProfileIndex += 1
                                    self.countGoogleApiHit(index: self.selectedProfileIndex)
                                    self.tableView.reloadData()
                                }
                            }
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
    
    func viewNotifications() {
        let vc = NotificatioinsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData() {
        
        for number in 0..<(self.cuisines.count-1)
            
        {
            let circle1 = Float(self.cuisines[number]["count"] as! Int)
            
            cuisineCount = cuisineCount + circle1
        }
        for number in 0..<(self.cities.count-1)
            
        {
            let circle1 = Float(self.cities[number]["count"] as! Int)
            
            cityCount = cityCount + circle1
        }
        
        /*  print("count no is \(cityCount)")
         print("count no is \(cuisineCount)")
         
         let circle1 = Float(self.cuisines[0]["count"] as! Int)
         let circle2 = Float(self.cuisines[1]["count"] as! Int)
         let circle3 = Float(self.cuisines[2]["count"] as! Int)
         print("circle 1 count is \(circle1) circle2 count is \(circle2) circle3 count is \(circle3)")
         */
        
        let sliderWidth = (self.view.frame.size.width - 50)/3
      //  print("slider width is \(sliderWidth)")
      //  print("view is \(self.view.frame.size.width)")
        
        let topCuisineLabel = UILabel()
        topCuisineLabel.text = "Top Cuisines"
        self.view.addSubview(topCuisineLabel)
        topCuisineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        topCuisineLabel.textAlignment = .center
        //topCuisineLabel.font = UIFont(name: K_Font_Color, size: 23)
        topCuisineLabel.font = UIFont(name: K_Font_Color_Light, size: 23)
        
     /*   let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        
       
        BellBtn.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
        BellBtn.addTarget(self, action: #selector(self.GoNotification), for: .touchUpInside)
        self.view.addSubview(BellBtn)
        BellBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        */
//        let notifButton = UIButton(type: .custom)
//        notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
//        self.view.addSubview(notifButton)
//        notifButton.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
        // notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        
        if self.cuisines.count == 1
        {
            
            
            slider = RPCircularProgress()
            slider.trackTintColor = UIColor.lightGray
            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            slider.thicknessRatio = 0.22
            slider.enableIndeterminate(false) {
               // print("done")
            }
            
            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            let progress1 = Float(self.cuisines[0]["count"] as! Int)
            
            
            let variable = CGFloat(progress1/cuisineCount)
            
            let twoDecimalPlaces = String(format: "%.3f",variable)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
                f = Double(CGFloat(n))
            }
            
            slider.updateProgress(CGFloat(f))
            // slider.updateProgress(CGFloat((progress1/100))
            //slider.updateProgress(0.6,animated:true)
            self.view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel = UILabel()
            // sliderLabel.text = self.cuisines[0]["_id"] as? String
            if   let lblslider = self.cuisines[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel.textAlignment = .center
            sliderLabel.numberOfLines = 3
            self.view.addSubview(sliderLabel)
            sliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(slider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
        }//count city 1
            
            
        else if self.cuisines.count == 2
        {
            
            slider = RPCircularProgress()
            slider.trackTintColor = UIColor.lightGray
            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            slider.thicknessRatio = 0.22
            slider.enableIndeterminate(false) {
             //   print("done")
            }
            
            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            let progress1 = Float(self.cuisines[0]["count"] as! Int)
            
            
            let variable = CGFloat(progress1/cuisineCount)
            
            let twoDecimalPlaces = String(format: "%.3f",variable)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
                f = Double(CGFloat(n))
            }
            
            slider.updateProgress(CGFloat(f))
            // slider.updateProgress(CGFloat((progress1/100))
            //slider.updateProgress(0.6,animated:true)
            self.view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel = UILabel()
            //sliderLabel.text = self.cuisines[0]["_id"] as? String
            if   let lblslider = self.cuisines[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel.textAlignment = .center
            sliderLabel.numberOfLines = 3
            self.view.addSubview(sliderLabel)
            sliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(slider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            let slider2 = RPCircularProgress()
            slider2.trackTintColor = UIColor.lightGray
            slider2.progressTintColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            slider2.thicknessRatio = 0.22
            slider2.enableIndeterminate(false) {
               // print("done")
            }
            //slider2.updateProgress(0.5)
            slider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            let progress2 = Float(self.cuisines[1]["count"] as! Int)
            
            let variable1 = CGFloat(progress2/cuisineCount)
            
            let twoDecimalPlaces1 = String(format: "%.3f",variable1)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces1) {
                f1 = Double(CGFloat(n))
            }
            
            
            //slider2.updateProgress(0.8,animated:true)
            //slider2.updateProgress(CGFloat((progress2 * 3)/100))
            slider2.updateProgress(CGFloat(f1))
            
            
            self.view.addSubview(slider2)
            slider2.snp.makeConstraints { (make) in
                make.top.equalTo(slider.snp.top)
                make.left.equalTo(slider.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel2 = UILabel()
            // sliderLabel2.text = self.cuisines[1]["_id"] as? String
            if   let lblslider = self.cuisines[1]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            sliderLabel2.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel2.textAlignment = .center
            sliderLabel2.numberOfLines = 2
            self.view.addSubview(sliderLabel2)
            sliderLabel2.snp.makeConstraints { (make) in
                make.center.equalTo(slider2)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
        }
            
        else
            
        {
            
            //count 3 hain
            
            slider = RPCircularProgress()
            slider.trackTintColor = UIColor.lightGray
            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            slider.thicknessRatio = 0.22
            slider.enableIndeterminate(false) {
               // print("done")
            }
            
            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            let progress1 = Float(self.cuisines[0]["count"] as! Int)
            
            
            let variable = CGFloat(progress1/cuisineCount)
            
            let twoDecimalPlaces = String(format: "%.3f",variable)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
                f = Double(CGFloat(n))
            }
            
            slider.updateProgress(CGFloat(f))
            // slider.updateProgress(CGFloat((progress1/100))
            //slider.updateProgress(0.6,animated:true)
            self.view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel = UILabel()
            
            // sliderLabel.text = self.cuisines[0]["_id"] as? String
            if   let lblslider = self.cuisines[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel.textAlignment = .center
            sliderLabel.numberOfLines = 3
            self.view.addSubview(sliderLabel)
            sliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(slider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            let slider2 = RPCircularProgress()
            slider2.trackTintColor = UIColor.lightGray
            slider2.progressTintColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            slider2.thicknessRatio = 0.22
            slider2.enableIndeterminate(false) {
              //  print("done")
            }
            //slider2.updateProgress(0.5)
            slider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            let progress2 = Float(self.cuisines[1]["count"] as! Int)
            
            let variable1 = CGFloat(progress2/cuisineCount)
            
            let twoDecimalPlaces1 = String(format: "%.3f",variable1)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces1) {
                f1 = Double(CGFloat(n))
            }
            
            
            //slider2.updateProgress(0.8,animated:true)
            //slider2.updateProgress(CGFloat((progress2 * 3)/100))
            slider2.updateProgress(CGFloat(f1))
            
            
            self.view.addSubview(slider2)
            slider2.snp.makeConstraints { (make) in
                make.top.equalTo(slider.snp.top)
                make.left.equalTo(slider.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel2 = UILabel()
            
            //  sliderLabel2.text = self.cuisines[1]["_id"] as? String
            
            if   let lblslider = self.cuisines[1]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
            }
            sliderLabel2.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel2.textAlignment = .center
            sliderLabel2.numberOfLines = 2
            self.view.addSubview(sliderLabel2)
            sliderLabel2.snp.makeConstraints { (make) in
                make.center.equalTo(slider2)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let slider3 = RPCircularProgress()
            slider3.trackTintColor = UIColor.lightGray
            slider3.progressTintColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            slider3.thicknessRatio = 0.22
            slider3.enableIndeterminate(false) {
              //  print("done")
            }
            //slider3.updateProgress(0.5)
            let progress3 = Float(self.cuisines[2]["count"] as! Int)
            
            
            
            let variable3 = CGFloat(progress3/cuisineCount)
            
            let twoDecimalPlaces3 = String(format: "%.3f",variable3)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces3)
            {
                f2 = Double(CGFloat(n))
            }
            
            
            slider3.updateProgress(CGFloat(f2))
            // slider3.updateProgress(CGFloat((progress3 * 2)/100))
            //slider3.updateProgress(0.2,animated:true)
            slider3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine3)))
            self.view.addSubview(slider3)
            slider3.snp.makeConstraints { (make) in
                make.top.equalTo(slider.snp.top)
                make.left.equalTo(slider2.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel3 = UILabel()
            // sliderLabel3.text = self.cuisines[2]["_id"] as? String
            
            if   let lblslider = self.cuisines[2]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel3.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            
            sliderLabel3.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel3.textAlignment = .center
            sliderLabel3.numberOfLines = 2
            self.view.addSubview(sliderLabel3)
            sliderLabel3.snp.makeConstraints { (make) in
                make.center.equalTo(slider3)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
        }
        
        
        
        let topCityLabel = UILabel()
        topCityLabel.text = "Top Cities"
        self.view.addSubview(topCityLabel)
        topCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(slider.snp.bottom).offset(20)
        }
        topCityLabel.textAlignment = .center
        //topCityLabel.font = UIFont(name:  K_Font_Color, size: 23)
        topCityLabel.font = UIFont(name:  K_Font_Color_Light, size: 23)
        
        
        if self.cities.count == 1
        {
            
            
            let citySlider = RPCircularProgress()
            citySlider.trackTintColor = UIColor.lightGray
            citySlider.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            citySlider.thicknessRatio = 0.22
            citySlider.enableIndeterminate(false) {
               // print("done")
            }
            
            citySlider.isUserInteractionEnabled = true
            citySlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
            //citySlider.updateProgress(0.5)
            let progress4 = Float(self.cities[0]["count"] as! Int)
            
            let variable4 = CGFloat(progress4/cityCount)
            
            let twoDecimalPlaces4 = String(format: "%.3f",variable4)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces4) {
                c = Double(CGFloat(n))
            }
            
            
            citySlider.updateProgress(CGFloat(c))
            //citySlider.updateProgress(CGFloat((progress4 * 5 )/100))
            self.view.addSubview(citySlider)
            citySlider.snp.makeConstraints { (make) in
                make.top.equalTo(topCityLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let citySliderLabel = UILabel()
            // citySliderLabel.text = self.cities[0]["_id"] as? String
            if   let lblslider = self.cities[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                citySliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            citySliderLabel.textAlignment = .center
            citySliderLabel.numberOfLines = 3
            citySliderLabel.font = UIFont(name:K_Font_Color,size:12)
            self.view.addSubview(citySliderLabel)
            citySliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(citySlider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            let toprecentHeading = UILabel()
            toprecentHeading.text = "Recent Tastes"
            self.view.addSubview(toprecentHeading)
            toprecentHeading.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(citySlider.snp.bottom).offset(10)
            }
            toprecentHeading.textAlignment = .center
            //   toprecentHeading.font = UIFont(name: K_Font_Color, size: 23)
            toprecentHeading.font = UIFont(name: K_Font_Color_Light, size: 23)
            
        } //Count 1 hain to
            
            
            
        else if self.cities.count == 2
        {
            
            let citySlider = RPCircularProgress()
            citySlider.trackTintColor = UIColor.lightGray
            citySlider.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            citySlider.thicknessRatio = 0.22
            citySlider.enableIndeterminate(false) {
              //  print("done")
            }
            
            citySlider.isUserInteractionEnabled = true
            citySlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
            //citySlider.updateProgress(0.5)
            let progress4 = Float(self.cities[0]["count"] as! Int)
            
            let variable4 = CGFloat(progress4/cityCount)
            
            let twoDecimalPlaces4 = String(format: "%.3f",variable4)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces4) {
                c = Double(CGFloat(n))
            }
            
            
            citySlider.updateProgress(CGFloat(c))
            //citySlider.updateProgress(CGFloat((progress4 * 5 )/100))
            self.view.addSubview(citySlider)
            citySlider.snp.makeConstraints { (make) in
                make.top.equalTo(topCityLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let citySliderLabel = UILabel()
            // citySliderLabel.text = self.cities[0]["_id"] as? String
            if   let lblslider = self.cities[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                citySliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            citySliderLabel.textAlignment = .center
            citySliderLabel.numberOfLines = 3
            citySliderLabel.font = UIFont(name:K_Font_Color,size:12)
            self.view.addSubview(citySliderLabel)
            citySliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(citySlider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            let citySlider2 = RPCircularProgress()
            citySlider2.trackTintColor = UIColor.lightGray
            citySlider2.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            citySlider2.thicknessRatio = 0.22
            citySlider2.enableIndeterminate(false) {
               // print("done")
            }
            citySlider2.isUserInteractionEnabled = true
            citySlider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
            
            
            //citySlider.updateProgress(0.5)
            let progress5 = Float(self.cities[1]["count"] as! Int)
            
            
            let variable5 = CGFloat(progress5/cityCount)
            
            let twoDecimalPlaces5 = String(format: "%.3f",variable5)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces5) {
                c1 = Double(CGFloat(n))
            }
            citySlider2.updateProgress(CGFloat(c1))
            //citySlider2.updateProgress(CGFloat((progress5 * 5)/100))
            self.view.addSubview(citySlider2)
            citySlider2.snp.makeConstraints { (make) in
                make.top.equalTo(topCityLabel.snp.bottom).offset(10)
                make.left.equalTo(citySlider.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let citySliderLabel2 = UILabel()
            // citySliderLabel2.text = self.cities[1]["_id"] as? String
            if   let lblslider = self.cities[1]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                citySliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
            }
            citySliderLabel2.font = UIFont(name:K_Font_Color,size:12)
            citySliderLabel2.textAlignment = .center
            citySliderLabel2.numberOfLines = 3
            self.view.addSubview(citySliderLabel2)
            citySliderLabel2.snp.makeConstraints { (make) in
                make.center.equalTo(citySlider2)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            let toprecentHeading = UILabel()
            toprecentHeading.text = "Recent Tastes"
            self.view.addSubview(toprecentHeading)
            toprecentHeading.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(citySlider2.snp.bottom).offset(10)
            }
            toprecentHeading.textAlignment = .center
            // toprecentHeading.font = UIFont(name: K_Font_Color, size: 23)
            toprecentHeading.font = UIFont(name: K_Font_Color_Light, size: 23)
            
            
            
        } //count 2 hain to
            
        else
        {
            
            
            let citySlider = RPCircularProgress()
            citySlider.trackTintColor = UIColor.lightGray
            citySlider.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            citySlider.thicknessRatio = 0.22
            citySlider.enableIndeterminate(false) {
              //  print("done")
            }
            
            citySlider.isUserInteractionEnabled = true
            citySlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
            //citySlider.updateProgress(0.5)
            let progress4 = Float(self.cities[0]["count"] as! Int)
            
            let variable4 = CGFloat(progress4/cityCount)
            
            let twoDecimalPlaces4 = String(format: "%.3f",variable4)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces4) {
                c = Double(CGFloat(n))
            }
            
            
            citySlider.updateProgress(CGFloat(c))
            //citySlider.updateProgress(CGFloat((progress4 * 5 )/100))
            self.view.addSubview(citySlider)
            citySlider.snp.makeConstraints { (make) in
                make.top.equalTo(topCityLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let citySliderLabel = UILabel()
            // citySliderLabel.text = self.cities[0]["_id"] as? String
            if   let lblslider = self.cities[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                citySliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            citySliderLabel.textAlignment = .center
            citySliderLabel.numberOfLines = 3
            citySliderLabel.font = UIFont(name:K_Font_Color,size:12)
            self.view.addSubview(citySliderLabel)
            citySliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(citySlider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            let citySlider2 = RPCircularProgress()
            citySlider2.trackTintColor = UIColor.lightGray
            citySlider2.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            citySlider2.thicknessRatio = 0.22
            citySlider2.enableIndeterminate(false) {
               // print("done")
            }
            citySlider2.isUserInteractionEnabled = true
            citySlider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
            
            
            //citySlider.updateProgress(0.5)
            let progress5 = Float(self.cities[1]["count"] as! Int)
            
            
            let variable5 = CGFloat(progress5/cityCount)
            
            let twoDecimalPlaces5 = String(format: "%.3f",variable5)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces5) {
                c1 = Double(CGFloat(n))
            }
            citySlider2.updateProgress(CGFloat(c1))
            //citySlider2.updateProgress(CGFloat((progress5 * 5)/100))
            self.view.addSubview(citySlider2)
            citySlider2.snp.makeConstraints { (make) in
                make.top.equalTo(topCityLabel.snp.bottom).offset(10)
                make.left.equalTo(citySlider.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let citySliderLabel2 = UILabel()
            citySliderLabel2.text = self.cities[1]["_id"] as? String
            if   let lblslider = self.cities[1]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                citySliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
            }
            citySliderLabel2.font = UIFont(name:K_Font_Color,size:12)
            citySliderLabel2.textAlignment = .center
            citySliderLabel2.numberOfLines = 3
            self.view.addSubview(citySliderLabel2)
            citySliderLabel2.snp.makeConstraints { (make) in
                make.center.equalTo(citySlider2)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            //let citySlider3 = RPCircularProgress()
            citySlider3.trackTintColor = UIColor.lightGray
            citySlider3.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            citySlider3.thicknessRatio = 0.22
            citySlider3.enableIndeterminate(false) {
              //  print("done")
            }
            
            citySlider3.isUserInteractionEnabled = true
            citySlider3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity3)))
            
            //citySlider.updateProgress(0.5)
            let progress6 = Float(self.cities[2]["count"] as! Int)
            let variable6 = CGFloat(progress6/cityCount)
            let twoDecimalPlaces6 = String(format: "%.3f",variable6)
            if let n = NumberFormatter().number(from: twoDecimalPlaces6) {
                c2 = Double(CGFloat(n))
            }
            citySlider3.updateProgress(CGFloat(c2))
            
            
            //citySlider3.updateProgress(CGFloat((progress6 * 2)/100))
            self.view.addSubview(citySlider3)
            citySlider3.snp.makeConstraints { (make) in
                make.top.equalTo(topCityLabel.snp.bottom).offset(10)
                make.left.equalTo(citySlider2.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let citySliderLabel3 = UILabel()
            //citySliderLabel3.text = self.cities[2]["_id"] as? String
            if   let lblslider = self.cities[2]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                citySliderLabel3.text =   lblsliderSeperate.joined(separator: "\n")
            }
            citySliderLabel3.font = UIFont(name:K_Font_Color,size:12)
            citySliderLabel3.textAlignment = .center
            citySliderLabel3.numberOfLines = 3
            self.view.addSubview(citySliderLabel3)
            citySliderLabel3.snp.makeConstraints { (make) in
                make.center.equalTo(citySlider3)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            let toprecentHeading = UILabel()
            toprecentHeading.text = "Recent Tastes"
            self.view.addSubview(toprecentHeading)
            toprecentHeading.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(citySlider3.snp.bottom).offset(10)
            }
            toprecentHeading.textAlignment = .center
            // toprecentHeading.font = UIFont(name: K_Font_Color, size: 23)
            toprecentHeading.font = UIFont(name: K_Font_Color_Light, size: 23)
            
            
            
        }
        
        //All block complete above
        
        self.view.addSubview(self.tableView)
        self.tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            make.top.equalTo(topCuisineLabel.snp.bottom).offset(330)
        }
        self.tableView.backgroundColor = UIColor.clear
        
        
    }
    
    
    
    func notificationbutton (){
        
        //        if self.arrNotification.count > 0{
        //            notifButton.setImage(UIImage(named:"notifications"), for: .normal)
        //        }
        //        else{
        //            notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
        //        }
        if K_INNERUSER_DATA.countvalue == 0{
            BellBtn.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
            
        }
        else{
            BellBtn.setImage(UIImage(named:"BellWithRed"), for: .normal)
        }
        self.view.addSubview(BellBtn)
        BellBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        BellBtn.addTarget(self, action: #selector(self.GoNotification), for: .touchUpInside)
    }

    
   
    
    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        self.NotificationMethod()
        
    }
    func NotificationMethod() {
        
        SVProgressHUD.show()
        
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":singelton.loginId, "page":"0"] as [String : Any]
        
        
        
        DataManager.sharedManager.getNotificationAnalyticClass(params: parameters) { (response) in
            
            
            
            if let dataDic = response as?  Array<Dictionary<String,Any>>
                
            {
               // print("Notification Data",dataDic)
                self.arrNotification = dataDic
                
                if self.arrNotification.count > 0
                {
                    self.notificationbutton()
                    // self.viewDidLoad()
                    //   self.tableView.reloadData()
                    
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
                
               
                
            }
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
            }
            
            
        }
    }
    
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      //  return self.cuisinesFilter.count;
       // print("PhotoArray",self.PhotoRefArray.count)
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
        cell.selectionStyle = .none
        var images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04","dummy-img01"]
        let imageView = UIImageView()
        cell.contentView.addSubview(imageView)
         imageView.layer.cornerRadius = 5
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(0)
        }
        
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
        //print(cuisineDetail.cuisineName)
      //  if cuisineDetail.photo_ref.characters.count > 0 {
            imageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
       // }

        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill

//        if indexPath.row % 2 == 0{
//            imageView.image = UIImage(named: "dummy-img01")
//        }
//        else{
//            imageView.image = UIImage(named: "dummy-img02")
//        }
//        imageView.clipsToBounds = true
        
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
        
        
        if let cuisineArray = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
            textLabelCuisine.text = cuisineArray[0] as? String
        }
        else{
            textLabelCuisine.text = ""
        }
       
        
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
        var coordinate : [String:Any]?
      coordinate = self.cuisinesFilter[indexPath.row]["coordinates"] as? [String:Any]
        
        if let currentlat=(coordinate?["lat"] as? Double){
           self.latValueRestaurant = currentlat
        }else{
            self.latValueRestaurant = 0.0
        }
        
        if let currentlon=(coordinate?["lon"] as? Double){
            self.longValueRestaurant = currentlon
        }else{
            self.longValueRestaurant = 0.0
        }
        //print(self.latValueRestaurant,self.longValueRestaurant)
       // let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
        let singelton = SharedManager.sharedInstance
        let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
        let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude:  self.longValueRestaurant)
       // print(singelton.latValueInitial,singelton.longValueInitial)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        let finaldist =  distanceInMeters / 1609.344
        
        
        cuisineCoordinates.text = String(format:"%.1f", finaldist) + " Miles"

        //textLabel.text = "Jim's China"
        
        
        //for cuisine name
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        var coordinate : [String:Any]?
        //
        //        var location : [String:Any]?
        //
        //        coordinate = self.cuisinesFilter[indexPath.row]["coordinates"] as? [String:Any]
        //
        //         location = self.cuisinesFilter[indexPath.row]["location"] as? [String:Any]
        //
        //         address = (location?["address"] as? String)!
        //         city = (location?["city"] as? String)!
        //
        //        print("addressss is \(address) and city is \(city)")
        //
        //
        //        lat = (coordinate?["lat"] as? Double)!
        //        long = (coordinate?["lon"] as? Double)!
        //
        //        print("data lat \(lat) long is \(long) that")
        //
        //            self.showPin()
        //
        //            self.zoomToRegion()
        //
        //        mapWrapperView.isHidden = false
        
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[indexPath.row]
        K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
        
        K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
        
        let latNavigate =  annotationArray  [indexPath.row] ["latvalue"] as! Double
        K_INNERUSER_DATA.latvalueNavigate = latNavigate
        let longNavigate =  annotationArray  [indexPath.row] ["longvalue"] as! Double
        K_INNERUSER_DATA.longvalueNavigate = longNavigate
   
        //            let Place_Id = (self.PlaceIdArray[indexPath.row] ["placeid"] as! String)
      //  print(indexPath.row)
        let location : [String:Any]?
        
        location = self.cuisinesFilter[indexPath.row]["location"] as? [String:Any]
        
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
        if let locCountry=(location?["country"] as? String){
            K_INNERUSER_DATA.Country=locCountry
        }
        else{
            K_INNERUSER_DATA.Country=""
        }
        
        if let locState=(location?["state"] as? String){
            K_INNERUSER_DATA.State=locState
        }
        else{
            K_INNERUSER_DATA.State=""
        }
        if let locZip=(location?["zip"] as? NSNumber){
            K_INNERUSER_DATA.ZIP = locZip.stringValue
        }
        else{
            K_INNERUSER_DATA.ZIP=""
        }
        
        if let locTel = self.cuisinesFilter[indexPath.row]["tel"] as? String{
            K_INNERUSER_DATA.Phone = locTel
        }
        else{
            K_INNERUSER_DATA.Phone=""
        }
        if let locWebsite = self.cuisinesFilter[indexPath.row]["website"] as? String
{
            K_INNERUSER_DATA.Website=locWebsite
        }
        else{
            K_INNERUSER_DATA.Website=""
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
        //        K_INNERUSER_DATA.Address = (location?["address"] as? String)!
        //        K_INNERUSER_DATA.CITY=(location?["city"] as? String)!
        //        K_INNERUSER_DATA.Country=(location?["country"] as? String)!
        //        K_INNERUSER_DATA.State=(location?["state"] as? String)!
        //        K_INNERUSER_DATA.ZIP=(location?["zip"] as? String)!
        //
        //        K_INNERUSER_DATA.Phone = self.cuisinesFilter[indexPath.row]["tel"] as! String
        //        K_INNERUSER_DATA.Website =   self.cuisinesFilter[indexPath.row]["website"] as! String
        
        if let price = self.cuisinesFilter[indexPath.row]["price"] as? NSNumber
        {
            K_INNERUSER_DATA.Price = String(format:"%@",price)
        }
        
        if let rating = self.cuisinesFilter[indexPath.row]["rating"] as? NSNumber
        {
            
            K_INNERUSER_DATA.Rating = String(format:"%@",rating)
        }
        
       // K_INNERUSER_DATA.CuisineName = (self.cuisinesFilter[indexPath.row]["name"] as? String)!
        
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
        if let hours =  self.cuisinesFilter[indexPath.row]["hours_display"] as? String{
            K_INNERUSER_DATA.Hours = hours
        }
        else{
            K_INNERUSER_DATA.Hours = ""
        }
        if let Cuisinname = annotationArray [indexPath.row] ["GetCuisine"] {
            K_INNERUSER_DATA.CuisinSeleted = Cuisinname as! String
        }else{
            K_INNERUSER_DATA.CuisinSeleted = ""
        }
        
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
            isloading = true
            pageNo = pageNo + 1
            if self.cuisinesFilter.count >= 5{
                self.getRecentTaste()
            }
            
            
        }
       // print("indexpath for the last call is \(indexPath.row)")
        
    }

    func showCuisine1() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = self.cuisines[0]["_id"] as! String
        vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCuisine2() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = self.cuisines[1]["_id"] as! String
        vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCuisine3() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = self.cuisines[2]["_id"] as! String
        vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showCity1()
    {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[0]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func showCity2() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[1]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCity3() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[2]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placeMarks, error) in
            if error == nil {
                if (placeMarks?.count)! > 0 {
                    let pm = placeMarks![0] as! CLPlacemark
                   // print(pm.locality)
                    self.latValue = (self.locationManager?.location?.coordinate.latitude)!
                    self.longValue = (self.locationManager?.location?.coordinate.longitude)!
                   // self.locationManager?.stopUpdatingLocation()
                    
                }
            }
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    
    
}
