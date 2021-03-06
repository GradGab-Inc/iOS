//
//  MentorListRequest.swift
//  Gradgap
//
//  Created by iMac on 20/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct MentorListRequest: Encodable {
    var callType: Int?
    var callTime: Int?
    var dateTime: String?
    var page: Int?
    var timezone: Int?
    
    init(callType: Int? = nil,callTime:Int? = nil,dateTime:String? = nil,page:Int? = nil, timezone:Int? = nil) {
        
        self.callType = callType
        self.callTime = callTime
        self.dateTime = dateTime
        self.page = page
        self.timezone = timezone
    }
}


struct MentorDetailRequest: Encodable {
    var callType: Int?
    var userId: String?
    var dateTime: String?
    var callTime: Int?
    var timezone: Int?
    
    init(callType: Int? = nil,userId:String? = nil,dateTime:String? = nil, callTime: Int? = nil, timezone:Int? = nil) {
        
        self.callType = callType
        self.userId = userId
        self.dateTime = dateTime
        self.callTime = callTime
        self.timezone = timezone
        
    }
}

