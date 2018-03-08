//
//  ExploreTabViewController.swift
//  Taste
//
//  Created by Asish Pant on 11/10/17.
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
import GooglePlaces

class ExploreTabViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate
{

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var textFieldLocationSearch: UITextField!

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleExplore: UILabel!
    
   
    var banks = [[String:Any]]()
    var userData = [[String:Any]]()
    let texts = ["AMERICAN EXPRESS", "AMERICA", "BANK OF AMERICA", "CAPITAL ONE" ,"CHASE BANK" , "CITI BANK" , "CITIZENS BANK"]
   // var tableView:UITableView!
    var filtering = false
    var filteredBanks = [[String:Any]]()
    var  isloading  = true
    var replaced : String?
    var screenName :String?
    //let textFieldSearch = UITextField()
    
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
    var locDistance: String = ""
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
    var isTextSearch:String = "0" // whether first text field , second  or both clicked
    var isNotRefresh:Bool = true
    let myNotification = Notification.Name(rawValue:"NotificationExploreFilter")
    let myNotificationNotRefresh = Notification.Name(rawValue:"NotificationExploreMapViewNotRefresh")
   // let myNotificationPinRefresh = Notification.Name(rawValue:"NotificationExploreMapPin")
    let titleLabel = UILabel()
    var settingsButton = UIButton(type: .custom)
   // let backButton = UIButton(type: .custom)
   // var filterButton = UIButton(type: .custom)
    let leftImageView = UIImageView()
    var mapButton1 = UIButton(type: .custom)
    let titleLabel2 = UILabel()
    var settingsButtonWrapper = UIButton(type: .custom)
    var mapButton = UIButton(type: .custom)
   // let titleExplore = UILabel()
    // Declare variables to hold address form values.
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var sublocalityLevel1: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    var isCity:Bool = false
    var isShowCurrentLocation:Bool = true
    var  isFirstTime:Bool = true
    var isSearchRestaurantName:Bool = true
    var isTextSearchClick:Bool = false
    var latNavigate : Double = 0.0 // from map search
    var longNavigate : Double = 0.0 //from map search
    var navigateFromMap:Bool = false
    var isMapScreenRefresh:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        self.locationManager?.startUpdatingLocation()

