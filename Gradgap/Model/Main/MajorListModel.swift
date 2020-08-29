//
//  MajorListModel.swift
//  Gradgap
//
//  Created by iMac on 18/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct MajorListModel: Codable {
    let code: Int
    let message: String
    let data: [MajorListDataModel]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, format, timestamp
        case page, limit, size, hasMore
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([MajorListDataModel].self, forKey: .data) ?? []
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
struct MajorListDataModel: Codable {
    let id, name, shortName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, shortName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        shortName = try values.decodeIfPresent(String.self, forKey: .shortName) ?? ""
    }
    
    init() {
        id = ""
        name = ""
        shortName = ""
    }
    
}
