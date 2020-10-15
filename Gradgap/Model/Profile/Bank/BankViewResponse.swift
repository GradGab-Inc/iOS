//
//  BankViewResponse.swift
//  Gradgap
//
//  Created by iMac on 10/7/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct BankViewResponse: Codable {
    let code: Int
    let message: String
    let data: BankViewDataModel?
    let timestamp, format: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, format, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(BankViewDataModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
    init() {
        code = 0
        message = ""
        data = BankViewDataModel.init()
        format = ""
        timestamp = ""
    }

    
}

// MARK: - DataClass
struct BankViewDataModel: Codable {
    let id, bankName: String
    let deleted: Bool
    let v, lastDigitsOfAccountNo: Int
    let userRef: String
    let createdOn, updatedOn: Int
    let accountHolderName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case bankName, deleted
        case v = "__v"
        case lastDigitsOfAccountNo, userRef, createdOn, updatedOn, accountHolderName
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        createdOn = try values.decodeIfPresent(Int.self, forKey: .createdOn) ?? 0
        updatedOn = try values.decodeIfPresent(Int.self, forKey: .updatedOn) ?? 0
        bankName = try values.decodeIfPresent(String.self, forKey: .bankName) ?? ""
        accountHolderName = try values.decodeIfPresent(String.self, forKey: .accountHolderName) ?? ""
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? ""
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        lastDigitsOfAccountNo = try values.decodeIfPresent(Int.self, forKey: .lastDigitsOfAccountNo) ?? 0
        
    }
    
    init() {
        id = ""
        createdOn = 0
        updatedOn = 0
        bankName = ""
        accountHolderName = ""
        userRef = ""
        deleted = false
        v = 0
        lastDigitsOfAccountNo = 0
    }
    
}
