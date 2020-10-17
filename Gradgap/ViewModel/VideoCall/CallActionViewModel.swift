//
//  CallActionViewModel.swift
//  Gradgap
//
//  Created by iMac on 10/17/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol CallActionDelegate {
    func didRecieveCallActionResponse(response: SuccessModel)
}

struct CallActionViewModel {
    var delegate: CallActionDelegate?
    
    func getCallAction(request : GetBookingActionRequest) {
        GCD.CALL.action.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.action, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveCallActionResponse(response: success.self)
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
