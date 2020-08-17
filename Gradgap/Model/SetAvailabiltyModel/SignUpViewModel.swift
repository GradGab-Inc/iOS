//
//  SignUpViewModel.swift
//  Gradgap
//
//  Created by MACBOOK on 17/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol SignUpDelegate {
    func didRecieveSignUpResponse(response: SuccessModel)
}

struct SignUpViewModel {
    var delegate: SignUpDelegate?
    
    func createUser(signUpRequest: SignUpRequest) {
        GCD.USER.signup.async {
            APIManager.sharedInstance.I_AM_COOL(params: signUpRequest.toJSON(), api: API.USER.signup, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveSignUpResponse(response: success.self)
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
