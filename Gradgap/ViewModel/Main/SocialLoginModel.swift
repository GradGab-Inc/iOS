//
//  SocialLoginModel.swift
//  E-Auction
//
//  Created by iMac on 01/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol SocialLoginSuccessDelegate {
    func didReceivedSocialLoginData(userData: LoginResponse)
}

struct SocialLoginViewModel {
    var delegate: SocialLoginSuccessDelegate?
    
    func socialLogin(request:SocialLoginRequest) {
        GCD.USER.socialLogin.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.socialLogin, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into success model
                        switch success.code {
                        case 100:
                            self.delegate?.didReceivedSocialLoginData(userData: success)
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

