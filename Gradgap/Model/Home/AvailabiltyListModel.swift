//
//  AvailabiltyListModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct AvailabiltyListModel: Codable {
    let code: Int
    let message: String
    let data: [AvailabilityDataModel]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([AvailabilityDataModel].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? 0
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
}

// MARK: - Datum
struct AvailabilityDataModel: Codable {
    let deleted: Bool
    var id, startTime, endTime: String
    var type, weekDay: Int
    let mentorRef: String
    let datumV, v: Int?

    enum CodingKeys: String, CodingKey {
        case deleted
        case id = "_id"
        case startTime, endTime, type, weekDay, mentorRef
        case datumV = "v"
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? 0
        weekDay = try values.decodeIfPresent(Int.self, forKey: .weekDay) ?? 0
        datumV = try values.decodeIfPresent(Int.self, forKey: .datumV) ?? 0
        mentorRef = try values.decodeIfPresent(String.self, forKey: .mentorRef) ?? ""
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? ""
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime) ?? ""
    }
    
    init() {
        deleted = false
        id = ""
        v = 0
        type = 0
        weekDay = -1
        datumV = 0
        mentorRef = ""
        startTime = ""
        endTime = ""
    }
    
}

