//
//  ContactAdminResponse.swift
//  E-Auction
//
//  Created by iMac on 09/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct ContactAdminResponse: Codable {
    let code: Int
    let message: String
    let data: ContactAdminDataModel?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
         let values = try decoder.container(keyedBy: CodingKeys.self)
         
         code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
         message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
         data = try values.decodeIfPresent(ContactAdminDataModel.self, forKey: .data) ?? nil
         format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
         timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
     }
    
}

// MARK: - DataClass
struct ContactAdminDataModel: Codable {
    let id, ref: String
    let refType: Int
    let message, createdOn: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ref, refType, message, createdOn
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        refType = try values.decodeIfPresent(Int.self, forKey: .refType) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        ref = try values.decodeIfPresent(String.self, forKey: .ref) ?? ""
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
    }
    
}
