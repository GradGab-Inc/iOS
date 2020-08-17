//
//  ResendVerificationRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct ResendVerificationRequest: Encodable {
    var email: String
    var requestType: Int
}
