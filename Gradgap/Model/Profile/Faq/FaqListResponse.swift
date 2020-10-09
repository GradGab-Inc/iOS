//
//  FaqListResponse.swift
//  E-Auction
//
//  Created by iMac on 10/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct FaqListResponse: Codable {
    let code: Int
    let message: String
    let data: FaqListDataModel?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(FaqListDataModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
}

// MARK: - DataClass
struct FaqListDataModel: Codable {
    let faqs: [FAQList]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        faqs = try values.decodeIfPresent([FAQList].self, forKey: .faqs) ?? []

    }
    
}

// MARK: - FAQ
struct FAQList: Codable {
    let id, answer: String
    let deleted: Bool
    let v: Int
    let question: String
    let createdOn, updatedOn: Int
    let deletedOn: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case answer, deleted
        case v = "__v"
        case question, createdOn, updatedOn, deletedOn
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        question = try values.decodeIfPresent(String.self, forKey: .question) ?? ""
        answer = try values.decodeIfPresent(String.self, forKey: .answer) ?? ""
        createdOn = try values.decodeIfPresent(Int.self, forKey: .createdOn) ?? 0
        updatedOn = try values.decodeIfPresent(Int.self, forKey: .updatedOn) ?? 0
        deletedOn = try values.decodeIfPresent(String.self, forKey: .deletedOn) ?? ""
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
    }
    
}
