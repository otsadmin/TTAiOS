//
//  TransactionViewController.swift
//  Taste
//
//  Created by Lalit Mohan on 25/05/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import GooglePlaces
import Mixpanel
import Firebase
class TransactionViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate
{
    var cuisineArray = Array<Any>()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblCuisine: UILabel!
    @IBOutlet weak var lblRestaurant: UILabel!
    var restaurantProfile = RestaurantProfile()
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtCurrency: UITextField!
    @IBOutlet weak var txtTransactionDate: UITextField!
    
    @IBOutlet weak var txtPlaceName: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtTranstionDate: UITextField!
    @IBOutlet weak var txtzipCode: UITextField!
    @IBOutlet weak var txtRestaurant: UITextField!
    let datePickerView:UIDatePicker = UIDatePicker()
    var YOURINDEXPATH = IndexPath(row: 0, section: 0)
    let pickerViewCuisine = UIPickerView()
    var factual_id:String = ""
    var restaurants = [[String:Any]]()
    var restaurantsFresh = [[String:Any]]()
    @IBOutlet weak var txtCuisine: UITextField!
    var isRefreshData:Bool = true
    
    
    
    @IBAction func clearText(_ sender: Any) {
        SVProgressHUD.dismiss()
        txtRestaurant.text = ""
        txtCuisine.text = ""
        txtAmount.text = ""
        txtAddress.text = ""
        txtState.text = ""
        txtCity.text = ""

        pickerViewCuisine.selectRow(0, inComponent: 0, animated: false)
        self.tableView.isHidden = true
        self.isRefreshData = true
    }
    
    //    // Declare UI elements.
    //    @IBOutlet weak var address_line_1: UITextField!
    //    @IBOutlet weak var address_line_2: UITextField!
    //    @IBOutlet weak var city: UITextField!
    //    @IBOutlet weak var state: UITextField!
    //    @IBOutlet weak var postal_code_field: UITextField!
    //    @IBOutlet weak var country_field: UITextField!
    //    @IBOutlet weak var button: UIButton!
    
    // Declare variables to hold address form values.
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        //        self.txtAddress.isHidden = true
        //        self.txtCity.isHidden = true
        //        self.txtState.isHidden = true
        //        self.txtzipCode.isHidden = true
        //        self.txtCuisine.isHidden = true
        //        self.txtTranstionDate.isHidden = true
        //        self.txtAmount.isHidden = true
        pickerViewCuisine.dataSource = self
        pickerViewCuisine.delegate = self
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        txtTranstionDate.text = result
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        DataManager.sharedManager.getMasterDietList { (response) in
         //   print(response)
            
            if let dataDic = response as? [String:Any]
            {
                if let array = dataDic["data"] as? NSArray
                {
                    self.cuisineArray = array as! Array<Any>
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    let alert = UIAlertController(title: "Taste", message:"Cuisine Not Found",preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
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
                    return                }
                else{
                    
                    //TODO: ADD MIXPANEL AND FIREBASE ACTION
                    
                    Mixpanel.sharedInstance()?.track(R_SUBMIT_TRANSACTION,
                                                     properties: ["Plan" : "Premium"])
                    
                    Analytics.logEvent(R_SUBMIT_TRANSACTION, parameters: nil)
                    
                    let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }

//                if Reachability.isConnectedToNetwork() != true
//                {
//                    SVProgressHUD.dismiss()
//                    self.view.isUserInteractionEnabled = true
//                    let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                        UIAlertAction in
//                        NSLog("OK Pressed")
//                    }
//                    alert.addAction(okAction)
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
            }
            
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
            }
            
        }
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //    func keyboardWillShow(notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    //            if self.view.frame.origin.y == 0{
    //                self.view.frame.origin.y -= keyboardSize.height
    //            }
    //        }
    //    }
    //
    //    func keyboardWillHide(notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    //            if self.view.frame.origin.y != 0{
    //                self.view.frame.origin.y += keyboardSize.height
    //            }
    //        }
    //    }
    
