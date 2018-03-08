//
//  RDiningProfileMapVc.swift
//  Taste
//
//  Created by Ranjit Singh on 29/09/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import SVProgressHUD



class RDiningProfileMapVc: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

   // var mapView:GMSMapView!
    var titleStr:String = ""
    
    // variables for map view
    
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
    var zipString = ""
    var telephoneString = ""
    var websiteString = ""
    var priceString = ""
    var ratingString = ""
    var factualidString = ""
    var hoursDisplayString = ""
    var pageNo = 1
    var  isloading  = true
    var maxRow = 0
    var j = 0
    let tableView = UITableView()
    var cuisineArray = [ProfileCuisineFilter]()
    var GetCuisineName:String = ""
    var mapView:GMSMapView?
    var RestaurantResultArray = [[String:Any]]()
    
    @IBOutlet weak var mapWrapperView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleStr
        screenTitle.text = "DINING PROFILE"
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapWrapperView.frame.size.width, height: self.mapWrapperView.frame.size.height), camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 13))
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
//                mapView = GMSMapView.map(withFrame: self.mapWrapperView.bounds, camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 5.5))
        
       // mapView?.center = self.mapWrapperView.center
        mapView?.delegate = self
        self.mapWrapperView.addSubview(mapView!)
        
        
        //Location Manager code to fetch for  current location
        self.mapView?.isMyLocationEnabled = true
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingLocation()

        
        

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
            
//            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//                NSLog("OK Pressed")
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            return
            
        }
        self.getRecentTaste()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//            mapView?.delegate = nil
