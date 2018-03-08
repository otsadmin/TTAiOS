//
//  GoogleDataProvider.swift
//  Taste
//
//  Created by Asish Pant on 10/06/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import GooglePlacePicker
import GoogleMapsCore
import GooglePlaces
class GoogleDataProvider {
    var photoCache = [String:UIImage]()
    var placesTask: URLSessionDataTask?
    var session: URLSession {
        return URLSession.shared
    }
    
//    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: @escaping (([GMSPlace]) -> Void)) -> ()
//    {
//        var urlString = "http://localhost:10000/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
//        let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
//        urlString += "&types=\(typesString)"
//       // urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//        
//        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
//            task.cancel()
//        }
//        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        placesTask = session.dataTask(with: URL(string: urlString)!, completionHandler: {data, response, error in
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            
//            placesTask=session.dataTask(with: urlString, completionHandler: data,response,er)
//            var placesArray = [GMSPlace]()
//            if let aData = data {
//              //  let json = js(data:aData, options:NSJSONReadingOptions.MutableContainers, error:nil)
////                JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                do {
//                    
//                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                    
//                    
//                    print("have you reached login api \(parsedData)")
//                    
//                    let results = parsedData["data"] as! [[String:Any]]
//                    print(results)
//                    completion(results)
//                    
//                }
//                do{
//                    let json=try JSONSerialization.jsonObject(with: aData, options: []) as! [[String : AnyObject]]
//                    if let results = json["results"].arrayObject as? [[String : AnyObject]] {
//                        for rawPlace in results {
//                            let place = GooglePlace(dictionary: rawPlace, acceptedTypes: types)
//                            placesArray.append(place)
//                            if let reference = place.photoReference {
//                                self.fetchPhotoFromReference(reference) { image in
//                                    place.photo = image
//                                }
//                            }
//                        }
//                    }
//                }
//                catch let error as NSError {
//                    print(error)
//                }
//
//            }
//            DispatchQueue.main.async {
//                completion(placesArray)
//            }
//        }
//        placesTask?.resume()
//    }
//    
//    
////    func fetchPhotoFromReference(reference: String, completion: @escaping ((UIImage?) -> Void)) -> () {
////        if let photo = photoCache[reference] as UIImage? {
////            completion(photo)
////        } else {
////            let urlString = "http://localhost:10000/maps/api/place/photo?maxwidth=200&photoreference=\(reference)"
////            UIApplication.sharedApplication.networkActivityIndicatorVisible = true
////            session.downloadTaskWithURL(NSURL(string: urlString)! as URL) {url, response, error in
////                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
////                if let url = url {
////                    let downloadedPhoto = UIImage(data: NSData(contentsOfURL: url)!)
////                    self.photoCache[reference] = downloadedPhoto
////                    dispatch_async(dispatch_get_main_queue()) {
////                        completion(downloadedPhoto)
////                    }
////                }
////                else {
////                    dispatch_async(dispatch_get_main_queue()) {
////                        completion(nil)
////                    }
////                }
////                }.resume()
////        }
////    }
//
}
