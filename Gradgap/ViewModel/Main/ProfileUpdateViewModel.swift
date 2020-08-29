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
    
    func getchProfile() {
        GCD.USER.update.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.USER.update, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceivedData(response: success)
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
    
    func updateProfileWithTwoImage(request: UpdateRequest, imageData: Data, imageData1: Data) {
        GCD.USER.update.async {
            APIManager.sharedInstance.MULTIPART_IS_COOL_With_Pictures(imageData, imageData1, param: request.toJSON(), api: API.USER.update, login: true) { (response) in
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
