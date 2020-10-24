//
//  BookingDetailModel.swift
//  Gradgap
//
//  Created by iMac on 22/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - BookingDetailModel
struct BookingDetailModel: Codable {
    let code: Int
    let message: String
    let data: BookingDetail?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
       
       code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
       message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
       data = try values.decodeIfPresent(BookingDetail.self, forKey: .data) ?? nil
       format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
       timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
   }
    
}

// MARK: - BookingDetail
struct BookingDetail: Codable {
    var id, menteeRef, mentorRef, image: String
    var name, schoolName, additionalTopics, dateTime, bio, transactionTime, firstName, lastName: String
    let subjects: [Int]
    var anticipateYear, status, callTime, callType, timeSlot: Int
    let amount, mentorPaidAmount: Double
    var isFavourite: Bool
    let averageRating: Double
    let major: String
    var email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case menteeRef, mentorRef, image, name, schoolName, additionalTopics, dateTime, subjects, anticipateYear, status, callTime, callType, amount, isFavourite, averageRating, timeSlot, bio, transactionTime, firstName, lastName, major, email, mentorPaidAmount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        menteeRef = try values.decodeIfPresent(String.self, forKey: .menteeRef) ?? ""
        mentorRef = try values.decodeIfPresent(String.self, forKey: .mentorRef) ?? ""
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        schoolName = try values.decodeIfPresent(String.self, forKey: .schoolName) ?? ""
        additionalTopics = try values.decodeIfPresent(String.self, forKey: .additionalTopics) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime) ?? ""
        callTime = try values.decodeIfPresent(Int.self, forKey: .callTime) ?? 0
        status = try values.decodeIfPresent(Int.self, forKey: .status) ?? 0
        anticipateYear = try values.decodeIfPresent(Int.self, forKey: .anticipateYear) ?? 0
        callType = try values.decodeIfPresent(Int.self, forKey: .callType) ?? 0
        amount = try values.decodeIfPresent(Double.self, forKey: .amount) ?? 0
        timeSlot = try values.decodeIfPresent(Int.self, forKey: .timeSlot) ?? 0
        subjects = try values.decodeIfPresent([Int].self, forKey: .subjects) ?? []
        isFavourite = try values.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        transactionTime = try values.decodeIfPresent(String.self, forKey: .transactionTime) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        major = try values.decodeIfPresent(String.self, forKey: .major) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        mentorPaidAmount = try values.decodeIfPresent(Double.self, forKey: .mentorPaidAmount) ?? 0
    }
    
    
    init() {
        id = ""
        menteeRef = ""
        mentorRef = ""
        name = ""
        schoolName = ""
        additionalTopics = " "
        image = ""
        dateTime = ""
        callTime = 0
        status = 0
        anticipateYear = 0
        callType = 0
        amount = 0
        timeSlot = 0
        subjects = []
        isFavourite = false
        averageRating = 0.0
        bio = ""
        transactionTime = ""
        firstName = ""
        lastName = ""
        major = ""
        email = ""
        mentorPaidAmount = 0
    }
}
