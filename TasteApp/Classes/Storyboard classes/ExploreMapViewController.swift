//
//  ExploreMapViewController.swift
//  Taste
//
//  Created by Asish Pant on 11/10/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import SVProgressHUD

class ExploreMapViewController:UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var mapWrapperView: UIView!
     @IBOutlet weak var mapAreaBtn: UIButton!
    
    @IBOutlet weak var reloadButton: UIButton!
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
   // var cuisineArray = [ProfileCuisineFilter]()
    var GetCuisineName:String = ""
    var mapView:GMSMapView?
    var RestaurantResultArray = [[String:Any]]()
    
    
     var filteredUserProfileArray = [ProfileCuisineFilter]()
     var cuisineArray = [ProfileCuisineFilter]()
    var filtering = false
    var screenName :String?
     let myNotification = Notification.Name(rawValue:"NotificationExploreFilter")
    let myNotificationNotRefresh = Notification.Name(rawValue:"NotificationExploreMapViewNotRefresh")
    var isNotRefresh:Bool = false
    var isSearchChange:String = "0"
    var optionFilter:String = ""
    var optionPriceFilter :String = ""
    var optionCuisineFilter :String = ""
    var cuisineName = ""
    var cityName = ""
    var postCode:String = ""
    var isTextSearch:String = "0"
    var latNavigate : Double = 0.0
    var longNavigate : Double = 0.0
    var isSearchAfterNavigate:Bool = false
    var formattedTextAddress:String = ""
    var isTextSearchClick:Bool = false
    var locDistance: String = ""
    var isGettingData:Bool = true
    var latValueTransfer : Double = 0.0
    var longValuetransfer : Double = 0.0
    var isMapRefresh:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSearch.delegate = self as! UITextFieldDelegate
        textFieldSearch.backgroundColor = UIColor.black
        textFieldSearch.layer.cornerRadius = 8
        textFieldSearch.textColor = UIColor.white
        textFieldSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        textFieldSearch.leftViewMode = .always
        let str = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textFieldSearch.attributedPlaceholder = str
        textFieldSearch.returnKeyType = UIReturnKeyType.search
        
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "ic_search")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        textFieldSearch.leftViewMode = .always
        textFieldSearch.leftView = leftView
         SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        self.isMapRefresh = false
        self.createMap()
        
        self.showPin()

        // Do any additional setup after loading the view.
    }
    func createMap(){
         let singelton = SharedManager.sharedInstance
        var latitude = 0.0
        var longitude = 0.0
        if singelton.isExploreCitySearch {
            latitude = singelton.latValueExploreCity
            longitude = singelton.longValueExploreCity
        }
        else{
            latitude = singelton.latValueInitial
            longitude = singelton.longValueInitial
        }
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapWrapperView.frame.size.width, height: self.mapWrapperView.frame.size.height), camera: GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13.0))
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13.0)
        self.mapView?.animate(to: camera)
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
    func resetData(){
        filtering = false
        self.isNotRefresh = true
        self.cuisineArray.removeAll()
        self.filteredUserProfileArray.removeAll()
        self.cuisinesFilter.removeAll()
        self.selectedProfileIndex = 0
        self.PhotoRefArray.removeAll()
        self.j = 0
        self.isGettingData = true
        self.mapView?.clear()
    }
    @IBAction func reloadTap(_ sender: Any) {
        let singelton = SharedManager.sharedInstance
        self.pageNo = 1
        singelton.isExploreRestaurantSearch = false
        singelton.exploreRestaurantSearchText = ""
        singelton.isNavigateMapScreenAfterSearch = true
        textFieldSearch.text = ""
        isTextSearchClick = true
        self.isMapRefresh = true
        // isGettingData = true
        self.getExploreData()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        let ncRefresh = NotificationCenter.default
        ncRefresh.addObserver(forName:myNotificationNotRefresh, object:nil, queue:nil, using:catchNotificationRefresh)
        let singelton = SharedManager.sharedInstance
        textFieldSearch.text = singelton.exploreRestaurantSearchText 
        if self.isNotRefresh == true{
             self.view.isUserInteractionEnabled = false
             SVProgressHUD.show()
             self.createMap()
            self.getExploreData()
        }
        if  self.screenName == "ExploreRecommendation"{
            self.isNotRefresh = true
            self.screenName = ""
        }
       self.isNotRefresh = true
       
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
        self.pageNo = 1
        self.j = 0
        filtering = false
        textFieldSearch.text = ""
        self.isMapRefresh = true
        self.isGettingData = true // code added
       // self.titleExplore.isHidden = true
        
        
        
       
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
        self.isNotRefresh = true
    }
    func showPin()
    {
             //  SVProgressHUD.dismiss() //code comment
        
                self.mapView?.clear()
        
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
                            else if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("other"){
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
                                
                                
                                // added by Ranjit 15 dec
                                if cusineDetailProfile.innerCircleUrl.characters.count > 0{
                                    imageViewForPinMarker.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                                }
                                else{
                                    imageViewForPinMarker.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                                }

                               // imageViewForPinMarker.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "rest_defoutImage"))
                                marker.iconView = imageViewForPinMarker
                                marker.tracksViewChanges = true
                                marker.map = mapView
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(50)) {
                                // Code
                                //self.locationManager?.startUpdatingLocation()
                                self.mapView?.animate(with: update)
                                self.view.isUserInteractionEnabled = true
                                SVProgressHUD.dismiss()
                                
                                
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
                      //  print(cuisineArray.count)
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
                            else if cusineDetailProfile.suggestionBy.localizedCaseInsensitiveContains("other"){
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
                                
                                if cusineDetailProfile.innerCircleUrl.characters.count > 0{
                                    imageViewForPinMarker.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                                }
                                else{
                                    imageViewForPinMarker.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                                }

                                
                               // imageViewForPinMarker.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "rest_defoutImage"))
                                marker.iconView = imageViewForPinMarker
                                marker.tracksViewChanges = true
                                marker.map = mapView
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(50)) {
                                // Code
                                self.mapView?.animate(with: update)
                                self.view.isUserInteractionEnabled = true
                                SVProgressHUD.dismiss()
                                self.locationManager?.startUpdatingLocation()
                                
                            }
                            
                        }
                        
                    }
                    
                }
       SVProgressHUD.dismiss()
       self.view.isUserInteractionEnabled = true
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
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
    
    
    func getExploreData(){
        
       // print("count ------ ",cuisineArray.count)
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            
            let singelton = SharedManager.sharedInstance
            
            var latitude = 0.0
            var longitude = 0.0
            if singelton.isExploreCitySearch {
                latitude = singelton.latValueExploreCity
                longitude = singelton.longValueExploreCity
                
            }
            else{
                latitude = singelton.latValueInitial
                longitude = singelton.longValueInitial
            }
            
            isTextSearch =  singelton.isTextSearch
            if   singelton.isNavigateMapScreenAfterSearch{
                   latitude = self.latNavigate
                   longitude = self.longNavigate
                
            }
            if singelton.isExploreCitySearch {
               
                isTextSearch = "0"
                
                if singelton.isExploreRestaurantSearch == true{
                    isTextSearch = "2"
                }
            }
            else{
                 isTextSearch = "0"
                if singelton.isUserCurrentLocation{
                   
                    if singelton.isNavigateMapScreenAfterSearch{
                        isTextSearch = "0"
                        if singelton.isExploreRestaurantSearch == true{
                            isTextSearch = "2"
                        }
                    }
                    else{
                        if singelton.isExploreRestaurantSearch == true{
                            isTextSearch = "2"
                        }
                    }
                    
                   
                }
                else{
                    // if location not found
                     isTextSearch = "0"
                    if singelton.isNavigateMapScreenAfterSearch{
                        isTextSearch = "0"
                        if singelton.isExploreRestaurantSearch == true{
                            isTextSearch = "2"
                        }
                    }
                    else{
                        if singelton.isExploreRestaurantSearch == true{
                            isTextSearch = "1"
                        }
                    }
                }
                
//                if singelton.isExploreRestaurantSearch == true{
//                    if singelton.exploreCityFormattedAddress.characters.count > 0{
//                        isTextSearch = "0"
//                    }
//                    else{
//                        
//                        if singelton.isUserCurrentLocation{
//                            isTextSearch = "1"
//                        }
//                    }
//                   
//                }
            }
//            let singelton = SharedManager.sharedInstance
//            
//            let latitude = singelton.latValueInitial
//            let longitude = singelton.longValueInitial
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
                parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"page":self.pageNo,"is_filter":isSearchChange,"isTextSearch":isTextSearch,"search":singelton.exploreRestaurantSearchText,"isMap":"1","curlat":singelton.latValueInitial,"curlong":singelton.longValueInitial] as [String : Any]
            }
            else{
                parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"cuisine":self.optionCuisineFilter,"price":self.optionPriceFilter,"source":self.optionFilter,"page":self.pageNo,"is_filter":isSearchChange,"isTextSearch":isTextSearch,"search":singelton.exploreRestaurantSearchText,"isMap":"1","curlat":singelton.latValueInitial,"curlong":singelton.longValueInitial] as [String : Any]
            }
            
              print("pa---------",parameters)
            DataManager.sharedManager.getExploreDetail(params: parameters, completion: { (response) in
                if let dataDic = response as? [[String:Any]]
                {
                    self.cuisinesPageFilter = dataDic
                    //  print(dataDic)
                    
                    
                    //print(self.cuisinesPageFilter)
                    if self.cuisinesPageFilter.count > 0
                    {    // print("asd",self.cuisinesFilter.count)
                        if self.isTextSearchClick == true{
                            self.resetData()
                            self.isTextSearchClick = false
                        }

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
                            if let locDistance = self.cuisinesFilter[self.j]["loc_distance"] as? String{
                                self.locDistance = locDistance
                            }else{
                                self.locDistance = ""
                            }

                            
                            
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
                            cusineDetail.locDistance = self.locDistance
                            self.cuisineArray.append(cusineDetail)
                           if singelton.isExploreRestaurantSearch == true{
                                self.filteredUserProfileArray.append(cusineDetail)

                            }
                            self.countGoogleApiHit(index: self.j)
                            self.j = self.j + 1
                            //  print(self.nameRestaurant, self.latValue,self.longValue)
                        }
                        // print("count is",self.cuisineArray.count)
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                         self.view.isUserInteractionEnabled = true
                        if self.isTextSearchClick == true{
                            self.resetData()
                            self.isTextSearchClick = false
                        }

                        if self.cuisinesFilter.count > 0{
                            
                        }
                        else{
                            self.view.isUserInteractionEnabled = true
                            
                        }
                        
                    }
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    if self.isTextSearchClick == true{
                        self.resetData()
                        self.isTextSearchClick = false
                    }

                    
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
                   // SVProgressHUD.dismiss() //code comment
                    self.view.isUserInteractionEnabled = true
                    self.showPin()
                }
            })
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
    func countGoogleApiHit(index:Int){
        //  print(index,self.ProfileImagesArray.count,self.PhotoRefArray.count)
        if self.cuisineArray.count <= index {
            SVProgressHUD.dismiss()
            return
        }
        var cuisineDetail = ProfileCuisineFilter()
        if  cuisineArray.indices.contains(self.selectedProfileIndex){
            cuisineDetail = cuisineArray[self.selectedProfileIndex]
            
        }
        else{
            //  print("count is------p-p-",cuisineArray.count,self.selectedProfileIndex)
        }
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
                          //  print(photosArray.count)
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
    // MARK:TEXTFILED DELEGATE METHOD
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //self.titleLabel.isHidden = true
//        filtering = true
//        self.isNotRefresh = true
//        delayWithSeconds(0.5) {
//            self.filter(text: textField.text!)
//        }
//        
//        return true
//    }
    
    func filter (text:String) {
        // var user = InnerCircleProfile()
        filteredUserProfileArray.removeAll()
        
        if (text.characters.count == 0) {
            //filteredUserProfileArray.append(self.userProfileArray)
            filtering = false
           // self.tableView.reloadData()
            let singelton = SharedManager.sharedInstance
            singelton.exploreRestaurantSearchText = ""
            singelton.isExploreRestaurantSearch = false
            self.showPin()
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
        
       self.showPin()
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
         textField.text =  textField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
          if textFieldSearch.text  == ""{
            filtering = false
            let singelton = SharedManager.sharedInstance
            singelton.exploreRestaurantSearchText = ""
            singelton.isExploreRestaurantSearch = false
            textField.resignFirstResponder()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let singelton = SharedManager.sharedInstance
         textField.text =  textField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if textField.text == ""{
            //filteredUserProfileArray.removeAll()
            filtering = false
           
            singelton.exploreRestaurantSearchText = ""
           // self.isSearchAfterNavigate = false
            
            singelton.isExploreRestaurantSearch = false
           // self.showPin()
            singelton.isNavigateMapScreenAfterSearch = false
            textField.resignFirstResponder()
            return true
        }
        filtering = true
        self.pageNo = 1
        
         singelton.isExploreRestaurantSearch = true
         singelton.exploreRestaurantSearchText = textField.text!
         singelton.isNavigateMapScreenAfterSearch = true
         isTextSearchClick = true
        // isGettingData = true
         self.getExploreData()
        
        textField.resignFirstResponder()
        return true
    }
    func mapView(_ mapView:GMSMapView,idleAt position:GMSCameraPosition)
    {
//        let lat = mapView.camera.target.latitude
//        print(lat)
//        
//        let lon = mapView.camera.target.longitude
        self.latNavigate = mapView.camera.target.latitude
        self.longNavigate = mapView.camera.target.longitude
       // let cityCoords = CLLocation(latitude:self.latNavigate, longitude: self.longNavigate)
        print(mapView.camera.zoom)
        if mapView.camera.zoom >= 13.0{
            self.reloadButton.isHidden = false
        }
        else{
            self.reloadButton.isHidden = true

        }
        if isGettingData{
            self.latValueTransfer = self.latNavigate
            self.longValuetransfer = self.longNavigate
            let cityCoords = CLLocation(latitude:self.latValueTransfer, longitude: self.longValuetransfer)
            self.getAdressName(coords: cityCoords)
            isGettingData = false
        }
       
       
    }
    //Location Manager delegates  commented above code for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        
       // self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager?.stopUpdatingLocation()
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @IBAction func goBack(_ sender: Any) {
        
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"NotificationExploreMapViewNotRefresh")
        nc.post(name:myNotification,
                object: nil,
                userInfo:["screenName":"ExploreTabView","filter":filtering,"filteredArray":self.filteredUserProfileArray,"NonFilterArray":self.cuisineArray,"searchText":textFieldSearch.text ?? "","searchAddress":self.formattedTextAddress,"lat":self.latNavigate,"long":self.longNavigate,"isMapRefresh":self.isMapRefresh])

        _ = self.navigationController?.popViewController(animated: true)

    }
    @IBAction func goforward(_ sender: Any) {
       
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            self.isNotRefresh = true
            //self.screenName = "FilterScreen"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ExploreFilterViewController")
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
    @IBAction func mapAreaTap(_ sender: Any) {
        
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"NotificationExploreMapViewNotRefresh")
        nc.post(name:myNotification,
                object: nil,
                userInfo:["screenName":"ExploreTabView","filter":filtering,"filteredArray":self.filteredUserProfileArray,"NonFilterArray":self.cuisineArray,"searchText":textFieldSearch.text ?? "","searchAddress":self.formattedTextAddress,"lat":self.latNavigate,"long":self.longNavigate,"isMapRefresh":self.isMapRefresh])
      print( self.formattedTextAddress)
        _ = self.navigationController?.popViewController(animated: true)
    }
    func getAdressName(coords: CLLocation) {
        // print(coords.coordinate.latitude,coords.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                
                print("Hay un error")
                
            } else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    let place = placemark![0]
                    print("address",place)
                    var street_number: String = ""
                    var neighborhood: String = ""
                    var locality: String = ""
                    var administrative_area_level_1: String = ""
                    var country: String = ""
                    var truncatedString:String = ""
                    if place.name != nil {
                        street_number = place.name!
                       
                    }
                    
                    if place.subLocality != nil {
                        neighborhood = place.subLocality!
                       
                    }
                    if place.locality != nil {
                        locality = place.locality!
                       
                    }
                    if place.administrativeArea != nil {
                        administrative_area_level_1 = place.administrativeArea!
                                             }
                    
                    if place.country != nil {
                        country = place.country!
                        
                    }
                    
                    
                    if street_number.characters.count > 0{
                        //print(completeString)
                        if street_number.characters.count <= 32{
                            truncatedString = street_number + " "
                        }
                        else{
                            truncatedString = ""
                        }
                        
                    }
                    
                    if neighborhood.characters.count > 0{
                        //   print(completeString)
                        if truncatedString.characters.count + neighborhood.characters.count <= 32{
                            truncatedString = truncatedString  + neighborhood + " "
                        }
                        else{
                            locality = ""
                        }
                        
                    }
                    if locality.characters.count > 0{
                        
                        if truncatedString.characters.count + locality.characters.count <= 32{
                            truncatedString = truncatedString  + locality + " "
                        }
                        else{
                            administrative_area_level_1 = ""
                        }
                        
                    }
                    if administrative_area_level_1.characters.count > 0{
                        
                        if administrative_area_level_1.localizedCaseInsensitiveContains(locality){
                            
                        }
                        else{
                            if truncatedString.characters.count + administrative_area_level_1.characters.count <= 32{
                                truncatedString = truncatedString  + administrative_area_level_1 + " "
                            }
//                            else{
//                                country = ""
//                            }
                        }
                        
                        
                    }
//                    if country.characters.count > 0{
//                        
//                        if truncatedString.characters.count + country.characters.count <= 35{
//                            truncatedString = truncatedString +  country
//                        }
//                        else{
//                            
//                        }
//                        
//                    }

                  self.formattedTextAddress = truncatedString
                    
                    
                  //  self.formattedTextAddress = strLocality   + " " + strState
                    print(self.formattedTextAddress)
//                    var adressString : String = ""
//                    adressString = self.locality
//                    if place.administrativeArea != nil {
//                        adressString = adressString +  ", " + place.administrativeArea!
//                    }
//                      print(adressString)
                    /*  if place.postalCode != nil {
                     adressString = adressString + " (" + place.postalCode! + ")"
                     //    print(adressString)
                     }
                     */
//                    let singelton = SharedManager.sharedInstance
//                    singelton.exploreCityFormattedAddress = adressString
//                    singelton.isExploreCitySearch = true
//                    singelton.checkScreen = 10
                }
                
                
               // self.fillAddressForm()
            }
            
        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isNotRefresh == true{
            mapView?.delegate = nil
            mapView?.removeFromSuperview()
            mapView = nil
            let nc1 = NotificationCenter.default
            nc1.removeObserver(self, name: myNotification, object: nil)
            self.cuisineArray.removeAll()
            self.filteredUserProfileArray.removeAll()
            self.cuisinesFilter.removeAll()
            self.selectedProfileIndex = 0
            self.PhotoRefArray.removeAll()
            self.pageNo = 1
            self.j = 0
            isGettingData = true
          textFieldSearch.resignFirstResponder()
          self.reloadButton.isHidden = true
//            if mapWrapperView != nil{
//                mapWrapperView.removeFromSuperview()
//                mapWrapperView = nil
//            }
//            let nc = NotificationCenter.default
//            let myNotification = Notification.Name(rawValue:"NotificationExploreMapViewNotRefresh")
//            nc.post(name:myNotification,
//                    object: nil,
//                    userInfo:["screenName":"ExploreTabView"])
           // _ = self.navigationController?.popViewController(animated: true)
        }
        else{
            let nc1 = NotificationCenter.default
            nc1.removeObserver(self, name: myNotificationNotRefresh, object: nil)
        }
         SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        self.locationManager?.stopUpdatingLocation()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
