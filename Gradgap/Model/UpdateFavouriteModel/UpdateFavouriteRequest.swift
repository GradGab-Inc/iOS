//
//  UpdateFavouriteRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct UpdateFavouriteRequest: Encodable {
    var status: Bool
    var mentorRef: String
}
