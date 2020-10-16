//
//  NotificationResponse.swift
//  Gradgap
//
//  Created by iMac on 05/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NotificationResponse: Codable {
    let code: Int
    let message: String
    let data: [NotificationListModel]
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
        data = try values.decodeIfPresent([NotificationListModel].self, forKey: .data) ?? []
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
struct NotificationListModel: Codable {
    let id, name, message, image, ref, firstName, lastName: String
    let createdOn: String
    let type: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, message, image, createdOn, ref, firstName, lastName, type
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        ref = try values.decodeIfPresent(String.self, forKey: .ref) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? 0
    }
    
    init() {
        message = ""
        image = ""
        createdOn = ""
        id = ""
        name = ""
        ref = ""
        firstName = ""
        lastName = ""
        type = 0
    }
    
}
