//
//  LoginResponse.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let code: Int
    let message: String
    let data: UserDataModel?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(UserDataModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - UserDataModel
struct UserDataModel: Codable {
    var accessToken: String
    var user: User?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? DocumentDefaultValues.Empty.string
        user = try values.decodeIfPresent(User.self, forKey: .user) ?? nil
    }
    
    init() {
        accessToken = DocumentDefaultValues.Empty.string
        user = User.init()
    }
}

// MARK: - User
struct User: Codable {
    let personality: Personality?
    let lastName, image: String
    let userType, studyingIn, anticipateYear, collegePath, walletAmount: Int
    let scoreSAT: Double
    let scoreACT, gpa, averageRating: Double
    let ethnicity: Int
    let subjects: [Int]
    let bio, major, otherLanguage, id, enrollmentId: String
    let firstName, email: String
    let school: [MajorListDataModel]
    let profileCompleted: Bool
    

    enum CodingKeys: String, CodingKey {
        case personality, lastName, image, userType, studyingIn, anticipateYear, scoreSAT, scoreACT, enrollmentId, walletAmount
        case gpa = "GPA"
        case ethnicity, subjects, bio, major, otherLanguage, averageRating, collegePath
        case id = "_id"
        case firstName, email, school, profileCompleted
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personality = try values.decodeIfPresent(Personality.self, forKey: .personality) ?? nil
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        userType = try values.decodeIfPresent(Int.self, forKey: .userType) ?? DocumentDefaultValues.Empty.int
        collegePath = try values.decodeIfPresent(Int.self, forKey: .collegePath) ?? DocumentDefaultValues.Empty.int
        studyingIn = try values.decodeIfPresent(Int.self, forKey: .studyingIn) ?? DocumentDefaultValues.Empty.int
        anticipateYear = try values.decodeIfPresent(Int.self, forKey: .anticipateYear) ?? DocumentDefaultValues.Empty.int
        scoreSAT = try values.decodeIfPresent(Double.self, forKey: .scoreSAT) ?? DocumentDefaultValues.Empty.double
        scoreACT = try values.decodeIfPresent(Double.self, forKey: .scoreACT) ?? DocumentDefaultValues.Empty.double
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? DocumentDefaultValues.Empty.double
        gpa = try values.decodeIfPresent(Double.self, forKey: .gpa) ?? DocumentDefaultValues.Empty.double
        ethnicity = try values.decodeIfPresent(Int.self, forKey: .ethnicity) ?? DocumentDefaultValues.Empty.int
        subjects = try values.decodeIfPresent([Int].self, forKey: .subjects) ?? []
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? DocumentDefaultValues.Empty.string
        major = try values.decodeIfPresent(String.self, forKey: .major) ?? DocumentDefaultValues.Empty.string
        otherLanguage = try values.decodeIfPresent(String.self, forKey: .otherLanguage) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        school = try values.decodeIfPresent([MajorListDataModel].self, forKey: .school) ?? []
        enrollmentId = try values.decodeIfPresent(String.self, forKey: .enrollmentId) ?? DocumentDefaultValues.Empty.string
        walletAmount = try values.decodeIfPresent(Int.self, forKey: .walletAmount) ?? DocumentDefaultValues.Empty.int
        profileCompleted = try values.decodeIfPresent(Bool.self, forKey: .profileCompleted) ?? false
    }
    
    init() {
        personality =  Personality.init()
        lastName = DocumentDefaultValues.Empty.string
        image = DocumentDefaultValues.Empty.string
        userType = DocumentDefaultValues.Empty.int
        studyingIn = DocumentDefaultValues.Empty.int
        anticipateYear = DocumentDefaultValues.Empty.int
        collegePath = DocumentDefaultValues.Empty.int
        scoreSAT = DocumentDefaultValues.Empty.double
        scoreACT = DocumentDefaultValues.Empty.double
        averageRating = DocumentDefaultValues.Empty.double
        gpa = DocumentDefaultValues.Empty.double
        ethnicity = -1
        subjects = []
        bio = DocumentDefaultValues.Empty.string
        major = DocumentDefaultValues.Empty.string
        otherLanguage = DocumentDefaultValues.Empty.string
        id = DocumentDefaultValues.Empty.string
        firstName = DocumentDefaultValues.Empty.string
        email = DocumentDefaultValues.Empty.string
        school = [MajorListDataModel].init()
        enrollmentId = DocumentDefaultValues.Empty.string
        walletAmount = DocumentDefaultValues.Empty.int
        profileCompleted = false
    }
    
}

// MARK: - Personality
struct Personality: Codable {
    let decisionOnLogic, energyFromBeingWithOthers, goWithFlow, informationFromOthers: Int
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        decisionOnLogic = try values.decodeIfPresent(Int.self, forKey: .decisionOnLogic) ?? DocumentDefaultValues.Empty.int
        energyFromBeingWithOthers = try values.decodeIfPresent(Int.self, forKey: .energyFromBeingWithOthers) ?? DocumentDefaultValues.Empty.int
        goWithFlow = try values.decodeIfPresent(Int.self, forKey: .goWithFlow) ?? DocumentDefaultValues.Empty.int
        informationFromOthers = try values.decodeIfPresent(Int.self, forKey: .informationFromOthers) ?? DocumentDefaultValues.Empty.int
    }
    
    init() {
        decisionOnLogic = DocumentDefaultValues.Empty.int
        energyFromBeingWithOthers = DocumentDefaultValues.Empty.int
        goWithFlow = DocumentDefaultValues.Empty.int
        informationFromOthers = DocumentDefaultValues.Empty.int
    }
    
    
}
