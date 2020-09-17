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
    
    init(startTime: Int? = nil,endTime:Int? = nil,type:[Int]? = nil,weekDay:Int? = nil,availabilityRef:String? = nil){
        
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.weekDay = weekDay
        self.availabilityRef = availabilityRef
    }
}


struct AvailabiltyDeleteRequest: Encodable {
    var availabilityRef: String
}

