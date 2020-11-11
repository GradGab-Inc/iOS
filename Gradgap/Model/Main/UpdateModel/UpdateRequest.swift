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
    var ethnicity: Int?
    var scoreSAT: Double?
    var scoreACT: Double?
    var GPA: Double?
    var subjects: [Int]?
    var changeUserType, collegePath : Int?
    var firstName : String?
    var lastName, bio : String?
    var completeProfile: Bool?
    var referralId: String?
    
    init(schools: [String]? = nil,anticipateYear:Int? = nil,major:String? = nil,otherLanguage:String? = nil,energyFromBeingWithOthers:Int? = nil,informationFromOthers: Int? = nil,decisionOnLogic:Int? = nil,goWithFlow:Int? = nil, scoreSAT:Double? = nil, ethnicity:Int? = nil, scoreACT:Double? = nil, GPA:Double? = nil, subjects:[Int]? = nil, changeUserType:Int? = nil, firstName:String? = nil, lastName:String? = nil, bio:String? = nil, collegePath:Int? = nil, completeProfile:Bool? = nil, referralId:String? = nil){
        
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
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.collegePath = collegePath
        self.completeProfile = completeProfile
        self.referralId = referralId
    }
    
    
}
