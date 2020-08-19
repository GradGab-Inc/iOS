//
//  SetAvailabilityViewModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol SetAvailabilityDelegate {
    func didRecieveSetAvailabilityResponse(response: AvailabiltyListModel)
    func didRecieveDeleteAvailabilityResponse(response: SuccessModel)
    func didRecieveUpdateAvailabilityResponse(response: AvailabiltyListModel)
}

struct SetAvailabilityViewModel {
    var delegate: SetAvailabilityDelegate?
    
    func setAvailability(signUpRequest: SignUpRequest) {
        GCD.AVAILABILITY.set.async {
            APIManager.sharedInstance.I_AM_COOL(params: signUpRequest.toJSON(), api: API.AVAILABILITY.set, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AvailabiltyListModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveSetAvailabilityResponse(response: success.self)
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
    
    func deleteAvailability(signUpRequest: AvailabiltyDeleteRequest) {
        GCD.AVAILABILITY.delete.async {
            APIManager.sharedInstance.I_AM_COOL(params: signUpRequest.toJSON(), api: API.AVAILABILITY.delete, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveDeleteAvailabilityResponse(response: success.self)
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
    
    func updateAvailability(signUpRequest: SignUpRequest) {
        GCD.AVAILABILITY.update.async {
            APIManager.sharedInstance.I_AM_COOL(params: signUpRequest.toJSON(), api: API.AVAILABILITY.update, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AvailabiltyListModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveUpdateAvailabilityResponse(response: success.self)
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
