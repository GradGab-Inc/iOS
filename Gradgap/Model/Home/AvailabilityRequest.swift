//
//  AvailabilityRequest.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct SetAvailabiltyRequest: Encodable {
    var availability: [AvailabiltyRequest]
    var timezone : Int
}

struct AvailabiltyRequest: Encodable {
    var startTime: Int?
    var endTime: Int?
    var type: [Int]?
    var weekDay: Int?
    var availabilityRef : String?
    var customDate: String?
    
    init(startTime: Int? = nil, endTime:Int? = nil, type:[Int]? = nil, weekDay:Int? = nil, availabilityRef:String? = nil, customDate:String? = nil){
        
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.weekDay = weekDay
        self.availabilityRef = availabilityRef
        self.customDate = customDate
    }
}


struct AvailabiltyDeleteRequest: Encodable {
    var availabilityRef: String
}


struct SelectDateAvailabiltyRequest: Encodable {
    var dateTime: String
}


struct SetDateAvailabiltyRequest: Encodable {
    var availability: [AvailabiltyRequest]
    var timezone : Int
    var dateTime : String
}


struct UpdateDateAvailabiltyRequest: Encodable {
    var availability: [AvailabiltyRequest]
    var timezone : Int
    var customDate : String
}
