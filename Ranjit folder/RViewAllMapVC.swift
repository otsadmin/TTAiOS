
//
//  RViewAllMapVC.swift
//  Taste
//
//  Created by Ranjit Singh on 05/10/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import SVProgressHUD


class RViewAllMapVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    // var mapView:GMSMapView!
    var titleStr:String = ""
    
    // variables for map view
    var screenName:String = ""
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
    var mapView:GMSMapView?
    var RestaurantResultArray = [[String:Any]]()
    
    @IBOutlet weak var mapWrapperView: UIView!
    @IBOutlet weak var screenTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenName == "cuisines"{
            self.screenTitle.text = "TOP CUISINES"
        }
        else if screenName == "cities" {
            self.screenTitle.text = "TOP CITIES"
        }
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapWrapperView.frame.size.width, height: self.mapWrapperView.frame.size.height), camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 13.0))
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        self.showPin()

    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        mapView?.delegate = nil
//        mapView?.removeFromSuperview()
//        mapView = nil
//        if mapWrapperView != nil{
//            mapWrapperView.removeFromSuperview()
//            mapWrapperView = nil
//        }
//        
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - SHOW PIN ON MAP

    func showPin()
    {
        SVProgressHUD.dismiss()
   //     var bounds = GMSCoordinateBounds()
        
        // commented the previous code
        
//        let sydney = GMSCameraPosition.camera(withLatitude: annotationArray  [0] ["latvalue"] as! Double,
//                                              longitude: annotationArray [0] ["longvalue"] as! Double,
//                                              zoom: 12)
      //  mapView?.camera = sydney
        
        
        for location in annotationArray {
            //  print("----",annotationArray);
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location["latvalue"] as! Double, longitude: location["longvalue"] as! Double)
//            bounds = bounds.includingCoordinate(marker.position)
//            let update = GMSCameraUpdate.fit(bounds, withPadding: 64)
            marker.title = location["nameValue"] as? String
            marker.snippet = location["cityValue"] as? String
            marker.icon = UIImage(named:"map-markar")!
            marker.map = self.mapView
//            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(50)) {
//                // Code
//                self.mapView?.animate(with: update)
//                self.view.isUserInteractionEnabled = true
//            }

        }
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        for var i in 0..<self.annotationArray.count  {
            
            if let name =  annotationArray  [i] ["nameValue"] as? String{
                if name == marker.title {
                    
                    /*
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
                     */
                    
                    
                    
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

    @IBAction func buildingBtnPressed(_ sender: Any) {
         _ =  self.navigationController?.popViewController(animated: false)
    }

}