        textFieldSearch.delegate = self
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
      

        
        textFieldLocationSearch.delegate = self
        textFieldLocationSearch.backgroundColor = UIColor.black
        textFieldLocationSearch.layer.cornerRadius = 8
        textFieldLocationSearch.textColor = UIColor.white
        textFieldLocationSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        textFieldLocationSearch.leftViewMode = .always
        let strLocation = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textFieldLocationSearch.attributedPlaceholder = strLocation
        textFieldLocationSearch.returnKeyType = UIReturnKeyType.search
        let singelton = SharedManager.sharedInstance
        singelton.checkScreen = 10
        singelton.refreshExplore = "yes"
//        let leftImageViewLocation = UIImageView()
//        leftImageViewLocation.image = UIImage(named: "ic_search")
//        
//        let leftViewLocation = UIView()
//        leftViewLocation.addSubview(leftImageView)
//        
//        leftViewLocation.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        leftImageViewLocation.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
//        textFieldLocationSearch.leftViewMode = .always
//        textFieldLocationSearch.leftView = leftView
        

     
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (textFieldLocationSearch.text?.characters.count)! > 0 {
             self.cancelBtn.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
       
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        let ncRefresh = NotificationCenter.default
        ncRefresh.addObserver(forName:myNotificationNotRefresh, object:nil, queue:nil, using:catchNotificationRefresh)
//        let ncMapPin = NotificationCenter.default
//        ncMapPin.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotificationRefreshMapPin)
       // print("status",self.isNotRefresh)
      /*  if self.isNotRefresh == true{
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
        */
        self.isFirstTime =  true // for location update
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
            if  self.screenName == "ExploreTabView"{
                self.isNotRefresh = true
                self.screenName = ""
                let singelton = SharedManager.sharedInstance
                singelton.refreshExplore = "no"
                if singelton.isExploreCitySearch {
                    self.textFieldLocationSearch.text = singelton.exploreCityFormattedAddress
                    self.textFieldSearch.text =  singelton.exploreRestaurantSearchText
//                    if (self.textFieldLocationSearch.text?.characters.count)! > 0{
//                        self.cancelBtn.isHidden = true
//                    }
//                    else{
//                        self.cancelBtn.isHidden = false
//                    }
                    singelton.checkScreen = 10
                    isShowCurrentLocation = false
                }
            }
            else{
                 let singelton = SharedManager.sharedInstance
                if self.isNotRefresh == true{
                    if singelton.refreshExplore == "yes"{
                         singelton.refreshExplore = "no"
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
                        let singelton = SharedManager.sharedInstance
                        if singelton.isExploreCitySearch {
                            // print(singelton.exploreCityFormattedAddress)
                            self.textFieldLocationSearch.text = singelton.exploreCityFormattedAddress
                            self.textFieldSearch.text =  singelton.exploreRestaurantSearchText
//                            if (self.textFieldLocationSearch.text?.characters.count)! > 0{
//                                self.cancelBtn.isHidden = true
//                            }
//                            else{
//                                self.cancelBtn.isHidden = false
//                            }
                            singelton.checkScreen = 10
                            isShowCurrentLocation = false
                            self.setupView()
                        }
                        else{
                            
                            if isCity{
                                DispatchQueue.main.async {
                                    
                                    SVProgressHUD.show()
                                    
                                }
                                //                            let singelton = SharedManager.sharedInstance
                                //
                                //                            let cityCoords = CLLocation(latitude:  singelton.latValueExploreCity, longitude: singelton.longValueExploreCity)
                                //                            self.getAdressName(coords: cityCoords)
                                let singelton = SharedManager.sharedInstance
                                // singelton.exploreCityFormattedAddress = adressString
                                singelton.isExploreCitySearch = true
                                isShowCurrentLocation = false
                                singelton.checkScreen = 10
                                
                                isCity = false
                                self.textFieldLocationSearch.text = singelton.exploreCityFormattedAddress
                                 self.textFieldSearch.text =  singelton.exploreRestaurantSearchText
//                                if (self.textFieldLocationSearch.text?.characters.count)! > 0{
//                                    self.cancelBtn.isHidden = true
//                                }
//                                else{
//                                    self.cancelBtn.isHidden = false
//                                }
                                self.setupView()
                                
                                
                            }
                            else{
                                DispatchQueue.main.async {
                                    
                                    SVProgressHUD.show()
                                    
                                }
                                
                                self.view.isUserInteractionEnabled = false
                                singelton.checkScreen = 10
                                //singelton.exploreCityFormattedAddress = ""
                                //self.textFieldLocationSearch.text = ""
                                self.textFieldSearch.text =  singelton.exploreRestaurantSearchText
//                                if (self.textFieldLocationSearch.text?.characters.count)! > 0{
//                                    self.cancelBtn.isHidden = true
//                                }
//                                else{
//                                    self.cancelBtn.isHidden = false
//                                }
                                if singelton.isExploreRestaurantSearch || singelton.isNavigateMapScreenAfterSearch {
                                    self.setupView()
                                }
                                else{
                                    singelton.isUserCurrentLocation = true
                                    singelton.exploreCityFormattedAddress = ""
                                    self.textFieldLocationSearch.text = ""
                                    locationManager = CLLocationManager()
                                    locationManager?.delegate = self
                                    self.locationManager?.startUpdatingLocation()
                                }
                            }
                            
                        }
                     }
                }
                else
                {
                     self.isNotRefresh = true// when click on cell didselect
                    let singelton = SharedManager.sharedInstance
                    singelton.refreshExplore = "no"
                    if singelton.isExploreCitySearch {
                        self.textFieldLocationSearch.text = singelton.exploreCityFormattedAddress
                        self.textFieldSearch.text =  singelton.exploreRestaurantSearchText
//                        if (self.textFieldLocationSearch.text?.characters.count)! > 0{
//                            self.cancelBtn.isHidden = true
//                        }
//                        else{
//                            self.cancelBtn.isHidden = false
//                        }
                        isShowCurrentLocation = false
                        singelton.checkScreen = 10
                    }
                }
                
                
            }
            
        }
        else
        {
            let singelton = SharedManager.sharedInstance
            singelton.checkScreen = 10
            self.view.isUserInteractionEnabled = true // code comment
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        // isShowCurrentLocation = true
         //self.view.isUserInteractionEnabled = true // code comment
        
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
        self.titleExplore.isHidden = true
        let singelton = SharedManager.sharedInstance
        singelton.refreshExplore = "yes"
        
        //self.selectedRestaurantIndex = 0
        // self.setupView()
        //self.loadTableViewData()
    }
    func catchNotificationRefresh(notification:Notification) -> Void {
        //  print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let optionSource  = userInfo["screenName"] as? String,
            let optionFilter  = userInfo["filter"] as? Bool,
            let optionFilteredArray  = userInfo["filteredArray"] as? [ProfileCuisineFilter],
            let optionNonFilterArray = userInfo["NonFilterArray"] as? [ProfileCuisineFilter],
            let optionSearchText  = userInfo["searchText"] as? String,
            let searchAddressText  = userInfo["searchAddress"] as? String,
            let latiNavigate  = userInfo["lat"] as? Double,
            let longiNavigate  = userInfo["long"] as? Double,
            let isMapRefreshed  = userInfo["isMapRefresh"] as? Bool
            else {
                //  print("No userInfo recommendation in notification")
                return
        }
        print(searchAddressText)
        self.cuisineArray.removeAll()
        self.filteredUserProfileArray.removeAll()
        self.cuisinesFilter.removeAll()
        self.selectedProfileIndex = 0
        self.PhotoRefArray.removeAll()
        //self.pageNo = 1
        self.j = 0
      // print(self.pageNo)
        self.screenName = optionSource
        filtering = optionFilter
        let singelton = SharedManager.sharedInstance
        singelton.exploreRestaurantSearchText = optionSearchText
        if filtering{
            textFieldSearch.text = optionSearchText
            self.filteredUserProfileArray = optionFilteredArray
            self.cuisineArray = optionNonFilterArray
              filtering = false
        }
        else{
            self.cuisineArray = optionNonFilterArray
            filtering = false
            
        }
        textFieldSearch.text = singelton.exploreRestaurantSearchText
        if singelton.isExploreRestaurantSearch == true{
            let address = searchAddressText.trimmingCharacters(in: CharacterSet.whitespaces)
            if address.characters.count > 0{
                if isMapRefreshed{
                self.textFieldLocationSearch.text = address
                singelton.exploreCityFormattedAddress =  address
                self.latNavigate = latiNavigate
                self.longNavigate = longiNavigate
                }
               // singelton.isNavigateMapScreenAfterSearch = true
                
            }
            else{
               // singelton.isNavigateMapScreenAfterSearch = false
            }
           
        }
        else
        {
            let address = searchAddressText.trimmingCharacters(in: CharacterSet.whitespaces)
            if address.characters.count > 0{
                if isMapRefreshed{
                    self.textFieldLocationSearch.text = address
                    singelton.exploreCityFormattedAddress =  address
                    self.latNavigate = latiNavigate
                    self.longNavigate = longiNavigate
                }
               
                // singelton.isNavigateMapScreenAfterSearch = true
                
            }
            else{
                // singelton.isNavigateMapScreenAfterSearch = false
            }
        }
        self.isloading = false
        self.view.isUserInteractionEnabled = true // code comment
        if (self.cuisineArray.count > 0) || (self.filteredUserProfileArray.count > 0){
             self.titleExplore.isHidden = true
             self.tableView.reloadData()
        }
        else{
            self.tableView.reloadData()
            self.titleExplore.isHidden = false
        }
      
        
    }
//    func catchNotificationRefreshMapPin(notification:Notification) -> Void {
//        //  print("Catch notification")
//        
//        guard let userInfo = notification.userInfo,
//            let optionSource  = userInfo["screenName"] as? String
//            else {
//                //  print("No userInfo recommendation in notification")
//                return
//        }
//        self.screenName = optionSource
//        
//    }
  
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        textFieldSearch.resignFirstResponder()
        self.isFirstTime =  false
        // self.hideMap()
         let singelton = SharedManager.sharedInstance
        print("")
        
