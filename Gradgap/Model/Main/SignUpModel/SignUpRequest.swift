//
//  SignUpRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct SignUpRequest: Encodable {
    var firstName, lastName: String
    var email, password: String
    var contactCode, contactNumber: String
    var device, fcmToken: String
}
