//
//  RatingViewModel.swift
//  Gradgap
//
//  Created by iMac on 05/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol RatingDelegate {
    func didRecieveRatingAddResponse(response: NotificationResponse)
}

struct RatingViewModel {
    var delegate: RatingDelegate?
    
    func notificationList(request : RatingAddRequest) {
        GCD.RATING.add.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.RATING.add, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(NotificationResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveRatingAddResponse(response: success.self)
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
