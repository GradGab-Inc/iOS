//
//  FavoriteListModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct FavoriteListModel: Codable {
    let code: Int
    let message: String
    let data: [FavoriteDataModel]
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
        data = try values.decodeIfPresent([FavoriteDataModel].self, forKey: .data) ?? []
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
struct FavoriteDataModel: Codable {
    let id, mentorRef: String
    let averageRating: Double
    let schoolName, image, name, firstName, lastName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case mentorRef, averageRating, schoolName, image, name, firstName, lastName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        mentorRef = try values.decodeIfPresent(String.self, forKey: .mentorRef) ?? ""
        schoolName = try values.decodeIfPresent(String.self, forKey: .schoolName) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
    }
}
