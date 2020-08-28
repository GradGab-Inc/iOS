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
    var additionalTopics: String
}


struct BookingListRequest: Encodable {
    var status: Int?
    var dateStart: String?
    var dateEnd: String?
    var limit: Int?
    var page : Int?
    
    init(status: Int? = nil,dateStart:String? = nil,dateEnd:String? = nil, limit:Int? = nil, page:Int? = nil){
        
        self.status = status
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.limit = limit
        self.page = page
    }
}


struct GetBookingDetailRequest: Encodable {
    var bookingRef: String
}


struct GetBookingActionRequest: Encodable {
    var bookingRef: String
    var status: Int
}
