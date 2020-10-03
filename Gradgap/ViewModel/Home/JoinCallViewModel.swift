//
//  JoinCallViewModel.swift
//  Gradgap
//
//  Created by iMac on 10/3/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol JoinCallDelegate {
    func didRecieveJoinCallResponse(response: VideoCallResponse)
}

struct JoinCallViewModel {
    var delegate: JoinCallDelegate?
    
    func getVideoCallData(request : VideoCallDataRequest) {
        GCD.CALL.join.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.join, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(VideoCallResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveJoinCallResponse(response: success.self)
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
