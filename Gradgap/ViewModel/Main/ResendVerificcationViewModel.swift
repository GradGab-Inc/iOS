//
//  ResendVerificcationViewModel.swift
//  Gradgap
//
//  Created by iMac on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils


protocol ResendVerificcationSuccessDelegate {
    func didReceivedData(message: String)
}

struct ResendVerificcationViewModel {
    var delegate: ResendVerificcationSuccessDelegate?
    
    func resendVerification(request:ResendVerificationRequest) {
        GCD.USER.resendVerification.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.resendVerification, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code {
                        case 100:
                            self.delegate?.didReceivedData(message: success.message)
                            break
                        default:
                            APIManager.sharedInstance.handleError(errorCode: success.code, success.message)
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

