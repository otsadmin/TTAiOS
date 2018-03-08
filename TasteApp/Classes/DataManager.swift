//
//  DataManager.swift
//  TasteApp
//
//  Created by Shubhank on 13/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Alamofire

class DataManager: NSObject {
    
    
    static let sharedManager : DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    //MARK: Web service methods
    func login(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        
       Alamofire.request(K_LOGIN_URL, method: .post, parameters: params,encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_LOGIN_URL) is \(responseString)")
                    
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    
                    print("have you reached login api \(parsedData)")
                    
                    if   let results = parsedData["data"] as? [[String:Any]]{
                        print(results)
                        completion(results)
                    }
                    else{
                        completion("")
                    }
                   
                    
                } catch let error as NSError {
                    print(error)
                     completion("")
                }
                
        }
    }
    
    
    func logout(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_LOGOUT_URL, method: .post, parameters: params,encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_LOGIN_URL) is \(responseString)")
                    
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    
                    print("have you reached login api \(parsedData)")
                    
                    if   let results = parsedData["data"] as? [[String:Any]]{
                        print(results)
                        completion(results)
                    }
                    else{
                        completion("")
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }

    
    
    
    //MARK: INVITE API HIT TO SEND NOTIFICATION TO FRIEND
    
    
    func inviteFriendApi(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_INVITE_FRIEND, method: .post, parameters: params,encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_LOGIN_URL) is \(responseString)")
                    
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    
                    print("have you reached login api \(parsedData)")
                    
                        completion(parsedData)
              

                    
