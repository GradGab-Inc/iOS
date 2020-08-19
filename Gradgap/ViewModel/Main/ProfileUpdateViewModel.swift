//
//  ProfileUpdateViewModel.swift
//  Gradgap
//
//  Created by iMac on 18/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils


protocol ProfileUpdateSuccessDelegate {
    func didReceivedData(response: LoginResponse)
}

struct ProfileUpdateViewModel {
    var delegate: ProfileUpdateSuccessDelegate?
    
    func updateProfile(request: UpdateRequest, imageData: Data, fileName: String) {
        GCD.USER.update.async {
            APIManager.sharedInstance.MULTIPART_IS_COOL(imageData, param: request.toJSON(), api: API.USER.update, login: true, fileName: fileName) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into success model
                        switch success.code {
                        case 100:
                            self.delegate?.didReceivedData(response: success)
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
