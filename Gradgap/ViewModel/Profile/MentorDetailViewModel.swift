//
//  MentorDetailViewModel.swift
//  Gradgap
//
//  Created by iMac on 20/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol MentorDetailDelegate {
    func didRecieveMentorDetailResponse(response: MentorDetailModel)
}

struct MentorDetailViewModel {
    var delegate: MentorDetailDelegate?
    
    func getMentorDetail(request : MentorDetailRequest) {
        GCD.USER.details.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.details, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MentorDetailModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveMentorDetailResponse(response: success.self)
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
