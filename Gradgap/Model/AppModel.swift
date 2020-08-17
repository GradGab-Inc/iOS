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
//    var currentUser: User!
    var isSocialLogin: Bool = Bool()
    var fcmToken: String = ""
    var token = ""
    var device = "iOS"
}

// MARK: - SuccessModel
struct SuccessModel: Codable {
    let code: Int
    let message, format, timestamp: String
}

