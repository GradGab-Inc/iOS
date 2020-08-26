//
//  SwitchProfileViewModel.swift
//  Gradgap
//
//  Created by iMac on 24/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol SwitchProfileDelegate {
    func didRecieveSwitchProfileResponse(response: LoginResponse)
}

struct SwitchProfileViewModel {
    var delegate: SwitchProfileDelegate?
    
    func switchProfile(request : SwitchProfileRequest) {
        GCD.BOOKING.bookingDetail.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.bookingDetail, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into model
                        switch success.code {
                        case 100:
                            self.delegate?.didRecieveSwitchProfileResponse(response: success.self)
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
