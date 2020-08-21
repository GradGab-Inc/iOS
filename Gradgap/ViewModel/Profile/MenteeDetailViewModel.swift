//
//  MenteeDetailViewModel.swift
//  Gradgap
//
//  Created by iMac on 21/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol MenteeDetailDelegate {
    func didRecieveMenteeDetailResponse(response: MenteeDetailModel)
}

struct MenteeDetailViewModel {
    var delegate: MenteeDetailDelegate?
    
    func getMenteeProfileDetail() {
        GCD.USER.details.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.USER.details, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MenteeDetailModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveMenteeDetailResponse(response: success.self)
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