        if self.isNotRefresh == true{
             if singelton.refreshExplore == "yes"{
                let nc1 = NotificationCenter.default
                nc1.removeObserver(self, name: myNotificationNotRefresh, object: nil)
                self.cuisineArray.removeAll()
                self.filteredUserProfileArray.removeAll()
                self.cuisinesFilter.removeAll()
                self.selectedProfileIndex = 0
                self.PhotoRefArray.removeAll()
                self.pageNo = 1
                self.j = 0
                filtering = false
               // textFieldSearch.text = ""
                //            let singelton = SharedManager.sharedInstance
                //            singelton.isExploreCitySearch = false
                self.tableView.reloadData()
                // self.titleExplore.isHidden = true
                //  self.tableView.removeFromSuperview()
            }
        }
        else{
            //            if mapWrapperView.isHidden == false{
            //                mapWrapperView.isHidden = true
            //                mapView.isHidden = true
            //            }
            
            if self.isNotRefresh == true{
                if singelton.refreshExplore == "yes"{
                    tableView.delegate = nil
                    tableView.dataSource = nil
                }
               
//                let singelton = SharedManager.sharedInstance
//                singelton.isExploreCitySearch = false

//                if mapWrapperView != nil{
//                    if mapView != nil{
//                        mapWrapperView.isHidden = true
//                        mapView.isHidden = true
//                        
//                    }
//                }
                
            }
            let nc = NotificationCenter.default
            nc.removeObserver(self, name: myNotification, object: nil)
        }
        if isShowCurrentLocation == true{
            let singelton = SharedManager.sharedInstance
            singelton.isExploreCitySearch = false
            
        }

      //  let singelton = SharedManager.sharedInstance
        
//        if singelton.checkScreen == 10{
//            self.isNotRefresh = true
//            singelton.isExploreCitySearch = false
//        }
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        if self.isNotRefresh == true{
//            mapView?.delegate = nil
//            mapView?.removeFromSuperview()
//            mapView = nil
//            if mapWrapperView != nil{
//                mapWrapperView.removeFromSuperview()
//                mapWrapperView = nil
//            }
//        }
//        
        
    }
    func setupView() {
     self.loadTableViewData()
    }
    
