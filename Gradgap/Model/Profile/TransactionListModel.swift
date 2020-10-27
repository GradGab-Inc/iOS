//
//  TransactionListModel.swift
//  Gradgap
//
//  Created by iMac on 12/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct TransactionResponse: Codable {
    let code: Int
    let message: String
    let data: [TransactionListModel]
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
        data = try values.decodeIfPresent([TransactionListModel].self, forKey: .data) ?? []
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

// MARK: - WelcomeDatum
struct TransactionListModel: Codable {
    let id: String
    let data: [TransactionListDataModel]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        data = try values.decodeIfPresent([TransactionListDataModel].self, forKey: .data) ?? []
    }
    
    init() {
        id = ""
        data = []
    }

}

// MARK: - Datum
struct TransactionListDataModel: Codable {
    let id, menteeRef, mentorRef, image: String
    let name: String
    let school: [SchoolArr]
    let createdOn: String
    let amount: Double
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case menteeRef, mentorRef, image, name, school, createdOn, amount, lastName, firstName
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        amount = try values.decodeIfPresent(Double.self, forKey: .amount) ?? 0
        school = try values.decodeIfPresent([SchoolArr].self, forKey: .school) ?? []
        mentorRef = try values.decodeIfPresent(String.self, forKey: .mentorRef) ?? ""
        menteeRef = try values.decodeIfPresent(String.self, forKey: .menteeRef) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
    }
    
    init() {
        id = ""
        amount = 0
        school = []
        mentorRef = ""
        menteeRef = ""
        name = ""
        image = ""
        createdOn = ""
        lastName = ""
        firstName = ""
    }
}

// MARK: - School
struct SchoolArr: Codable {
    let id, schoolRef, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case schoolRef, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        schoolRef = try values.decodeIfPresent(String.self, forKey: .schoolRef) ?? ""
    }
    
    init() {
        id = ""
        name = ""
        schoolRef = ""
    }
}
