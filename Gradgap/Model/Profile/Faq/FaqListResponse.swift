//
//  FaqListResponse.swift
//  E-Auction
//
//  Created by iMac on 10/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation



struct FaqListResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [FAQList]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([FAQList].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? 0
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
    }
    
}

// MARK: - Datum
struct FAQList: Codable {
    let id, answer: String
    let deleted: Bool
    let v: Int
    let deletedOn: String?
    let question, createdOn, updatedOn: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case answer, deleted
        case v = "__v"
        case deletedOn, question, createdOn, updatedOn
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        question = try values.decodeIfPresent(String.self, forKey: .question) ?? ""
        answer = try values.decodeIfPresent(String.self, forKey: .answer) ?? ""
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? ""
        deletedOn = try values.decodeIfPresent(String.self, forKey: .deletedOn) ?? ""
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
    }
}


// MARK: - Welcome
//struct FaqListResponse: Codable {
//    let code: Int
//    let message: String
//    let data: [FAQList]
//    let format, timestamp: String
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//
//        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
//        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
//        data = try values.decodeIfPresent([FAQList].self, forKey: .data) ?? []
//        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
//        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
//    }
//
//}

// MARK: - DataClass
struct FaqListDataModel: Codable {
    let faqs: [FAQList]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        faqs = try values.decodeIfPresent([FAQList].self, forKey: .faqs) ?? []

    }
    
}
