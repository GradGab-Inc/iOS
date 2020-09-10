//
//  API_Helper.swift
//  Trouvaille-ios
//
//  Created by MACBOOK on 01/04/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

//MARK: - API
struct API {
    //Development 
    //static let BASE_URL = "http://ec2-3-14-150-71.us-east-2.compute.amazonaws.com/development/api/"
    //Staging
//    static let BASE_URL = "http://3.82.95.119/development/api/"
    // Local
    static let BASE_URL = "http://3.82.95.119/development/api/"
    static let IMAGE_URL  = "https://gradgab.s3.us-east-2.amazonaws.com/development/images/best/"
    
    struct USER {
        static let signup                 = BASE_URL + "user/signup"
        static let login                  = BASE_URL + "user/login"
        static let resendVerification     = BASE_URL + "user/resendVerification"
        static let socialLogin            = BASE_URL + "user/socialLogin"
        static let update                 = BASE_URL + "user/update"
        static let details                = BASE_URL + "user/details"
        static let switchProfile          = BASE_URL + "user/switchProfile"
    }
    
    struct AVAILABILITY {
        static let list                   = BASE_URL + "availability/list"
        static let set                    = BASE_URL + "availability/set"
        static let mentorList             = BASE_URL + "availability/mentorList"
        static let delete                 = BASE_URL + "availability/delete"
        static let update                 = BASE_URL + "availability/update"
    }
    
    struct FAVOURITES {
        static let addOrRemove            = BASE_URL + "favourites/addOrRemove"
        static let favList                = BASE_URL + "favourites/list"
    }
        
    struct SCHOOL {
        static let search                 = BASE_URL + "school/search"
    }
    
    struct MAJOR {
        static let majorList              = BASE_URL + "major/list"
    }
    
    struct LANGUAGES {
        static let languageList           = BASE_URL + "language/list"
    }
    
    struct BOOKING {
        static let create                 = BASE_URL + "booking/create"
        static let bookingList            = BASE_URL + "booking/list"
        static let bookingDetail          = BASE_URL + "booking/details"
        static let action                 = BASE_URL + "booking/action"
    }
    
    struct CARD {
        static let add                    = BASE_URL + "card/add"
        static let list                   = BASE_URL + "card/list"
        static let select                 = BASE_URL + "card/select"
        static let remove                 = BASE_URL + "card/remove"
    }
    
    struct RATING {
        static let add                   = BASE_URL + "rating/add"
    }
    
    struct NOTIFICATION {
        static let list                   = BASE_URL + "notification/list"
    }
    
    struct TRANSACTION {
        static let detail                 = BASE_URL + "transaction/details"
    }
    
//    struct COUPON {
//        static let add                    = BASE_URL + "coupon/add"
//        static let list                   = BASE_URL + "coupon/list"
//    }
}

//MARK:- GCD
//MultiThreading
struct GCD{
    struct USER {
        static let signup = DispatchQueue(label: "com.app.USER_signup", qos: .background, attributes: .concurrent) //1
        static let login = DispatchQueue(label: "com.app.USER_login", qos: .background, attributes: .concurrent) //2
        static let resendVerification = DispatchQueue(label: "com.app.USER_resendVerification", qos: .background, attributes: .concurrent) //3
        static let socialLogin = DispatchQueue(label: "com.app.USER_socialLogin", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //4
        static let update = DispatchQueue(label: "com.app.USER_update", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //5
        static let details = DispatchQueue(label: "com.app.USER_details", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent) //6
        static let switchProfile = DispatchQueue(label: "com.app.USER_switchProfile", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent) //6
    }
    
    struct AVAILABILITY {
        static let list = DispatchQueue(label: "com.app.AVAILABILITY_list", qos: .utility, attributes: .concurrent) //1
        static let set = DispatchQueue(label: "com.app.AVAILABILITY_set", qos: .background, attributes: .concurrent)    //2
        static let mentorList = DispatchQueue(label: "com.app.AVAILABILITY_mentorList", qos: .utility, attributes: .concurrent) //3
        static let delete = DispatchQueue(label: "com.app.AVAILABILITY_delete", qos: .background, attributes: .concurrent)  //4
        static let update = DispatchQueue(label: "com.app.AVAILABILITY_update", qos: .background, attributes: .concurrent)  //5
    }
    
    struct FAVOURITES {
        static let addOrRemove = DispatchQueue(label: "com.app.FAVOURITES_addOrRemove", qos: .background, attributes: .concurrent)  //1
        static let favList = DispatchQueue(label: "com.app.FAVOURITES_favList", qos: .utility, attributes: .concurrent) //2
    }
        
    struct SCHOOL {
        static let search = DispatchQueue(label: "com.app.SCHOOL_search", qos: .utility)    //1
    }
    
    struct MAJOR {
        static let majorList = DispatchQueue(label: "com.app.MAJOR_majorList", qos: .utility, attributes: .concurrent)  //1
    }
    
    struct LANGUAGES {
        static let languageList = DispatchQueue(label: "com.app.LANGUAGES_languageList", qos: .utility, attributes: .concurrent)  //1
    }
    
    struct BOOKING {
        static let create = DispatchQueue(label: "com.app.BOOKING_create", qos: .background, attributes: .concurrent)   //1
        static let bookingList = DispatchQueue(label: "com.app.BOOKING_bookingList", qos: .utility, attributes: .concurrent)   //2
        static let bookingDetail = DispatchQueue(label: "com.app.BOOKING_bookingDetail", qos: .background, attributes: .concurrent)   //3
        static let action = DispatchQueue(label: "com.app.BOOKING_action", qos: .background, attributes: .concurrent)   //4
    }
    
    struct CARD {
        static let add = DispatchQueue(label: "com.app.CARD_add", qos: .background, attributes: .concurrent) //1
        static let list = DispatchQueue(label: "com.app.CARD_list", qos: .background, attributes: .concurrent) //2
        static let select = DispatchQueue(label: "com.app.CARD_select", qos: .background, attributes: .concurrent) //3
        static let remove = DispatchQueue(label: "com.app.CARD_remove", qos: .background, attributes: .concurrent) //4
    }
    
    struct RATING {
        static let add = DispatchQueue(label: "com.app.RATING_add", qos: .background, attributes: .concurrent) //1
    }
    
    struct NOTIFICATION {
        static let list = DispatchQueue(label: "com.app.NOTIFICATION_list", qos: .background, attributes: .concurrent) //1
    }
    
    struct TRANSACTION {
        static let detail = DispatchQueue(label: "com.app.TRANSACTION_detail", qos: .background, attributes: .concurrent) //1
    }
    
//    struct COUPON {
//        static let add = DispatchQueue(label: "com.app.COUPON_add", qos: .background, attributes: .concurrent) //1
//        static let list = DispatchQueue(label: "com.app.COUPON_list", qos: .background, attributes: .concurrent) //2
//    }
    
}
