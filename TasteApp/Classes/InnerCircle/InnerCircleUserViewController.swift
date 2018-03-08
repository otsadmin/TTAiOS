//
//  InnerCircleUserViewController.swift
//  TasteApp
//
//  Created by Mohit Deval on 06/04/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import  SVProgressHUD
import Kingfisher

extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength()
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.characters.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.characters.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.characters.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSFontAttributeName: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSFontAttributeName: moreTextFont, NSForegroundColorAttributeName: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    func vissibleTextLength() -> Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSFontAttributeName: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [String : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.characters.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.characters.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [String : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.characters.count
    }
}


class InnerCircleUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var pageNo = 1
    var isloading  = true
    var RatingFilter = [[String:Any]]()
    var RatingPageFilter = [[String:Any]]()
    var cellCount = [[String:Any]]()
    var DataRespose: NSDictionary = NSDictionary()
    var PhotoRefArray = [[String:Any]]()
    var screenName :String?
    
    @IBOutlet weak var tableInnerView: UITableView!
    
    @IBOutlet weak var ratingview: CosmosView!
    
    @IBOutlet weak var viewshadow: UIView!
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var btnBackClicked: UIImageView!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var lblPhone: UILabel!
    
    
    @IBOutlet weak var lblHours: UILabel!
    
    @IBOutlet weak var lblWebsite: UILabel!
    
    
    @IBOutlet weak var lblcuisine: UILabel!
    
    @IBOutlet weak var lblrating: UILabel!
    
    
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var lblprice: UILabel!
    @IBOutlet weak var lblRestaurant: UILabel!
    
    
    let textLabel = ["Jordan Smith", "Jordan Smith", "Jordan Smith", "Jordan Smith" ,"Jordan Smith" , "Jordan Smith" , "Jordan Smith"]
    
    let subLabel = ["Sales Assoc. at Google", "Sales Assoc. at Google", "Sales Assoc. at Google", "Sales Assoc. at Google" ,"Sales Assoc. at Google" , "Sales Assoc. at Google" , "Sales Assoc. at Google"]
    
    let ratingLabel = ["1", "2", "3", "4" ,"5" , "5" , "6"]
    
    let cellReuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //           let countryZip =  K_INNERUSER_DATA.State + " " +  K_INNERUSER_DATA.ZIP
        //         let city = K_INNERUSER_DATA.CITY
        //        let array = [K_INNERUSER_DATA.Address,city,countryZip]
        //        K_INNERUSER_DATA.Address =  array.joined(separator: "\n")
        //        lblAddress.text = K_INNERUSER_DATA.Address
        //        lblPhone.text = K_INNERUSER_DATA.Phone
        //        lblWebsite.text = K_INNERUSER_DATA.Website
        //  let rating = self.cuisinesFilter[self.j]["rating"] as? NSNumber
        if let rat_value = K_INNERUSER_DATA.Rating as? String {
            self.ratingview.rating = Double(rat_value)!
            self.ratingview.settings.updateOnTouch = false
        }
        else{
            self.ratingview.rating = 0
            self.ratingview.settings.updateOnTouch = false
        }
        
        
        lblcuisine.text = K_INNERUSER_DATA.CuisinSeleted
        //      lblprice.text = K_INNERUSER_DATA.Price
        //   lblHours.text = K_INNERUSER_DATA.Hours
        lblRestaurant.text = K_INNERUSER_DATA.RestaurantName
        //
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(K_INNERUSER_DATA.Photo_Ref)&key=\(GOOGLE_APIKEY)")!
        //print("Url Is Final",url)
        
        let bannerUrl = "\(K_INNERUSER_DATA.Photo_Ref)"
        
        self.imageMain.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
        self.imageMain.clipsToBounds = true
        self.imageMain.contentMode = UIViewContentMode.scaleAspectFill
        
        self.viewshadow.alpha = 0.50
        var X_Axis: Int =  94
        if K_INNERUSER_DATA.Price.characters.count > 0{
            if let priceval = K_INNERUSER_DATA.Price as? String{
                
                var valPrice:Int? = Int(K_INNERUSER_DATA.Price)
                print(valPrice)
                for i in 0..<Int(valPrice!) {
                    let lblNew = UILabel()
                    lblNew.frame.size.width = 30
                    lblNew.frame.size.height = 30
                    lblNew.frame.origin.x = (CGFloat(X_Axis))
                    lblNew.frame.origin.y = 163
                    lblNew.text = "$"
                    lblNew.textColor = UIColor.white
                    X_Axis += 13
                    //  lblNew.translatesAutoresizingMaskIntoConstraints = false
                    self.viewshadow.addSubview(lblNew)
                    
                }
                
                
            }
        }else{
            //            let lblNew = UILabel()
            //            lblNew.frame.size.width = 30
            //            lblNew.frame.size.height = 30
            //            lblNew.frame.origin.x = (CGFloat(X_Axis))
            //            lblNew.frame.origin.y = 163
            //            lblNew.text = "$"
            //            lblNew.textColor = UIColor.white
            //            X_Axis += 13
            //            //  lblNew.translatesAutoresizingMaskIntoConstraints = false
            //            self.viewshadow.addSubview(lblNew)
        }
        btnBackClicked.isUserInteractionEnabled = true
        btnBackClicked.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        
        self.ParseGooglePlaceDetails()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.getRatingLoad()
        self.table_view.reloadData()
    }
    
    @IBAction func btnReadMoreClicked(_ sender: Any)
    {
        //InnerCircleReviewList
        
        /*   let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleReviewList")
         self.navigationController?.pushViewController(vc, animated: true)
         */
    }
    
    
    
    
    @IBAction func btnReviewClicked(_ sender: Any)
        
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RatingViewController")
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
    
    
    
    func goBack()
    {

        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"NotificationDiningUserProfile")
        nc.post(name:myNotification,
                object: nil,
                userInfo:["message":true])
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func ParseGooglePlaceDetails (){
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false//code added
        //        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=500&key=AIzaSyCm85ozJlxVBdYdr_GEhsy0Fi7lHvbKvhA"
        
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(K_INNERUSER_DATA.placeId)&key=\(GOOGLE_APIKEY)"
        
        let paramString = ["query":"ABC", "location": "", "radius":"500", "type": "restaurant","keyword":"cruise","key":"\(GOOGLE_APIKEY)"] as [String : Any]
        let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        // print("-------Url",UrlTrimString)
        DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
            if let dataDic = response as? [String:Any]
            {
                
                // print("Respomse", dataDic)
                
                //         for ResponseCount in responce{
                
                self.DataRespose = (response as? NSDictionary)!
                if let dataResponce = (response as AnyObject).object(forKey: "result"){
                    
                    let resultArray = dataResponce as! NSDictionary
                    
                    if resultArray.count > 0 {
                        
                        
                        
                        if let photosDict = resultArray.object(forKey: "photos"){
                            
                            let photosArray = photosDict as! NSArray
                            
                            for var i in 0..<photosArray.count  {
                                
                                
                                let photoDict = photosArray[i] as! NSDictionary
                                
                                
                                
                                if let photo_reference = photoDict.object(forKey: "photo_reference"){
                                    
                                    
                                    let PhotoRef = photo_reference as! String
                                    //   K_GoogleImagesData.ImagesDataArray.append(PhotoRef)
                                    
                                    var content = Dictionary<String,Any>()
                                    content.updateValue(PhotoRef, forKey: "Photo_Ref")
                                    //  content.updateValue(NameOfRest, forKey: "NameOfRest")
                                    
                                    
                                    self.PhotoRefArray.append(content)
                                    // call this after you update
                                    
                                    
                                    
                                    // print("PhotoRef : \(PhotoRef)")
                                    
                                }
                                
                                
                                
                            }
                            //print("PhotoRefArray :",self.PhotoRefArray)
                        }
                        
                        
                        if let photosDict = resultArray.object(forKey: "reviews"){
                            
                            
                            
                            
                            let photosArray = photosDict as! NSArray
                            
                            
                            
                            
                            
                            self.cellCount = photosArray as! [[String : Any]]
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true //code added
                            if photosArray.count > 0 {
                                
                                
                                let photoDict = photosArray[0] as! NSDictionary
                                
                                
                                // print("PhotoRef : \(photoDict)")
                                if let author_name = photoDict.object(forKey: "author_name"){
                                    
                                    
                                    let AuthorName = author_name as! String
                                    
                                    // print("PhotoRef : \(AuthorName)")
                                    
                                }
                                if let Profile_photo = photoDict.object(forKey: "profile_photo_url"){
                                    
                                    
                                    let profilePhoto = Profile_photo as! String
                                    
                                    //  print("PhotoRef : \(profilePhoto)")
                                    self.table_view.reloadData()
                                }
                                if let User_Rating = photoDict.object(forKey: "rating"){
                                    
                                    
                                    //                                let UserRating = User_Rating as! intmax_t
                                    //
                                    //                                print("PhotoRef : \(UserRating)")
                                    
                                }
                                if let Time_Description = photoDict.object(forKey: "relative_time_description"){
                                    
                                    
                                    let timedescription = Time_Description as! String
                                    
                                    //   print("PhotoRef : \(timedescription)")
                                    
                                }
                            }
                        }
                    }
                }
                self.table_view.reloadData()
                self.view.isUserInteractionEnabled = true //code added
            }
            
        })
    }
    
    // MARK: - TABLEVIEW DATASOURCE METHODS

    func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // print("----",section);
        // return self.textLabel.count
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return self.RatingFilter.count
        }
            
        else  {
            return self.cellCount.count
        }
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath)
        
         if indexPath.row > 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFour", for: indexPath) as UITableViewCell
            return cell
        }
        
        
        // print("----",indexPath.row);
        //  HeaderCell.lblAddress.text = "Header View Data"
        
        //        InnerCircleCell.titleLable.text = "Mohit Deval"
        //        InnerCircleCell.titleSubLable.text = "Gurgaon"
        
        if indexPath.section == 0 {
            let HeaderCell = tableView.dequeueReusableCell(withIdentifier: "ProfilecousineCellID", for: indexPath) as! ProfilecousineCell
            HeaderCell.lblAddress.text = K_INNERUSER_DATA.Address + ", " + K_INNERUSER_DATA.CITY + ", " + K_INNERUSER_DATA.State
            HeaderCell.objCall .setTitle(K_INNERUSER_DATA.Phone, for: UIControlState.normal)
            HeaderCell.objGoToBrowser .setTitle(K_INNERUSER_DATA.Website, for: UIControlState.normal)
            HeaderCell.lblHour.text = K_INNERUSER_DATA.Hours
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(K_INNERUSER_DATA.Photo_Ref)&key=AIzaSyCm85ozJlxVBdYdr_GEhsy0Fi7lHvbKvhA")!
            // print("Url Is Final",url)
            
            let bannerUrl = "\(K_INNERUSER_DATA.Photo_Ref)"
            HeaderCell.imageviewheader.layer.cornerRadius = 5
            HeaderCell.imageviewheader.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
            HeaderCell.imageviewheader.clipsToBounds = true
            HeaderCell.imageviewheader.contentMode = UIViewContentMode.scaleAspectFill
            return HeaderCell
            
        }
        else if indexPath.section == 1 {
            let InnerCircleCell = tableView.dequeueReusableCell(withIdentifier: "AddToInnerCircleCellID", for: indexPath) as! AddToInnerCircleCell
            InnerCircleCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if indexPath.row == 0{
                InnerCircleCell.lblInnerHeading.text = "Inner Circle Reviews"
            }else{
                InnerCircleCell.lblInnerHeading.text = ""
            }
            
            if let userProfileDic  = self.RatingFilter[indexPath.row]["user_profile"] as? [String:Any]{
                var name = ""
                if let imageURL = userProfileDic["image"] as? String{
                    if (imageURL.characters.count) > 0
                    {
                        //                         InnerCircleCell.innerimageview.kf.setImage(with: URL(string:K_IMAGE_BASE_URL + imageURL))
                        InnerCircleCell.innerimageview.layer.borderWidth = 1
                        InnerCircleCell.innerimageview.layer.masksToBounds = false
                        //  InnerCircleCell.innerimageview.layer.borderColor =  UIColor bla
                        InnerCircleCell.innerimageview.layer.cornerRadius = 65/2
                        InnerCircleCell.innerimageview.clipsToBounds = true
                        
                        InnerCircleCell.innerimageview.sd_setImage(with: URL(string: K_IMAGE_BASE_URL + imageURL), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                    }
                    
                    //  InnerCircleCell.innerimageview.imageUser.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
                }
                if let firstName  = userProfileDic["firstname"] as? String{
                    name = firstName
                }
                if let lastName  = userProfileDic["lastname"] as? String{
                    // InnerCircleCell.titleLabel.text = name + " " + lastName
                    InnerCircleCell.titleLable.text = name + " " + lastName
                }
                if let designation  = userProfileDic["designation"] as? String{
                    //  InnerCircleCell.titleSubLabel.text = designation
                    InnerCircleCell.titleSubLable.text = designation
                }
                
            }
            if let  rating =  self.RatingFilter[indexPath.row]["rate"] as? String{
                if rating.hasPrefix("yes"){
                    InnerCircleCell.ratingimageview.image = UIImage(named: "like")
                }
                else{
                    InnerCircleCell.ratingimageview.image = UIImage(named: "unlike")
                }
                
                //  cell.titleRating.text = rating
            }
            if let  message =  self.RatingFilter[indexPath.row]["message"] as? String{
                //    InnerCircleCell.descriptiontext.isUserInteractionEnabled = false
                
                InnerCircleCell.descriptiontext.text = message
                InnerCircleCell.descriptiontext.numberOfLines = 2;
                //                InnerCircleCell.descriptiontext.textContainer.lineBreakMode = NSLineBreakMode.byClipping;
                
                
                if message.count > 51{
                    
                    let readmoreFont = UIFont.systemFont(ofSize: 14)
                    let readmoreFontColor = UIColor.blue
                    DispatchQueue.main.async {
                        InnerCircleCell.descriptiontext?.addTrailing(with: "...", moreText: "Read more", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                    }
                    
                }
                
                
                
                
                //  InnerCircleCell.descriptiontext.isEditable = false
            }
            
            return InnerCircleCell
        }
        else {
            let InnerCircleGoogleReview = tableView.dequeueReusableCell(withIdentifier: "InnerCircleGoogleReviewCellID", for: indexPath) as! InnerCircleGoogleReviewCell
            
            
            if indexPath.row == 0 {
                InnerCircleGoogleReview.googleReviewHeading.text = "Google Reviews"
            }
            else{
                InnerCircleGoogleReview.googleReviewHeading.text = " "
            }
            if let dataResponce = self.DataRespose.object(forKey: "result"){
                
                let resultArray = dataResponce as! NSDictionary
                
                if resultArray.count > 0 {
                    
                    
                    if let photosDict = resultArray.object(forKey: "reviews"){
                        
                        let photosArray = photosDict as! NSArray
                        
                        if photosArray.count > 0 {
                            
                            let photoDict = photosArray[indexPath.row] as! NSDictionary
                            
                            
                            // print("PhotoRef : \(photoDict)")
                            if let author_name = photoDict.object(forKey: "author_name"){
                                
                                
                                let AuthorName = author_name as! String
                                InnerCircleGoogleReview.lblTitle.text = AuthorName
                                
                                //  print("PhotoRef : \(AuthorName)")
                                
                            }
                            if let Profile_photo = photoDict.object(forKey: "profile_photo_url"){
                                
                                
                                let profilePhoto = Profile_photo as! String
                                InnerCircleGoogleReview.imageUser.sd_setImage(with: URL(string: profilePhoto), placeholderImage: UIImage(named: " "))
                                //  print("PhotoRef : \(profilePhoto)")
                                
                            }
                            if let text_desc = photoDict.object(forKey: "text"){
                                
                                
                                let textdata = text_desc as! String
                                
                                // print("PhotoRef : \(textdata)")
                                InnerCircleGoogleReview.Descriptiontext.text = textdata
                                InnerCircleGoogleReview.Descriptiontext.numberOfLines = 2;
                                //                                InnerCircleGoogleReview.Descriptiontext.textContainer.lineBreakMode = NSLineBreakMode.byClipping;
                                
                                if textdata.count > 51{
                                    
                                    let readmoreFont = UIFont.systemFont(ofSize: 14)
                                    let readmoreFontColor = UIColor.blue
                                    DispatchQueue.main.async {
                                        InnerCircleGoogleReview.Descriptiontext?.addTrailing(with: "...", moreText: "Read more", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                                    }
                                }
                                
                                
                                
                            }
                            if let user_rating = photoDict.object(forKey: "rating"){
                                
                                
                                let Rating = user_rating as? NSNumber
                                
                                
                                // print("PhotoRef : \(Rating)")
                                //        InnerCircleGoogleReview.titleRatingValue.text = Rating?.stringValue
                                InnerCircleGoogleReview.ratingbyGoogle.rating = Rating as! Double
                                InnerCircleGoogleReview.ratingbyGoogle.settings.updateOnTouch = false
                                InnerCircleGoogleReview.ratingbyGoogle.settings.starMargin = 2
                                InnerCircleGoogleReview.ratingbyGoogle.settings.starSize = 15
                            }
                            
                            if let Time_Description = photoDict.object(forKey: "relative_time_description"){
                                
                                
                                let timedescription = Time_Description as! String
                                
                                //    print("PhotoRef : \(timedescription)")
                                
                            }
                        }
                    }
                }
            }
            
            
            return InnerCircleGoogleReview
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 165
        }
        else if indexPath.section == 1 {
            return 150
        }
        else{
            return 150
        }
        
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if indexPath.row == 0 {
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let vc = storyboard.instantiateViewController(withIdentifier: "RastaurantImageViewController")
        //            self.navigationController?.pushViewController(vc, animated: true)
        //
        //        }
        // print("You tapped cell number \(indexPath.row).")
        
        
        
        //InnerCircleReviewList
        
        //          let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //         let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleReviewList")
        //         self.navigationController?.pushViewController(vc, animated: true)
        
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RReviewViewController") as! RReviewViewController
        if indexPath.section == 0 {
            return
        }
        else if indexPath.section == 1 {
            vc.recieveDataDict = self.RatingFilter[indexPath.row]
            vc.fromGoogle = "no"
        }
            
        else  {
            vc.recieveDataDict = self.cellCount[indexPath.row]
            vc.fromGoogle = "yes"
        }

        if let resName = lblRestaurant.text{
            vc.restaurantName = resName
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - GET RATING FOR RESTAURANTS
    func getRatingLoad(){
        if Reachability.isConnectedToNetwork() == true
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            let parameter = ["factual_id":K_INNERUSER_DATA.FactualId,"page":self.pageNo,"user_id":singelton.loginId] as [String : Any]
             print(parameter)
            
            DataManager.sharedManager.getRating(params: parameter) { (response) in
                
                self.table_view.reloadData()
                if let dataDic = response as? [[String:Any]]
                {
                     print(dataDic)
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    

                    for dict in dataDic{
                        
                        var orderNum:NSNumber? = dict["flag_count"] as? NSNumber
                        var orderNumberInt:Int?  = (orderNum != nil) ? Int(orderNum!) : nil
                        print(orderNumberInt ?? 100)
                        if orderNumberInt!  < 5{
                            self.RatingFilter.append(dict)
                        }
                    }
                    self.table_view.reloadData()
                    
                    
//                    self.RatingPageFilter = dataDic
//                    if self.RatingPageFilter.count > 0
//                    {
//                        self.RatingFilter.append(contentsOf: self.RatingPageFilter)
//                        self.table_view.reloadData()
//                    }
                    
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
            }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        self.RatingFilter.removeAll()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func CallAction(_ sender: Any) {
        let charsToRemove: Set<Character> = Set("()+-".characters)
        let newNumberCharacters = String(K_INNERUSER_DATA.Phone.characters.filter { !charsToRemove.contains($0) })
        
        let nonWhiteCharacters = newNumberCharacters.unicodeScalars.filter {
            false == NSCharacterSet.whitespacesAndNewlines.contains($0)
            }.map(Character.init)
        let whitespacelessNumber = String(nonWhiteCharacters)
        if let phoneCallURL = NSURL(string: "tel:\(whitespacelessNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL as URL) {
                application.openURL(phoneCallURL as URL)
            }
            else{
                //  print("failed")
            }
        }
        
    }
    @IBAction func ActionNavigate(_ sender: Any) {
        let singelton = SharedManager.sharedInstance
        
        let url = "http://maps.apple.com/maps?saddr=\(singelton.latValueInitial),\(singelton.longValueInitial)&daddr=\(K_INNERUSER_DATA.latvalueNavigate),\(K_INNERUSER_DATA.longvalueNavigate)"
        
  //  let url = "http://maps.apple.com/maps?saddr=\(K_INNERUSER_DATA.latvalueNavigate),\(K_INNERUSER_DATA.longvalueNavigate)&daddr=\(K_INNERUSER_DATA.latvalueNavigate),\(K_INNERUSER_DATA.longvalueNavigate)"
        
        print(url)
        
        
        UIApplication.shared.openURL(URL(string:url)!)
    }
    @IBAction func GoToGallery(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RastaurantImageViewController") as! RastaurantImageViewController
        vc.PhotoRefArrayGet = self.PhotoRefArray
        // print(self.PhotoRefArray)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func BrowserAction(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: K_INNERUSER_DATA.Website)! as URL)
        
        
    }
}