//                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                    
//                    let status = parsedData["status"] as? String
//                    let msg = parsedData["message"] as? String
//                    print("status is \(status) and message is \(msg)")
//                    
//                    if status == "success"
//                    {
//                        let message = parsedData["message"] as? String
//                        
//                        if message != nil
//                        {
//                            completion(message!)
//                        }}
//                    else
//                    {
//                        let message = parsedData["message"] as? String
//                        if message != nil
//                        {
//                            completion(message!)
//                        }
//                    }
                    } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    //MARK: INVITE API HIT TO SEND NOTIFICATION TO FRIEND
    func inviteNonTTAUser(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_INVITE_NON_TTA_USER, method: .post, parameters: params,encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_LOGIN_URL) is \(responseString)")
                    
                }
                
                do {
                    
                    
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    
                    print("have you reached login api \(parsedData)")
                        completion(parsedData)

                    
//                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                    
//                    let status = parsedData["status"] as? String
//                    let msg = parsedData["message"] as? String
//                    print("status is \(status) and message is \(msg)")
//                    
//                    if status == "success"
//                    {
//                        let message = parsedData["message"] as? String
//                        
//                        if message != nil
//                        {
//                            completion(message!)
//                        }}
//                    else
//                    {
//                        let message = parsedData["message"] as? String
//                        if message != nil
//                        {
//                            completion(message!)
//                        }
//                    }
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    func checkFriendInviteStatus(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_CHECK_INVITE_STATUS, method: .get, parameters: params,encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_CHECK_INVITE_STATUS) is \(responseString)")
                    
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    
                    completion(parsedData)
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }

                
//                do {
//                    
//                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                    
//                    let status = parsedData["status"] as? String
//                    let msg = parsedData["message"] as? String
//                    print("status is \(status) and message is \(msg)")
//                    
//                    if status == "success"
//                    {
//                        let message = parsedData["message"] as? String
//                        
//                        if message != nil
//                        {
//                            completion(message!)
//                        }}
//                    else
//                    {
//                        let message = parsedData["message"] as? String
//                        if message != nil
//                        {
//                            completion(message!)
//                        }
//                    }
//                } catch let error as NSError {
//                    print(error)
//                }
                
        }
    }
    
    //MARK: //NOTIFICATTION API
    
    
   /* func getNotification(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_NOTIFICATION, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    
                    print("Data not found")
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    */
    func getNotification(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_NOTIFICATION, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    if let results = parsedData["data"] as? NSDictionary{
                        let val_count = results["count"] as! NSNumber
                        print("BBB",val_count)
                        K_INNERUSER_DATA.countvalue = Int(val_count)

                        if let linkdata = results["list"] as? Array<Dictionary<String,Any>>{
                             completion(linkdata as Any)
                        }
                    }
                    else{
                        completion("")
                    }
                   
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    
    func getNotificationAnalyticClass(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_NOTIFICATION, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    if let results = parsedData["data"] as? NSDictionary{
                        let val_count = results["count"] as! NSNumber
                        print("BBB",val_count)
                        K_INNERUSER_DATA.countvalue = Int(val_count)
                        
                        if let linkdata = results["list"] as? Array<Dictionary<String,Any>>{
                            completion(linkdata as Any)
                        }
                    }
                    else{
                        completion("")
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }

    
    func getNotificationProfileCuisinClass(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_NOTIFICATION, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    if let results = parsedData["data"] as? NSDictionary{
                        let val_count = results["count"] as! NSNumber
                        print("BBB",val_count)
                        K_INNERUSER_DATA.countvalue = Int(val_count)
                        
                        if let linkdata = results["list"] as? Array<Dictionary<String,Any>>{
                            completion(linkdata as Any)
                        }
                    }
                    else{
                        completion("")
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }

    
    
    
    func postNotification(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_NOTIFICATION, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    
                    completion("yes")
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    
    

    
    
    
    
    
    //MARK: BANK LIST THROUGH YODLLE API
    
    func getBankListYodlee(Params:[String:Any],completion:@escaping (Any)  -> Void)
    {
        
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(K_PROVIDER, method: .get, parameters: Params, encoding: URLEncoding.default, headers: headers)
       
        .response { (response) in
            
            //print(response)
            print("paramter is \(Params) \n and url is \(K_PROVIDER)")
            
            
          
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                
                print(parsedData)
                
                 let results = parsedData["data"] as? [String:Any]
                
                 completion(results)
                
            }catch let error as NSError {
            print(error)
            completion("")
            
            }
       }
    }
 
    
    func getBanksList(completion: @escaping (Any) -> Void)
    {
        Alamofire.request("https://tartan.plaid.com/institutions/all", method: .post, parameters: ["client_id":K_PLAID_CLIENT_ID, "secret" : K_PLAID_SECRET], encoding: URLEncoding.default, headers:nil)
            .response
            { (response) in
                print(response)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    let results = parsedData["results"] as! [[String:Any]]
                    
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                }
        }
    }
    
   
    
    func getDietList(params :[String:Any],completion : @escaping (Any) -> Void)
    {
        Alamofire.request(K_DIETLIST_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers:nil)
            .response
            { (response) in
                print(response)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let results = parsedData["data"] as! [String:Any]
                    
                    print(results)
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print("yes i got the errror is \(error)that")
                }
        }
        
    }
    
    func getDietHistory(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_Transaction_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print("error case in parsed data \(parsedData)")
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    
                    print("Data not found")
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    
    //post histroy
    
    
    func postDietHistory(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_Transaction_URL, method:.post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    print("error case in parsed data \(parsedData)")
                    print("bankid is that \(K_CURRENT_USER.bank_id)")
                    //                    let results = parsedData["data"] as! [[String:Any]]
                    
                    
                    // print("Data not found")
                    completion(parsedData)
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    
    
     //Mark:Bank List Already Added Account
   
    func bankList(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_BANK_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print(response)
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    print(results)
                    
                    completion(results)
                    
                } catch let error as NSError {
                    //print(error)
                    completion("")
                }
                
        }
    }
    
    
    //Mark: Bank Count Api
    
    func bankCount(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_BANK_COUNT, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print(response)
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let results = parsedData["data"] as! [String:Any]
                    
                    print(results)
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }

    
    
    
    
   //MARK:BANK ACCOUNT DELETE API
    
    func bankAccountDelete(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        Alamofire.request(K_BANK_URL, method: .delete, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print(response)
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    let status = parsedData["status"] as? String
                    print("status is \(status)")
                    
                    if status == "success"
                    {
                       let message = parsedData["message"] as? String
                        
                        if message != nil
                        {
                        completion(message!)
                        }}
                    else
                    {
                        let message = parsedData["message"] as? String
                        if message != nil
                        {
                            completion(message!)
                        }
                    }} catch let error as NSError {
                    print(error)
                }}}

    
    
    func getMasterDietList(completion: @escaping (Any) -> Void) {
        Alamofire.request(K_MASTERDIETLIST_URL, method: .get, encoding: URLEncoding.default, headers:nil)
            .response
            { (response) in
                print(response)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    //                    let result  = parsedData["data"] as? [String:Any]
                    //                    print(result)
                    completion(parsedData)
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
        }
    }
   
   //MARK:YODLLE BANK LOGIN API
    
    
    func bankLogin(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        Alamofire.request(K_BANK_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print(response)
                
                if K_DEBUG
                {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_BANK_URL) is \(responseString!)")
                    
                }
                
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    let status = parsedData["status"] as? String
                    print("the status is \(status) that")
                    
                    if status == "success"
                    {
                    if  let result = parsedData["data"] as? [[String:Any]]
                    {
                        completion(result)
                    }
                    else if let result = parsedData["data"] as? [String:Any]
                    {
                          completion(result)
                    }
                    }
                    
                    else
                    {
                        if let resultData = parsedData["data"] as? [String:Any]
                        {
                            if let providerAccountID = resultData["providerAccount"] as? [String:Any]
                            {
                               K_USER_DATA.provideAccountID = providerAccountID["id"] as! Int
                                print("Provider Account id here is \(K_USER_DATA.provideAccountID)")
                            }
                        }
                        
                        
                        let message = parsedData["message"] as? String

                        
                        completion(message)
                    }
                    
                } catch let error as NSError
                {
                    K_USER_DATA.loginTry = "yes"
                    completion("Please Try Again")
                    print(error)
                }
                
        }
    }
    
    
    //MARK:Bank Update LOgin
    
    
    func bankUpdateLogin(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        Alamofire.request(K_BANK_URL, method: .put, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print(response)
                
                if K_DEBUG
                {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_BANK_URL) is \(responseString!)")
                    
                }
                
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    let status = parsedData["status"] as? String
                    print("the status is \(status) that")
                    
                    if status == "success"
                    {
                        if  let result = parsedData["data"] as? [[String:Any]]
                        {
                            completion(result)
                        }
                        else if let result = parsedData["data"] as? [String:Any]
                        {
                            completion(result)
                        }
                    }
                        
                    else
                    {
                        if let resultData = parsedData["data"] as? [String:Any]
                        {
                            if let providerAccountID = resultData["providerAccount"] as? [String:Any]
                            {
                                K_USER_DATA.provideAccountID = providerAccountID["id"] as! Int
                                print("Provider Account id here is \(K_USER_DATA.provideAccountID)")
                            }
                        }
                        
                        
                        let message = parsedData["message"] as? String
                        
                        
                        completion(message)
                    }
                    
                } catch let error as NSError {
                    completion("Please Try Again")
                    print(error)
                }
                
        }
    }

    
    
    
    
    
    
    //MARK:BANK MFA_LOGIN_CHALLENGE
    
    
    
    func bankMFA_LOGIN_CHALLENGE(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        Alamofire.request(K_MFA_CHALLENGE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print(response)
                
                if K_DEBUG
                {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_MFA_CHALLENGE) is \(responseString!)")
                    
                }
                
                
                /*  do {
                 
                 let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                 
                 let status = parsedData["status"] as? String
                 print("the status is \(status) that")
                 
                 if status == "success"
                 {
                 let message = parsedData["message"] as? String
                 
                 
                 completion(message)
                 }
                 
                 else
                 {
                 let message = parsedData["message"] as? String
                 
                 
                 completion(message)
                 }
                 
                 } catch let error as NSError {
                 completion("Please Try Again")
                 print(error)
                 }*/
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    let status = parsedData["status"] as? String
                    print("the status is \(status) that")
                    
                    if status == "success"
                    {
                        if  let result = parsedData["data"] as? [[String:Any]]
                        {
                            completion(result)
                        }
                        else if let result = parsedData["data"] as? [String:Any]
                        {
                            completion(result)
                        }
                        else{
                            completion("success")
                            
                        }
                    }
                        
                    else
                    {
                        if let resultData = parsedData["data"] as? [String:Any]
                        {
                            if let providerAccountID = resultData["providerAccount"] as? [String:Any]
                            {
                                K_USER_DATA.provideAccountID = providerAccountID["id"] as! Int
                                print("Provider Account id here is \(K_USER_DATA.provideAccountID)")
                            }
                        }
                        
                        
                        let message = parsedData["message"] as? String
                        
                        
                        completion(message)
                    }
                    
                } catch let error as NSError
                {
                    //  K_USER_DATA.loginTry = "yes"
                    K_USER_DATA.loginTry = "no"
                    if  K_USER_DATA.bankUpdate == "yes"{
                         completion("Your account has been successfully updated.")
                    }
                    else{
                         completion("Your account has been successfully added.")
                    }
                    
                    print(error)
                }
                
                
        }
    }

   
    
   
    func getAnalytics(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_ANALYTIC_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                   // print(" response for url analytics  is \(responseString)")
                    
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let results = parsedData["data"] as? [String:Any]
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    func getUsers(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_USERS_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_PLAID_CONNECT_URL) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    
    //MARK://INNER CIRCLE ADDED API GET FROM NOTIFICATION REQUEST
    
    func getInnerCircleUserAdded(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_INNERCIRCLE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_INNERCIRCLE) is \(String(describing: responseString))")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    completion(results)
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    //get delete innercircl user
    func getDeleteInnerCircleUser(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_INVITE_DELETE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_INVITE_DELETE_URL) is \(responseString)")
                }
                
                do {
                    print(response)
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        if   let results = parsedData["data"] as? [[String:Any]]{
                            completion(results)
                        }
                        else{
                            if  let status = parsedData ["status"] as? String{
                               completion(status)
                                
                            }
                        }
                    }
                    
                    
                   // let results = parsedData["data"] as! [[String:Any]]
                    
                
                    
                } catch let error as NSError {
                    print(error)
                     completion("")
                }
                
        }
    }
    
    //Mark:Rating api Hit
    
    
    func ratingSubmitted(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_RATE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                                if K_DEBUG {
                                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                                    print(" response for url \(K_RATE) is \(responseString!)")
                                }
                
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        
                        if  let status = parsedData ["status"] as? String
                        {
                            if let message = parsedData ["message"] as? String{
                                if status == "status"
                                {
                                    completion(message)
                                }
                                    
                                else
                                {
                                    completion(message)
                                }
                                
                            }
                        }
                       
                    }
                    
                   // print(parsedData)
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    
                }
                
        }
    }
    
    
    
    
    
    
    func getInnerCircleUser(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_INNERCIRCLESUGGESTION_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                                if K_DEBUG {
                                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                                    print(" response for url \(K_INNERCIRCLESUGGESTION_URL) is \(responseString)")
                                }
                
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                    
                }
                
        }
    }
    // Mark:Inner circle Rating  api
    
    func getInnerCircleRatingReview(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_RATE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
              /*  if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_RATE) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let results = parsedData["data"] as! [[String:Any]]
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                */
                do {
                    
                    if let url = NSURL(string: K_RATE){
                        if let data = try? Data(contentsOf: url as URL){
                            let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                            print(parsedData)
                            let results = parsedData["data"] as! [[String:Any]]
                            completion(results)
                            
                        }
                        else{
                            completion("")
                        }
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
               
        }
    }
// get rating From factual id
    
    func getRating(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_RATE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_RATE) is \(responseString)")
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]{
                        if   let results = parsedData["data"] as? [[String:Any]]
                        {
                         completion(results)
                        }
                        else{
                            completion("")
                        }

                    }
                   
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                    
                }
                
        }
    }
    
    // post flag
    
    func postFlag(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_FLAG, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_RATE) is \(responseString)")
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]{
                        if   let results = parsedData as? [String:Any]
                        {
                            print(results)
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                        
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    
                }
                
        }
    }

    // get rating From factual id
    
    func isRated(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_ISRATED, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_ISRATED) is \(responseString)")
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]{
                        if   let results = parsedData["data"] as? [[String:Any]]
                        {
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                        
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                     completion("")
                    
                }
                
        }
    }

    
    func GetImagesResponse(params:[String:Any],url:String, completion: @escaping (Any) -> Void) {
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
               // print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    //  print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                  //  print(parsedData)//code comment
                   // let results = parsedData["results"] as! [[String:Any]]
                    completion(parsedData)
                    
                    
                    
                } catch let error as NSError {
                   // print(error)
                     completion("")
                }
                
        }
    }

    
    
    
    
    
    func getCuisineDetail(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_CUISINES_DETAIL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                  //  print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)//code comment
                    let results = parsedData["data"] as! [[String:Any]]
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    func getRecommendationDetail(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_RECOMMENDATION_DETAIL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    //  print(" response for url \(K_RECOMMENDATION_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)//code comment
                    let results = parsedData["data"] as! [[String:Any]]
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    //MARK:Transaction Entry
    
    func transactionEntry(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_Transaction_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_Transaction_URL) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let status = parsedData["status"] as? String
                    print("the status is \(status) that")
                    
                    if status == "success"
                    {
                        let message = parsedData["message"] as? String
                        
                        
                        completion(message)
                    }
                        
                    else
                    {
                        let message = parsedData["message"] as? String
                        
                        
                        completion(message)
                    }
                    } catch let error as NSError {
                   // print(error)
                        completion(K_Internet_Message)
                }
                
        }
    }

    //MARK:Transaction count
    
    func transactionCount(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_Transaction_Count, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_Transaction_Count) is \(responseString)")
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        if  let status = parsedData["data"] as? [String: Any]
                        {
                            if let count = status["count"] as? Int
                            {
                                
                                completion(count)
                            }
                        }
                        else{
                            completion(0)
                        }
                    }
                    completion(0)
                }
                catch let error as NSError {
                    print(error)
                }
        }
    }

    
    //Mark: Review Api
    
    
    func ReviewEntrySubmit(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_RATE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_REVIEW_URL) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let status = parsedData["status"] as? String
                    print("the status is \(status) that")
                    
                    if status == "success"
                    {
                        let message = parsedData["message"] as? String
                        
                        
                        completion(message)
                    }
                        
                    else
                    {
                        let message = parsedData["message"] as? String
                        
                        
                        completion(message)
                    }
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }

    
    
 
    
    
    func getInnerCircleUserProfile(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_INNERCIRCLEUSERPROFILE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_INNERCIRCLEUSERPROFILE) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let results = parsedData["data"] as! [String:Any]
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
        }
    }
    func getInnerCircleUserAddedProfile(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_INNERCIRCLEUSERADDEDPROFILE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_INNERCIRCLEUSERADDEDPROFILE) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let results = parsedData["data"] as! [String:Any]
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                     completion("")
                }
        }
    }
    
    
    func setEditDiet(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_DIETLIST_URL, method: .put, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    let results = parsedData["status"] as? [String:Any]
                    print(results)
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    
    
    
    //MARK: Invitation Request and Reject REquest Api in INner Circle
    
    func invitationAcceptApi(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_INVITE_URL, method: .put, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_INVITE_URL) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    
                    let status = parsedData["status"] as? String
                    let message = parsedData["message"] as? String
                    
                    if status == "success"
                    {
                        completion(message!)
                    }
                    else
                    {
                         completion(message!)
                    }
                                       
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }

    
    func notificationInviteStatus(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_Invitestatus, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_NOTIFICATION) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    
                    let status = parsedData["status"] as? String
                    let message = parsedData["message"] as? String
                    
                    if status == "success"
                    {
                        completion(parsedData)
                    }
                    else
                    {
                        completion(message!)
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    
    
    func DeleteNotificationStatus(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_DELETE_NOTIFICATION_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_NOTIFICATION) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    
//                    let status = parsedData["status"] as? String
//                    let message = parsedData["message"] as? String
//                    
//                    if status == "success"
//                    {
//                        completion(parsedData)
//                    }
//                    else
//                    {
                        completion(parsedData)
                 //   }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }

    
    
    
    
    
    func notificationStatusApi(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_NOTIFICATION, method: .put, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_NOTIFICATION) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)
                    
                    
                    let status = parsedData["status"] as? String
                    let message = parsedData["message"] as? String
                    
                    if status == "success"
                    {
                        completion(message!)
                    }
                    else
                    {
                        completion(message!)
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }

    
    
    func getSetting(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_SETTING, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let results = parsedData["data"] as! [[String:Any]]
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    
    //bank_TransactionCount
    
    //MARK:Transaction count
    
    func bankTransactionCount(params:[String:Any],completion: @escaping (Any) -> Void)
    {
        Alamofire.request(K_BANK_Transaction_Count, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_BANK_Transaction_Count) is \(responseString)")
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        if  let status = parsedData["data"] as? [String: Any]
                        {
                            //                            if let count = status["transaction_count"] as? Int
                            //                            {
                            //
                            //                                completion(count)
                            //                            }
                            completion(status)
                        }
                        else{
                            completion(0)
                        }
                    }
                    completion(0)
                }
                catch let error as NSError {
                    //print(error)
                    completion(0)//code added
                }
        }
    }

    func checkDummy(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request("http://34.227.16.30/tasteapp2/api/v1/encrypt", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                      print(" response for url  is \(String(describing: responseString))")

                }

                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        print(parsedData)
                        if  let results = parsedData as?  [String: Any]{
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                //  parsedData["data"]
        }
    }

    
    func getRecentTaste(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_RECENT_TASTE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                     print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)//code comment
                    let results = parsedData["data"] as! [[String:Any]]
                    completion(results)
                    
                } catch let error as NSError {
                    completion("")
                    print(error)
                }
                
        }
    }

    
    func getRecommendation(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_RECOMMENDATION, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                  //  print(" response for url \(K_RECOMMENDATION) is \(responseString)")
                    
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        print(parsedData)
                        if  let results = parsedData as?  [String: Any]{
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
              //  parsedData["data"]
        }
    }
    func getAdminRecommendation(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_ADMIN_RECOMMENDATION, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    //  print(" response for url \(K_RECOMMENDATION) is \(responseString)")
                    
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        print(parsedData)
                        if  let results = parsedData as?  [String: Any]{
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                //  parsedData["data"]
        }
    }

    func checkRecomendationGet(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_CHECK_RECOMENDATION_GET, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    //  print(" response for url \(K_RECOMMENDATION) is \(responseString)")
                    
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        print(parsedData)
                        if  let results = parsedData as?  [String: Any]{
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                //  parsedData["data"]
        }
    }
    
    
    
    func getExploreDetail(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_EXPLORE_DETAIL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
               // print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                  //  print(" response for url \(K_EXPLORE_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                  // print(parsedData)//code comment
                    let results = parsedData["data"] as! [[String:Any]]
                   // print(results)
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }

    
    func inviteEmail(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_INVITE_OVER_EMAIL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_INVITE_OVER_EMAIL) is \(responseString)")
                    
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                        if  let results = parsedData["message"] as? String{
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                     completion("")
                }
        }
    }
    
    func searchRestaurant(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_SEARCH_RESTAURANT, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                //print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                  //  print(" response for url \(K_SEARCH_RESTAURANT) is \(responseString)")
                    
                }
                
                do {
                    
                    if  let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    {
                       // print(parsedData)
                        if  let results = parsedData["data"] as?  Array<Dictionary<String,Any>>{
                            completion(results)
                        }
                        else{
                            completion("")
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }
    func getSearchExploreList(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_SEARCH_FILTER, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                   // print(" response for url \(K_SEARCH_FILTER) is \(responseString)")
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let results = parsedData["data"] as! [String:Any]
                    
                    completion(results)
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
        }
    }
    
    func getViewAll(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_VIEW_ALL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)//code comment
                    let results = parsedData
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    completion("")
                    print(error)
                }
                
        }
    }
    func getAllRecentTasteForMap(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_ALL_RECENT_TASTE_FOR_MAP, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_CUISINES_DETAIL) is \(responseString)")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)//code comment
                    let results = parsedData["data"] as! [[String:Any]]
                    completion(results)
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
        }
    }
    
    func getNotificationCount(params:[String:Any],completion : @escaping (Any) -> Void)
    {
        
        Alamofire.request(K_NOTIFICATION_COUNT, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    if let results = parsedData["data"] as? NSDictionary{
                        // let val_count = results["count"] as! NSNumber
                        // print("BBB",val_count)
                        // K_INNERUSER_DATA.notificationCount = Int(val_count)
                        
                        completion(results as NSDictionary)
                    }
                    else{
                        completion("")
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion("")
                }
                
        }
    }

    
    func getGraphData(params:[String:Any],completion: @escaping (Any) -> Void) {
        Alamofire.request(K_GET_GRAPH_DATA, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response
            { (response) in
                print(response)//code comment
                
                if K_DEBUG {
                    let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(" response for url \(K_CUISINES_DETAIL) is \(String(describing: responseString))")//code comment
                }
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(parsedData)//code comment
                     let status = parsedData["status"] as! String
                    if status != "fail"{
                        let results = parsedData["data"] as! [String:Any]
                        completion(results)
                    }
                    

                    
                    
                    
                } catch let error as NSError {
                     completion("")
                    print(error)
                }
                
        }
    }
    


}

