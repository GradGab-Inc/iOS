//
//  GlobalConstant.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation
import UIKit

let APP_VERSION = 1.0
let BUILD_VERSION = 1
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString
let TERMS_URL = ""
var otp : String = ""

let ITUNES_URL = ""
let APPLE_LANGUAGE_KEY = "AppleLanguages"

//let GOOGLE_KEY = "AIzaSyATrKIWITsawxsFU266wSzEpfHQDRnx7hg"
let CLIENT_ID = "89503098735-s5d2ik5ah6i3ei60r113rtt9th706gh3.apps.googleusercontent.com"
let GOOGLE_PLACE_ID = "AIzaSyBAW5TIjkcjxUUuY37NTtcDJSXyzXXqVSw"

let COLOUR_ARR = ["#06BD8C","#FB5895","#CC837B","#0E66B7","#308995","#667EEA","#64B6FF","#33D17C"]

struct SCREEN
{
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

struct DATE_FORMAT {
    static var SERVER_DATE_FORMAT = "YYYY-MM-dd"
    static var SERVER_TIME_FORMAT = "HH:mm a"
    static var SERVER_DATE_TIME_FORMAT = "yyyy-MM-dd" //HH:mm:ss"
    static var DISPLAY_DATE_FORMAT = "yyyy-MM-dd"
    static var DISPLAY_DATE_FORMAT1 = "MM/dd/yyyy"
    static var DISPLAY_TIME_FORMAT = "dd-MM-YYYY"
    static var DISPLAY_DATE_TIME_FORMAT = "YYYY-MM-dd HH:mm:ss"
}

struct CONSTANT{
    static var DP_IMAGE_WIDTH     =  1000
    static var DP_IMAGE_HEIGHT    =  1000
    
    static let MAX_EMAIL_CHAR = 254
    static let MAX_PREFER_NAME_CHAR = 40
    static let MIN_PWD_CHAR = 8
    static let MAX_PWD_CHAR = 16
    static let MAX_FIRST_NAME_CHAR = 40
    static let MAX_MIDDLE_NAME_CHAR = 40
    static let MAX_LAST_NAME_CHAR = 40
    
    static let DOB_CHAR = 8
    static let DOB_SPACE_CHAR = 4
    static let DOB_DATE_CHAR = 2
    static let DOB_MONTH_CHAR = 2
    static let DOB_YEAR_CHAR = 4
    
    static let MOBILE_NUMBER_CHAR = 8
    static let MOBILE_NUMBER_SPACE_CHAR = 2
    static let MOBILE_NUMBER_CODE = ""
    
    static let CARD_NUMBER_CHAR = 16
    static let CARD_NUMBER_DASH_CHAR = 3
    static let CARD_EXP_DATE_CHAR = 5
    static let CARD_CVV_CHAR = 3
    
    static let SMS_CODE_CHAR = 4
    static let SMS_CODE_SPACE_CHAR = 3
    
    static let IMAGE_QUALITY   =  1
    
    static let CURRENCY   =  "$"
    static let DIST_MEASURE   =  "km"
    static let TIME_ZONE = "Australia/Sydney"
    
    static let DEF_TAKE : Int = 24
    
    
}

struct DEVICE {
    static var IS_IPHONE_X = (fabs(Double(SCREEN.HEIGHT - 812)) < Double.ulpOfOne)
}

struct MEDIA {
    static var IMAGE = "IMAGE"
    static var VIDEO = "VIDEO"
}

struct IMAGE {
    static var USER_PLACEHOLDER = ""
    static var STADIUM_PLACEHOLDER = ""
}

struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    static var HOME = UIStoryboard(name: "Home", bundle: nil)
    static var MY_ITEMS = UIStoryboard(name: "MyItems", bundle: nil)
    static var VIEW_LISTS = UIStoryboard(name: "ViewLists", bundle: nil)
    static var PROFILE = UIStoryboard(name: "Profile", bundle: nil)
}

struct NOTIFICATION {
    static var UPDATE_CURRENT_USER_DATA     =   "UPDATE_CURRENT_USER_DATA"
    static var REDICT_TAB_BAR               =   "REDICT_TAB_BAR"
    static var NOTIFICATION_TAB_CLICK       =   "NOTIFICATION_TAB_CLICK"
    static var ADD_SORT                     =   "ADD_SORT"
    static var ADD_FILTER                   =   "ADD_FILTER"
    static var GET_ABOUT_DATA               =   "GET_ABOUT_DATA"
    static var RELOAD_ADDRESS_DATA          =   "RELOAD_ADDRESS_DATA"
    static var RELOAD_BID_NOW               =   "RELOAD_BID_NOW"
    static var PRIVATE_AUCTION_CLICK        =   "PRIVATE_AUCTION_CLICK"
    static var RELOAD_HOME_DATA             =   "RELOAD_HOME_DATA"
    static var REDIRECT_TO_LOGIN            =   "REDIRECT_TO_LOGIN"
}

struct REDIRECT_TYPE {
    static var REDIRECT_PRODUCT_DETAIL      =   "REDIRECT_PRODUCT_DETAIL"
    
}


struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

struct INFO_TITLE {
    static var info1 = "Connect with current students at your dream school."
    static var info2 = "Our mentors are current students who can give you real insights on what college is really like."
    static var info3 = "Create a profile, pick a few schools, and we’ll match you with mentors who share the same interests."
}

//enum ViewListType:Int{
//    case SAVED = 1
//    case VIEWED
//}

