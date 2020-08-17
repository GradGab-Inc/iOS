//
//  LoginViewModel.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol LoginDelegate {
    func didRecieveLoginResponse(response: LoginResponse)
}

struct LoginViewModel {
    var delegate: LoginDelegate?
    
    func loginUser(loginRequest: LoginRequest) {
        GCD.USER.login.async {
            APIManager.sharedInstance.I_AM_COOL(params: loginRequest.toJSON(), api: API.USER.login, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveLoginResponse(response: success.self)
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
