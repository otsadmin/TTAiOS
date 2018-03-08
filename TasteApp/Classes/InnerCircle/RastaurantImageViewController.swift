//
//  RastaurantImageViewController.swift
//  Taste
//
//  Created by Lalitmohan on 6/2/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class RastaurantImageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    @IBOutlet weak var collectionView: UICollectionView!
    var PhotoRefArrayGet = [[String:Any]]()
    let identifier = "Cell"
    var addval :Int = 0
    var setleftLabel :Int = 1
    @IBOutlet weak var lblright: UILabel!
    @IBOutlet weak var lblleft: UILabel!
    @IBOutlet weak var lblrestName: UILabel!
    @IBOutlet weak var imageviewGallery: UIImageView!
    @IBOutlet weak var objLeftBtn: UIButton!
    
    @IBOutlet weak var lblOf: UILabel!
    @IBOutlet weak var lblNoImage: UILabel!
    
    @IBOutlet weak var objRightBtn: UIButton!
    var images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04","dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04","dummy-img01", "dummy-img02"]
    
    
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
        if     setleftLabel <= self.PhotoRefArrayGet.count  {
            let imageval =  (self.PhotoRefArrayGet[addval] ["Photo_Ref"] as! String)
            
            self.lblleft.text = String(setleftLabel)
            
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(imageval)&key=\(GOOGLE_APIKEY)")!
            print("Url Is Final",url)
            
            let bannerUrl = "\(url)"
            
            imageviewGallery.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
            imageviewGallery.clipsToBounds = true
            imageviewGallery.contentMode = UIViewContentMode.scaleAspectFit
            if setleftLabel == self.PhotoRefArrayGet.count{
                
            }else{
                addval += 1
                setleftLabel += 1
            }
            
        }else{
            
        }
        
        
    }
    
    @IBAction func LeftAction(_ sender: Any) {
        if setleftLabel >= 1 {
            
            self.lblleft.text = String(setleftLabel)
            let imageval =  (self.PhotoRefArrayGet[addval] ["Photo_Ref"] as! String)
            
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(imageval)&key=\(GOOGLE_APIKEY)")!
            print("Url Is Final",url)
            
            let bannerUrl = "\(url)"
            
            imageviewGallery.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
            imageviewGallery.clipsToBounds = true
            imageviewGallery.contentMode = UIViewContentMode.scaleAspectFit
            if setleftLabel == 1{
                
            }else{
                addval -= 1
                setleftLabel -= 1
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblrestName.text =  K_INNERUSER_DATA.RestaurantName
        self.lblNoImage.isHidden =  true
        if self.PhotoRefArrayGet.count == 0 {
            self.lblNoImage.isHidden =  false
            self.lblleft.isHidden = true
            self.lblright.isHidden = true
            self.lblOf.isHidden = true
            self.objLeftBtn.isHidden = true
            self.objRightBtn.isHidden = true
        }
        
//        self.lblright.text = String(self.PhotoRefArrayGet.count)
//        self.lblleft.text = String(setleftLabel)
//        if self.PhotoRefArrayGet.count > 0{
//            let imageval =  (self.PhotoRefArrayGet[addval] ["Photo_Ref"] as! String)
//            
//            
//            
//            let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(imageval)&key=\(GOOGLE_APIKEY)")!
//            print("Url Is Final",url)
//            
//            let bannerUrl = "\(url)"
//            
//            imageviewGallery.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
//            imageviewGallery.clipsToBounds = true
//            imageviewGallery.contentMode = UIViewContentMode.scaleAspectFit
//        }
//        else{
//            
//        }
        
        //  cell.lblRestName.text = K_INNERUSER_DATA.RestaurantName
        
        
        
        // self.countGoogleApiHit()
    }
    
    
    //    func countGoogleApiHit(){
    //
    //            // self.GoogleApi()
    //
    //            //    if let parameterGoogle = ArrCount as? String{
    //
    //
    //
    //
    //
    //
    //
    //                let lat_long = "\(K_INNERUSER_DATA.latvalueNavigate),\(K_INNERUSER_DATA.longvalueNavigate)"
    //             let address = "\(K_INNERUSER_DATA.name)+\(K_INNERUSER_DATA.cityname)"
    //
    //                let paramString = ["query":address, "location": lat_long, "radius":"500", "type": "restaurant","keyword":"cruise","key":"AIzaSyBWZ0-N1ry6uluUKonnKy5c2ECnA6QqfHs"] as [String : Any]
    //                print(paramString.count)
    //                // Attach Credit Card By krish AIzaSyBf5p8z9QCBLh2re71V8bo-xB_cpoqcNmU
    //                //AIzaSyBEnLvlTUqZ6dtC9zsgBOQ7nGj8f60vWfU
    //
    //                // AIzaSyCljFU99JMokpxVF7HeiC5pd-xv_g_K9Y4
    //                //let finalParam = paramString[0]["location"]
    //                //      print(paramString)
    //                //  AIzaSyCAgXgLuxmTOHn3ZIq5oJDmxQEep8vWZSU    AIzaSyAddgvNRIZUZOTHXIfbHO7Hp8lBLwh-0W8
    //                //AIzaSyCm85ozJlxVBdYdr_GEhsy0Fi7lHvbKvhA //using
    //                //   AIzaSyBWZ0-N1ry6uluUKonnKy5c2ECnA6QqfHs
    //                //AIzaSyCAtwlpNYCaCnkro25MpQ6c8Xq9jEg9CZk
    //                //  AIzaSyAddgvNRIZUZOTHXIfbHO7Hp8lBLwh-0W8
    //                let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(address)&location=\(lat_long)&radius=500&key=AIzaSyCm85ozJlxVBdYdr_GEhsy0Fi7lHvbKvhA"
    //                let UrlTrimString = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    //
    //
    //
    //
    //
    //                print("-------Print Request Url",UrlTrimString)
    //
    //                DataManager.sharedManager.GetImagesResponse(params: paramString,url: UrlTrimString , completion: { (response) in
    //                    if let dataDic = response as? [String:Any]
    //                    {
    //
    //
    //
    //                        print("Respomse", dataDic)
    //
    //                        //         for ResponseCount in responce{
    //
    //
    //                        if let dataResponce = (response as AnyObject).object(forKey: "results"){
    //
    //                            let resultArray = dataResponce as! NSArray
    //
    //                            var contentRes = Dictionary<String,Any>()
    //                            contentRes.updateValue(resultArray, forKey: "RefResults")
    //
    //                        //    self.RestaurantResultArray.append(contentRes)
    //                            if resultArray.count > 0 {
    //
    //
    //
    //                                let arrayDict = resultArray[0] as! NSDictionary
    //                                var NameOfRest = ""
    //                                if let Rest_name = arrayDict.object(forKey: "name"){
    //                                    NameOfRest = Rest_name as! String
    //                                    print("Rest Name is", NameOfRest)
    //                                }
    //
    //                                if let photosDict = arrayDict.object(forKey: "photos"){
    //
    //                                    let photosArray = photosDict as! NSArray
    //                                    for var i in 0..<photosArray.count  {
    //
    //
    //
    //                                    let placeId = arrayDict.object(forKey: "place_id")
    //
    //
    //                                    print("place id is---",placeId)
    //
    //                                    var contentPlaceId = Dictionary<String,Any>()
    //                                    contentPlaceId.updateValue(placeId!, forKey: "placeid")
    //
    //                            //        self.PlaceIdArray.append(contentPlaceId)
    //
    //
    //                                    if photosArray.count > 0 {
    //
    //                                        let photoDict = photosArray[i] as! NSDictionary
    //
    //
    //
    //                                        if let photo_reference = photoDict.object(forKey: "photo_reference"){
    //
    //
    //                                            let PhotoRef = photo_reference as! String
    //                                            //   K_GoogleImagesData.ImagesDataArray.append(PhotoRef)
    //
    //                                            var content = Dictionary<String,Any>()
    //                                            content.updateValue(PhotoRef, forKey: "Photo_Ref")
    //                                            content.updateValue(NameOfRest, forKey: "NameOfRest")
    //                                            self.collectionView.reloadData()
    //                                            //                                                                            for var j in 0..<self.cuisinesFilter.count {
    //                                            //                                                                                if let name = self.cuisinesFilter[j]["name"] as? String{
    //                                            //                                                                                    if name.localizedCaseInsensitiveContains(NameOfRest) {
    //                                            //                                                                                        print("index is ",name,j)
    //                                            //                                                                                        print(self.PhotoRefArray.count)
    //                                            //                                                                                         //self.PhotoRefArray.insert(content, at:j)
    //                                            //                                                                                    }
    //                                            //                                                                                }
    //                                            //                                                                            }
    //
    //                               //             self.PhotoRefArray.append(content)
    //                                            // call this after you update
    //
    //
    //
    //                                            print("PhotoRef : \(PhotoRef)")
    //
    //                                        }
    //                                    }
    //                                }
    //                                }
    //                            }
    //                            else{
    //                                var content = Dictionary<String,Any>()
    //                                content.updateValue("Defoult", forKey: "Photo_Ref")
    //
    //                                self.PhotoRefArray.append(content)
    //                                print("Key Expaire");
    //
    //                            }
    //
    //                        }
    //                        //           self.tableView.reloadData()
    //
    //                    }
    //
    //
    //                    //  }
    //                })
    //
    //
    //
    //
    //
    //
    //
    //
    //    //    print("All photos Reference", self.PhotoRefArray)
    //     //   print("All photos count", self.PhotoRefArray.count)
    //
    //        //  self.tableView .reloadData()
    //
    //    }
    
    
    
    //MARK: COLLECTIONVIEW DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("Images data",self.PhotoRefArrayGet)
        return self.PhotoRefArrayGet.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Your code here
        
        print("Name")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! RastaurantCell
        
        print("Images data",self.PhotoRefArrayGet)
        let imageval =  (self.PhotoRefArrayGet[indexPath.row] ["Photo_Ref"] as! String)
    
        
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(imageval)&key=AIzaSyBf5p8z9QCBLh2re71V8bo-xB_cpoqcNmU")!
        print("Url Is Final",url)
        
        let bannerUrl = "\(url)"
        
        cell.innerImageView.sd_setImage(with: URL(string: bannerUrl), placeholderImage: UIImage(named: "rest_defoutImage"))
        cell.innerImageView.clipsToBounds = true
        cell.innerImageView.contentMode = UIViewContentMode.scaleAspectFit
      //  cell.lblRestName.text = K_INNERUSER_DATA.RestaurantName
        //        cell.innerImageView.image = UIImage(named:images[indexPath.row])
        //        cell.backgroundColor = UIColor.red
        self.lblleft.text = ""
        self.lblright.text = ""
        self.lblleft.text = String(indexPath.row+1)
        self.lblright.text = String(PhotoRefArrayGet.count)
        return cell
        
    }
    
    
    
}
