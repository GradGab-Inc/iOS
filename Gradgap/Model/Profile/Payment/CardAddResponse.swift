//
//  CardAddResponse.swift
//  Gradgap
//
//  Created by iMac on 11/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct CardAddResponse: Codable {
    let code: Int
    let message: String
    let data: CardListDataModel?
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, format, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(CardListDataModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
}
