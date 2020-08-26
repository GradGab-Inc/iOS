//
//  BookingActionViewModel.swift
//  Gradgap
//
//  Created by iMac on 22/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol BookingActionDelegate {
    func didRecieveBookingActionResponse(response: SuccessModel)
}

struct BookingActionViewModel {
    var delegate: BookingActionDelegate?
    
    func getBookingAction(request : GetBookingActionRequest) {
        GCD.BOOKING.action.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.action, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveBookingActionResponse(response: success.self)
                            break
                        case 424:
                            self.delegate?.didRecieveBookingActionResponse(response: success.self)
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
