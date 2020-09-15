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
    let id, question, answer, createdOn: String
    let updatedOn: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question, answer, createdOn, updatedOn
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        question = try values.decodeIfPresent(String.self, forKey: .question) ?? ""
        answer = try values.decodeIfPresent(String.self, forKey: .answer) ?? ""
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? ""
    }
}