//            mapView?.removeFromSuperview()
//            mapView = nil
//            if mapWrapperView != nil{
//                mapWrapperView.removeFromSuperview()
//                mapWrapperView = nil
//        }
//        
//    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
         _ =  self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - SHOW PIN ON MAP

    func showPin()
    {
        SVProgressHUD.dismiss()
        // var bounds = GMSCoordinateBounds()
//        let sydney = GMSCameraPosition.camera(withLatitude: annotationArray  [0] ["latvalue"] as! Double,
//                                              longitude: annotationArray [0] ["longvalue"] as! Double,
//                                              zoom: 12)
//        mapView?.camera = sydney
        for location in annotationArray {
            //  print("----",annotationArray);
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
//            bounds = bounds.includingCoordinate(marker.position)
//            let update = GMSCameraUpdate.fit(bounds, withPadding: 64)
            marker.title = location["nameValue"] as? String
            marker.snippet = location["cityValue"] as? String
            marker.icon = UIImage(named:"map-markar")!
            marker.map = mapView
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(50)) {
//                // Code
//                self.mapView?.animate(with: update)
//                self.view.isUserInteractionEnabled = true
//            }
        }
    }

    func getRecentTaste(){
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            
            //please give suggestion here for entry cuisine 0r city
            
            let parameter = [ "user_id":singelton.loginId] as [String : Any]
            
            DataManager.sharedManager.getAllRecentTasteForMap(params: parameter, completion: { (response) in
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
                            if let locZip=(location?["zip"] as? NSNumber){
                                self.zipString = locZip.stringValue
                            }
                            else{
                                self.zipString = ""
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
                            
                            if let locTel = self.cuisinesFilter[self.j]["tel"] as? String{
                                self.telephoneString = locTel
                            }
                            else{
                                self.telephoneString = ""
                            }
                            if let locWebsite = self.cuisinesFilter[self.j]["website"] as? String
                            {
                                self.websiteString = locWebsite
                            }
                            else{
                                self.websiteString = ""
                            }
                            
                            if let price = self.cuisinesFilter[self.j]["price"] as? NSNumber
                            {
                                self.priceString = String(format:"%@",price)
                            }
                            
                            if let rating = self.cuisinesFilter[self.j]["rating"] as? NSNumber
                            {
                                
                                self.ratingString = String(format:"%@",rating)
                            }
                            if let hours =  self.cuisinesFilter[self.j]["hours_display"] as? String{
                                self.hoursDisplayString = hours
                            }
                            else{
                                self.hoursDisplayString = ""
                            }
                            if let factual_id = self.cuisinesFilter[self.j]["factual_id"] as? String{
                                self.factualidString = factual_id
                            }
                            else{
                                self.factualidString  = ""
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
                            let cusineDetail = ProfileCuisineFilter()
                            cusineDetail.latitudeValue = self.latValue
                            cusineDetail.longitudeValue = self.longValue
                            cusineDetail.restaurantName = self.nameRestaurant
                            cusineDetail.cuisineName = self.GetCuisineName
                            cusineDetail.address = self.addressString
                            cusineDetail.city = self.cityString
                            cusineDetail.state = self.stateString
                            cusineDetail.country = self.countryString
                            cusineDetail.PostCode = self.zipString
                            cusineDetail.phone = self.telephoneString
                            cusineDetail.website = self.websiteString
                            cusineDetail.hour = self.hoursDisplayString
                            cusineDetail.photo_ref = ""
                            cusineDetail.rating =  self.ratingString
                            cusineDetail.Price =  self.priceString
                            cusineDetail.FactualId = self.factualidString
                            self.cuisineArray.append(cusineDetail)
                            self.countGoogleApiHit(index: self.j)
                            
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
                    //  self.countGoogleApiHit(index:self.selectedProfileIndex)
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    self.showPin()
                    
                }
            })
        }
        else
        {
            
            //            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            //            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            //                UIAlertAction in
            //                NSLog("OK Pressed")
            //            }
            //            alert.addAction(okAction)
            //            self.present(alert, animated: true, completion: nil)
            //            return
            
        }
        
    }

    
    //MARK: Location Manager
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(locations.last!) { (placeMarks, error) in
//            if error == nil {
//                if (placeMarks?.count)! > 0 {
//                    let pm = placeMarks![0] as! CLPlacemark
//                    // print(pm.locality)
//                    self.latValue = (self.locationManager?.location?.coordinate.latitude)!
//                    self.longValue = (self.locationManager?.location?.coordinate.longitude)!
//                    // self.locationManager?.stopUpdatingLocation()
//                    
//                }
//            }
//        }
//    }
    
    //Location Manager delegates  commented above code for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)

        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager?.stopUpdatingLocation()
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        for var i in 0..<self.annotationArray.count  {
            
            if let name =  annotationArray  [i] ["nameValue"] as? String{
                if name == marker.title {
                    
                    /*  if let city =  annotationArray  [i] ["cityValue"] {
                     K_INNERUSER_DATA.cityname = city as! String
                     
                     }
                     //                    if  let name =  annotationArray  [i] ["nameValue"] {
                     //                        K_INNERUSER_DATA.name = name as! String
                     //
                     //                    }
                     let latNavigate =  annotationArray  [i] ["latvalue"] as! Double
                     K_INNERUSER_DATA.latvalueNavigate = latNavigate
                     
                     
                     
                     let longNavigate =  annotationArray  [i] ["longvalue"] as! Double
                     K_INNERUSER_DATA.longvalueNavigate = longNavigate
                     
                     
                     
                     if let Phone_no =  annotationArray  [i] ["tel"] {
                     K_INNERUSER_DATA.Phone = Phone_no as! String
                     }else{
                     
                     }
                     
                     if let web =  annotationArray  [i] ["website"]{
                     K_INNERUSER_DATA.Website = web as! String
                     
                     }
                     
                     if let Hour_count =  annotationArray  [i] ["hours_display"] {
                     K_INNERUSER_DATA.Hours = Hour_count as! String
                     
                     }
                     
                     if let user_add =  annotationArray  [i] ["Address"]{
                     K_INNERUSER_DATA.Address = user_add as! String
                     
                     }
                     */
                    //                    if let factualID =  annotationArray  [i] ["factualId"] {
                    //                        K_INNERUSER_DATA.FactualId = factualID as! String
                    //
                    //                    }
                    //
                    
                    
                    
                    var cuisineDetail = ProfileCuisineFilter()
                    cuisineDetail = cuisineArray[i]
                    K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
                    K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
                    K_INNERUSER_DATA.FactualId = cuisineDetail.FactualId
                    K_INNERUSER_DATA.Price = cuisineDetail.Price
                    K_INNERUSER_DATA.Rating = cuisineDetail.rating
                    K_INNERUSER_DATA.RestaurantName = cuisineDetail.restaurantName
                    K_INNERUSER_DATA.CuisinSeleted = cuisineDetail.cuisineName
                    K_INNERUSER_DATA.latvalueNavigate = cuisineDetail.latitudeValue
                    K_INNERUSER_DATA.longvalueNavigate = cuisineDetail.longitudeValue
                    K_INNERUSER_DATA.Address = cuisineDetail.address
                    K_INNERUSER_DATA.CITY = cuisineDetail.city
                    K_INNERUSER_DATA.State = cuisineDetail.state
                    K_INNERUSER_DATA.Country = cuisineDetail.country
                    K_INNERUSER_DATA.ZIP =  cuisineDetail.PostCode
                    
                    K_INNERUSER_DATA.Phone = cuisineDetail.phone
                    K_INNERUSER_DATA.Website = cuisineDetail.website
                    K_INNERUSER_DATA.Hours = cuisineDetail.hour
                    
                    print(cuisineDetail.restaurantName,cuisineDetail.cuisineName)
                    
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
    

    @IBAction func buildingBtnPressed(_ sender: Any) {
         _ =  self.navigationController?.popViewController(animated: false)
    }




}
