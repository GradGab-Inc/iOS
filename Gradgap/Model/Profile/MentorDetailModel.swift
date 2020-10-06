//
//  MentorDetailModel.swift
//  Gradgap
//
//  Created by iMac on 20/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MentorDetailModel: Codable {
    let code: Int
    let message: String
    let data: MentorData?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(MentorData.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
}

// MARK: - DataClass
struct MentorData: Codable {
    let id, firstName, lastName, email: String
    let image: String
    let userType, studyingIn, anticipateYear: Int
    let major: String
    let scoreSAT, scoreACT, gpa: Double
    let ethnicity: Int
    let subjects: [Int]
    let bio, enrollmentID: String
    let personality: Personality?
    let school: [MajorListDataModel]
    let averageRating, amount: Int
    let availableTimings: [Int]
    let isFavourite: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, image, userType, studyingIn, anticipateYear, major, scoreSAT, scoreACT, amount
        case gpa = "GPA"
        case subjects, bio, ethnicity
        case enrollmentID = "enrollmentId"
        case personality, school, averageRating, availableTimings, isFavourite
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        major = try values.decodeIfPresent(String.self, forKey: .major) ?? ""
        userType = try values.decodeIfPresent(Int.self, forKey: .userType) ?? 0
        studyingIn = try values.decodeIfPresent(Int.self, forKey: .studyingIn) ?? 0
        anticipateYear = try values.decodeIfPresent(Int.self, forKey: .anticipateYear) ?? 0
        scoreSAT = try values.decodeIfPresent(Double.self, forKey: .scoreSAT) ?? 0.0
        scoreACT = try values.decodeIfPresent(Double.self, forKey: .scoreACT) ?? 0.0
        gpa = try values.decodeIfPresent(Double.self, forKey: .gpa) ?? 0.0
        amount = try values.decodeIfPresent(Int.self, forKey: .amount) ?? 0
        subjects = try values.decodeIfPresent([Int].self, forKey: .subjects) ?? []
        ethnicity = try values.decodeIfPresent(Int.self, forKey: .ethnicity) ?? 0
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? ""
        enrollmentID = try values.decodeIfPresent(String.self, forKey: .enrollmentID) ?? ""
        averageRating = try values.decodeIfPresent(Int.self, forKey: .averageRating) ?? 0
        availableTimings = try values.decodeIfPresent([Int].self, forKey: .availableTimings) ?? []
        school = try values.decodeIfPresent([MajorListDataModel].self, forKey: .school) ?? []
        personality = try values.decodeIfPresent(Personality.self, forKey: .personality) ?? nil
        isFavourite = try values.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
    }
    
    init() {
        id = ""
        firstName = ""
        lastName = ""
        email = ""
        image = ""
        major = ""
        userType = 0
        studyingIn = 0
        anticipateYear = 0
        scoreSAT = 0.0
        scoreACT = 0.0
        gpa = 0.0
        subjects = []
        ethnicity = 0
        bio = ""
        enrollmentID = ""
        averageRating = 0
        availableTimings = []
        school = [MajorListDataModel].init()
        personality = Personality.init()
        isFavourite = false
        amount = 0
        
    }
}




