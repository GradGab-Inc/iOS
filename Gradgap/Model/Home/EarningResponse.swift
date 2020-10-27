//
//  EarningResponse.swift
//  Gradgap
//
//  Created by iMac on 15/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct EarningResponse: Codable {
    let code: Int
    let message: String
    let data: EarningDataModel?
    let page, limit: Int
    let hasMore: Bool
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, data, page, limit, hasMore, format, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(EarningDataModel.self, forKey: .data) ?? nil
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
    
    init() {
        code = 0
        message = ""
        data = EarningDataModel.init()
        page = 0
        limit = 0
        hasMore = false
        format = ""
        timestamp = ""
    }
    
}

// MARK: - DataClass
struct EarningDataModel: Codable {
    let earningList: [TransactionListModel]
    let total: Total?
    
    enum CodingKeys: String, CodingKey {
        case earningList
        case total
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        total = try values.decodeIfPresent(Total.self, forKey: .total) ?? nil
        earningList = try values.decodeIfPresent([TransactionListModel].self, forKey: .earningList) ?? []
      
    }
    
    init() {
        total = Total.init()
        earningList = []
    }
    
}

// MARK: - Total
struct Total: Codable {
    let id: String
    let count: Int
    let earnings: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case count, earnings
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        earnings = try values.decodeIfPresent(Double.self, forKey: .earnings) ?? 0.00
    }
    
    init() {
        count = 0
        id = ""
        earnings = 0.00
    }
    
}
