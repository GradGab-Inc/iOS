//
//  CreateBookingViewModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol CreateBookingDelegate {
    func didRecieveCreateBookingResponse(response: SuccessModel)
}

struct CreateBookingViewModel {
    var delegate: CreateBookingDelegate?
    
    func createBooking(request : CreateBookingRequest) {
        GCD.BOOKING.create.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.BOOKING.create, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveCreateBookingResponse(response: success.self)
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
