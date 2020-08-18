//
//  UpdateRequest.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation

struct UpdateRequest: Encodable {
    
    var schools: [String]?
    var anticipateYear: Int?
    var major: String?
    var otherLanguage: String?
    var energyFromBeingWithOthers: Int?
    var informationFromOthers: Int?
    var decisionOnLogic: Int?
    var goWithFlow: Int?
    var ethnicity: String?
    var scoreSAT: Float?
    var scoreACT: Float?
    var GPA: Float?
    var subjects: [Int]?
    var changeUserType : Bool?
    
    init(schools: [String]? = nil,anticipateYear:Int? = nil,major:String? = nil,otherLanguage:String? = nil,energyFromBeingWithOthers:Int? = nil,informationFromOthers: Int? = nil,decisionOnLogic:Int? = nil,goWithFlow:Int? = nil, scoreSAT:Float? = nil, ethnicity:String? = nil, scoreACT:Float? = nil, GPA:Float? = nil, subjects:[Int]? = nil, changeUserType:Bool? = false){
        
        self.schools = schools
        self.anticipateYear = anticipateYear
        self.major = major
        self.otherLanguage = otherLanguage
        self.energyFromBeingWithOthers = energyFromBeingWithOthers
        self.informationFromOthers = informationFromOthers
        self.decisionOnLogic = decisionOnLogic
        self.goWithFlow = goWithFlow
        self.scoreSAT = scoreSAT
        self.ethnicity = ethnicity
        self.scoreACT = scoreACT
        self.GPA = GPA
        self.subjects = subjects
        self.changeUserType = changeUserType
    }
    
    
}
