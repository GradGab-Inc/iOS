//
//  SwitchProfileRequest.swift
//  Gradgap
//
//  Created by iMac on 10/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct SwitchProfileRequest: Encodable {
    var switchUserType: Int?
    var referralId: String?
    
    init(switchUserType: Int? = nil, referralId:String? = nil) {
        
        self.switchUserType = switchUserType
        self.referralId = referralId
    }
}
