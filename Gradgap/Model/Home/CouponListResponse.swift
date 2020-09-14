//
//  CouponListResponse.swift
//  Gradgap
//
//  Created by iMac on 12/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct CouponListResponse: Codable {
    let code: Int
    let message: String
    let data: [CouponListDataResponse]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, page, limit, size, hasMore, format, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([CouponListDataResponse].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? 0
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
    init() {
        code = 0
        message = ""
        data = []
        page = 0
        limit = 0
        size = 0
        hasMore = false
        format = ""
        timestamp = ""
    }
    
}

// MARK: - Datum
struct CouponListDataResponse: Codable {
    let id: String
    let amountOff: Int
    let note: String
    let deleted: Bool
    let userRef, referredUser: String
    let type, createdOn, updatedOn, v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case amountOff, note, deleted, userRef, referredUser, type, createdOn, updatedOn
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        amountOff = try values.decodeIfPresent(Int.self, forKey: .amountOff) ?? 0
        note = try values.decodeIfPresent(String.self, forKey: .note) ?? ""
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? 0
        createdOn = try values.decodeIfPresent(Int.self, forKey: .createdOn) ?? 0
        updatedOn = try values.decodeIfPresent(Int.self, forKey: .updatedOn) ?? 0
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? ""
        referredUser = try values.decodeIfPresent(String.self, forKey: .referredUser) ?? ""
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
    }
    
    init() {
        amountOff = 0
        note = ""
        type = 0
        createdOn = 0
        updatedOn = 0
        v = 0
        deleted = false
        userRef = ""
        referredUser = ""
        id = ""
    }
}