    func loadTableViewData(){
        
      //  print("count ------- ",cuisineArray.count)
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
                 isTextSearch = "0"
                
                if singelton.isExploreRestaurantSearch == true{
                    isTextSearch = "2"
                   
                }
            }
            else{
                latitude = singelton.latValueInitial
                longitude = singelton.longValueInitial
                isTextSearch = "0"
                
                if singelton.isExploreRestaurantSearch == true{
                    isTextSearch = "1"
                    if singelton.isUserCurrentLocation {
                        isTextSearch = "2"
                    }
                     if  singelton.isNavigateMapScreenAfterSearch {
                        isTextSearch = "2"
                    }
                    
                }
                else{
                    if  singelton.isNavigateMapScreenAfterSearch {
                        isTextSearch = "0"
                    }
                }
            }
           singelton.isTextSearch = isTextSearch
            if  singelton.isNavigateMapScreenAfterSearch {
                latitude = self.latNavigate
                longitude = self.longNavigate
            }
        

        
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
                parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"page":self.pageNo,"is_filter":isSearchChange,"isTextSearch":isTextSearch,"search":singelton.exploreRestaurantSearchText,"curlat":singelton.latValueInitial,"curlong":singelton.longValueInitial] as [String : Any]
            }
            else{
                parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"cuisine":self.optionCuisineFilter,"price":self.optionPriceFilter,"source":self.optionFilter,"page":self.pageNo,"is_filter":isSearchChange,"isTextSearch":isTextSearch,"search":singelton.exploreRestaurantSearchText,"curlat":singelton.latValueInitial,"curlong":singelton.longValueInitial] as [String : Any]
            }
            DispatchQueue.main.async {
                
                SVProgressHUD.show()
                
            }
              print("pa---------",parameters)
            DataManager.sharedManager.getExploreDetail(params: parameters, completion: { (response) in
                if let dataDic = response as? [[String:Any]]
                {
                    self.cuisinesPageFilter = dataDic
                     // print(dataDic)
                   
                    
                    
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
                            cusineDetail.locDistance = self.locDistance
                            self.cuisineArray.append(cusineDetail)
                            
                            self.j = self.j + 1
                            //  print(self.nameRestaurant, self.latValue,self.longValue)
                        }
                         self.titleExplore.isHidden = true
                        // print("count is",self.cuisineArray.count)
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        if self.isTextSearchClick == true{
                            self.resetData()
                            self.isTextSearchClick = false
                        }
                        if self.cuisineArray.count > 0{
                             self.view.isUserInteractionEnabled = true
                        }
                        else{
                            self.view.isUserInteractionEnabled = true
                            self.titleExplore.isHidden = false
                            
                        }
                        
                    }
                    
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    if self.isTextSearchClick == true{
                        self.resetData()
                        self.isTextSearchClick = false
                    }
                    if self.cuisineArray.count > 0{
                        
                    }
                    else
                    {
                        self.view.isUserInteractionEnabled = true
                        self.titleExplore.isHidden = false
                        
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
                DispatchQueue.main.async {
                    
                    
                    //  print("index value is and count--- ",self.cuisineArray.count)
                    if self.cuisineArray.count > 0 {
                       // self.tableView.delegate = self
                       // self.tableView.dataSource = self
                        
                        
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        //delayWithSeconds(1.5){
                           self.countGoogleApiHit(index:self.selectedProfileIndex)
                        //}
                    }
                    else{
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                    }
                    
                    
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
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  return cuisinesFilter.count;
        // return self.PhotoRefArray.count
        if (filtering) {
            return filteredUserProfileArray.count;
        }
        //print("Email Data",userProfileArray)
      //  print(cuisineArray)
        return cuisineArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTabTableViewCell", for: indexPath) as! ExploreTabTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        _ = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04"]
        var cuisineDetail =  ProfileCuisineFilter()
        if filtering{
            
           // cuisineDetail  = self.filteredUserProfileArray[indexPath.row]
            if  self.filteredUserProfileArray.indices.contains(indexPath.row){
                cuisineDetail  = self.filteredUserProfileArray[indexPath.row]
            }
        }
        else{
            if  cuisineArray.indices.contains(indexPath.row){
                cuisineDetail  = cuisineArray[indexPath.row]
            }
            
        }
        
            //image view
            cell.exploreImageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
            // }
            cell.exploreImageView.clipsToBounds = true
            cell.exploreImageView.contentMode = UIViewContentMode.scaleAspectFill
            cell.exploreImageView.layer.cornerRadius = 5.0
            cell.exploreImageView.clipsToBounds = true
        
            //overlay view
            cell.overlayView?.backgroundColor = UIColor.black
            cell.overlayView?.alpha = 0.50
            cell.overlayView?.layer.cornerRadius = 5
        
            // restraunt text
            cell.lblrestraunt.numberOfLines = 1
            cell.lblrestraunt.adjustsFontSizeToFitWidth = true
            cell.lblrestraunt.minimumScaleFactor = 0.2
            cell.lblrestraunt.font = UIFont(name:K_Font_Color_Regular,size:24)
            cell.lblrestraunt.textColor = UIColor.white
            
            cell.lblrestraunt.text = cuisineDetail.restaurantName
            
            cell.lblCuisineName.textColor = UIColor.white
            cell.lblCuisineName.numberOfLines = 1
            cell.lblCuisineName.adjustsFontSizeToFitWidth = true
            cell.lblCuisineName.minimumScaleFactor = 0.2
            cell.lblCuisineName.font = UIFont(name:K_Font_Color,size:18)
            cell.lblCuisineName.text = cuisineDetail.cuisineName
        
            self.latValueRestaurant = cuisineDetail.latitudeValue
            self.longValueRestaurant = cuisineDetail.longitudeValue
            
            let singelton = SharedManager.sharedInstance
            let coordinate1 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
            let coordinate2 = CLLocation(latitude: self.latValueRestaurant, longitude:  self.longValueRestaurant)
        
            let distanceInMeters = coordinate1.distance(from: coordinate2)
            let finaldist =  distanceInMeters / 1609.344
        
            cell.lblMiles.numberOfLines = 1
            cell.lblMiles.adjustsFontSizeToFitWidth = true
            cell.lblMiles.minimumScaleFactor = 0.2
            cell.lblMiles.font = UIFont(name:K_Font_Color,size:18)
            cell.lblMiles.textColor = UIColor.white
            
            //cell.lblMiles.text = String(format:"%.4f", finaldist) + " Miles"
           // cell.lblMiles.text = String(format:"%f", cuisineDetail.locDistance) + " Miles"
            cell.lblMiles.text = cuisineDetail.locDistance + " Miles"
           if cuisineDetail.suggestionBy == "other"{
            cell.textLabelSuggestion.isHidden = true
            cell.suggestedBy.isHidden = true
           }
           else{
            cell.textLabelSuggestion.isHidden = false
            cell.suggestedBy.isHidden = false
           }
            cell.textLabelSuggestion.numberOfLines = 1
            cell.textLabelSuggestion.adjustsFontSizeToFitWidth = true
            cell.textLabelSuggestion.minimumScaleFactor = 0.2
            cell.textLabelSuggestion.font = UIFont(name:K_Font_Color,size:18)
            cell.textLabelSuggestion.textColor = UIColor.white
            
            cell.textLabelSuggestion.text = cuisineDetail.suggestionBy
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let singelton = SharedManager.sharedInstance
        if singelton.isExploreCitySearch == true{
            singelton.checkScreen = 100
            isShowCurrentLocation = false
        }
        else{
            singelton.checkScreen = 10
            isShowCurrentLocation = true
        }

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
            var cuisineDetail = ProfileCuisineFilter()
            cuisineDetail = cuisineArray[indexPath.row]
            K_INNERUSER_DATA.Address = cuisineDetail.address
            K_INNERUSER_DATA.CITY = cuisineDetail.city
            K_INNERUSER_DATA.Country = cuisineDetail.country
            K_INNERUSER_DATA.State = cuisineDetail.state
            K_INNERUSER_DATA.ZIP = cuisineDetail.PostCode
            K_INNERUSER_DATA.Phone = cuisineDetail.phone
            K_INNERUSER_DATA.Website = cuisineDetail.website
            K_INNERUSER_DATA.Hours = cuisineDetail.hour
            //  K_INNERUSER_DATA.CuisineName = cusineDetails.cuisineName
            K_INNERUSER_DATA.CuisinSeleted = cuisineDetail.cuisineName
            K_INNERUSER_DATA.FactualId = cuisineDetail.FactualId
            K_INNERUSER_DATA.RestaurantName = cuisineDetail.restaurantName
            K_INNERUSER_DATA.latvalueNavigate = cuisineDetail.latitudeValue
            K_INNERUSER_DATA.longvalueNavigate = cuisineDetail.longitudeValue
            K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
            K_INNERUSER_DATA.Price = cuisineDetail.Price
            K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
            K_INNERUSER_DATA.Rating = cuisineDetail.rating

//            if let locAddress = self.cuisinesFilter[indexPath.row]["address"] as? String{
//                K_INNERUSER_DATA.Address = locAddress
//            }
//            else{
//                K_INNERUSER_DATA.Address=""
//            }
//            if let locCity = self.cuisinesFilter[indexPath.row]["locality"] as? String{
//                K_INNERUSER_DATA.CITY=locCity
//            }
//            else{
//                K_INNERUSER_DATA.CITY=""
//            }
//            if let locCountry = self.cuisinesFilter[indexPath.row]["country"] as? String{
//                K_INNERUSER_DATA.Country=locCountry
//            }
//            else{
//                K_INNERUSER_DATA.Country=""
//            }
//            
//            if let locState = self.cuisinesFilter[indexPath.row]["region"] as? String{
//                K_INNERUSER_DATA.State=locState
//            }
//            else{
//                K_INNERUSER_DATA.State=""
//            }
//            if let locZip =  self.cuisinesFilter[indexPath.row]["postcode"] as? NSNumber
//            {
//                K_INNERUSER_DATA.ZIP = locZip.stringValue
//            }
//            else{
//                K_INNERUSER_DATA.ZIP=""
//            }
//            if let locTel =  self.cuisinesFilter[indexPath.row]["tel"] as? String{
//                
//                K_INNERUSER_DATA.Phone = locTel
//            }
//            else{
//                K_INNERUSER_DATA.Phone=""
//            }
//            if let locWebsite =  self.cuisinesFilter[indexPath.row]["website"] as? String{
//                
//                K_INNERUSER_DATA.Website = locWebsite
//            }
//            else{
//                K_INNERUSER_DATA.Website=""
//            }
//            
//            if let hours =  self.cuisinesFilter[indexPath.row]["hours_display"] as? String{
//                K_INNERUSER_DATA.Hours = hours
//            }
//            else{
//                K_INNERUSER_DATA.Hours = ""
//            }
            
//            if let cuisineArr = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
//                if cuisineArr.count > 0{
//                    if let cuisine = cuisineArr[0] as? String{
//                        K_INNERUSER_DATA.CuisinSeleted = cuisine
//                    }
//                    else{
//                        K_INNERUSER_DATA.CuisinSeleted = ""
//                    }
//                    
//                    
//                }
//                else{
//                    K_INNERUSER_DATA.CuisinSeleted = ""
//                }
//            }
//            else{
//                K_INNERUSER_DATA.CuisinSeleted = ""
//            }
            
            
            
//            if let factual_id = self.cuisinesFilter[indexPath.row]["factual_id"] as? String{
//                K_INNERUSER_DATA.FactualId = factual_id
//            }
//            else{
//                K_INNERUSER_DATA.FactualId = ""
//            }
            
//            if let restName  = self.cuisinesFilter[indexPath.row]["name"] as? String
//            {
//                K_INNERUSER_DATA.RestaurantName = restName
//            }
//            else{
//                K_INNERUSER_DATA.RestaurantName  = ""
//            }
            
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
           
//            K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
//            K_INNERUSER_DATA.Price = cuisineDetail.Price
//            K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
            
            //  print("place" ,K_INNERUSER_DATA.placeId)
            //K_INNERUSER_DATA.Rating = cuisineDetail.rating
            self.isNotRefresh = false
            let singelton = SharedManager.sharedInstance
            singelton.refreshExplore = "no"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
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
        let lastElement = self.cuisineArray.count
      //  print(self.cuisineArray.count)
        if  !(indexPath.row + 1 < lastElement)  && isloading == false
        {
            isloading = true
            
            if self.cuisineArray.count >= 20{
                isSearchChange = "0" // not updating explore filter
                pageNo = pageNo + 1
                self.loadTableViewData()
            }
            
            
        }
        //  print("indexpath for the last call is \(indexPath.row)")
        
    }
    // MARK:TEXTFILED DELEGATE METHOD
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //self.titleLabel.isHidden = true
        if textField.tag == 0
        {
            filtering = true
            self.isNotRefresh = true
            delayWithSeconds(0.5) {
                self.filter(text: textField.text!)
             }
          }
        else {
//                            isShowCurrentLocation = false
//                            let autocompleteController = GMSAutocompleteViewController()
//                            autocompleteController.delegate = self
//                
//                            // Set a filter to return only addresses.
//                            let addressFilter = GMSAutocompleteFilter()
//                            addressFilter.type = .city
//                          //  addressFilter.country = .po
//                            autocompleteController.autocompleteFilter = addressFilter
//                
//                            present(autocompleteController, animated: true, completion: nil)

            }

        
        return true
    }
    */
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag == 1{
            isShowCurrentLocation = false
            let singelton = SharedManager.sharedInstance
            singelton.refreshExplore = "yes"
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            // Set a filter to return only addresses.
            let addressFilter = GMSAutocompleteFilter()
            addressFilter.type = .noFilter
           
            autocompleteController.autocompleteFilter = addressFilter
            
            present(autocompleteController, animated: true, completion: nil)
        }
        
        
    }
    func filter (text:String) {
     /*   // var user = InnerCircleProfile()
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
 */
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
        let singelton = SharedManager.sharedInstance
        if textField.tag == 0{
            
            textField.text =  textField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            if ((textField.text?.characters.count)! > 0){
                singelton.exploreRestaurantSearchText =  textField.text!
                 singelton.isExploreRestaurantSearch = true //  first textfield search
            }
            else{
                singelton.exploreRestaurantSearchText = ""
                 singelton.isExploreRestaurantSearch = false
            }
            self.pageNo = 1
           isTextSearchClick = true
           self.loadTableViewData()
        }
        textField.resignFirstResponder()
        return true
    }
    func resetData(){
        self.cuisineArray.removeAll()
        self.filteredUserProfileArray.removeAll()
        self.cuisinesFilter.removeAll()
        self.selectedProfileIndex = 0
        self.PhotoRefArray.removeAll()
        //self.pageNo = 1
        self.j = 0
        self.tableView.reloadData()
       
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textFieldSearch.text  == ""
        {
            let singelton = SharedManager.sharedInstance
            singelton.exploreRestaurantSearchText = ""
            singelton.isExploreRestaurantSearch = false
            
        }
    }

    func countGoogleApiHit(index:Int){
        //   print(index,self.PhotoRefArray.count)
        if self.cuisineArray.count <= index {
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true // code added
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
      //  SVProgressHUD.dismiss()
        // print("All photos Reference", self.PhotoRefArray)
        //  print("All photos count", self.PhotoRefArray.count)
        
        
    }
    

    @IBAction func goBack(_ sender: Any) {
      /*   self.screenName = ""
         self.isNotRefresh = true
        let singelton = SharedManager.sharedInstance
        singelton.isExploreCitySearch = false
        singelton.checkScreen = 10
       isCity = false
        isShowCurrentLocation = true
 */
        self.tabBarController?.selectedIndex =  1
        
        // _ = self.navigationController?.popViewController(animated: true)

    }
    func goBack()
    {
       
       /*  self.screenName = ""
         self.isNotRefresh = true
         let singelton = SharedManager.sharedInstance
         singelton.isExploreCitySearch = false
         singelton.checkScreen = 10
         isCity = false
        isShowCurrentLocation = true
 */
        self.tabBarController?.selectedIndex =  1
        
        // _ = self.navigationController?.popViewController(animated: true)
    }
    func goforward()
    {
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            self.isNotRefresh = true
            self.screenName = "FilterScreen"
            let singelton = SharedManager.sharedInstance
            if singelton.isExploreCitySearch == true{
                singelton.checkScreen = 100
                isShowCurrentLocation = false
            }
            else{
                singelton.checkScreen = 10
                isShowCurrentLocation = true
            }
            singelton.refreshExplore = "yes"
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
    @IBAction func ClearText(_ sender: Any) {
         self.textFieldLocationSearch.text = ""
//        if (self.textFieldLocationSearch.text?.characters.count)! > 0{
//            self.cancelBtn.isHidden = false
//        }
//        else{
//            self.cancelBtn.isHidden = true
//        }
         self.cancelBtn.isHidden = true
         let singelton = SharedManager.sharedInstance
        // singelton.exploreCityFormattedAddress = ""
         singelton.isExploreCitySearch = false
         singelton.checkScreen = 10
         singelton.isUserCurrentLocation = false
         singelton.isNavigateMapScreenAfterSearch = false // when search from map screen after search
         isCity = false
    }
    @IBAction func goforward(_ sender: Any) {
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            self.isNotRefresh = true
            self.screenName = "FilterScreen"
            let singelton = SharedManager.sharedInstance
            if singelton.isExploreCitySearch == true{
                singelton.checkScreen = 100
                isShowCurrentLocation = false
            }
            else{
                singelton.checkScreen = 10
                isShowCurrentLocation = true
            }
            singelton.refreshExplore = "yes"
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
    
    
     @IBAction func mapButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExploreMapViewController") as! ExploreMapViewController
        let singelton = SharedManager.sharedInstance
        if singelton.isExploreCitySearch == true{
            singelton.checkScreen = 100
             isShowCurrentLocation = false
             singelton.isUserCurrentLocation = false
        }
        else{
            singelton.checkScreen = 10
             isShowCurrentLocation = true
            if self.textFieldLocationSearch.text == "Current Location"{
                singelton.isUserCurrentLocation = true
            }
            else{
               singelton.isUserCurrentLocation = false
            }
            
        }
       
        //vc.annotationArray = self.annotationArray
        
        if filtering{
            vc.cuisineArray = self.filteredUserProfileArray
        }
        else{
          vc.cuisineArray = cuisineArray
        }
       // vc.cuisineArray = cuisineArray
        //vc.filtering = filtering
         vc.filtering = false
        //vc.filteredUserProfileArray = self.filteredUserProfileArray
        self.isNotRefresh = false
        
        singelton.refreshExplore = "no"
        singelton.isNavigateMapScreenAfterSearch = false
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placeMarks, error) in
            if error == nil {
                if (placeMarks?.count)! > 0 {
                    let pm = placeMarks![0] as! CLPlacemark
                  
                    var thoroughfare:String = ""
                    var subLocality:String = ""
                    var strConCat:String = ""
                    
                    if pm.thoroughfare != nil {thoroughfare = pm.thoroughfare!}
                    if pm.subLocality != nil {subLocality = pm.subLocality!}

                    
                    let strLocality = pm.locality
                    let strState = pm.administrativeArea
                   // let strPin = pm.postalCode
                    
                   // let strConCat = strLocality!  + "," + " " + strState! + " (" + (strPin!) + ")"
                     if self.isFirstTime{
                    // let strConCat = strLocality!  + "," + " " + strState!
                        if thoroughfare.characters.count > 0 || subLocality.characters.count > 0{
                            strConCat =  thoroughfare + " " + subLocality
                        }
                        else{
                            strConCat = strLocality!  + " "  + strState!
                        }
                    //  print("location is",strConCat)
                //    self.textFieldLocationSearch.text = strConCat //pm.locality
                          self.textFieldLocationSearch.text = "Current Location"
                        if (self.textFieldLocationSearch.text?.characters.count)! > 0 {
                            self.cancelBtn.isHidden = false
                        }
                        else{
                            self.cancelBtn.isHidden = true
                        }

                    self.latValue = (self.locationManager?.location?.coordinate.latitude)!
                    self.longValue = (self.locationManager?.location?.coordinate.longitude)!
                    let singelton = SharedManager.sharedInstance
                    singelton.latValueInitial = self.latValue
                    singelton.longValueInitial = self.longValue
                      //  print("lat is ",singelton.latValueInitial)
                      //  print("long is",singelton.longValueInitial)
                    self.locationManager?.stopUpdatingLocation()
                   
                   
                         self.setupView()
                        self.isFirstTime = false
                    }
                   
                    //  print(self.latValue,self.longValue)
                }
            }
        }
        
        
    }
    // Populate the address form fields.
    func fillAddressForm() {
       
        street_number = ""
        route = ""
        neighborhood = ""
       // locality = ""
        administrative_area_level_1  = ""
        country = ""
        postal_code = ""
        postal_code_suffix = ""
         let singelton = SharedManager.sharedInstance
        self.textFieldLocationSearch.text = singelton.exploreCityFormattedAddress
        singelton.checkScreen = 10
        self.setupView()


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
                    
                    var adressString : String = ""
                    adressString = self.locality
                    if place.administrativeArea != nil {
                        adressString = adressString +  ", " + place.administrativeArea!
                    }
                  //  print(adressString)
                  /*  if place.postalCode != nil {
                        adressString = adressString + " (" + place.postalCode! + ")"
                    //    print(adressString)
                    }
                  */
                    let singelton = SharedManager.sharedInstance
                    singelton.exploreCityFormattedAddress = adressString
                    singelton.isExploreCitySearch = true
                    singelton.checkScreen = 10
                }
                
              
                self.fillAddressForm()
            }
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



