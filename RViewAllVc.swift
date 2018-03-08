//
//  RViewAllVc.swift
//  Taste
//
//  Created by Ranjit Singh on 29/09/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class RViewAllVc: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var pageNo = 1
    var cuisineArray = [ProfileCuisineFilter]()
    
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
    var c = 0.0,c1 = 0.0,c2 = 0.0
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
    var  isloading  = true
    var maxRow = 0
    var j = 0
    var GetCuisineName:String = ""
    var arrNotification =  [[String:Any]]()
    var screenName:String = ""

    
    @IBOutlet weak var rTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ranjit Singh")

        self.setupView()
    }
    
    //TODO:TABLE VIEW DATA SOURCE METHODS
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return self.cuisineArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RRecentTasteTableViewCell", for: indexPath) as! RRecentTasteTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        var images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04","dummy-img01"]
        
        var cuisineDetail = ProfileCuisineFilter()
        cuisineDetail = cuisineArray[indexPath.row]
        cell.myImageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
        cell.myImageView.contentMode = UIViewContentMode.scaleAspectFill
        cell.myImageView.layer.cornerRadius = 5.0
        cell.myImageView.clipsToBounds = true
        
        //overlay view
        cell.overlayView?.backgroundColor = UIColor.black
        cell.overlayView?.alpha = 0.50
        cell.overlayView?.layer.cornerRadius = 5
        
        // restraunt text
        cell.lblrestraunt.numberOfLines = 1
        cell.lblrestraunt.adjustsFontSizeToFitWidth = true
        cell.lblrestraunt.minimumScaleFactor = 0.2
        cell.lblrestraunt.font = UIFont(name:K_Font_Color,size:24)
        cell.lblrestraunt.textColor = UIColor.white
        
        cell.lblrestraunt.text = self.cuisinesFilter[indexPath.row]["name"] as? String
        
        
        // cuisine text
        cell.lblMiles.numberOfLines = 1
        cell.lblMiles.adjustsFontSizeToFitWidth = true
        cell.lblMiles.minimumScaleFactor = 0.2
        cell.lblMiles.font = UIFont(name:K_Font_Color,size:18)
        cell.lblMiles.textColor = UIColor.white
        if screenName == "cuisines"{
            if let cuisineArray = self.cuisinesFilter[indexPath.row]["cuisine"] as? NSArray{
                cell.lblMiles.text = cuisineArray[0] as? String
            }
            else{
                cell.lblMiles.text = ""
            }
        }
        else if screenName == "cities" {
            if let cuisineArray = self.cuisinesFilter[indexPath.row]["location"] as? NSDictionary{
                cell.lblMiles.text = cuisineArray.value(forKey: "city") as? String
            }
            else{
                cell.lblMiles.text = ""
            }
        }
        
        cell.lblCuisineName.textColor = UIColor.white
        cell.lblCuisineName.font = UIFont(name:K_Font_Color,size:18)
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
        
        
        cell.lblCuisineName.text = String(format:"%.1f", finaldist) + " Miles"
        
        //textLabel.text = "Jim's China"
        
        
        //for cuisine name
        
        
        return cell
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

    @IBAction func backBUttonPressed(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        SVProgressHUD.show()
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
                
                
                
                // self.loadData()
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
            
            let parameter = [ "user_id":singelton.loginId,"page":self.pageNo,"filter_by":screenName] as [String : Any]
            
            DataManager.sharedManager.getViewAll(params: parameter, completion: { (response) in
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
                    self.rTableView.reloadData()
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
        
        
        
        
        
          print("-------Print Request Url",UrlTrimString)
        
        DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
            if let dataDic = response as? [String:Any]
            {
                
                   print("Respomse", dataDic)
                
                //         for ResponseCount in responce{
                
                self.rTableView .reloadData()
                
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
                                    self.rTableView.reloadData()
                                }
                            }
                        }
                    }
                    else{
                        var content = Dictionary<String,Any>()
                        content.updateValue("Defoult", forKey: "Photo_Ref")
                        
                        self.PhotoRefArray.append(content)
                        cuisineDetail.photo_ref = ""
                        self.selectedProfileIndex += 1
                        self.countGoogleApiHit(index: self.selectedProfileIndex)
                        self.rTableView.reloadData()
                    }
                }
                
            }
            
        })
        SVProgressHUD.dismiss()
    }

    @IBAction func mapBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RViewAllMapVC") as! RViewAllMapVC
        vc.annotationArray = annotationArray
        vc.cuisineArray = cuisineArray
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func bellIconHasPressed(_ sender: Any) {
        let vc = NotificatioinsViewController() as NotificatioinsViewController
        vc.RecvarrNotification = self.arrNotification
        self.navigationController?.pushViewController(vc, animated: true)
    }
    



}
