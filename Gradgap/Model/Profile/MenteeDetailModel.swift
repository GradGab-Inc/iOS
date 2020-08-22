//
//  MenteeDetailModel.swift
//  Gradgap
//
//  Created by iMac on 21/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct MenteeDetailModel: Codable {
    let code: Int
    let message: String
    let data: User?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(User.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
}
