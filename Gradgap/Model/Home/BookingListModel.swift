//
//  BookingListModel.swift
//  Gradgap
//
//  Created by iMac on 21/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - BookingListModel
struct BookingListModel: Codable {
    let code: Int
    let message: String
    let data: [BookingListDataModel]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([BookingListDataModel].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? 0
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
    
}

// MARK: - BookingListDataModel
struct BookingListDataModel: Codable {
    let id, menteeRef, mentorRef, name: String
    let schoolName, dateTime, image: String
    let status, callTime, callType: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case menteeRef, mentorRef, name, schoolName, dateTime, status, callTime, image, callType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        status = try values.decodeIfPresent(Int.self, forKey: .status) ?? 0
        callTime = try values.decodeIfPresent(Int.self, forKey: .callTime) ?? 0
        callType = try values.decodeIfPresent(Int.self, forKey: .callType) ?? 0
        mentorRef = try values.decodeIfPresent(String.self, forKey: .mentorRef) ?? ""
        menteeRef = try values.decodeIfPresent(String.self, forKey: .menteeRef) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        schoolName = try values.decodeIfPresent(String.self, forKey: .schoolName) ?? ""
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
    
    init() {
        id = ""
        status = 0
        callTime = 0
        callType = 0
        mentorRef = ""
        menteeRef = ""
        name = ""
        schoolName = ""
        dateTime = ""
        image = ""
    }
    
}
