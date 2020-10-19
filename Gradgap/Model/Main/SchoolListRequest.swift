//
//  SchoolListRequest.swift
//  Gradgap
//
//  Created by iMac on 18/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct SchoolSearchRequest: Encodable {
    var text: String
    var page: Int
}

struct MorePageRequest : Encodable {
    var page: Int
}

struct MorePageWithLimitRequest : Encodable {
    var page: Int
    var limit: Int
}

