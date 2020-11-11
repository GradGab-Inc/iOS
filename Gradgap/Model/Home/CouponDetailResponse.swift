//
//  CouponDetailResponse.swift
//  Gradgap
//
//  Created by iMac on 11/9/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct CouponDetailResponse: Codable {
    let code: Int
    let message: String
    let data: CouponDetailModel?
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, format, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(CouponDetailModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
    init() {
        code = 0
        message = ""
        data = CouponDetailModel.init()
        format = ""
        timestamp = ""
    }
}

// MARK: - DataClass
struct CouponDetailModel: Codable {
    let amountOff: Int
    let note: String
    let deleted: Bool
    let id, userRef, referredUser: String
    let type, createdOn, updatedOn, v: Int
    let code: String

    enum CodingKeys: String, CodingKey {
        case amountOff, note, deleted
        case id = "_id"
        case userRef, referredUser, type, createdOn, updatedOn
        case v = "__v"
        case code
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
        code = try values.decodeIfPresent(String.self, forKey: .code) ?? ""
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
        code = ""
    }
}
