//
//  EarningListRequest.swift
//  Gradgap
//
//  Created by iMac on 9/22/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


struct EarningListRequest: Encodable {
    
    var dateStart: String?
    var dateEnd: String?
    var page : Int?
    var limit: Int?
    
    init(dateStart:String? = nil,dateEnd:String? = nil, page:Int? = nil, limit:Int? = nil){
        
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.page = page
        self.limit = limit
    }
}
