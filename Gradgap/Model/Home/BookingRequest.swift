//
//  BookingRequest.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct CreateBookingRequest: Encodable {
    var callType: Int
    var dateTime: String
    var mentorRef: String
    var timeSlot: Int
    var callTime: Int
}


struct MentorListRequest: Encodable {
    var callType: Int?
    var callTime: String?
    var dateTime: String?
    
    init(callType: Int? = nil,callTime:String? = nil,dateTime:String? = nil) {
        
        self.callType = callType
        self.callTime = callTime
        self.dateTime = dateTime
        
    }
    
}

