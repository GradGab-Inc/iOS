//
//  RatingAddRequest.swift
//  Gradgap
//
//  Created by iMac on 05/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct RatingAddRequest: Encodable {
    var mentorRef: String
    var bookingRef: String
    var stars : Int
    var pursueThisSchool : Int
    var moreInterestedInSchool : Int
    var insightful : Int
}
