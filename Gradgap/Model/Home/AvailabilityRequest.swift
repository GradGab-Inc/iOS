//
//  AvailabilityRequest.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct AvailabiltyDeleteRequest: Encodable {
    var availabilityRef: String
}


struct FavoriteItemRequest : Encodable {
    var status:Bool
    var itemRef:String
}
