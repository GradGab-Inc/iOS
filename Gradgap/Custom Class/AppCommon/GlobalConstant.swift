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

let CLIENT_ID = "611977964118-b7pvhpm6mdti5ntfqqs6pfnv0h7ufmcg.apps.googleusercontent.com"

let weekArr = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
let graduationYear = ["2020", "2021",  "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2035"]

//let timeSloteArr = ["1: AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "10 AM", "12 AM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "10 PM", "12 PM",]

let timeSloteArr = ["12:00 AM", "12:15 AM", "12:30 AM", "12:45 AM", "01:00 AM", "01:15 AM", "01:30 AM", "01:45 AM", "02:00 AM", "02:15 AM", "02:30 AM", "02:45 AM", "03:00 AM", "03:15 AM", "03:30 AM", "03:45 AM", "04:00 AM", "04:15 AM", "04:30 AM", "04:45 AM", "05:00 AM", "05:15 AM", "05:30 AM", "05:45 AM", "06:00 AM", "06:15 AM", "06:30 AM", "06:45 AM", "07:00 AM", "07:15 AM", "07:30 AM", "07:45 AM", "08:00 AM", "08:15 AM", "08:30 AM", "08:45 AM", "09:00 AM", "09:15 AM", "09:30 AM", "09:45 AM", "10:00 AM", "10:15 AM", "10:30 AM", "10:45 AM", "11:00 AM", "11:15 AM", "11:30 AM", "11:45 AM", "12:00 PM", "12:15 PM", "12:30 PM", "12:45 PM", "01:00 PM", "01:15 PM", "01:30 PM", "01:45 PM", "02:00 PM", "02:15 PM", "02:30 PM", "02:45 PM", "03:00 PM", "03:15 PM", "03:30 PM", "03:45 PM", "04:00 PM", "04:15 PM", "04:30 PM", "04:45 PM", "05:00 PM", "05:15 PM", "05:30 PM", "05:45 PM", "06:00 PM", "06:15 PM", "06:30 PM", "06:45 PM", "07:00 PM", "07:15 PM", "07:30 PM", "07:45 PM", "08:00 PM", "08:15 PM", "08:30 PM", "08:45 PM", "09:00 PM", "09:15 PM", "09:30 PM", "09:45 PM", "10:00 PM", "10:15 PM", "10:30 PM", "10:45 PM", "11:00 PM", "11:15 PM", "11:30 PM", "11:45 PM"]

let collegePathArr = ["From High School", "Transfer", "Community College", "Work"]

var InterestArr = [INTERESTARR.INTEREST1, INTERESTARR.INTEREST2, INTERESTARR.INTEREST3, INTERESTARR.INTEREST4, INTERESTARR.INTEREST5, INTERESTARR.INTEREST6, INTERESTARR.INTEREST7, INTERESTARR.INTEREST8, INTERESTARR.INTEREST9, INTERESTARR.INTEREST10, INTERESTARR.INTEREST11, INTERESTARR.INTEREST12, INTERESTARR.INTEREST13, INTERESTARR.INTEREST14, INTERESTARR.INTEREST15]

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
    static var PROFILE = UIStoryboard(name: "Profile", bundle: nil)
}