extension ExploreTabViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        //        print("Place name: \(place.name)")
               print("Place address: \(place.formattedAddress)")
               print("Place attributions: \(place.attributions)")
        
        // Get the address components.
       
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
        
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeSublocalityLevel1:
                    sublocalityLevel1 = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    country = field.name
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                // Print the items we aren't using.
                
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        var truncatedString:String = ""
        if street_number.characters.count > 0{
            //print(completeString)
            if street_number.characters.count <= 32{
                truncatedString = street_number + " "
            }
            else{
                truncatedString = ""
            }
           
        }
        if route.characters.count > 0{
            //  print(completeString)
            
            if truncatedString.characters.count + route.characters.count <= 32{
                truncatedString = truncatedString  + route + " "
            }
            else{
                neighborhood = ""
            }
            
        }
        if neighborhood.characters.count > 0{
            //   print(completeString)
            if truncatedString.characters.count + neighborhood.characters.count <= 32{
                truncatedString = truncatedString  + neighborhood + " "
            }
            else{
                sublocalityLevel1 = ""
            }
            
        }
        if sublocalityLevel1.characters.count > 0{
            
            if truncatedString.characters.count + sublocalityLevel1.characters.count <= 32{
                truncatedString = truncatedString  + sublocalityLevel1 + " "
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
//                else{
//                    country = ""
//                }
            }
            
            
        }
