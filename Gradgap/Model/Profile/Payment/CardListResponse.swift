//
//  CardListResponse.swift
//  Gradgap
//
//  Created by iMac on 05/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - CardListResponse
struct CardListResponse: Codable {
    let code: Int
    let message: String
    let data: [CardListDataModel]
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, format, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([CardListDataModel].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
    init() {
        code = 0
        message = ""
        data = []
        format = ""
        timestamp = ""
    }
    
}

// MARK: - Datum
struct CardListDataModel: Codable {
    let id, userRef: String
    let lastDigitsOfCard: Int
    let cardType, country: String
    let datumDefault: Bool
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userRef, lastDigitsOfCard, cardType, country
        case datumDefault = "default"
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        lastDigitsOfCard = try values.decodeIfPresent(Int.self, forKey: .lastDigitsOfCard) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? ""
        cardType = try values.decodeIfPresent(String.self, forKey: .cardType) ?? ""
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        datumDefault = try values.decodeIfPresent(Bool.self, forKey: .datumDefault) ?? false
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
    }
    
    init() {
        lastDigitsOfCard = 0
        id = ""
        userRef = ""
        cardType = ""
        country = ""
        datumDefault = false
        v = 0
    }
    
}
