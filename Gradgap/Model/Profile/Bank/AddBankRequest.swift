//
//  AddBankRequest.swift
//  Gradgap
//
//  Created by iMac on 9/18/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
/*
lastDigitsOfAccountNo,
accountHolderName,
bankName,
frontImage,
backImage,
city,
country,
line1,
line2,
postalCode,
state,
firstName,
lastName,
day,
month,
year,
gender,
phone,
ssnLastFour,                    // Social Security Number's last four digits
ip, (edited) */


struct AddBankRequest: Encodable {
    var lastDigitsOfAccountNo: String
    var accountHolderName: String
    var bankName : String
    var city : String
    var country : String
    var line1 : String
    
    var line2 : String
    var postalCode : String
    var state : String
    var ssnLastFour : String
    var gender : Int
    var ip : String
    var stripeToken : String
    
}
