//
//  MentorListModel.swift
//  Gradgap
//
//  Created by iMac on 20/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MentorListModel: Codable {
    let code: Int
    let message: String
    let data: [MentorSectionModel]
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
        data = try values.decodeIfPresent([MentorSectionModel].self, forKey: .data) ?? []
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
struct MentorSectionModel: Codable {
    let id: String
    let data: [MentorListDataModel]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        data = try values.decodeIfPresent([MentorListDataModel].self, forKey: .data) ?? []
    }
    
    init() {
        id = ""
        data = [MentorListDataModel].init()
    }
}


// MARK: - Datum
struct MentorListDataModel: Codable {
    let id: String
    let averageRating: Int
    let image, name, schoolID, schoolName: String
    let schoolShortName: String
    let availableTimings: [Int]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case averageRating, image, name
        case schoolID = "schoolId"
        case schoolName, schoolShortName, availableTimings
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        averageRating = try values.decodeIfPresent(Int.self, forKey: .averageRating) ?? 0
        availableTimings = try values.decodeIfPresent([Int].self, forKey: .availableTimings) ?? []
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        schoolID = try values.decodeIfPresent(String.self, forKey: .schoolID) ?? ""
        schoolName = try values.decodeIfPresent(String.self, forKey: .schoolName) ?? ""
        schoolShortName = try values.decodeIfPresent(String.self, forKey: .schoolShortName) ?? ""
    }
    
    init() {
        id = ""
        averageRating = 0
        availableTimings = []
        image = ""
        name = ""
        schoolID = ""
        schoolName = ""
        schoolShortName = ""
    }
}
