//
//  ExploreFilterViewController.swift
//  Taste
//
//  Created by ASHISH PANT on 03/09/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD

class ExploreFilterViewController: UIViewController {
    var buttonCompanyClick = false
    var buttonInnerCircleClick = false
    var buttonRecentTasteClick = false
    var buttonSelectAllClick = false
    
    var priceLessfifteenClick = true
    var priceMorefifteenClick = true
    var priceLessFiftyClick = true
    var priceMoreFiftyClick = true
    var priceMoreSeventyClick = true
    
    
    var btnSelectAllClick:String = ""
    //for source
    var option:String = ""
    var optionCompany:String = ""
    var optionRecentTaste : String = ""
    var optionInnerCircle : String = ""
    var optionSelectAll : String = ""
    
    //for price
    var optionPrice :String = ""
    var optionLessfifteen :String = ""
    var optionMorefifteen : String = ""
    var optionLessFifty : String = ""
    var optionMoreFifty : String = ""
    var optionMoreSeventy : String = ""
    
    var optionCuisine :String = ""
    

    
   
    var cuisineListArray = [String]()
   
    
    //selected
    var sourceListSelectedArray = [String]()
    var cuisineListSelectedArray = [String]()
    var priceListSelectedArray = [String]()
    //not selected
    var sourceListNotSelectedArray = [String]()
    var cuisineListNotSelectedArray = [String]()
    var priceListNotSelectedArray = [String]()
    var cuisineSelectedArray = [ExploreFilter]()
    var j = 0
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cuisineView: UIView!
    
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var viewLine3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = false
        self.SourceNotSet()
        
        
    }
    func searchFilterLoad()  {
        
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            
            let parameters = ["user_id":singelton.loginId] as [String : Any]
           // print(parameters)
            DataManager.sharedManager.getSearchExploreList(params: parameters, completion: { (response) in
                // print(response)
                if let dataDic = response as? [String:Any]
                {
                    if let userSelected = dataDic["user_selected"] as? [String:Any]
                    {
                        
                        if let sourceArray = userSelected["source"] as? Array<Any>{
                            if sourceArray.count > 0{
                               // print(sourceArray)
                                self.sourceListSelectedArray = sourceArray as! [String]
                            }
                        }
                        if let priceArray = userSelected["price"] as? Array<Any>{
                            if priceArray.count > 0{
                                self.priceListSelectedArray = priceArray as! [String]
                            }
                        }
                        if let cuisinesSelected = userSelected["cuisine"] as? Array<Any>{
                            if cuisinesSelected.count > 0{
                              //  print("dic is ",cuisinesSelected.count)
                                while self.j < cuisinesSelected.count
                                {
                                    var cusineDetail : [String:Any]?
                                    cusineDetail  = cuisinesSelected[self.j] as? [String:Any]
                                    let cusineValue = ExploreFilter()

                                    if let cuisineName = cusineDetail?["name"] as? String{
                                      //  print("name",cuisineName)
                                        cusineValue.cuisineName = cuisineName
                                    }
                                    else{
                                        
                                    }
                                    if let cuisineSelected = cusineDetail?["is_selected"] as? Bool{
                                       // print("selected",cuisineSelected)
                                         cusineValue.selectedValue = cuisineSelected
                                    }
                                    else{
                                        
                                    }
                                    self.cuisineSelectedArray.append(cusineValue)
                                    self.j = self.j + 1

                                }
                                //self.cuisineListSelectedArray =  cuisinesSelectedArray as! [String]
                            }
                        }
                        
                    }
                    
                    if let userNotSelected = dataDic["default"] as? [String:Any]{
                        if let sourceArray = userNotSelected["source"] as? Array<Any>{
                            if sourceArray.count > 0{
                                self.sourceListNotSelectedArray = sourceArray as! [String]
                            }
                        }
                        if let priceArray = userNotSelected["price"] as? Array<Any>{
                            if priceArray.count > 0{
                                self.priceListNotSelectedArray = priceArray as! [String]
                            }
                        }
//                        if let cuisinesSelectedArray = userNotSelected["cuisine"] as? Array<Any>{
//                            if cuisinesSelectedArray.count > 0{
//                                self.cuisineListNotSelectedArray =  cuisinesSelectedArray as! [String]
//                            }
//                        }
                    }
                    
                    if (self.sourceListSelectedArray.count > 0) || (  self.priceListSelectedArray.count > 0) || ( self.cuisineSelectedArray.count > 0){
                        self.SourceSet()
                       
                    }
                    else{
                        self.defaultSourceSet()
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
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                }
                
            })
            
        }
        else
        {
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
    
    func createCuisineButton() {
        // var tag = 1
        var buttonX: CGFloat = 29
        var buttonY: CGFloat = 1
        let buttonWidth: CGFloat = 155
        let buttonheight: CGFloat = 52
        let constantSpace: CGFloat = 1
        let constantSpaceLine: CGFloat = 1
        // print(self.cuisineArray.count)
        for number in 0..<(self.cuisineSelectedArray.count) {
            
          
            let cusineButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonheight))
            
            if number % 2 == 0{
                buttonX = buttonWidth + 29 + constantSpace
                buttonY =  buttonY + 0
                
            }
            else{
                buttonX =  29
                buttonY = buttonY +  buttonheight + constantSpaceLine + 2
                
            }

            var cusineValue = ExploreFilter()
            cusineValue = self.cuisineSelectedArray[number]
           // print("value is-----",cusineValue.cuisineName,cusineValue.selectedValue)
            cusineButton.titleLabel?.font = UIFont(name: K_Font_Color_Light, size: 20)

            if cusineValue.selectedValue == false{
                cusineButton.backgroundColor = UIColor.white
                cusineButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else{
                
                cusineButton.backgroundColor = UIColor.black
                cusineButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            }
            
            cusineButton.titleLabel?.textAlignment = .center
            cusineButton.titleLabel?.minimumScaleFactor = 0.5
            cusineButton.titleLabel?.numberOfLines = 0
            cusineButton.titleLabel?.adjustsFontSizeToFitWidth = true
            cusineButton.setTitle((cusineValue.cuisineName)
               , for: UIControlState.normal)
            cusineButton.addTarget(self, action: #selector(self.cusineButtonPressed), for: .touchUpInside)
            cusineButton.tag = number
            //  print(number)
            cusineButton.isSelected = cusineValue.selectedValue
            self.cuisineView.addSubview(cusineButton)  // myView in this case is the view you want these
            self.cuisineView.frame.size.height = buttonY + 100.0
            if number % 2 == 0{
                
            }
            else{
                //  print("frame is ", self.viewLine3.frame.origin.y,self.cuisineView.frame.origin.y,self.cuisineView.frame.size.height)
                let label = UILabel(frame: CGRect(x: 30, y:  buttonY - 2, width: 320, height:  1 ))
                // print("ff",label.frame)
                label.backgroundColor = UIColor.lightGray
                label.textColor = UIColor.lightGray
                self.cuisineView.addSubview(label)
                
            }
            
        }
        
        self.scrollView.contentSize = CGSize(width: self.cuisineView.frame.size.width, height:self.viewPrice.frame.origin.y + self.cuisineView.frame.size.height + 250)
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
    }
    
    func cusineButtonPressed(sender:UIButton!) {
      //  print("tagvalue is",sender.tag)
        if sender.titleLabel?.text != nil {
            if sender.isSelected {
              //  sender.titleLabel?.font = UIFont(name: K_Font_Color_Light, size: 20)
                sender.setTitleColor(UIColor.black, for: UIControlState.normal)
                sender.backgroundColor = UIColor.white

                var cusineValue = ExploreFilter()
                cusineValue = self.cuisineSelectedArray[sender.tag]
                cusineValue.selectedValue = false
                sender.isSelected = cusineValue.selectedValue
            }
            else{
               // sender.titleLabel?.font = UIFont(name: K_Font_Color_Light, size: 20)

                sender.setTitleColor(UIColor.white, for: UIControlState.normal)
                sender.backgroundColor = UIColor.black
                var cusineValue = ExploreFilter()
                cusineValue = self.cuisineSelectedArray[sender.tag]
                cusineValue.selectedValue = true
                sender.isSelected = cusineValue.selectedValue
              
            }
            
        } else {
            
            // print("Nowhere to go :/")
            
        }
        
    }
    func SourceNotSet(){
        
        buttonCompany.backgroundColor = UIColor.white
        buttonCompany.setTitleColor(UIColor.black, for: UIControlState.normal)
        buttonCompanyClick = true
        
        buttonInnerCircle.backgroundColor = UIColor.white
        buttonInnerCircle.setTitleColor(UIColor.black, for: UIControlState.normal)
        buttonInnerCircleClick = true
        
        
        buttonRecentTaste.backgroundColor = UIColor.white
        buttonRecentTaste.setTitleColor(UIColor.black, for: UIControlState.normal)
        buttonRecentTasteClick = true
        
       // btnSelectAll.backgroundColor = UIColor.white
       // btnSelectAll.setTitleColor(UIColor.black, for: UIControlState.normal)
       // buttonSelectAllClick = true
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1500)
        self.searchFilterLoad()

    }
    func SourceSet() {
        //showing color for source
        for source in self.sourceListSelectedArray{
           // print(source)
            if source == "Company"{
                buttonCompany.backgroundColor = UIColor.black
                buttonCompany.setTitleColor(UIColor.white, for: UIControlState.normal)
                buttonCompanyClick = false
            }
            if source == "Inner Circle"{
                buttonInnerCircle.backgroundColor = UIColor.black
                buttonInnerCircle.setTitleColor(UIColor.white, for: UIControlState.normal)
                buttonInnerCircleClick = false
            }
            if source == "Recent Taste"{
                buttonRecentTaste.backgroundColor = UIColor.black
                buttonRecentTaste.setTitleColor(UIColor.white, for: UIControlState.normal)
                buttonRecentTasteClick = false
            }
            if source == "Select All"{
               // btnSelectAll.backgroundColor = UIColor.black
               // btnSelectAll.setTitleColor(UIColor.white, for: UIControlState.normal)
               // buttonSelectAllClick = false
            }
        }
        //showing color for price
        for price in self.priceListSelectedArray{
            if price == "P1"{
                buttonPriceOne.backgroundColor = UIColor.black
                buttonPriceOne.setTitleColor(UIColor.white, for: UIControlState.normal)
                priceLessfifteenClick = false
            }
            if price == "P2"{
                buttonPriceTwo.backgroundColor = UIColor.black
                buttonPriceTwo.setTitleColor(UIColor.white, for: UIControlState.normal)
                priceMorefifteenClick = false
            }
            if price == "P3"{
                buttonPriceThree.backgroundColor = UIColor.black
                buttonPriceThree.setTitleColor(UIColor.white, for: UIControlState.normal)
                priceLessFiftyClick = false
            }

            if price == "P4"{
                buttonPriceFour.backgroundColor = UIColor.black
                buttonPriceFour.setTitleColor(UIColor.white, for: UIControlState.normal)
                priceMoreFiftyClick = false
            }
            if price == "P5"{
                buttonPriceFive.backgroundColor = UIColor.black
                buttonPriceFive.setTitleColor(UIColor.white, for: UIControlState.normal)
                priceMoreSeventyClick = false
            }
        }
        self.createCuisineButton()
    }
    func defaultSourceSet() {
        
        buttonCompany.backgroundColor = UIColor.black
        buttonCompany.setTitleColor(UIColor.white, for: UIControlState.normal)
        buttonCompanyClick = false
        
        buttonInnerCircle.backgroundColor = UIColor.black
        buttonInnerCircle.setTitleColor(UIColor.white, for: UIControlState.normal)
        buttonInnerCircleClick = false
        
        buttonRecentTaste.backgroundColor = UIColor.black
        buttonRecentTaste.setTitleColor(UIColor.white, for: UIControlState.normal)
        buttonRecentTasteClick = false
        
       // btnSelectAll.backgroundColor = UIColor.black
       // btnSelectAll.setTitleColor(UIColor.white, for: UIControlState.normal)
       // buttonSelectAllClick = false
        
        self.createCuisineButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.createJsonFilter()
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var buttonCompany: UIButton!
    
    @IBOutlet weak var buttonInnerCircle: UIButton!
    
    
    @IBOutlet weak var buttonRecentTaste: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    
    @IBOutlet weak var buttonPriceOne: UIButton!
    
    @IBOutlet weak var buttonPriceTwo: UIButton!
    
    
    @IBOutlet weak var buttonPriceThree: UIButton!
    @IBOutlet weak var buttonPriceFour: UIButton!
    @IBOutlet weak var buttonPriceFive: UIButton!
    
    
    
    
    
    @IBAction func buttonCompanyTap(_ sender: Any)
    {
        
        if buttonCompanyClick
        {
            buttonCompany.backgroundColor = UIColor.black
            buttonCompany.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonCompanyClick = false
        }
        else
        {
            buttonCompany.backgroundColor = UIColor.white
            buttonCompany.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonCompanyClick = true
            
           // btnSelectAll.backgroundColor = UIColor.white
          //  btnSelectAll.setTitleColor(UIColor.black, for: UIControlState.normal)
           // buttonSelectAllClick = true
            
        }
        
        
    }
    
    
    @IBAction func buttonInnerCircleTap(_ sender: Any)
    {
        if buttonInnerCircleClick
        {
            buttonInnerCircle.backgroundColor = UIColor.black
            buttonInnerCircle.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonInnerCircleClick = false
        }
        else
        {
            buttonInnerCircle.backgroundColor = UIColor.white
            buttonInnerCircle.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonInnerCircleClick = true
            
           // btnSelectAll.backgroundColor = UIColor.white
            //btnSelectAll.setTitleColor(UIColor.black, for: UIControlState.normal)
           // buttonSelectAllClick = true
            
        }
        
        
    }
    
    
    @IBAction func buttonRecentTasteTap(_ sender: Any)
    {
        if buttonRecentTasteClick
        {
            buttonRecentTaste.backgroundColor = UIColor.black
            buttonRecentTaste.setTitleColor(UIColor.white, for: UIControlState.normal)
            buttonRecentTasteClick = false
        }
        else
        {
            buttonRecentTaste.backgroundColor = UIColor.white
            buttonRecentTaste.setTitleColor(UIColor.black, for: UIControlState.normal)
            buttonRecentTasteClick = true
           // btnSelectAll.backgroundColor = UIColor.white
           // btnSelectAll.setTitleColor(UIColor.black, for: UIControlState.normal)
           // buttonSelectAllClick = true
            
        }
        
        
        
    }
    
    @IBAction func btnSelectAllTap(_ sender: Any)
    {
        // self.defaultSourceSet()
        
    }
    
    @IBAction func buttonPriceOneTap(_ sender: Any)
    {
        
        if priceLessfifteenClick
        {
            buttonPriceOne.backgroundColor = UIColor.black
            buttonPriceOne.setTitleColor(UIColor.white, for: UIControlState.normal)
            priceLessfifteenClick = false
        }
        else
        {
            buttonPriceOne.backgroundColor = UIColor.white
            buttonPriceOne.setTitleColor(UIColor.black, for: UIControlState.normal)
            priceLessfifteenClick = true
        }
        
        
    }
    
    
    @IBAction func buttonPriceTwoTap(_ sender: Any)
    {
        if priceMorefifteenClick
        {
            buttonPriceTwo.backgroundColor = UIColor.black
            buttonPriceTwo.setTitleColor(UIColor.white, for: UIControlState.normal)
            priceMorefifteenClick = false
        }
        else
        {
            buttonPriceTwo.backgroundColor = UIColor.white
            buttonPriceTwo.setTitleColor(UIColor.black, for: UIControlState.normal)
            priceMorefifteenClick = true
        }
        
        
    }
    
    
    @IBAction func buttonPriceThreeTap(_ sender: Any)
    {
        if priceLessFiftyClick
        {
            buttonPriceThree.backgroundColor = UIColor.black
            buttonPriceThree.setTitleColor(UIColor.white, for: UIControlState.normal)
            priceLessFiftyClick = false
        }
        else
        {
            buttonPriceThree.backgroundColor = UIColor.white
            buttonPriceThree.setTitleColor(UIColor.black, for: UIControlState.normal)
            priceLessFiftyClick = true
        }
        
        
        
    }
    
    @IBAction func buttonPriceFourTap(_ sender: Any)
    {
        if priceMoreFiftyClick
        {
            buttonPriceFour.backgroundColor = UIColor.black
            buttonPriceFour.setTitleColor(UIColor.white, for: UIControlState.normal)
            priceMoreFiftyClick = false
        }
        else
        {
            buttonPriceFour.backgroundColor = UIColor.white
            buttonPriceFour.setTitleColor(UIColor.black, for: UIControlState.normal)
            priceMoreFiftyClick = true
        }
        
        
    }
    @IBAction func buttonPriceFiveTap(_ sender: Any)
    {
        if priceMoreSeventyClick
        {
            buttonPriceFive.backgroundColor = UIColor.black
            buttonPriceFive.setTitleColor(UIColor.white, for: UIControlState.normal)
            priceMoreSeventyClick = false
        }
        else
        {
            buttonPriceFive.backgroundColor = UIColor.white
            buttonPriceFive.setTitleColor(UIColor.black, for: UIControlState.normal)
            priceMoreSeventyClick = true
        }
        
        
    }
    func createJsonFilter()
    {
        if !buttonCompanyClick
        {
            optionCompany = "Company" + ","
        }
        else
        {
            optionCompany = ""
        }
        
        if !buttonInnerCircleClick
        {
            optionInnerCircle  = "Inner Circle" + ","
        }
        else
        {
            optionInnerCircle = ""
        }
        
        
        if !buttonRecentTasteClick
        {
            optionRecentTaste  = "Recent Taste" + ","
        }
        else
        {
            optionRecentTaste = ""
        }
//        if !buttonSelectAllClick
//        {
//            optionSelectAll  = "Company" + "," + "Inner Circle" + "," + "Recent Taste" + "," + "Select All" + ","
//        }
//        else
//        {
//            optionSelectAll = ""
//        }
//        if optionSelectAll.count > 1{
//            option = optionSelectAll
//        }
//        else{
//            option = optionCompany + optionInnerCircle + optionRecentTaste
//        }
        option = optionCompany + optionInnerCircle + optionRecentTaste
        if option.count > 0
        {
            option = String(option.characters.dropLast(1))
            //self.sourceListArray = option.components(separatedBy: ",")
            
        }
        else{
           // self.sourceListArray.removeAll()
        }
        //source
        print("value is",option)
        
        
        //company
        if !priceLessfifteenClick
        {
            optionLessfifteen = "P1" + ","
        }
        else
        {
            optionLessfifteen = ""
        }
        
        if !priceMorefifteenClick
        {
            optionMorefifteen  = "P2" + ","
        }
        else
        {
            optionMorefifteen = ""
        }
        
        
        if !priceLessFiftyClick
        {
            optionLessFifty  = "P3" + ","
        }
        else
        {
            optionLessFifty = ""
        }
        if !priceMoreFiftyClick
        {
            optionMoreFifty  = "P4" + ","
        }
        else
        {
            optionMoreFifty = ""
        }
        if !priceMoreSeventyClick
        {
            optionMoreSeventy  = "P5" + ","
        }
        else
        {
            optionMoreSeventy = ""
        }
        
        optionPrice = optionLessfifteen + optionMorefifteen + optionLessFifty + optionMoreFifty + optionMoreSeventy
        if optionPrice.count > 0
        {
            optionPrice = String(optionPrice.characters.dropLast(1))
            
        }
        else{
        }
        
        
        

        for number in 0..<(self.cuisineSelectedArray.count){
            var cusineValue = ExploreFilter()
            cusineValue = self.cuisineSelectedArray[number]
          //  print("name ",cusineValue.cuisineName,cusineValue.selectedValue)
            if cusineValue.selectedValue == true{
                 self.cuisineListArray.append(cusineValue.cuisineName)
            }
        }
             if self.cuisineListArray.count > 0
             {
                optionCuisine =  self.cuisineListArray.joined(separator: ",")
            }
             else{
                 self.cuisineListArray.removeAll()
        }
       // print("option cuisine",optionCuisine)
        if option.characters.count > 0 || optionPrice.characters.count > 0 || optionCuisine.characters.count > 0 {
        }
//        else{
//            let alert = UIAlertController(title: "Taste", message:"Please Select Recent Taste.", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//                NSLog("OK Pressed")
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//            
//        }
        
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"NotificationExploreFilter")
        nc.post(name:myNotification,
                object: nil,
                userInfo:["source":self.option,"price":self.optionPrice,"cuisine":self.optionCuisine,"searchFilter":"1"])
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
         SVProgressHUD.dismiss()
         self.view.isUserInteractionEnabled = true
         sourceListSelectedArray.removeAll()
         cuisineListSelectedArray.removeAll()
         priceListSelectedArray.removeAll()
         sourceListNotSelectedArray.removeAll()
         cuisineListNotSelectedArray.removeAll()
         priceListNotSelectedArray.removeAll()

        
        super.viewWillDisappear(animated)
    }
    
}