struct NOTIFICATION {
    static var UPDATE_MENTEE_HOME_DATA     =   "UPDATE_MENTEE_HOME_DATA"
    static var UPDATE_MENTOR_HOME_DATA     =   "UPDATE_MENTOR_HOME_DATA"
    static var UPDATE_MENTOR_BOOKED_DATA   =   "UPDATE_MENTOR_BOOKED_DATA"
    static var UPDATE_SIDEMENU_DATA        =   "UPDATE_SIDEMENU_DATA"
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

struct  MENTOR_SIDEMENU_DATA {
    static var PROFILE = "Profile"
    static var NOTI = "Notifications"
    static var MY_EARN = "My Earnings"
    static var BANK_DETAIL = "Bank Details"
    static var REFER_FRIEND = "Refer to Friends"
    static var SETTING = "Settings"
}

struct SIDEMENU_DATA {
    static var PROFILE = "Profile"
    static var NOTI = "Notifications"
    static var BOOKING = "Bookings"
    static var FAVORITE = "Favorites"
    static var TRANSACTION = "Transactions"
    static var PAY_METHODE = "Payment Method"
    static var REFER_FRIEND = "Refer to Friends"
    static var SETTING = "Settings"
}


struct CONVERSATION_DATA {
    static var GENERAL_QUE = "General Questions"
    static var ACADEMIC = "Academics / Career"
    static var SOCIAL = "Extracurricular / Social Science"
    static var CAMPUS = "Campus Life"
}

struct GENERAL_QUE {
    static var QUESTION1 = "What are your favorite things about the school?"
    static var QUESTION2 = "What are your favorite experiences/memories at the school?"
    static var QUESTION3 = "What is the general culture/atmosphere?"
    static var QUESTION4 = "Things you wish you knew before you got here"
}

struct ACADEMIC {
    static var QUESTION1 = "What’s your class schedule like/how many classes or credits do you have each semester?"
    static var QUESTION2 = "What’s your workload/How much time do you spend studying?"
    static var QUESTION3 = "What’s it like being a [your major] major?"
    static var QUESTION4 = "What are the most popular classes and/or professors?"
    static var QUESTION5 = "What’s it like signing up for class? Do you usually get your first choice?"
    static var QUESTION6 = "What career resources does your school offer?"
    static var QUESTION7 = "What was/is it like finding an internship?"
    static var QUESTION8 = "What’s the alumni network like?"
}

struct SOCIAL {
    static var QUESTION1 = "What do students do on the weekends?"
    static var QUESTION2 = "What are the popular hangouts around campus?"
    static var QUESTION3 = "What are the sports teams/events like?"
    static var QUESTION4 = "Are intramural sports popular? What sports do people play?"
    static var QUESTION5 = "What are some of the clubs you belong to or unique clubs on campus?"
    static var QUESTION6 = "What is the Greek Life like?"
    static var QUESTION7 = "What’s the social/party scene like?"
    static var QUESTION8 = "What are popular restaurants or bars that students go to?"
}

struct CAMPUS {
    static var QUESTION1 = "What are the dorms like?"
    static var QUESTION2 = "Do I need a car? What’s parking like?"
    static var QUESTION3 = "What are the food options? What’s most popular?"
    static var QUESTION4 = "What’s off-campus housing like?"
    static var QUESTION5 = "Are there any fun facts or campus traditions?"
    static var QUESTION6 = "What’s the campus like? Are there any unique buildings or landmarks?"
}

struct INTERESTARR {
    static var INTEREST1 = "Dorms"
    static var INTEREST2 = "School Athletics"
    static var INTEREST3 = "Campus Events"
    static var INTEREST4 = "Intramural Athletics"
    static var INTEREST5 = "Clubs"
    static var INTEREST6 = "Classes"
    static var INTEREST7 = "Social life"
    static var INTEREST8 = "Greek Life"
    static var INTEREST9 = "Music"
    static var INTEREST10 = "Career Planning"
    static var INTEREST11 = "Application Process"
    static var INTEREST12 = "Transfer"
    static var INTEREST13 = "Diversity"
    static var INTEREST14 = "Community"
    static var INTEREST15 = "Affordability"
}

struct  SETTING_ARR {
    static var ABOUT = "About Us"
    static var TERMS = "Terms & Connditions"
    static var PRIVACY = "Privacy Policy"
    static var HELP = "Help"
    static var LOGOUT = "Logout"
}

//MARK:- AppColors
struct AppColors{
    static let LoaderColor =  UIColor.blue
}

//MARK:- DocumentDefaultValues
struct DocumentDefaultValues{
    struct Empty{
        static let string =  ""
        static let int =  0
        static let bool = false
        static let double = 0.0
    }
}

//MARK: - UserDefaultKeys
struct UserDefaultKeys {
    static let currentUser = "currentUser"
    static let token = "accessToken"
}

struct BookingStatus {
    static let BOOKED =  1
    static let CANCELLED =  2
    static let PENDING = 3
    static let REJECT = 4
}


struct ProfileStatus {
    static let MENTEE =  1
    static let MENTOR =  2
}
