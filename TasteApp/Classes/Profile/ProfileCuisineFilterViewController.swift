//
//  ProfileCuisineFilterViewController.swift
//  TasteApp
//
//  Created by Shubhank on 22/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import Alamofire
import CoreLocation
import GoogleMaps
import GooglePlaces
import SDWebImage

extension String {
    var count: Int
    { return self.characters.count
    }
}
class ProfileCuisineFilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate
{
    var friendId:String = ""
    var cuisineProfileId:String = ""
    var screenName:String = ""
    var lat : Double = 0.0
    var long  : Double =  0.0
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    var cuisineName = ""
    var cityName = ""
    var arrNotification =  [[String:Any]]()
    //var mapView:MKMapView!
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
    var PhotoRefArray = [[String:Any]]()
    var RestaurantResultArray = [[String:Any]]()
    var PlaceIdArray = [[String:Any]]()
    //let BellBtn = UIButton(type: .custom)
    let titleLabel = UILabel()
    var AllrestaurentRef = [[String:Any]]()
    var latValue : Double = 0.0
    var longValue : Double = 0.0
    var latValueRestaurant : Double = 0.0
    var longValueRestaurant : Double = 0.0
    var imageView = UIImageView()
    var j = 0
    var addressString = ""
    var cityString = ""
    var Locstring = ""
    var pageNo = 1
    var  isloading  = true
    var maxRow = 0
    let tableView = UITableView()
    var ProfileImagesArray = [ProfileImages]()
    var selectedProfileIndex = 0
    var cuisineArray = [ProfileCuisineFilter]()
    var GetCuisinName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
        
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
        //let address = "\(cuisineDetail.restaurantName)+,+\(cuisineDetail.address)+,+\(cuisineDetail.city)+,+\(cuisineDetail.state)+,+\(cuisineDetail.country)"
        let address = cuisineDetail.restaurantName + "," + cuisineDetail.address + "," + cuisineDetail.city + "," + cuisineDetail.state + "," + cuisineDetail.country
        let paramString = ["query":address, "location": lat_long, "radius":"500", "type": "restaurant","keyword":"cruise","key":GOOGLE_APIKEY] as [String : Any]
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
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=100&key=\(GOOGLE_APIKEY)"
        let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        
        
        
        
        //  print("-------Print Request Url",UrlTrimString)
        
        DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
            if let dataDic = response as? [String:Any]
            {
                
                //  print("Respomse", dataDic)
                
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
                            // print("Rest Name is", NameOfRest)
                        }
                        
                        if let photosDict = arrayDict.object(forKey: "photos"){
                            
                            let photosArray = photosDict as! NSArray
                            print(photosArray.count)
                            let placeId = arrayDict.object(forKey: "place_id")
                            
                            // print("place id is---",placeId)
                            
                            cuisineDetail.Placeid = placeId as! String
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
                                    // print("index is",self.self.selectedProfileIndex,cuisineDetail.photo_ref)
                                    
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
    
    
    
    // Mohit Deval Code
    
    //    func GoogleApi(){
    //
    //        let parameterGoogle =
    //            [ anno ] as [String : Any]
    //
    //        GoogleImages.GoogleImageManager.GetDataFromGoogleApi(params: parameterGoogle, completion: {(response) in
    //            if   let dataDicGoogle = response as? [[String:Any]]
    //            {
    //                print("Data val mohit Google Api",dataDicGoogle)
    //
    //                self.loadFirstPhotoForPlace(placeID: "ChIJ98rIiTiuEmsRErGRhS-ILJo")
    //
    //            }
    //
    //        })
    //    }
    
    
    
    
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error:NEw \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("-------",photo)
                //                self.imageView.image = photo;
                //                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    
    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        self.NotificationMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        self.mapView?.isMyLocationEnabled = true
        delayWithSeconds(2.5) {
            self.locationManager?.startUpdatingLocation()
            self.mapView?.delegate = self //code updated by mohit
        }
        
        
        locationManager?.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager?.location
            //  print(currentLocation?.coordinate.latitude)// code comment
            // print(currentLocation?.coordinate.longitude) // code comment
        }
        
