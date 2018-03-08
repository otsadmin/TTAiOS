//
//  SharedManager.swift
//  Taste
//
//  Created by Asish Pant on 15/06/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit


class SharedManager: NSObject {
    static let sharedInstance = SharedManager()
    var deviceToken: String=""
    var loginId: String=""
    var latValueInitial : Double = 0.0
    var longValueInitial : Double = 0.0
    var refeshRecommendation: String="yes"
   
    var latValueExploreCity : Double = 0.0
    var longValueExploreCity : Double = 0.0
    var isExploreCitySearch:Bool = false
    var isExploreRestaurantSearch:Bool = false
    var exploreCityFormattedAddress:String = ""
    var exploreRestaurantSearchText:String = ""
    var isTextSearch:String = "0" 
    var checkScreen:Int = 0
    var refreshExplore:String="yes"
    var isNavigateMapScreenAfterSearch:Bool = false
    var isUserCurrentLocation:Bool = false
    var isUserCitySearch:Bool = false
}
