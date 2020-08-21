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



