//
//  CustomDateAvaibilityViewModel.swift
//  Gradgap
//
//  Created by iMac on 9/23/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol CustomDateAvailabilityDelegate {
    func didRecieveCustomDateAvailabilityResponse(response: SuccessModel)
}


struct CustomDateAvaibilityViewModel {
    var delegate: CustomDateAvailabilityDelegate?

    func setAvailability(request: SetAvailabiltyRequest) {
        GCD.AVAILABILITY.setCustom.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.AVAILABILITY.setCustom, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code {
                        case 100:
                            self.delegate?.didRecieveCustomDateAvailabilityResponse(response: success.self)
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
