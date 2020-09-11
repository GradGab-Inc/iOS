//
//  AddCardRequest.swift
//  Gradgap
//
//  Created by iMac on 11/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct AddCardRequest : Encodable {
    var cardNumber: String
    var year: Int
    var month: Int
    var cvv: Int
    var stripeToken: String
}