//        if country.characters.count > 0{
//            
//            if truncatedString.characters.count + country.characters.count <= 35{
//                truncatedString = truncatedString +  country
//            }
//            else{
//                
//            }
//            
//        }


       
        // Call custom function to populate the address form.
        let singelton = SharedManager.sharedInstance
        
         singelton.latValueExploreCity = place.coordinate.latitude
         singelton.longValueExploreCity = place.coordinate.longitude
       // var completeString:String = ""
      //  print(street_number)

      //  print(neighborhood)
      //   print(route)
      //  print(locality)
      /*  if street_number.characters.count > 0{
             //print(completeString)
           completeString  = street_number
        }
        if route.characters.count > 0{
           //  print(completeString)
            
            completeString = completeString + " " + route
           
        }
        if neighborhood.characters.count > 0{
           //   print(completeString)
            completeString = completeString + " " + neighborhood
           
        }
        if locality.characters.count > 0{
           
          completeString = completeString + " " + locality
            
        }
        if administrative_area_level_1.characters.count > 0{
           
            if administrative_area_level_1.localizedCaseInsensitiveContains(locality){
                
            }
            else{
                 completeString = completeString + " " + administrative_area_level_1
            }
    
            
        }
        if country.characters.count > 0{
        
            completeString = completeString + " " + country
            
        }
 */
       // print("text",completeString)
        // singelton.exploreCityFormattedAddress = completeString
         singelton.exploreCityFormattedAddress = truncatedString
         isCity = true
         singelton.isExploreCitySearch = false
         singelton.isNavigateMapScreenAfterSearch = false
         singelton.isUserCurrentLocation = false // code added
       /*  singelton.isExploreCitySearch = true
         singelton.checkScreen = 10
         let cityCoords = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
         self.getAdressName(coords: cityCoords)
*/
        
        // Close the autocomplete widget.
        street_number = ""
        route = ""
        neighborhood = ""
        locality = ""
        sublocalityLevel1 = ""
        administrative_area_level_1  = ""
        country = ""
        postal_code = ""
        postal_code_suffix = ""
         self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
         isShowCurrentLocation = false
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
