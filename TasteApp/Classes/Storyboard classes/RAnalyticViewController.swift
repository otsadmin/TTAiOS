//
//  RAnalyticViewController.swift
//  Taste
//
//  Created by Ranjit Singh on 27/09/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CoreLocation
import PieCharts

class RPieChartCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var chartView: PieChart!
    
    //  @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var topCuisinesLbl: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    
    
    
    
    // color view
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    
    // text Label
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    // button Wrapper on view and label
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
}
class PieChartViewCell:UITableViewCell{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblRecentTaste: UILabel!
    @IBOutlet weak var btnDiningHistory: UIButton!
}

class RAnalyticViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, PieChartDelegate {
    
    // TODO: OBJECT DECLARATION FOR THIS CLASS
    
    var constantValue = 1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BellBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var addAccountBtn: UIButton!
    
    // for button click
    
    var cuisinePercentageValue:NSArray = NSArray()
    var cityPercentageValue:NSArray = NSArray()
    var cuisineNameValue:NSArray = NSArray()
    var cityNameValue:NSArray = NSArray()
    
    
    var arrNotification =  [[String:Any]]()
    var pageNo = 1
    var cuisineArray = [ProfileCuisineFilter]()
    var graphDataDict = [String:Any]()
    
    
    // copy all variable
    
    var indexPathForisibleCell = IndexPath()
    var pieChartCell = PieChartViewCell()
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tableView.isHidden = true
        //24 Oct
        //        self.pageControl.isHidden = true
        //        self.lblRecentTaste.isHidden = true
        //        self.collectionView.isHidden = true
        
        
        //        self.infoLbl.isHidden = true
        //        self.mapBtn.isUserInteractionEnabled = true
        //        self.addAccountBtn.isHidden = true
        //        self.mapBtn.isHidden = false
        
        
        
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
        
        
        
