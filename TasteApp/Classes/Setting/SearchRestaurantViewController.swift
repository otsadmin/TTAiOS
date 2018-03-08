//
//  SearchRestaurantViewController.swift
//  Taste
//
//  Created by Asish Pant on 03/08/17.
//  Copyright © 2017 Ots. All rights reserved.
//
protocol PinRemoverDelegate: class {
    func removePin()
}


import UIKit
import SVProgressHUD
class SearchRestaurantViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    var tableView:UITableView!
    let textField = UITextField()
    var restaurants = [[String:Any]]()
    let profile = TransactionViewController()
    let  restaurantProfile = RestaurantProfile()
    weak var delegate: PinRemoverDelegate? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        // Do any additional setup after loading the view.
    }
    func setupView()
    {
        
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        let titleLabel = UILabel()
        titleLabel.text = "Search Restaurant"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 24)
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
        
        
        self.textField.delegate = self
        self.view.addSubview( self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        self.textField.backgroundColor = UIColor.black
        self.textField.layer.cornerRadius = 8
        self.textField.textColor = UIColor.white
        //textField.text = "Search"
        
        
        
        self.textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        self.textField.leftViewMode = .always
        let str = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor.white])
        self.textField.attributedPlaceholder = str
        self.textField.returnKeyType = UIReturnKeyType.search
        
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "ic_search")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        self.textField.leftViewMode = .always
        self.textField.leftView = leftView
        
        
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.gray
        //tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
            make.top.equalTo( self.textField.snp.bottom).offset(10)
        }
        tableView.tableFooterView = UIView()
    }
    func goBack() {
        // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField.text?.characters.count)! > 4
        {
            //SVProgressHUD.show()
            //tableView.isUserInteractionEnabled = false
            // self.textField.isUserInteractionEnabled = false
            
            //self.filter(text: textField.text!)
            //self.tableView.reloadData()
            self.searchRestaurant(name: textField.text!)
        }
            
        else if (textField.text?.characters.count)! == 0
        {
            
            // SVProgressHUD.show()
            //self.loadTableViewData()
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    func searchRestaurant(name:String) {
        SVProgressHUD.show()
        
        // let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"phone_nos":self.phoneString,"emails":self.emailString]
        let singelton = SharedManager.sharedInstance
        print(singelton.loginId)
        let parameters = ["name":name]
        
        DataManager.sharedManager.searchRestaurant(params: parameters, completion:
            { (response) in
                
                
                
                if let dataDic = response as? [[String:Any]]
                {
                    print(dataDic)
                    self.restaurants = dataDic
                    
                    if self.restaurants.count > 0{
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    //                    if self.users.count > 0
                    //                    {
                    //                        //  self.collectionView.reloadData()
                    //                        self.loadUserData()
                    //                    }
                    
                    //                    else
                    //                    {
                    //                        SVProgressHUD.dismiss()
                    //
                    //                    }
                    
                }
                else
                {
                    if Reachability.isConnectedToNetwork() != true
                    {
                        SVProgressHUD.dismiss()
                        
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
                
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                }
                
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return cuisinesFilter.count;
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let textRestaurant = UILabel()
        textRestaurant.numberOfLines = 1
        textRestaurant.adjustsFontSizeToFitWidth = true
        textRestaurant.minimumScaleFactor = 0.2
        textRestaurant.font = UIFont(name:K_Font_Color_Regular,size:15)
        textRestaurant.textColor = UIColor.black
        cell.contentView.addSubview(textRestaurant)
        textRestaurant.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(340)
            make.height.equalTo(30)
            make.top.equalTo(20)
        }
        
        //        let textLabel = UILabel()
        //        textLabel.textColor = UIColor.black
        //        textLabel.font = UIFont(name: K_Font_Color, size: 18)
        //        cell.contentView.addSubview(textLabel)
        //        textLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(14)
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(cell.contentView).offset(-10)
        //            //make.top.equalTo(2)
        //        }
        
        //textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        
        
        let sublabel = UILabel()
        cell.contentView.addSubview(sublabel)
        sublabel.font = UIFont(name: K_Font_Color, size:18)
        sublabel.textAlignment = .left
        sublabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(textRestaurant.snp.bottom).offset(2)
            make.right.equalTo(-10)
        }
        
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
        
        if let factualId  =  self.restaurants[indexPath.row]["factual_id"] as? String{
            restaurantProfile.factualId = factualId
        }
        textRestaurant.text = restaurantProfile.name
        sublabel.text = restaurantProfile.city + ", " + restaurantProfile.state
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
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
        if let factualId  =  self.restaurants[indexPath.row]["factual_id"] as? String{
            restaurantProfile.factualId = factualId
        }
        
        profile.restaurantProfile = restaurantProfile
        weak var delegate: PinRemoverDelegate? = nil
        delegate?.removePin()
        
        //self.delegate?.fillData()
        self.dismiss(animated: true, completion: nil)
        
    }
    func removePin() {
        print(profile.restaurantProfile)
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
