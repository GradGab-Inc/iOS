//
//  ExtendCallViewModel.swift
//  Gradgap
//
//  Created by iMac on 10/14/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol ExtendCallDelegate {
    func didRecieveExtendCallResponse(response: SuccessModel)
}

struct ExtendCallViewModel {
    var delegate: ExtendCallDelegate?
    
    func setExtendCall(request : ExtendVideoCallDataRequest) {
        GCD.CALL.extend.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.extend, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code {
                        case 100:
                            self.delegate?.didRecieveExtendCallResponse(response: success.self)
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