    //    @IBAction func textFieldEditing(_ sender: UITextField)
    //    {
    //
    //        datePickerView.datePickerMode = UIDatePickerMode.date
    //
    //            sender.inputView = datePickerView
    //
    //        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    //
    //
    //    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let selectedDate = formatter.string(from: sender.date)
       // print("transactioon date is \(selectedDate)")
        
        
        // txtTranstionDate.text = ""
        
        
        txtTranstionDate.text = selectedDate
        
        
        
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: Any)
    {


         self.view.isUserInteractionEnabled = false
        
        //        if  let restaurant = txtRestaurant.text   {
        //            txtRestaurant.text =  restaurant.trimmingCharacters(in: CharacterSet.whitespaces)
        //        }
        //        if  let amount = txtAmount.text   {
        //            txtAmount.text =  amount.trimmingCharacters(in: CharacterSet.whitespaces)
        //        }
        //        if  let city = txtCity.text  {
        //            txtCity.text =  city.trimmingCharacters(in: CharacterSet.whitespaces)
        //        }
        //        if  let state = txtState.text   {
        //            txtState.text =  state.trimmingCharacters(in: CharacterSet.whitespaces)
        //        }
        //        if  let zipCode = txtzipCode.text   {
        //            txtzipCode.text =  zipCode.trimmingCharacters(in: CharacterSet.whitespaces)
        //        }
       
        if txtCuisine.text!.isEmpty || txtRestaurant.text!.isEmpty || (txtAmount.text?.isEmpty)! || (txtTranstionDate.text?.isEmpty)! || txtAddress.text!.isEmpty || (txtCity.text?.isEmpty)! || (txtState.text?.isEmpty)!
        {
            let alert = UIAlertController(title: "Taste", message:"Please fill all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
               
            }
            alert.addAction(okAction)
             self.view.isUserInteractionEnabled = true
             self.present(alert, animated: true, completion: nil)
            return
        }
       
        if self.factual_id.characters.count <= 0{
            let alert = UIAlertController(title: "Taste", message:"Restaurant Not found.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
               
            }
            alert.addAction(okAction)
            self.view.isUserInteractionEnabled = true
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        self.TransationEntryApiHIt()
        
        
        
        
    }
    
    
    
    func TransationEntryApiHIt()
    {
        
        //  let parameter = ["cuisine":txtCuisine.text!,"address":txtAddress.text!,"city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"amount":txtAmount.text!,"transaction_date":txtTranstionDate.text!,"currency":txtCurrency.text!,"name":txtPlaceName.text!,"user_id":UserDefaults.standard.string(forKey: "user_id")!,"description":txtViewDescription.text!]
        //  print(<#T##items: Any...##Any#>)
        
        let singelton = SharedManager.sharedInstance
        // singelton.loginId = K_CURRENT_USER.login_Id
        // prin
      //  print(txtTranstionDate.text)
        let parameter =
            ["user_id":singelton.loginId,"factual_id":self.factual_id,"cuisine":txtCuisine.text!,"transaction_date":txtTranstionDate.text!,"amount":txtAmount.text!]
       // print(parameter)
        SVProgressHUD.show()
       // self.view.isUserInteractionEnabled = false
        DataManager.sharedManager.transactionEntry(params: parameter, completion: { (response) in
            
            
            if let dataDic = response as? String
            {
                if (dataDic == K_Internet_Message){
                    if Reachability.isConnectedToNetwork() != true
                    {
                        let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                    else{
                        
                        //TODO: ADD MIXPANEL AND FIREBASE ACTION
                        
                        Mixpanel.sharedInstance()?.track(R_SUBMIT_TRANSACTION,
                                                         properties: ["Plan" : "Premium"])
                        Analytics.logEvent(R_SUBMIT_TRANSACTION, parameters: nil)
                        
                        let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        return
                        
                    }
                    
                }
                else{
                    let alert = UIAlertController(title: "Taste", message:dataDic, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    // self.navigationController?.popViewController(animated: true)
                    return
                    
                }
            }
               
        })
        
    }
    
    
    
    //MARK: TEXTFILED DELEGATE METHOD
    
    
    func textFieldDidBeginEditing(_ textField: UITextField!)
    {
        
        if textField.tag == 1 {
            if (txtCuisine.text?.isEmpty)!{
                pickerViewCuisine.selectRow(0, inComponent: 0, animated: false)
            }
            
            for number in 0..<(self.cuisineArray.count)
            {
                if (self.cuisineArray[number]) as? String == txtCuisine.text{
                    pickerViewCuisine.selectRow(number, inComponent: 0, animated: false)
                }
            }
            txtCuisine.inputView = pickerViewCuisine
            txtCuisine.inputView = pickerViewCuisine
        }
        if textField.tag == 3
        {
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.maximumDate = NSDate() as Date
            
            textField.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        if textField.tag == 5 {
            //            let autocompleteController = GMSAutocompleteViewController()
            //            autocompleteController.delegate = self
            //
            //            // Set a filter to return only addresses.
            //            let addressFilter = GMSAutocompleteFilter()
            //            addressFilter.type = .address
            //            autocompleteController.autocompleteFilter = addressFilter
            //
            //            present(autocompleteController, animated: true, completion: nil)
        }
            
        else
        {
            textField.becomeFirstResponder()
        }
        
        
        
    }
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if textField.tag == 0 {
    //            if (textField.text?.characters.count)! >= 3
    //            {
    //
    //                self.searchRestaurant(name: textField.text!)
    //            }
    //        }
    //
    //        return true
    //    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 0 {
            if (textField.text?.characters.count)! >= 2
            {
                SVProgressHUD.show()
                self.view.isUserInteractionEnabled = false
               
                delayWithSeconds(0.5){
                self.isRefreshData = true
                self.searchRestaurant(name: textField.text!)
                }
            }
        }
        if textField.tag == 1 {
            txtCuisine.inputView = pickerViewCuisine
        }
        if textField.tag == 3
        {
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.maximumDate = NSDate() as Date
            
            textField.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        if textField.tag == 5 {
            //            let autocompleteController = GMSAutocompleteViewController()
            //            autocompleteController.delegate = self
            //
            //            // Set a filter to return only addresses.
            //            let addressFilter = GMSAutocompleteFilter()
            //            addressFilter.type = .address
            //            autocompleteController.autocompleteFilter = addressFilter
            //
            //            present(autocompleteController, animated: true, completion: nil)
        }
            
        else
        {
            textField.becomeFirstResponder()
        }
        // return true
        
        return true
    }
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    //    {
    ////        if textField.tag == 0 {
    ////            if (textField.text?.characters.count)! >= 3
    ////            {
    ////                //SVProgressHUD.show()
    ////                //tableView.isUserInteractionEnabled = false
    ////                // self.textField.isUserInteractionEnabled = false
    ////
    ////                //self.filter(text: textField.text!)
    ////                //self.tableView.reloadData()
    ////                self.searchRestaurant(name: textField.text!)
    ////            }
    ////        }
    //
    //    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if textField.tag == 1{
            if let cusine = (self.cuisineArray[0] as! NSString) as String!{
                //cusine.characters.count > 0{
                if (txtCuisine.text?.isEmpty)!{
                    txtCuisine.text = cusine
                     pickerViewCuisine.selectRow(0, inComponent: 0, animated: false)
                }
                
            }
            
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    
    //    func textViewShouldReturn(textView: UITextView!) -> Bool {
    //        self.view.endEditing(true);
    //        return true;
    //    }
    
    func searchRestaurant(name:String) {
       
        let parameters = ["name":name]
      //  print("name is",name)
        DataManager.sharedManager.searchRestaurant(params: parameters, completion:
            { (response) in
                
                self.tableView.isHidden = true
                self.restaurantsFresh.removeAll()
                
                if let dataDic = response as? [[String:Any]]
                {
                    self.restaurantsFresh = dataDic
                   // print("count vaue is ",self.restaurants.count)
                    if self.restaurantsFresh.count > 0{
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        if self.isRefreshData{
                            self.restaurants = self.restaurantsFresh
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                      
                        
                       
                    }
                    
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
                          //  NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else{
                        //TODO: ADD MIXPANEL AND FIREBASE ACTION
                        
                        Mixpanel.sharedInstance()?.track(R_SUBMIT_TRANSACTION,
                                                         properties: ["Plan" : "Premium"])
                        
                        Analytics.logEvent(R_SUBMIT_TRANSACTION, parameters: nil)
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
    
    
    // MARK: TABLEVIEW DATA SOURCE AND DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return cuisinesFilter.count;
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTable", for: indexPath) as! TransactionTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        
       // print("index -----",indexPath.row,self.restaurants.count)
        let  restaurantProfile = RestaurantProfile()
        if let name  =  self.restaurants[indexPath.row]["name"] as? String{
            restaurantProfile.name = name
        }
        if let address  =  self.restaurants[indexPath.row]["address"] as? String{
            restaurantProfile.address = address
        }
        if let city  =  self.restaurants[indexPath.row]["city"] as? String{
            restaurantProfile.city = city
        }
        if let state  =  self.restaurants[indexPath.row]["state"] as? String{
            restaurantProfile.state = state
        }
        
        cell.labelRestaurantDetail.text = restaurantProfile.name
        cell.labelSubTitle.text =  restaurantProfile.address + ", " + restaurantProfile.city + ", " + restaurantProfile.state
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // SVProgressHUD.dismiss()
        
        self.isRefreshData = false
        self.tableView.isHidden = true
        let  restaurantProfile = RestaurantProfile()
        if let name  =  self.restaurants[indexPath.row]["name"] as? String{
            restaurantProfile.name = name
        }
        if let city  =  self.restaurants[indexPath.row]["city"] as? String{
            restaurantProfile.city = city
        }
        if let state  =  self.restaurants[indexPath.row]["state"] as? String{
            restaurantProfile.state = state
        }
        if let address  =  self.restaurants[indexPath.row]["address"] as? String{
            restaurantProfile.address = address
        }
        //        if let country  =  self.restaurants[indexPath.row]["country"] as? String{
        //            restaurantProfile.country = country
        //        }
        if let factualId  =  self.restaurants[indexPath.row]["factual_id"] as? String{
            restaurantProfile.factualId = factualId
        }
        if let cuisineArray = self.restaurants[indexPath.row]["cuisine"] as? NSArray{
            if cuisineArray.count > 0{
                if let cusineName = (cuisineArray[0] as? String){
                    restaurantProfile.cuisine = cusineName
                }
                else{
                     restaurantProfile.cuisine = ""
                }
                
            }
            else{
                restaurantProfile.cuisine = ""
            }
            
        }
        
        
        
        
        //  print(restaurantProfile.country)
        self.factual_id = restaurantProfile.factualId
        txtRestaurant.text = restaurantProfile.name
        txtCity.text = restaurantProfile.city
        txtState.text = restaurantProfile.state
        txtAddress.text = restaurantProfile.address
        txtCuisine.text = restaurantProfile.cuisine
        
        //        self.txtAddress.isHidden = false
        //        self.txtCity.isHidden = false
        //        self.txtState.isHidden = false
        //        self.txtzipCode.isHidden = false
        //        self.txtCuisine.isHidden = false
        //        self.txtTranstionDate.isHidden = false
        //        self.txtAmount.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        super.viewWillDisappear(animated)
    }

    // MARK: PICKER VIEW DATASOURCE METHODS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cuisineArray.count
    }
    
    // MARK: PICKER VIEW DELEGATE METHODS
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (self.cuisineArray[row] as! NSString) as String!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCuisine.text =  (self.cuisineArray[row] as! NSString) as String!
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        
//        SVProgressHUD.dismiss()
//        self.restaurantsFresh.removeAll()
//        self.restaurants.removeAll()
//        self.view.isUserInteractionEnabled = true
//        // self.cuisinesFilter.removeAll()
//        super.viewWillDisappear(animated)
//    }
//    
    
    // Populate the address form fields.
    func fillAddressForm() {
      //  print(street_number,route,locality,administrative_area_level_1,postal_code,postal_code_suffix)
        txtAddress.text = street_number + " " + route
        txtCity.text = locality
        txtState.text = administrative_area_level_1
        if postal_code_suffix != "" {
            txtzipCode.text = postal_code + "-" + postal_code_suffix
        } else {
            txtzipCode.text = postal_code
        }
        // txtCountry.text = country
        
        // Clear values for next time.
        street_number = ""
        route = ""
        neighborhood = ""
        locality = ""
        administrative_area_level_1  = ""
        country = ""
        postal_code = ""
        postal_code_suffix = ""
    }
    
}

// MARK: PICKER VIEW EXTENTIONS
extension TransactionViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        //        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        
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
        
        // Call custom function to populate the address form.
        fillAddressForm()
        
        // Close the autocomplete widget.
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
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
