//
//  AboutResponse.swift
//  E-Auction
//
//  Created by iMac on 10/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct AboutResponse: Codable {
    let code: Int
    let message: String
    let data: AboutAppDetails?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
       
       code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
       message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
       data = try values.decodeIfPresent(AboutAppDetails.self, forKey: .data) ?? nil
       format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
       timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
   }
    
}

// MARK: - DataClass
struct AboutAppData: Codable {
    let appDetails: AboutAppDetails?
    
     init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        appDetails = try values.decodeIfPresent(AboutAppDetails.self, forKey: .appDetails) ?? nil
    }
    
}

// MARK: - AppDetails
struct AboutAppDetails: Codable {
    let id, aboutUs, termsAndCondition, privacyPolicy: String
    let createdOn, updatedOn: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case aboutUs, termsAndCondition, privacyPolicy, createdOn, updatedOn
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        aboutUs = try values.decodeIfPresent(String.self, forKey: .aboutUs) ?? ""
        termsAndCondition = try values.decodeIfPresent(String.self, forKey: .termsAndCondition) ?? ""
        privacyPolicy = try values.decodeIfPresent(String.self, forKey: .privacyPolicy) ?? ""
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? ""
    }
    
    init() {
        v = 0
        id = ""
        aboutUs = ""
        termsAndCondition = ""
        privacyPolicy = ""
        createdOn = ""
        updatedOn = ""
    }
    
}
