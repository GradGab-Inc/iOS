//
//  LoginRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    var email, password: String
    var device, fcmToken: String
}