        // Do any additional setup after loading the view.
        
        //  self.GoogleApi()
        
        
        
        
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
        
        
        ///////////////////////////////////////
        super.viewWillAppear(animated)
        
        self.NotificationMethod()
        NotificationCenter.default.addObserver(self, selector: #selector(AnalyticsViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        let manager = NetworkReachabilityManager(host: "www.google.com")
        manager?.listener = { status in
            // print("Network Status Changed: \(status)")
            // print("network reachable \(manager!.isReachable)")
            
            if manager!.isReachable != true
            {
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
            }
            else
            {
                //SVProgressHUD.show()
                // self.loadTableViewData()
                
                
            }
        }
        manager?.startListening()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        // self.cuisinesFilter.removeAll()
        super.viewWillDisappear(animated)
    }
    
    
    func notificationbutton (){

//        if K_INNERUSER_DATA.countvalue == 0{
//            BellBtn.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
//            
//        }
//        else{
//            BellBtn.setImage(UIImage(named:"BellWithRed"), for: .normal)
//        }
//        self.view.addSubview(BellBtn)
//        BellBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
//            make.width.equalTo(35)
//            make.height.equalTo(35)
//        }
//        BellBtn.addTarget(self, action: #selector(self.GoNotification), for: .touchUpInside)
    }
    
    
    
    func NotificationMethod() {
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false //code added
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":singelton.loginId, "page":"0"] as [String : Any]
        
        
        
        DataManager.sharedManager.getNotificationProfileCuisinClass(params: parameters) { (response) in
            
            
            self.view.isUserInteractionEnabled = true //code added
            if let dataDic = response as?  Array<Dictionary<String,Any>>
                
            {
                //  print("Notification Data",dataDic)
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
                
                //                print("notification array is \(self.arrNotification)")
                //                print("array data is \(self.arrNotification)")
                
            }else{
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
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                
            }
            
            
        }
    }
    
    
    
    
    
    func GoNotification() {
        let vc = NotificatioinsViewController() as NotificatioinsViewController
     //   vc.RecvarrNotification = self.arrNotification
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        
        _ =  self.navigationController?.popViewController(animated: true)
                mapView?.delegate = nil
                mapView?.removeFromSuperview()
                mapView = nil
                if mapWrapperView != nil{
                    mapWrapperView.removeFromSuperview()
                    mapWrapperView = nil
                }
        

    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        // let titleLabel = UILabel()
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
        //        notifButton.setImage(UIImag e(named:"ic_notification_bell"), for: .normal)
        //        self.view.addSubview(notifButton)
        //        notifButton.snp.makeConstraints { (make) in
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(titleLabel.snp.centerY)
        //            make.width.equalTo(30)
        //            make.height.equalTo(30)
        //        }
        let titleCuisine = UILabel()
        if cuisineName == "others"{
            titleCuisine.text = "Others"
        }
        else{
            titleCuisine.text = cuisineName
        }
       // titleCuisine.text = cuisineName
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
            make.centerY.equalTo(titleLabel.snp.centerY )
        }
        
        
//        BellBtn.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
//        BellBtn.addTarget(self, action: #selector(self.GoNotification), for: .touchUpInside)
//        self.view.addSubview(BellBtn)
//        BellBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.centerY.equalTo(titleLabel.snp.centerY).offset(-5)
//            make.width.equalTo(35)
//            make.height.equalTo(35)
//        }
//        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        if app.checkForNotification == "RInnerCircleAddedUserProfileVc"{
//            BellBtn.isHidden = true
//        }
//        else{
//            BellBtn.isHidden = false
//        }
        
        
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
            /*   make.right.equalTo(self.view.snp.right).offset(-20)
             make.width.equalTo(40)
             make.height.equalTo(40)
             make.top.equalTo(self.view.snp.bottom).offset(-90)
             */
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
        
