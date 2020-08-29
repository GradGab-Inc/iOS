//
//  SchoolSearchListViewModel.swift
//  Gradgap
//
//  Created by iMac on 18/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils


protocol SchoolSearchListSuccessDelegate {
    func didReceivedData(response: MajorListModel)
}

struct SchoolSearchListViewModel {
    var delegate: SchoolSearchListSuccessDelegate?
    
    func schoolSearchList(request : SchoolSearchRequest) {
        GCD.SCHOOL.search.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.SCHOOL.search, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MajorListModel.self, from: response!) // decode the response into success model
                        switch success.code {
                        case 100:
                            self.delegate?.didReceivedData(response: success)
                            break
                        default:
                            log.error("\(Log.stats()) \(success.message)")/
                        }
                    }
                    catch let err {
                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                    }
                }
            }
        }
    }
}
