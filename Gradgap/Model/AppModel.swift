//
//  AppModel.swift
//  cwrnch-ios
//
//  Created by App Knit on 27/12/19.
//  Copyright © 2019 Sukhmani. All rights reserved.
//

import Foundation
//MARK: - AppModel
class AppModel: NSObject {
    static let shared = AppModel()
    var currentUser: UserDataModel!
    var isSocialLogin: Bool = Bool()
    var fcmToken: String = ""
    var token = ""
    var device = "iOS"
}



// MARK: - SuccessModel

struct SuccessModel: Codable {
    let code: Int
    let message, format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
    }
}

