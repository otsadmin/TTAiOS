//
//  WebViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import SVProgressHUD
class WebViewController: UIViewController, UIWebViewDelegate {
    
    var userData = [[String:Any]]()
    var email = [[String:Any]]()
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    
    // MARK: Constants
    
    //
    
    
    
   // for live url
    
    let linkedInKey = "81ewiz1mv07zo8" // live  New key
    let linkedInSecret = "tbCIFNPiLg68Odjo"//live Newsecret key
     //live new 5113185  url live
     //live new li5113185 url scheme live
    
    
   // for Demo Url
    
    // 5110185   url  demo
    // li5110185 url scheme demo
    //  let linkedInKey = "81wvuxq587o99l" // demo key
    // let linkedInSecret = "3Aa4oXplSO5ZTbbj" //demo secret key


    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        webView.delegate = self
        
        startAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: IBAction Function
    
    
    @IBAction func dismiss(_ sender: AnyObject) {
        //        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController( animated: true)
    }
    
    
    // MARK: Custom Functions
    
    func startAuthorization() {
        // Specify the response type which should always be "code".
        let responseType = "code"
        
        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
        
        // Create a random string based on the time intervale (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(Date().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile,r_emailaddress"
        
        
        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
      //  print(authorizationURL)
        
        
        // Create a URL request and load it in the web view.
        let request = URLRequest(url: URL(string: authorizationURL)!)
        webView.loadRequest(request)
        
        
        //I added the print line above just to let you see with your own eyes in the console how the request is finally formed.
    }
    
    
    func requestForAccessToken(_ authorizationCode: String) {
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!  //redirect url
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        // Convert the POST parameters into a NSData object.
        let postData = postParams.data(using: String.Encoding.utf8)
        
        //
        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: URL(string: accessTokenEndPoint)!)
        
        // Indicate that we're about to make a POST request.
        request.httpMethod = "POST"
        
        // Set the HTTP body using the postData object created above.
        request.httpBody = postData
        
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        
        //        // Initialize a NSURLSession object.
        //        let session = NSURLSession(configuration: URLSessionConfiguration.default)
        
        //     ion object.
        
        _ = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        
        let task = URLSession.shared.dataTask(with : request as URLRequest)
        {(data, response, error) -> Void in
            //        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // Get the HTTP status code of the request.
           // let statusCode = (response as! HTTPURLResponse).statusCode
            if let httpResponse = response as? HTTPURLResponse{
            if httpResponse.statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    print("the  accesstoken we get here is \(dataDictionary) that")
                    
                    
                    
                    let accessToken = dataDictionary["access_token"] as! String
                    
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        //   self.dismiss(animated: true, completion: nil)
                        self.makefunctiontogetandsenddata()  //for getting the data and sending it to server
                        
                        /* if ((UserDefaults.standard.string(forKey: "bankcount")) != nil)
                         
                         {
                         
                         K_USER_DATA.bankCount = UserDefaults.standard.string(forKey: "bankcount")!
                         print("BANK COUNT IN LOGIN SCREEN \(K_USER_DATA.bankCount)")
                         
                         let count:Int =  Int(K_USER_DATA.bankCount)!
                         
                         if (count > 0)
                         {
                         let vc = ProfileBeingCreatedViewController()
                         let navVC = UINavigationController(rootViewController: vc)
                         navVC.isNavigationBarHidden = true
                         self.present(navVC, animated: true, completion: nil)
                         }
                         else
                         {
                         let vc = BanksListViewController()
                         let navVC = UINavigationController(rootViewController: vc)
                         navVC.isNavigationBarHidden = true
                         self.present(navVC, animated: true, completion: nil)
                         
                         }
                         
                         }
                         */
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        };
        
        task.resume()
        
    }
    
    
    //   MARK: UIWebViewDelegate Functions
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
       // print(url)
        
        if url.host == "com.appcoda.linkedin.oauth" {
            if url.absoluteString.range(of: "code") != nil {
                //                // Extract the authorization code.
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")[1]
                
                requestForAccessToken(code)
                
                
                
            }
        }
        
