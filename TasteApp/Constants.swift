//
//  Constants.swift
//  TasteApp
//
//  Created by Shubhank on 01/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import Foundation

//let HOSTURL = "http://159.203.180.90/tasteapp/"
//let BASEURL =  "api/v1/"
//let HOSTURL = "http://159.203.180.90/tasteapp2"
//let HOSTURL = "http://34.227.16.30/tasteapp2"
let HOSTURL = "http://app.thetasteapp.com"
//let HOSTURL = "http://192.168.1.79/tasteapp2"
let BASEURL =  "/api/v1/"

let K_SERVERNEW_URL = HOSTURL + BASEURL
//let K_SERVERNEW_URL = "http://159.203.180.90/tasteapp/index.php/api/v1/"
let K_DEBUG = true
let k_userlogin_ID = "QuMKkB5dfR4bZ61ekYpwgBhut4ZOzlD7Al6Gmo2wLwSg0DsXrtPVUGUPZAcd5JnP5KMdhd3HFUsX45-PW0jI7w"

let K_CURRENT_USER = TasteAppUser()
let K_INNERUSER_PROFILE = InnerCircleUser()
let K_INNERUSER_DATA = InnerUserDetail()
let K_BANKCREDENTIAL_DATA = BankCredential()
let K_USER_DATA = UserData()

var SELECTED_DISTANCE_IN_MILES = ""
let K_LOGIN_URL = K_SERVERNEW_URL + "login"
let K_LOGOUT_URL = K_SERVERNEW_URL + "logout"
let K_DELETE_NOTIFICATION_URL = K_SERVERNEW_URL + "notification_del"
let K_USERS_URL = K_SERVERNEW_URL + "users"
let K_BANK_URL  = K_SERVERNEW_URL  + "bank"
let K_BANK_DELETE_URL = K_SERVERNEW_URL + "bank_del"
let K_DIETLIST_URL = K_SERVERNEW_URL + "diet"
let K_MASTERDIETLIST_URL = K_SERVERNEW_URL + "master_cuisines"
let K_Transaction_URL = K_SERVERNEW_URL + "transaction"
let K_INNERCIRCLESUGGESTION_URL = K_SERVERNEW_URL + "inner_circle_suggestion"
let K_RECOMMENDATION_DETAIL = K_SERVERNEW_URL + "recommendation_list"
let K_CUISINES_DETAIL = K_SERVERNEW_URL + "cuisines_detail"
let K_INNERCIRCLEUSERPROFILE = K_SERVERNEW_URL + "user_profile"
let K_INNERCIRCLEUSERADDEDPROFILE = K_SERVERNEW_URL + "user_profile_detail"
let K_DININGHISTORY_URL = K_SERVERNEW_URL + "dinning_history"
let K_SETTINGSIMPLE = K_SERVERNEW_URL + "setting_simple"
let K_SETTING = K_SERVERNEW_URL + "setting"
let K_PROVIDER = K_SERVERNEW_URL + "provider"
let K_MFA_CHALLENGE = K_SERVERNEW_URL + "post_mfa_challenge"
let K_BANK_COUNT = K_SERVERNEW_URL + "bank_count"
let K_INVITE_FRIEND = K_SERVERNEW_URL + "invite"
let K_INVITE_NON_TTA_USER = K_SERVERNEW_URL + "company_invite_email"
let K_CHECK_INVITE_STATUS = K_SERVERNEW_URL + "invite_status"
let K_REVIEW_URL = K_SERVERNEW_URL + "review"
let K_INVITE_URL = K_SERVERNEW_URL + "invite"
let K_INVITE_DELETE_URL = K_SERVERNEW_URL + "invite_del"
let K_INNERCIRCLE = K_SERVERNEW_URL + "inner_circle"
let K_RATE = K_SERVERNEW_URL + "rate"
let K_NOTIFICATION = K_SERVERNEW_URL + "notification"
let K_PLAID_CLIENT_ID  = "58a2aaac4e95b84a1cde1b2f"
let K_PLAID_PUBLIC_KEY = "d66e13448d66528a463272e6ba752f"
let K_PLAID_SECRET     = "c7cbc2544a41dc815c47782d9fc322"
let K_PLAID_CONNECT_URL = "https://tartan.plaid.com/connect"
let K_ANALYTIC_URL = K_SERVERNEW_URL + "analytic"
let K_Transaction_Count = K_SERVERNEW_URL + "transaction_count"
let K_BANK_Transaction_Count = K_SERVERNEW_URL + "bank_transaction_count"
let K_RECOMMENDATION = K_SERVERNEW_URL + "recommendation"
let K_ADMIN_RECOMMENDATION = K_SERVERNEW_URL + "admin_recommendation"
let K_CHECK_RECOMENDATION_GET = K_SERVERNEW_URL + "Check_Recommendation"
let K_Font_Color = "Roboto-Thin"
let K_Font_Color_Bold = "Roboto-Bold"
let K_Font_Color_Regular = "Roboto-Regular"
let K_Font_Color_Light = "Roboto-Light"
let K_Font_Color_MyanmarBold = "MyanmarSangamMN-Bold"
let K_FONT_COLOR_Alethia  = "Alethia Pro"
let APP_NAME = "Taste"
//let K_IMAGE_BASE_URL = "http://159.203.180.90/tasteapp2/uploads/"
let K_IMAGE_BASE_URL = HOSTURL + "/uploads/"
let K_INVITE_OVER_EMAIL = K_SERVERNEW_URL + "invite_over_emaiL"
let K_SEARCH_RESTAURANT = K_SERVERNEW_URL + "search_restaurant"
let K_ISRATED = K_SERVERNEW_URL + "is_rated"
//let K_LOGOUT_URL = K_SERVERNEW_URL + "logout"
let K_Invitestatus = K_SERVERNEW_URL + "invite_status"
let K_EXPLORE_DETAIL = K_SERVERNEW_URL + "explore"
let GOOGLE_APIKEY: String="AIzaSyBf5p8z9QCBLh2re71V8bo-xB_cpoqcNmU"
let K_SEARCH_FILTER = K_SERVERNEW_URL + "filters"
let K_RECENT_TASTE = K_SERVERNEW_URL + "recent_taste"
let K_VIEW_ALL = K_SERVERNEW_URL + "analytic_viewall_maps"
let K_ALL_RECENT_TASTE_FOR_MAP = K_SERVERNEW_URL + "recent_taste_map_view"
let K_GET_GRAPH_DATA = K_SERVERNEW_URL + "analytic_graph"
let K_NOTIFICATION_COUNT = K_SERVERNEW_URL + "unread_notification"
let K_MAKE_NOTIFICATION_READ = K_SERVERNEW_URL + "notification"
let K_Internet_Message = "Unable to fetch data."
let K_FLAG = K_SERVERNEW_URL + "flag"


// TODO: MIXPANEL AND FIREBASE ACTION

let R_SUBMIT_TRANSACTION =  "Manual Txn Error"


// TODO: ALERT DATA
let R_DO_NOT_HAVE_RECOMMENDATION =  "You do not have eneough recommendation. Please add more bank account."

public func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
