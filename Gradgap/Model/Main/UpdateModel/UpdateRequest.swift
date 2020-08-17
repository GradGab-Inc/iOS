//
//  UpdateRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct UpdateRequest: Encodable {
    var schools: [String]
    var anticipateYear: Int
    var major: String
    var otherLanguage: String
    var energyFromBeingWithOthers: Int
    var informationFromOthers: Int
    var decisionOnLogic: Int
    var goWithFlow: Int
    var ethnicity: String
    var scoreSAT: Int
    var scoreACT: Int
    var GPA: Int
    var subjects: [Int]
}
