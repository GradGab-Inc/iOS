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
//    static let BASE_URL = "http://3.23.147.117/staging/api/"
    // Local
     static let BASE_URL = "http://c46bad99e257.ngrok.io/api/"
    
    struct USER {
        static let signup                 = BASE_URL + "user/signup"
        static let login                  = BASE_URL + "user/login"
        static let resendVerification     = BASE_URL + "user/resendVerification"
        static let socialLogin            = BASE_URL + "user/socialLogin"
        static let update                 = BASE_URL + "user/update"
        static let details                = BASE_URL + "user/details"
    }
    
    struct AVAILABILITY {
        static let list                   = BASE_URL + "availability/list"
        static let set                    = BASE_URL + "availability/set"
        static let mentorList             = BASE_URL + "availability/mentorList"
        static let delete                 = BASE_URL + "availability/delete"
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
    }
    
    struct AVAILABILITY {
        static let list = DispatchQueue(label: "com.app.AVAILABILITY_list", qos: .utility, attributes: .concurrent) //1
        static let set = DispatchQueue(label: "com.app.AVAILABILITY_set", qos: .background, attributes: .concurrent)    //2
        static let mentorList = DispatchQueue(label: "com.app.AVAILABILITY_mentorList", qos: .utility, attributes: .concurrent) //3
        static let delete = DispatchQueue(label: "com.app.AVAILABILITY_delete", qos: .background, attributes: .concurrent)  //4
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
}