        //        mapView = MKMapView()
        //        mapWrapperView.addSubview(mapView)
        //        mapView.snp.makeConstraints { (make) in
        //            make.left.equalTo(0)
        //            make.right.equalTo(0)
        //            make.top.equalTo(80)
        //            make.bottom.equalTo(0)
        //        }
        //        mapView.mapType = MKMapType.standard
        //        mapView.isZoomEnabled = true
        //        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
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
           // make.bottom.equalTo(-50)
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
            //  print(singelton.loginId,"", self.cuisineName,self.filterName,self.pageNo)
            var id = singelton.loginId
            
            if screenName == "UserAddedDetail"{
                id  = self.cuisineProfileId
            }
            if screenName == "RInnerCircle" {
                id  = self.friendId
            }
            
            //  screenName = ""
            let parameter = [ "user_id":id,"city":self.cuisineName,"filter_by":self.filterName,"cuisine":self.cuisineName,"page":self.pageNo] as [String : Any]
         //   print("parameter:\(parameter)")
            
            DataManager.sharedManager.getCuisineDetail(params: parameter, completion: { (response) in
                if let dataDic = response as? [[String:Any]]
                {
                    SVProgressHUD.dismiss()
                    self.cuisinesPageFilter = dataDic
                    //  print(dataDic)
                    // self.cuisinesFilter = dataDic
                    
                    //  print("cout is  \(self.cuisinesFilter.count)")//code comment
                    
                    //var i = 0
                    if self.cuisinesPageFilter.count > 0
                    {
                        self.cuisinesFilter.append(contentsOf: self.cuisinesPageFilter)
                        // self.cuisineArray.append(contentsOf: self.cuisinesFilter)
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
                                        self.GetCuisinName = cuisinGet
                                    }
                                    else
                                    {
                                        self.GetCuisinName = ""
                                    }
                                }
                                
                            }
                            else{
                                self.GetCuisinName = ""
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
                            if let locState = (location?["state"] as? String){
                                self.stateString = locState
                            }
                            else
                            {
                                self.stateString = ""
                            }
                            if let locCountry = (location?["country"] as? String){
                                self.countryString = locCountry
                            }
                            else
                            {
                                self.countryString = ""
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
                            
                            if let price = self.cuisinesFilter[self.j]["price"] as? NSNumber
                            {
                                K_INNERUSER_DATA.Price = String(format:"%@",price)
                            }
                            
                            if let rating = self.cuisinesFilter[self.j]["rating"] as? NSNumber
                            {
                                
                                K_INNERUSER_DATA.Rating = String(format:"%@",rating)
                            }
                            
                            //  K_INNERUSER_DATA.CuisineName = self.cuisineName
                            
                            if let factual_id = self.cuisinesFilter[self.j]["factual_id"] as? String{
                                K_INNERUSER_DATA.FactualId = factual_id
                            }
                            else{
                                K_INNERUSER_DATA.FactualId = ""
                            }
                            
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
                            content.updateValue(self.GetCuisinName , forKey: "CuisineGet")
                            
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
                            cusineDetail.cuisineName = self.GetCuisinName
                            //                            if let cuisineArray = self.cuisinesFilter[self.j]["cuisine"] as? NSArray{
                            //                                cusineDetail.cuisineName = (cuisineArray[0] as? String)!
                            //                            }
                            self.cuisineArray.append(cusineDetail)
                            self.j = self.j + 1
                        }
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                    }
                    // self.countGoogleApiHit()
                    
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
                    self.countGoogleApiHit(index:self.selectedProfileIndex)
                    //   SVProgressHUD.dismiss()
                    self.tableView.reloadData()
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
    func hideMapped()
        
    {
        self.mapWrapperView.isHidden = true
        
        //        mapView?.delegate = nil
        //        mapView?.removeFromSuperview()
        //        mapView = nil
        //        if mapWrapperView != nil{
        //            mapWrapperView.removeFromSuperview()
        //            mapWrapperView = nil
        //        }
        
        
    }
    
    func viewNotifications() {
        let vc = NotificatioinsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func settingsTapped()
    {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func showPin()
    {
        
        //        let sydney = GMSCameraPosition.camera(withLatitude: annotationArray  [0] ["latvalue"] as! Double,
        //                                              longitude: annotationArray [0] ["longvalue"] as! Double,
        //                                              zoom: 12)
        //        mapView.camera = sydney
        for location in annotationArray {
            //  print("----",annotationArray);
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
            marker.title = location["nameValue"] as? String
            marker.snippet = location["cityValue"] as? String
            marker.icon = UIImage(named:"map-markar")!
            marker.map = mapView
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
            
            
            //        for location in annotationArray {
            //            let annotation = MKPointAnnotation()
            ////            annotation.title = location["addressvalue"] as? String
            ////            annotation.subtitle = location["cityValue"] as? String
            //            annotation.title = location["nameValue"] as? String
            //            annotation.subtitle = location["cityValue"] as? String
            //            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
            //            print(annotation.title,annotation.subtitle,annotation.coordinate)
            //            mapView.addAnnotation(annotation)
            //
            //
            //            // let location = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double , longitude: location["longvalue"] as! Double)
            //
            //            // let region = MKCoordinateRegionMakeWithDistance(location, 400.0, 400.0)
            //
            //            //  print("set region for each element is \(region)")
            //
            //            //  mapView.setRegion(region, animated: true)
            //
            //
            //
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
        
        //        mapView?.delegate = nil
        //        mapView?.removeFromSuperview()
        //        mapView = nil
        //        if mapWrapperView != nil{
        //            mapWrapperView.removeFromSuperview()
        //            mapWrapperView = nil
        //        }
        
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print(self.cuisinesFilter.count)
        //       // return 1;
        //      return self.PhotoRefArray.count
        return self.cuisineArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print("All photos Reference cell", self.PhotoRefArray)
        //        print("All photos count cell", self.PhotoRefArray.count)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04"]
        imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 5
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(0)
            //            make.height.equalTo(70)
            //            make.width.equalTo(380)
        }
        
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[indexPath.row]
        // print(cuisineDetail.cuisineName)
        //   if cuisineDetail.photo_ref.characters.count > 0 {
        imageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
        //  }
        //        if cusineDetail.photo_ref.count > 0{
        //            imageView.sd_setImage(with: URL(string: cusineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
        //        }
        // print("-----index",indexPath.row)
        // print("-----ArrayData",(PhotoRefArray[indexPath.row] ["Photo_Ref"] as! String))
        // if(PhotoRefArray.count>0){
        //            for var j in 0..<self.cuisinesFilter.count
        //            {
        //                let name = (PhotoRefArray[j] ["NameOfRest"] as! String)
        //                let param_val = (PhotoRefArray[j] ["Photo_Ref"] as! String)
        //                if let nameOld = self.cuisinesFilter[j]["name"] as? String
        //                {
        //                    if nameOld.localizedCaseInsensitiveContains(name) {
        //                        print("index is ",nameOld,indexPath.row)
        //                        print(self.PhotoRefArray.count)
        //                    }
        //                    self.PhotoRefArray[j] = (name as? [String:Any])!
        //                }
        //            }
        
        
        //code comment
        /*  let param_val = (PhotoRefArray[indexPath.row] ["Photo_Ref"] as! String)
         
         if param_val.localizedCaseInsensitiveContains("Defoult") {
         imageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "rest_defoutImage"))
         }else{
         
         let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(param_val)&key=AIzaSyBf5p8z9QCBLh2re71V8bo-xB_cpoqcNmU")!
         print("Url Is Final",url)
         
         let bannerUrl = "\(url)"
         // let bannerUrl = url as? String
         //  let defoultImageurl = URL(string: "http://159.203.180.90:9090/img/logo_image.gif")
         
         imageView.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
         
         print("----------",bannerUrl)
         }*/
        //            let heightInPoints = image.size.height
        //            let heightInPixels = heightInPoints * image.scale
        //
        //            let widthInPoints = image.size.width
        //            let widthInPixels = widthInPoints * image.scale
        
        
        //            MyDuniaConnectionHelper.urlToImageConverter(bannerUrl as String, completionHandler: { (image, success) in
        //
        //                                if success {
        //
        //                                    DispatchQueue.main.async(execute: { () -> Void in
        //
        //                                        self.imageView.image = image
        //
        //                                    })
        //                                }
        //            })
        
        //                    let data = try? Data(contentsOf: url)
        //
        //                    if let imageData = data {
        //                        let image = UIImage(data: data!)
        //                        imageView.image =  image
        //                    }
        
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
        
        /*  let textLabelImage = UILabel()
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
        textRestaurant.font = UIFont(name:K_Font_Color_Regular,size:24)
        textRestaurant.textColor = UIColor.white
        cell.contentView.addSubview(textRestaurant)
        textRestaurant.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(340)
            make.height.equalTo(40)
            make.top.equalTo(20)
        }
        
        
        
        //  textRestaurant.text = self.cuisinesFilter[indexPath.row]["name"] as? String
        
        textRestaurant.text = cuisineDetail.restaurantName
        
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
      //  print(cuisinesFilter)
        
        if self.filterName == "cuisines"&&self.cuisineName == "others"{
            
            if let cuisineArray = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
                if cuisineArray.count != 0{
                    textLabelCuisine.text = cuisineArray[0] as? String
                }
            }
            else{
                textLabelCuisine.text = ""
            }
        }
        else if self.filterName == "cities"&&self.cuisineName == "others"{
            
            if let locationDict = self.cuisinesFilter[indexPath.row]["location"] as? NSDictionary{
                if let selectedCityName = locationDict["city"] as? String {
                    textLabelCuisine.text = selectedCityName
                }
            }
            else{
                textLabelCuisine.text = ""
            }
        }
        else{
            
            textLabelCuisine.text = cuisineName
        }
        
        
        //textLabelCuisine.text = cuisineDetail.cuisineName
        //textLabelCuisine.text = cuisineName
        
        
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
        //  print(self.latValueRestaurant,self.longValueRestaurant)
        // let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
        let singelton = SharedManager.sharedInstance
        let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
        // let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude:  self.longValueRestaurant)
        let coordinate2 = CLLocation(latitude: cuisineDetail.latitudeValue, longitude:  cuisineDetail.longitudeValue)
        //  print(singelton.latValueInitial,singelton.longValueInitial)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        let finaldist =  distanceInMeters / 1609.344
        
        
        cuisineCoordinates.text = String(format:"%.1f", finaldist) + " Miles"
        //}
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //         print("Photos ref array ----",self.PhotoRefArray)
        //       print("Restaurant array count----",RestaurantResultArray.count)
        //        print("Restaurant array----",RestaurantResultArray)
        let city =  annotationArray  [indexPath.row] ["cityValue"]
        K_INNERUSER_DATA.cityname = city as! String
        let name =  annotationArray  [indexPath.row] ["nameValue"]
        K_INNERUSER_DATA.name = address as! String
        let latNavigate =  annotationArray  [indexPath.row] ["latvalue"] as! Double
        K_INNERUSER_DATA.latvalueNavigate = latNavigate
        let longNavigate =  annotationArray  [indexPath.row] ["longvalue"] as! Double
        K_INNERUSER_DATA.longvalueNavigate = longNavigate
        //        for RestaurantData in RestaurantResultArray {
        //            if RestaurantData.count > 0 {
        //
        //                let arrayDict = RestaurantResultArray[0] as NSDictionary
        //
        //                 if let ResultDict = arrayDict.object(forKey: "RefResults") {
        //
        //                    let ResultArray = ResultDict as! NSArray
        //
        //                    let dicval = ResultArray[0] as! NSDictionary
        //
        //                if let photosDict = dicval.object(forKey: "photos") {
        //
        //                    let photosArray = photosDict as! NSArray
        //
        //                    if photosArray.count > 0 {
        //
        //                        let photoDict = photosArray[0] as! NSDictionary
        //
        //
        //
        //                        if let photo_reference = photoDict.object(forKey: "photo_reference"){
        //
        //
        //                            let PhotoRef = photo_reference as! String
        //                            //   K_GoogleImagesData.ImagesDataArray.append(PhotoRef)
        //
        //                            var content = Dictionary<String,Any>()
        //                            content.updateValue(PhotoRef, forKey: "Photo_Ref")
        //
        //                            self.AllrestaurentRef.append(content)
        //                            // call this after you update
        //
        //                            print("PhotoRef : \(PhotoRef)")
        //
        //                        }
        //                    }
        //                }
        //            }
        //            }
        //        }
        
        
        
        
        //  if let PhotoValue = (self.PhotoRefArray[indexPath.row] ["Photo_Ref"] as? String){
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[indexPath.row]
        K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
        // }
        
        
        //  if let Place = (self.PlaceIdArray[indexPath.row] ["placeid"] as? String) {
        //            let Place_Id = (self.PlaceIdArray[indexPath.row] ["placeid"] as! String)
        K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
        // }
        
        
        K_INNERUSER_DATA.RestaurantName = cuisineDetail.restaurantName
        
        K_INNERUSER_DATA.Price = cuisineDetail.Price
        K_INNERUSER_DATA.Rating = cuisineDetail.rating
        
        // print(indexPath.row)
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
        
        if let locWebsite = self.cuisinesFilter[indexPath.row]["website"] as?String{
            K_INNERUSER_DATA.Website = locWebsite
        }
        else{
            K_INNERUSER_DATA.Website=""
        }
        
        if let hours = self.cuisinesFilter[indexPath.row]["hours_display"] as? String{
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
        
        // K_INNERUSER_DATA.CuisineName = self.cuisineName // code commented
        let Cuisinname = annotationArray [indexPath.row]["CuisineGet"]
        K_INNERUSER_DATA.CuisinSeleted = Cuisinname as! String
        
        if let factual_id = self.cuisinesFilter[indexPath.row]["factual_id"] as? String{
            K_INNERUSER_DATA.FactualId = factual_id
        }
        else{
            K_INNERUSER_DATA.FactualId = ""
        }
        
        //        if let restName  = self.cuisinesFilter[indexPath.row]["name"] as? String
        //        {
        //            K_INNERUSER_DATA.RestaurantName = restName
        //        }
        //        else{
        //            K_INNERUSER_DATA.RestaurantName  = ""
        //        }
        
        
        /*
         if let locAddress = self.cuisinesFilter[i]["address"] as? String{
         K_INNERUSER_DATA.Address = locAddress
         }
         else{
         K_INNERUSER_DATA.Address=""
         }
         if let locCity = self.cuisinesFilter[i]["locality"] as? String{
         K_INNERUSER_DATA.CITY=locCity
         }
         else{
         K_INNERUSER_DATA.CITY=""
         }
         if let locCountry = self.cuisinesFilter[i]["country"] as? String{
         K_INNERUSER_DATA.Country=locCountry
         }
         else{
         K_INNERUSER_DATA.Country=""
         }
         
         if let locState = self.cuisinesFilter[i]["region"] as? String{
         K_INNERUSER_DATA.State=locState
         }
         else{
         K_INNERUSER_DATA.State=""
         }
         if let locZip =  self.cuisinesFilter[i]["postcode"] as? NSNumber
         {
         K_INNERUSER_DATA.ZIP = locZip.stringValue
         }
         else{
         K_INNERUSER_DATA.ZIP=""
         }
         if let locTel =  self.cuisinesFilter[i]["tel"] as? String{
         
         K_INNERUSER_DATA.Phone = locTel
         }
         else{
         K_INNERUSER_DATA.Phone=""
         }
         if let locWebsite =  self.cuisinesFilter[i]["website"] as? String{
         
         K_INNERUSER_DATA.Website = locWebsite
         }
         else{
         K_INNERUSER_DATA.Website=""
         }
         
         if let hours =  self.cuisinesFilter[i]["hours_display"] as? String{
         K_INNERUSER_DATA.Hours = hours
         }
         else{
         K_INNERUSER_DATA.Hours = ""
         }
         */
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
        
        //  K_INNERUSER_DATA.CuisineName = self.cuisineName
        
        if let factual_id = self.cuisinesFilter[indexPath.row]["factual_id"] as? String{
            K_INNERUSER_DATA.FactualId = factual_id
        }
        else{
            K_INNERUSER_DATA.FactualId = ""
        }
        
        //        if let restName  = self.cuisinesFilter[indexPath.row]["name"] as? String
        //        {
        //            K_INNERUSER_DATA.RestaurantName = restName
        //        }
        //        else{
        //            K_INNERUSER_DATA.RestaurantName  = ""
        //        }
        
        
        
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
                self.loadTableViewData()
            }
            
            
        }
        // print("indexpath for the last call is \(indexPath.row)")
        
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
    //code called by Mohit
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        for var i in 0..<self.annotationArray.count  {
            
            if let name =  annotationArray  [i] ["nameValue"] as? String{
                if name == marker.title {
                    
                    
                    
                    
                    if let city =  annotationArray  [i] ["cityValue"] {
                        K_INNERUSER_DATA.cityname = city as! String
                        
                    }
                    if  let name =  annotationArray  [i] ["nameValue"] {
                        K_INNERUSER_DATA.name = name as! String
                        
                    }
                    let latNavigate =  annotationArray  [i] ["latvalue"] as! Double
                    K_INNERUSER_DATA.latvalueNavigate = latNavigate
                    
                    
                    
                    let longNavigate =  annotationArray  [i] ["longvalue"] as! Double
                    K_INNERUSER_DATA.longvalueNavigate = longNavigate
                    
                    
                    
                    if let Phone_no =  annotationArray  [i] ["user_tel"] {
                        K_INNERUSER_DATA.Phone = Phone_no as! String
                    }else{
                        
                    }
                    
                    if let web =  annotationArray  [i] ["user_website"]{
                        K_INNERUSER_DATA.Website = web as! String
                        
                    }
                    
                    if let Hour_count =  annotationArray  [i] ["user_hours_display"] {
                        K_INNERUSER_DATA.Hours = Hour_count as! String
                        
                    }
                    
                    if let user_add =  annotationArray  [i] ["Address"]{
                        K_INNERUSER_DATA.Address = user_add as! String
                        
                    }
                    
                    if let factualID =  annotationArray  [i] ["factualId"] {
                        K_INNERUSER_DATA.FactualId = factualID as! String
                        
                    }
                    
                    
                    
                    
                    var cuisineDetail = ProfileCuisineFilter()
                    cuisineDetail = cuisineArray[i]
                    K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                    
                    K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                    
                    
                    K_INNERUSER_DATA.RestaurantName = cuisineDetail.restaurantName
                    
                    K_INNERUSER_DATA.Price = cuisineDetail.Price
                    K_INNERUSER_DATA.Rating = cuisineDetail.rating
                    K_INNERUSER_DATA.CuisinSeleted = cuisineDetail.cuisineName
                    
                    
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
    
    //MARK: Location Manager
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //
    //        let geoCoder = CLGeocoder()
    //        geoCoder.reverseGeocodeLocation(locations.last!) { (placeMarks, error) in
    //            if error == nil {
    //                if (placeMarks?.count)! > 0 {
    //                    let pm = placeMarks![0] as! CLPlacemark
    //                    print(pm.locality)
    //                }
    //            }
    //        }
    //    }
    
    
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
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //            mapView?.delegate = nil
    //            mapView?.removeFromSuperview()
    //            mapView = nil
    //            if mapWrapperView != nil{
    //                mapWrapperView.removeFromSuperview()
    //                mapWrapperView = nil
    //            }
    //
    //
    //    }
    
    
    
    
}
