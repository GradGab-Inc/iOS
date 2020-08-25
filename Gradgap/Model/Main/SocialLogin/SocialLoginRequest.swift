//
//  SocialLoginRequest.swift
//  E-Auction
//
//  Created by iMac on 01/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation


struct SocialLoginRequest : Encodable {
    var socialToken:String
    var socialIdentifier:Int
    var firstName: String
    var lastName: String?
    var socialId:String
    var email:String
    var fcmToken: String
    var device:String
}

enum SocialType : Int {
    case facebook = 1
    case google = 2
    case apple = 3
}
