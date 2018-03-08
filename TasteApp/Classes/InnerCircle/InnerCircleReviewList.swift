//
//  InnerCircleReviewList.swift
//  Taste
//
//  Created by Lalitmohan on 5/30/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import  Alamofire
import Kingfisher
import CoreLocation

class InnerCircleReviewList: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //  @IBOutlet weak var tblGoogleReview: UITableView!
    @IBOutlet weak var tblInnerView: UITableView!
    
    //inner circle data
    var innerCircleReview=["1","2"]
    
    let textLabel = ["Jordan Smith", "Jordan Smith"]
    
    let subLabel = ["Sales Assoc. at Google", "Sales Assoc. at Google"]
    
    let ratingLabel = ["1", "2"]
    
    //google review data
    var googleReview=["1","2","3","4"]
    let textLabelGoogleReview = ["Jordan Smith","Jordan Smith", "Jordan Smith","Jordan Smith"]
    
    let subLabelGoogleReview = ["Sales Assoc. at Google","Sales Assoc. at Google", "Sales Assoc. at Google", "Sales Assoc. at Google"]
    
    let ratingLabelGoogleReview = ["3","1", "2", "3"]
    
    let cellReuseIdentifier = "Cell"
    //for getting rate review dictionary
    var ratingList = [[String:Any]]()
    
    let dataProvider = GoogleDataProvider()
     var searchedTypes = ["restaurant"]
     let searchRadius: Double = 1000
    @IBAction func btnBackClicked(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        tblInnerView.dataSource = self
        tblInnerView.delegate = self
        SVProgressHUD.show()
        
        let parameter=["ID":"EV__uk8I8rfB8Q33ClzONkjvhiXB_nlsUPd1QIdvCWjY_krQuaZ8Vr5NYyBvv27FYQnUbf4jfxYU24gtImxOQg"] as [String : Any]
        DataManager.sharedManager.getInnerCircleRatingReview(params: parameter) { (response) in
            if let dataDic = response as? [[String:Any]]
            {
                var rating = [[String:Any]]()
                rating = dataDic
                self.ratingList=rating
                
                if self.ratingList.count > 0
                {
                    
                    self.tblInnerView.dataSource = self
                    self.tblInnerView.delegate = self
                    
                    self.tblInnerView.reloadData()
                }
                else
                {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
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
                else{
                    SVProgressHUD.dismiss()
                    
                    let alert = UIAlertController(title: "Taste", message:"Something Unexpected Happened.", preferredStyle: UIAlertControllerStyle.alert)
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
    
    //Mark:TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 1
        
        //        if innerCircleReview.count>5 {
        //            count=1
        //            return count
        //        }
        //        else if googleReview.count>=0 && innerCircleReview.count>=0{
        //            count=2
        //        }
        //
        if self.ratingList.count>0
        {
            count=1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count:Int?
        
        if section==0
        {
            count=self.ratingList.count
        }
        //        else if section==1
        //        {
        //            count=googleReview.count
        //        }
        return count!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell1 = tableView.dequeueReusableCell(withIdentifier:"Cell1") as! InnerCircleReviewCell
        
        if indexPath.section==0
        {
            if self.ratingList.count>=0
            {
                cell1.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                if indexPath.row<1 {
                    cell1.reviewHeading.text="Inner Circle Reviews"
                }
                else{
                    cell1.reviewHeading.text=""
                }
                
                var rate = [String: Any]()
                
                rate =  self.ratingList [indexPath.row]["rate"] as! [String: Any]
                cell1.titleText.text = (rate["firstname"] as? String)! + " " + (rate["lastname"] as? String)!
                cell1.subTitleText.text = (rate["company_name"] as? String)
               // let url = URL(string: (rate["image"] as? String)!)
                
                cell1.imageView?.layer.cornerRadius = 25
                 cell1.imageView?.clipsToBounds = true
                
                let size = CGSize(width: 83, height: 77)
                let processImage = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
               
                    cell1.imageView?.kf.setImage(with:URL(string:(rate["image"] as? String)!), placeholder: UIImage(named: "profile"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
                
                
                

                cell1.ratingValue.text = rate["rate"] as? String
                cell1.descriptionText.text = rate["message"] as? String
              
                
                
            }
            else
            {
                if self.ratingList.count>indexPath.row
                {
                    
                    if  indexPath.row<1 {
                        cell1.reviewHeading.text="Inner Circle Reviews"
                    }
                    else{
                        cell1.reviewHeading.text=""
                    }
                    var rate = [String: Any]()
                    
                    rate =  self.ratingList [indexPath.row]["rate"] as! [String: Any]
                    cell1.titleText.text = (rate["firstname"] as? String)! + " " + (rate["lastname"] as? String)!
                    cell1.subTitleText.text = (rate["company_name"] as? String)
                    let url = URL(string: (rate["image"] as? String)!)
                    cell1.imageView?.kf.setImage(with: url)
                    cell1.ratingValue.text = rate["rate"] as? String
                    cell1.descriptionText.text = rate["message"] as? String
                    
                    cell1.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                    
                    if self.ratingList.count-1==indexPath.row
                    {
                        cell1.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
                    }
                }
            }
            return cell1
            
        }
        else if indexPath.section==1{
            let cell2=tableView.dequeueReusableCell(withIdentifier: "Cell2")as!InnerCircleGoogleReviewCell
            
            cell2.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
            
            if  indexPath.row<1 {
                cell2.googleReviewHeading.text="Google Reviews"
            }
            else{
                cell2.googleReviewHeading.text=""
            }
            
          //  cell2.titleLabel.text = textLabelGoogleReview[indexPath.row]
            cell2.titleRatingValue.text = ratingLabelGoogleReview[indexPath.row]
            return cell2
        }
        
        return cell1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 230
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
        if tableView == self.tblInnerView
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:"InnerCircleDetailReview") as!
            InnerCircleDetailReview
            if indexPath.section==0{
              if let cell = tableView.cellForRow(at: indexPath) as? InnerCircleReviewCell
              {
                if let text = cell.titleText.text, !text.isEmpty{
                    vc.updateTitleLabel=cell.titleText.text
                    
                }
                else{
                     vc.updateTitleLabel=""
                }
                
                if let text = cell.subTitleText.text, !text.isEmpty{
                    vc.updateDesignationLabel=cell.subTitleText.text
                    
                }
                else{
                    vc.updateDesignationLabel=""
                }
                
                if let text = cell.descriptionText.text, !text.isEmpty{
                    vc.updateDescriptionLabel=cell.descriptionText.text
                    
                }
                else{
                    vc.updateDescriptionLabel=""
                }
               
                
                if let text = cell.ratingValue.text, !text.isEmpty{
                    vc.updateRatingLabel=cell.ratingValue.text
                    
                }
                else{
                    vc.updateRatingLabel=""
                }
//                if ((cell.imageView?.image) != nil){
//                    vc.imageview.image=cell.imageView?.image
//                }
//                else
//                {
//                    vc.imageview.image=UIImage(named: "profile")
//                }
                
//                if (cell.imageView?.image) != nil{
//                     vc.imageview.image=cell.imageView?.image
//                }
//                else{
//                     vc.imageview.image=UIImage(named: "profile")
//                }
////                vc.updateDesignationLabel=cell.subTitleText.text!
//                vc.updateDescriptionLabel=cell.descriptionText.text!
//                vc.updateRatingLabel=cell.ratingValue.text!
////                vc.imageview.image=cell.imageView?.image
              }
            
            }
           
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else
            
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:"InnerCircleDetailReview") as! InnerCircleDetailReview
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
        
        
    }
    
//    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
//       
//        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
//            for place: GooglePlace in places {
//                let marker = PlaceMarker(place: place)
//                marker.map = self.mapView
//            }
//        }
//    }

    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }
    
    
    
}
