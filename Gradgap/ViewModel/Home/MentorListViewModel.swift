//
//  MentorListViewModel.swift
//  Gradgap
//
//  Created by iMac on 20/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol MentorListDelegate {
    func didRecieveMentorListResponse(response: MentorListModel)
}

struct MentorListViewModel {
    var delegate: MentorListDelegate?
    
    func getMentorList(request : MentorListRequest) {
        GCD.BOOKING.create.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.create, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MentorListModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveMentorListResponse(response: success.self)
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