        return true
    }
    
    func makefunctiontogetandsenddata() {
        
        if let accessToken = UserDefaults.standard.object(forKey: "LIAccessToken") {
            // Specify the URL string that we'll get the profile info from.
            let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url,id,first-name,last-name,maiden-name,email-address,positions:(title,company),pictureUrls::(original))?format=json"
            
            
            // Initialize a mutable URL request object.
            let request = NSMutableURLRequest(url: URL(string: targetURLString)!)
            
            // Indicate that this is a GET request.
            request.httpMethod = "GET"
            
            // Add the access token as an HTTP header field.
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            
            // Initialize a NSURLSession object.
            _ = URLSession(configuration: URLSessionConfiguration.default)
            
            // Make the request.
            let task = URLSession.shared.dataTask(with : request as URLRequest)
            {(data, response, error) -> Void in
                // Get the HTTP status code of the request.
               // let statusCode = (response as! HTTPURLResponse).statusCode
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200  {
                    // Convert the received JSON data into a dictionary.
                    do {
                        //                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                        if let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                        {
                          //  print(dataDictionary)
                            /*  print("the  data we get here is \(dataDictionary) that")
                             let profileURLString = dataDictionary["publicProfileUrl"] as! String
                             let linkedIn_id = dataDictionary["id"] as! String
                             let firstName = dataDictionary["firstName"] as! String
                             let lastName = dataDictionary["lastName"] as! String
                             //    let email = dataDictionary["emailAddress"] as! String
                             let Designation = dataDictionary["positions"] as! [String:Any]
                             let values = Designation["values"] as? [[String:Any]]
                             
                             
                             if (dataDictionary["emailAddress"] as? String) != nil {
                             self.email = dataDictionary["emailAddress"] as! [[String : Any]]
                             }
                             else
                             {
                             
                             }
                             
                             let defaults = UserDefaults.standard
                             // defaults.set(true, forKey: "isLinkedin")
                             defaults.set(linkedIn_id, forKey: "linkedin_id")
                             defaults.set(firstName, forKey: "name")
                             defaults.set(lastName, forKey: "lastname")
                             defaults.set("123@gmail.com", forKey: "email")
                             
                             
                             
                             for item in values!
                             {
                             let title = item["title"] as! String
                             print("title we get is \(title) complete")
                             K_CURRENT_USER.designation = title
                             defaults.set(title, forKey: "title")
                             }
                             
                             
                             
                             
                             K_CURRENT_USER.name = firstName
                             K_CURRENT_USER.user_id = linkedIn_id
                             K_CURRENT_USER.lname = lastName
                             K_CURRENT_USER.email = "123@gmail.com"
                             
                             */
                            
                            if   let linkedIn_id = dataDictionary["id"] as? String{
                                K_CURRENT_USER.user_id = linkedIn_id
                            }
                            else{
                                K_CURRENT_USER.user_id = ""
                            }
                            if  let firstName = dataDictionary["firstName"] as? String{
                                K_CURRENT_USER.name = firstName
                            }
                            else{
                                K_CURRENT_USER.name = ""
                            }
                            
                            if  let lastName = dataDictionary["lastName"] as? String{
                                K_CURRENT_USER.lname = lastName
                                
                            }
                            else{
                                K_CURRENT_USER.lname = ""
                            }
                            
                            if  let email = dataDictionary["emailAddress"] as? String{
                                K_CURRENT_USER.email = email
                            }
                            else{
                                K_CURRENT_USER.email = ""
                            }
                            
                            if   let Designation = dataDictionary["positions"] as? [String:Any]{
                                if  let values = Designation["values"] as? [[String:Any]]{
                                    for item in values
                                    {
                                        if let title = item["title"] as? String{
                                            K_CURRENT_USER.designation = title
                                        }
                                    }
                                }
                            }
                            else{
                                K_CURRENT_USER.designation = ""
                            }
                            let singelton = SharedManager.sharedInstance
                            let deviceToken = singelton.deviceToken
                            
                            
                            
                            /*  var params = ["is_linkedin_user":"true",
                             "linkedin_key":linkedIn_id,
                             "firstname": firstName,
                             "lastname":lastName,
                             "email":"123@gmail.com",
                             "profile_type" :"public",
                             "has_device_key" : "true",
                             "device_os"  : "ios",
                             "deviceuid" : UserDefaults.standard.string(forKey: "devicetoken")!,
                             "device_name" : "iphone6"] as [String : Any]
                             */
                            //print(UIDevice.current.name)
                            
                            
                            
                            
                            /*      if let positionsDict = dataDictionary["positions"] as? [String:Any] {
                             if let valuesArr = positionsDict["values"] as? [[String:Any]] {
                             if valuesArr.count > 0 {
                             let positionOb = valuesArr[0]
                             if let companyDict = positionOb["company"] as? [String:Any] {
                             let nameOfComp = companyDict["name"] as! String
                             print("name of company issss \(nameOfComp)")
                             params["company_name"] = nameOfComp
                             K_CURRENT_USER.company = nameOfComp
                             defaults.set(nameOfComp, forKey: "company")
                             }
                             }
                             }
                             }
                             
                             
                             
                             
                             if let response = dataDictionary["pictureUrls"] as? [String:Any]
                             {
                             if  let aarti = response["values"] as? NSArray
                             
                             {
                             if aarti.count > 0
                             {
                             let positionOb = aarti[0]
                             print("picture string is \(positionOb)")
                             
                             K_CURRENT_USER.image_url = positionOb as! String
                             params["profile_image"] = positionOb
                             defaults.set(positionOb, forKey: "imageUrl")
                             defaults.synchronize()
                             
                             
                             
                             }
                             
                             }
                             
                             }
                             
                             */
                            
                            
                            if let positionsDict = dataDictionary["positions"] as? [String:Any] {
                                if let valuesArr = positionsDict["values"] as? [[String:Any]] {
                                    if valuesArr.count > 0 {
                                        let positionOb = valuesArr[0]
                                        if let companyDict = positionOb["company"] as? [String:Any] {
                                            if  let nameOfComp = companyDict["name"] as? String{
                                                K_CURRENT_USER.company = nameOfComp
                                            }
                                            //  params["company_name"] = nameOfComp
                                        }
                                    }
                                }
                            }
                            else{
                                K_CURRENT_USER.company = ""
                            }
                            
                            
                            if let response = dataDictionary["pictureUrls"] as? [String:Any]
                            {
                                if  let aarti = response["values"] as? NSArray
                                    
                                {
                                    if aarti.count > 0
                                    {
                                        let positionOb = aarti[0]
                                        K_CURRENT_USER.image_url = positionOb as! String
                                        // params["profile_image"] = positionOb
                                    }
                                    
                                }else{
                                    K_CURRENT_USER.image_url = ""
                                }
                                
                            }
                            else{
                                K_CURRENT_USER.image_url = "http://www.iaimhealthcare.com/images/doctor/no-image.jpg"
                            }
                            
                            
                            // if let userimageUrl = dataDictionary["pictureUrl"] as? String {
                            //    K_CURRENT_USER.image_url = userimageUrl
                            //   params["profile_image"] = userimageUrl
                            //   defaults.set(userimageUrl, forKey: "imageUrl")
                            //   defaults.synchronize()
                            //}
                            
                            var params = ["is_linkedin_user":"true",
                                          "linkedin_key": K_CURRENT_USER.user_id,
                                          "firstname": K_CURRENT_USER.name,
                                          "lastname":K_CURRENT_USER.lname,
                                          "company_name":K_CURRENT_USER.company,
                                          "designation":K_CURRENT_USER.designation,
                                          "email":K_CURRENT_USER.email,
                                          "profile_image":K_CURRENT_USER.image_url,
                                          "profile_type" :"public",
                                          "has_device_key" : "true",
                                          "device_os"  : "ios",
                                          "deviceuid" : deviceToken,
                                          "device_name" : UIDevice.current.name] as [String : Any]
                           // print(params)
                            DataManager.sharedManager.login(params: params , completion: { (response) in
                                
                                
                                if let dataDic = response as? [[String:Any]]
                                {
                                    
                                //    print("Mohit Deval",dataDic)
                                    
                                    self.userData  = dataDic
                                     self.loadData()
                                }
                                else{
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

                                
                            })     //end for sending data to server
                            
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                //  self.btnOpenProfile.setTitle(profileURLString, for: UIControlState())
                                // self.btnOpenProfile.isHidden = false
                                
                            })
                        }
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            }
            };
            
            task.resume()
        }
        
        
    }
    
    
    func loadData()
    {
        /*  let loginId = self.userData[0]["_id"] as? String
         print("login id isssss \(loginId!)")
         let bankCount = self.userData[0]["total_bank"] as! Int
         print("bank count is \(bankCount) that")
         let defaults = UserDefaults.standard
         defaults.set(loginId!, forKey: "user_id")
         defaults.set(bankCount, forKey: "bankcount")
         defaults.synchronize()
         
         */
       // print(self.userData)
        if let loginId = self.userData[0]["_id"] as? String{
            K_CURRENT_USER.login_Id = loginId
        }
        
        if let profile = self.userData[0]["profile"] as? [String:Any]{

            if let fName = profile["firstname"] as? String{
                K_CURRENT_USER.name = fName
            }
            if let lName = profile["lastname"] as? String{
                 K_CURRENT_USER.lname = lName
            }
            if let companyName = profile["company_name"] as? String{
               K_CURRENT_USER.company = companyName
            }
            if let desination = profile["designation"] as? String{
                K_CURRENT_USER.designation = desination
            }
            if let email = profile["email"] as? String{
               K_CURRENT_USER.email = email
            }
            if let image = profile["image"] as? String{
               K_CURRENT_USER.image_url = K_IMAGE_BASE_URL + image
            }else{
                K_CURRENT_USER.image_url = ""
            }
//            if let selectedMiles = self.userData[0]["user_selected_miles"] as? String{
//                K_CURRENT_USER.selected_miles = selectedMiles
//            }
//            else{
//                K_CURRENT_USER.selected_miles = "0.5"
//            }

            
            
        }
      
        let singelton = SharedManager.sharedInstance
        singelton.loginId = K_CURRENT_USER.login_Id
        
        self.saveUserProfileData(firstName:  K_CURRENT_USER.name, lastName: K_CURRENT_USER.lname, companyName:  K_CURRENT_USER.company, designation: K_CURRENT_USER.designation, email:  K_CURRENT_USER.email, userId:  K_CURRENT_USER.login_Id, linkedinId: K_CURRENT_USER.user_id, imageUrl: K_CURRENT_USER.image_url, selected_miles:K_CURRENT_USER.selected_miles)
        
        
        self.getTransactionCount()
      //  self.makefunctiontogetandsenddata()
    }
    
    func getTransactionCount() {
      //  print(K_CURRENT_USER.login_Id)
        let parameter=["user_id":K_CURRENT_USER.login_Id] as [String : Any]
        DataManager.sharedManager.bankTransactionCount(params: parameter) { (response) in
            if let dataDic = response as? [String: Any]    {
                var transactionCount = 0
                var bankCount = 0
                if let count = dataDic["transaction_count"] as? Int{
                    transactionCount = count
                }
                if let count = dataDic["bank_count"] as? Int{
                    bankCount = count
                }
                
                if transactionCount > 0 || bankCount > 0 {
                    SVProgressHUD.dismiss()
                    let vc = ProfileBeingCreatedViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.isNavigationBarHidden = true
                    self.present(navVC, animated: true, completion: nil)
                }
                else{
                    SVProgressHUD.dismiss()
                    let vc = BanksListViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.isNavigationBarHidden = true
                    self.present(navVC, animated: true, completion: nil)
                }
                
            }
            else{
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
    }
    
    func saveUserProfileData(firstName:String, lastName:String,companyName:String, designation: String, email: String, userId: String, linkedinId: String, imageUrl:String,selected_miles:String)  {
        let plistFileName = "data.plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0] as NSString
        let plistPath = documentPath.appendingPathComponent(plistFileName)
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        //saving values
        dict.setObject(firstName, forKey:  "firstName" as NSCopying)
        dict.setObject(lastName, forKey:  "lastName" as NSCopying)
        dict.setObject(companyName, forKey:  "companyName" as NSCopying)
        dict.setObject(designation, forKey:  "designation" as NSCopying)
        dict.setObject(email, forKey:  "email" as NSCopying)
        dict.setObject(userId, forKey:  "userId" as NSCopying)
        dict.setObject(linkedinId, forKey:  "linkedinId" as NSCopying)
        dict.setObject(imageUrl, forKey:  "imageUrl" as NSCopying)
        dict.setObject(selected_miles, forKey:  "selected_miles" as NSCopying)
        
        
        //dict.removeObject(forKey: "firstName")
        
        //writing to Data.plist
        dict.write(toFile: plistPath, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: plistPath)
        // print("Saved Data.plist file is --> \(resultDictionary?.description)")
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }
    
    
    
}
