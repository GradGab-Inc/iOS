//
//  SetAvailabilityRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct SetAvailabilityRequest:Encodable {
    var availability: Availability
}

struct Availability: Encodable {
    var startTime: Int
    var endTime: Int
    var type: Int
    var weekDay: Int
}
