//
//  VideoCallDataRequest.swift
//  Gradgap
//
//  Created by iMac on 10/3/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct VideoCallDataRequest: Encodable {
    var bookingRef: String
}


struct ExtendVideoCallDataRequest: Encodable {
    var bookingRef: String
    var dateTime: String
}