        self.getGraphData()
        SVProgressHUD.show()
        self.NotificationMethod()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() == true
        {
            self.perform(#selector(NotificationMethod))
            NotificationCenter.default.addObserver(self, selector: #selector(RAnalyticViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
            
            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            app.checkForNotification = "RAnalyticViewController"

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

    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        self.NotificationMethod()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //24 Oct
        
        //        self.pageControl.isHidden = false
        //        self.lblRecentTaste.isHidden = false
        
    }
   
    // MARK: SET ALL THE USER INTERFACE VIEW
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
                    SVProgressHUD.dismiss()
                    self.cuisines = cuisineArr
                    
                }
                    
                else
                {
                    
                    SVProgressHUD.dismiss()
                    //                    let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
                    //                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    //                        UIAlertAction in
                    //                        // NSLog("OK Pressed")
                    //                    }
                    //                    alert.addAction(okAction)
                    //                    self.present(alert, animated: true, completion: nil)
                    //                    return
                    
                }
                
                if let citiesArr = dataDic["cities"] as? [[String:Any]] {
                    self.cities = citiesArr
                }
                
                
                
                // self.loadData()
            }
            else{
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

        }
        self.getRecentTaste()
    }
    
    
    // TODO:COLLECTION VIEW DATA SOURCE METHODS
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 2
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RPieChartCollectionViewCell", for: indexPath) as! RPieChartCollectionViewCell
        
        cell.viewAllButton.tag = indexPath.row
        cell.viewAllButton.addTarget(self, action:#selector(viewAllButtonPressed(_:)), for: .touchUpInside)
        
        cell.button1.tag = indexPath.row
        cell.button1.addTarget(self, action:#selector(view1ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button2.tag = indexPath.row
        cell.button2.addTarget(self, action:#selector(view2ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button3.tag = indexPath.row
        cell.button3.addTarget(self, action:#selector(view3ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button4.tag = indexPath.row
        cell.button4.addTarget(self, action:#selector(view4ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button5.tag = indexPath.row
        cell.button5.addTarget(self, action:#selector(view5ButtonPressed(_:)), for: .touchUpInside)
        
        cell.button6.tag = indexPath.row
        cell.button6.addTarget(self, action:#selector(view6ButtonPressed(_:)), for: .touchUpInside)
        
        cell.frame.size.width = UIScreen.main.bounds.width-50
        // auto shrink label
        
        print(graphDataDict)
        if indexPath.item == 0 {
            
            cell.topCuisinesLbl.text = "Top Cuisines"
            
            if let cuisineValue:NSArray = graphDataDict["cuisines"] as? NSArray{
                print(cuisineValue)
                cuisinePercentageValue = cuisineValue.value(forKey: "percentage") as! NSArray
                cuisineNameValue = cuisineValue.value(forKey: "_id") as! NSArray
                
                cell.chartView.layers = [createCustomViewsLayer(), createTextLayer()]
                cell.chartView.delegate = self
                cell.chartView.models = self.createModels(nameArr:cuisineNameValue,percentageArr:cuisinePercentageValue)
                
                if cuisinePercentageValue.count == 0 {
                    
                    cell.view1.isHidden = true
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = true
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = true
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                }
                else if cuisinePercentageValue.count == 1 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                }
                else if cuisinePercentageValue.count == 2 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                }
                else if cuisinePercentageValue.count == 3 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                }
                else if cuisinePercentageValue.count == 4 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                    cell.label4.text = cuisineNameValue[3] as? String
                }
                else if cuisinePercentageValue.count == 5 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                    cell.label4.text = cuisineNameValue[3] as? String
                    cell.label5.text = cuisineNameValue[4] as? String
                }
                else if cuisinePercentageValue.count == 6 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = false
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = false
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = false
                    
                    cell.label1.text = cuisineNameValue[0] as? String
                    cell.label2.text = cuisineNameValue[1] as? String
                    cell.label3.text = cuisineNameValue[2] as? String
                    cell.label4.text = cuisineNameValue[3] as? String
                    cell.label5.text = cuisineNameValue[4] as? String
                    cell.label6.text = cuisineNameValue[5] as? String
                }
                
            }
            return cell
        }
        else{
            
            cell.topCuisinesLbl.text = "Top Cities"
            if let cuisineValue:NSArray = graphDataDict["cities"] as? NSArray{
                print(cuisineValue)
                cityPercentageValue = cuisineValue.value(forKey: "percentage") as! NSArray
                cityNameValue = cuisineValue.value(forKey: "_id") as! NSArray
                
                cell.chartView.layers = [createCustomViewsLayer(), createTextLayer()]
                cell.chartView.delegate = self
                cell.chartView.models = self.createModels(nameArr:cityNameValue,percentageArr:cityPercentageValue)
                
                if cityPercentageValue.count == 0 {
                    
                    cell.view1.isHidden = true
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = true
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = true
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                }
                else if cityPercentageValue.count == 1 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = true
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = true
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = true
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                }
                else if cityPercentageValue.count == 2 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = true
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = true
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = true
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                }
                else if cityPercentageValue.count == 3 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = true
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = true
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = true
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                }
                else if cityPercentageValue.count == 4 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = true
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = true
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = true
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                    cell.label4.text = cityNameValue[3] as? String
                }
                else if cityPercentageValue.count == 5 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = true
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = true
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = true
                    
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                    cell.label4.text = cityNameValue[3] as? String
                    cell.label5.text = cityNameValue[4] as? String
                }
                else if cityPercentageValue.count == 6 {
                    
                    cell.view1.isHidden = false
                    cell.view2.isHidden = false
                    cell.view3.isHidden = false
                    cell.view4.isHidden = false
                    cell.view5.isHidden = false
                    cell.view6.isHidden = false
                    
                    cell.label1.isHidden = false
                    cell.label2.isHidden = false
                    cell.label3.isHidden = false
                    cell.label4.isHidden = false
                    cell.label5.isHidden = false
                    cell.label6.isHidden = false
                    
                    cell.button1.isHidden = false
                    cell.button2.isHidden = false
                    cell.button3.isHidden = false
                    cell.button4.isHidden = false
                    cell.button5.isHidden = false
                    cell.button6.isHidden = false
                    
                    //cell.label1.text = "Middle Eastern/Mediterranean"
                    cell.label1.text = cityNameValue[0] as? String
                    cell.label2.text = cityNameValue[1] as? String
                    cell.label3.text = cityNameValue[2] as? String
                    cell.label4.text = cityNameValue[3] as? String
                    cell.label5.text = cityNameValue[4] as? String
                    cell.label6.text = cityNameValue[5] as? String
                }
                
                
            }
            return cell
        }
        
        
        
        // order is important - models have to be set at the end
        
        
        
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RPieChartCollectionViewCell", for: indexPath) as! RPieChartCollectionViewCell
        //        cell.viewAllButton.tag = indexPath.row
        //        cell.viewAllButton.addTarget(self, action:#selector(viewAllButtonPressed(_:)), for: .touchUpInside)
        //
        //        if indexPath.item == 0 {
        //            cell.topCuisinesLbl.text = "Top Cuisines"
        //
        //            if let cuisineValue:NSArray = graphDataDict["cuisines"] as? NSArray{
        //                let percentageValue:NSArray = cuisineValue.value(forKey: "percentage") as! NSArray
        //                let nameValue:NSArray = cuisineValue.value(forKey: "_id") as! NSArray
        //                if percentageValue.count == 1{
        //                    cell.pieChartView?.segments = [
        //
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 2{
        //                    cell.pieChartView?.segments = [
        //
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 3{
        //                    cell.pieChartView?.segments = [
        //
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 4{
        //                    cell.pieChartView?.segments = [
        //
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                        Segment(color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0), name: nameValue[3] as! String, value: percentageValue[3] as! CGFloat ),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 5{
        //                    cell.pieChartView?.segments = [
        //
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                        Segment(color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0), name: nameValue[3] as! String, value: percentageValue[3] as! CGFloat ),
        //                        Segment(color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0), name: nameValue[4] as! String, value: percentageValue[4] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //
        //
        //                }
        //                else if percentageValue.count == 6{
        //
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                        Segment(color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0), name: nameValue[3] as! String, value: percentageValue[3] as! CGFloat ),
        //                        Segment(color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0), name: nameValue[4] as! String, value: percentageValue[4] as! CGFloat),
        //                        Segment(color: UIColor(red: 101.0/255.0, green: 137.0/255.0, blue: 159.0/255.0, alpha: 1.0), name: nameValue[5] as! String, value: percentageValue[5] as! CGFloat)
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //
        //
        //                }
        //
        //            }
        //            else{
        //                cell.pieChartView?.segments = [
        //
        //                    Segment(color: UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0), name: "No Record" , value: 100.0 )
        //                ]
        //                cell.viewAllButton.isUserInteractionEnabled = false
        //            }
        //        }
        //        else{
        //            cell.topCuisinesLbl.text = "Top Cities"
        //            if let cuisineValue:NSArray = graphDataDict["cities"] as? NSArray{
        //                let percentageValue:NSArray = cuisineValue.value(forKey: "percentage") as! NSArray
        //                let nameValue:NSArray = cuisineValue.value(forKey: "_id") as! NSArray
        //
        //                if percentageValue.count == 1{
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 2{
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 3{
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 4{
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                        Segment(color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0), name: nameValue[3] as! String, value: percentageValue[3] as! CGFloat ),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 5{
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                        Segment(color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0), name: nameValue[3] as! String, value: percentageValue[3] as! CGFloat ),
        //                        Segment(color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0), name: nameValue[4] as! String, value: percentageValue[4] as! CGFloat),
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //                else if percentageValue.count == 6{
        //                    cell.pieChartView?.segments = [
        //                        Segment(color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0), name:nameValue[0] as! String, value:percentageValue[0] as! CGFloat),
        //                        Segment(color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0), name: nameValue[1] as! String, value: percentageValue[1] as! CGFloat),
        //                        Segment(color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0), name: nameValue[2] as! String, value: percentageValue[2] as! CGFloat),
        //                        Segment(color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0), name: nameValue[3] as! String, value: percentageValue[3] as! CGFloat ),
        //                        Segment(color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0), name: nameValue[4] as! String, value: percentageValue[4] as! CGFloat),
        //                        Segment(color: UIColor(red: 101.0/255.0, green: 137.0/255.0, blue: 159.0/255.0, alpha: 1.0), name: nameValue[5] as! String, value: percentageValue[5] as! CGFloat)
        //                    ]
        //                    cell.viewAllButton.isUserInteractionEnabled = true
        //                }
        //
        //            }
        //            else{
        //                cell.pieChartView?.segments = [
        //
        //                    Segment(color: UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0), name: "No Record" , value: 100.0 )
        //                ]
        //                cell.viewAllButton.isUserInteractionEnabled = false
        //            }
        //        }
        //        cell.pieChartView.segmentLabelFont = UIFont.boldSystemFont(ofSize: 10)
        //        cell.pieChartView.showSegmentValueInLabel = true
        //
        //        return cell
    }
    
    
    
    
    //TODO: TABLE VIEW DATA SOURCE METHODS
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.cuisineArray.count+1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row == 0 {
            pieChartCell = tableView.dequeueReusableCell(withIdentifier: "PieChartViewCell", for: indexPath) as! PieChartViewCell
            pieChartCell.btnDiningHistory.addTarget(self, action:#selector(goToDiningHistory(_:)), for: .touchUpInside)

            if constantValue == 1 {
                pieChartCell.collectionView.reloadData()
            }
            
            
            pieChartCell.selectionStyle = .none
            
            return pieChartCell
        }
        else{
            constantValue = 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "RRecentTasteTableViewCell", for: indexPath) as! RRecentTasteTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            
            let images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04","dummy-img01"]
            
            var cuisineDetail = ProfileCuisineFilter()
            cuisineDetail = cuisineArray[indexPath.row-1]
            cell.myImageView.sd_setImage(with: URL(string: cuisineDetail.photo_ref), placeholderImage: UIImage(named: "rest_defoutImage"))
            cell.myImageView.contentMode = UIViewContentMode.scaleAspectFill
            cell.myImageView.layer.cornerRadius = 5.0
            // cell.myImageView.clipsToBounds = true
            cell.myImageView.layer.masksToBounds = true
            
            //overlay view
            cell.overlayView.backgroundColor = UIColor.black
            cell.overlayView.alpha = 0.50
            cell.overlayView.layer.cornerRadius = 5.0
            cell.overlayView.layer.masksToBounds = true
            
            // restraunt text
            cell.lblrestraunt.numberOfLines = 1
            cell.lblrestraunt.adjustsFontSizeToFitWidth = true
            cell.lblrestraunt.minimumScaleFactor = 0.2
            cell.lblrestraunt.font = UIFont(name:K_Font_Color_Regular,size:24)
            cell.lblrestraunt.textColor = UIColor.white
            
            cell.lblrestraunt.text = self.cuisinesFilter[indexPath.row-1]["name"] as? String
            
            
            // cuisine text
            cell.lblMiles.numberOfLines = 1
            cell.lblMiles.adjustsFontSizeToFitWidth = true
            cell.lblMiles.minimumScaleFactor = 0.2
            cell.lblMiles.font = UIFont(name:K_Font_Color,size:18)
            cell.lblMiles.textColor = UIColor.white
            let dataArr = self.cuisinesFilter[indexPath.row-1]["cuisine"] as? NSArray
            if dataArr?.count != 0{
                cell.lblMiles.text = dataArr?[0] as? String
            }
            else{
                cell.lblMiles.text = ""
            }
            
            
            
            cell.lblCuisineName.textColor = UIColor.white
            cell.lblCuisineName.font = UIFont(name:K_Font_Color,size:18)
            var coordinate : [String:Any]?
            coordinate = self.cuisinesFilter[indexPath.row-1]["coordinates"] as? [String:Any]
            
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
    }
    func goToDiningHistory(_ sender: UIButton){
        
        let vc = DiningHistoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 294.0
        }
        else{
            return 120.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0{
            return
        }
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
        cuisineDetail = cuisineArray[indexPath.row-1]
        K_INNERUSER_DATA.Photo_Ref = cuisineDetail.photo_ref
        
        K_INNERUSER_DATA.placeId = cuisineDetail.Placeid
        
        let latNavigate =  annotationArray  [indexPath.row-1] ["latvalue"] as! Double
        K_INNERUSER_DATA.latvalueNavigate = latNavigate
        let longNavigate =  annotationArray  [indexPath.row-1] ["longvalue"] as! Double
        K_INNERUSER_DATA.longvalueNavigate = longNavigate
        
        //            let Place_Id = (self.PlaceIdArray[indexPath.row] ["placeid"] as! String)
        //  print(indexPath.row)
        let location : [String:Any]?
        
        location = self.cuisinesFilter[indexPath.row-1]["location"] as? [String:Any]
        
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
        
        if let locTel = self.cuisinesFilter[indexPath.row-1]["tel"] as? String{
            K_INNERUSER_DATA.Phone = locTel
        }
        else{
            K_INNERUSER_DATA.Phone=""
        }
        if let locWebsite = self.cuisinesFilter[indexPath.row-1]["website"] as? String
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
        
        if let price = self.cuisinesFilter[indexPath.row-1]["price"] as? NSNumber
        {
            K_INNERUSER_DATA.Price = String(format:"%@",price)
        }
        
        if let rating = self.cuisinesFilter[indexPath.row-1]["rating"] as? NSNumber
        {
            
            K_INNERUSER_DATA.Rating = String(format:"%@",rating)
        }
        
        // K_INNERUSER_DATA.CuisineName = (self.cuisinesFilter[indexPath.row]["name"] as? String)!
        
        if let factual_id = self.cuisinesFilter[indexPath.row-1]["factual_id"] as? String{
            K_INNERUSER_DATA.FactualId = factual_id
        }
        else{
            K_INNERUSER_DATA.FactualId = ""
        }
        
        if let restName  = self.cuisinesFilter[indexPath.row-1]["name"] as? String
        {
            K_INNERUSER_DATA.RestaurantName = restName
        }
        else{
            K_INNERUSER_DATA.RestaurantName  = ""
        }
        if let hours =  self.cuisinesFilter[indexPath.row-1]["hours_display"] as? String{
            K_INNERUSER_DATA.Hours = hours
        }
        else{
            K_INNERUSER_DATA.Hours = ""
        }
        if let Cuisinname = annotationArray [indexPath.row-1] ["GetCuisine"] {
            K_INNERUSER_DATA.CuisinSeleted = Cuisinname as! String
        }else{
            K_INNERUSER_DATA.CuisinSeleted = ""
        }
        
        print( self.cuisinesFilter[indexPath.row-1])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleUserViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    // TODO: METHODS FOR PAGE CONTROLS
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = pieChartCell.collectionView.frame.size.width
        pieChartCell.pageControl.currentPage = Int(pieChartCell.collectionView.contentOffset.x / pageWidth)
        pieChartCell.pageControl.updateCurrentPageDisplay()
        
        // change the header label
        //        var visibleRect = CGRect()
        //        visibleRect.origin = collectionView.contentOffset
        //        visibleRect.size = collectionView.bounds.size
        //        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        //        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        //        print(visibleIndexPath[1])
        //        if visibleIndexPath[1] == 0 {
        //            topCuisinesLbl.text = "Top Cuisines"
        //        }
        //        else{
        //            topCuisinesLbl.text = "Top Cities"
        //        }
    }
    
    @IBAction func backBUttonPressed(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bellIconHasPressed(_ sender: Any) {
        let vc = NotificatioinsViewController() as NotificatioinsViewController
       // vc.RecvarrNotification = self.arrNotification
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // TODO: GET NOTIFICATION DATA
    
    func NotificationMethod() {
        
        // SVProgressHUD.show()
        
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
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.notificationbutton()
                }
            }
            else{
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
                }
           
            
        }
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
    }
    
    // MARK: BUTTON ACTION FOR A PARTICULAR CUISINE/CITY DETAILS
    
    func view1ButtonPressed(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
        //        vc.arrNotification = self.arrNotification
        //        if sender.tag == 0{
        //            vc.screenName = "cuisines"
        //        }
        //        else{
        //            vc.screenName = "cities"
        //        }
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[0] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[0] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    func view2ButtonPressed(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
        //        vc.arrNotification = self.arrNotification
        //        if sender.tag == 0{
        //            vc.screenName = "cuisines"
        //        }
        //        else{
        //            vc.screenName = "cities"
        //        }
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[1] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[1] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view3ButtonPressed(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
        //        vc.arrNotification = self.arrNotification
        //        if sender.tag == 0{
        //            vc.screenName = "cuisines"
        //        }
        //        else{
        //            vc.screenName = "cities"
        //        }
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[2] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[2] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view4ButtonPressed(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
        //        vc.arrNotification = self.arrNotification
        //        if sender.tag == 0{
        //            vc.screenName = "cuisines"
        //        }
        //        else{
        //            vc.screenName = "cities"
        //        }
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[3] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[3] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func view5ButtonPressed(_ sender: UIButton) {
        //
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
        //        vc.arrNotification = self.arrNotification
        //        if sender.tag == 0{
        //            vc.screenName = "cuisines"
        //        }
        //        else{
        //            vc.screenName = "cities"
        //        }
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            vc.cuisineName = cuisineNameValue[4] as! String
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            vc.cuisineName = cityNameValue[4] as! String
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    func view6ButtonPressed(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
        //        vc.arrNotification = self.arrNotification
        //        if sender.tag == 0{
        //            vc.screenName = "cuisines"
        //        }
        //        else{
        //            vc.screenName = "cities"
        //        }
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if sender.tag == 0{
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            //vc.cuisineName = cuisineNameValue[5] as! String
            vc.cuisineName = "others"
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            //  vc.cuisineName = cityNameValue[5] as! String
            vc.cuisineName = "others"
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func viewAllButtonPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RViewAllVc") as! RViewAllVc
        vc.arrNotification = self.arrNotification
        if sender.tag == 0{
            vc.screenName = "cuisines"
        }
        else{
            vc.screenName = "cities"
        }
        let singelton = SharedManager.sharedInstance
        vc.providedId = singelton.loginId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //TODO: GET RECENT TASTES
    
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
                        self.tableView.isHidden = false
                        self.infoLbl.isHidden = true
                        self.addAccountBtn.isHidden = true
                        self.mapBtn.isUserInteractionEnabled = true
                        self.mapBtn.isHidden = false
                        
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
                    else{
                        
                        if self.cuisineArray.count != 0 {
                            self.infoLbl.isHidden = true
                            self.addAccountBtn.isHidden = true
                            self.mapBtn.isUserInteractionEnabled = true
                            self.mapBtn.isHidden = false
                            self.tableView.isHidden = false
                        }
                        else{
                            self.infoLbl.isHidden = false
                            self.mapBtn.isUserInteractionEnabled = false
                            self.addAccountBtn.isHidden = false
                            self.mapBtn.isHidden = true
                            self.tableView.isHidden = true
                        }
                    }
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
        
        
        
//        let indexToScrollTo = IndexPath(item: 0, section: 0)
//        pieChartCell.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
        
//        let  ijk  = pieChartCell.collectionView.indexPathsForVisibleItems
//        if ijk.count == 1{
//            
//            if ijk[0][1] == 1 {
//                let indexPath = IndexPath(item: 1, section: 0)
//                tableView.reloadRows(at: [indexPath], with: .top)
//            }
//            print(ijk)
//        }

        // print("indexpath for the last call is \(indexPath.row)")
        
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
                        cuisineDetail.photo_ref = ""
                        self.selectedProfileIndex += 1
                        self.countGoogleApiHit(index: self.selectedProfileIndex)
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        })
        SVProgressHUD.dismiss()
    }
    
    //TODO: GET GRAPH DATA
    
    func getGraphData() -> Void {
        if Reachability.isConnectedToNetwork() == true{
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            
            //please give suggestion here for entry cuisine 0r city
            
            let parameter = [ "user_id":singelton.loginId] as [String : Any]
            
            DataManager.sharedManager.getGraphData(params: parameter, completion: { (response) in
                if let dataDic = response as? [String :Any]
                {
                    self.view.isUserInteractionEnabled = true
                    print("the graph data is \(dataDic)")
                    self.graphDataDict = dataDic
                    self.setupView()
                }else{
                    
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
            }
            )}
        else{
            pieChartCell.collectionView.isHidden = false
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
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RDiningProfileMapVc") as! RDiningProfileMapVc
            vc.titleStr = "PROFILE"
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
    
    @IBAction func addAcountBtnPressed(_ sender: UIButton) {
        
        let vc = BanksListViewController()
        vc.screenName = "bankaccount"
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
        let  arrayOfVisibleCell  = pieChartCell.collectionView.indexPathsForVisibleItems
        print(arrayOfVisibleCell[0][1])
        
        if arrayOfVisibleCell[0][1] == 0{
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! ProfileCuisineFilterViewController
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            // pas data to fetch data
            
            if slice.data.id  != 5{
                vc.cuisineName = cuisineNameValue[slice.data.id] as! String
            }
            else{
                vc.cuisineName = "others"
            }
            
            vc.filterName = "cuisines"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cuisines"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "RPieChartsClickDataVc") as! RPieChartsClickDataVc
            
            let vc = ProfileCuisineFilterViewController()
            vc.arrNotification = self.arrNotification
            
            // pas data to fetch data
            
            if slice.data.id  != 5{
                vc.cuisineName = cityNameValue[slice.data.id] as! String
            }
            else{
                vc.cuisineName = "others"
            }
            vc.filterName = "cities"
            let singelton = SharedManager.sharedInstance
            vc.cuisineProfileId = singelton.loginId
            vc.screenName = "cities"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "RViewAllVc") as! RViewAllVc
        //        vc.arrNotification = self.arrNotification
        //            vc.screenName = "cuisines"
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        //
        //        print()
        //        let alert = UIAlertController(title: "selected Index is", message:"\(slice.data.id)", preferredStyle: UIAlertControllerStyle.alert)
        //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //            UIAlertAction in
        //            NSLog("OK Pressed")
        //        }
        //        alert.addAction(okAction)
        //        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Models
    
    fileprivate func createModels(nameArr:NSArray,percentageArr:NSArray) -> [PieSliceModel] {
        if percentageArr.count == 1{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 2{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 3{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 4{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[3] as! Double, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
                
            ]
        }
        else if percentageArr.count == 5{
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[3] as! Double, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[4] as! Double, color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0)),
            ]
        }
        else if percentageArr.count == 6{
            
            return [
                PieSliceModel(value: percentageArr[0] as! Double, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[1] as! Double, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[2] as! Double, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[3] as! Double, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[4] as! Double, color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0)),
                PieSliceModel(value: percentageArr[5] as! Double, color: UIColor(red: 101.0/255.0, green: 137.0/255.0, blue: 159.0/255.0, alpha: 1.0)),
            ]
        }
        else{
            return [
                PieSliceModel(value: 0, color: UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)),
            ]
            
            
        }
        //        return [
        //            PieSliceModel(value: 0.5, color: UIColor(red: 111.0/255.0, green: 153.0/255.0, blue: 199.0/255.0, alpha: 1.0)),
        //            PieSliceModel(value: 9.5, color: UIColor(red:99.0/255.0, green: 128.0/255.0, blue: 171.0/255.0, alpha: 1.0)),
        //            PieSliceModel(value: 20, color: UIColor(red: 104.0/255.0, green: 155.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
        //            PieSliceModel(value: 10, color: UIColor(red: 142.0/255.0, green: 168.0/255.0, blue: 184.0/255.0, alpha: 1.0)),
        //            PieSliceModel(value: 30, color: UIColor(red: 127.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: 1.0)),
        //            PieSliceModel(value: 30, color: UIColor(red: 101.0/255.0, green: 137.0/255.0, blue: 159.0/255.0, alpha: 1.0)),
        //        ]
    }
    
    // MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 100
        settings.hideOnOverflow = true
        viewLayer.settings = settings
        
        // comment to stop the showing images
        
        //  viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 70
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            
            if slice.data.id == 3 || slice.data.id == 0 {
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                    specialTextLabel.text = "views"
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.text = "Custom"
                }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 10, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            }
            
            
            //  src of images: www.freepik.com, http://www.flaticon.com/authors/madebyoliver
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "fish"
                case 1: return "grapes"
                case 2: return "doughnut"
                case 3: return "water"
                case 4: return "chicken"
                case 5: return "beet"
                case 6: return "cheese"
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            
            return container
        }
    }
    
    
}


