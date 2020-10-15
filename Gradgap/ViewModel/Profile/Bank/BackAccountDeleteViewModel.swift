//
//  BackAccountDeleteViewModel.swift
//  Gradgap
//
//  Created by iMac on 9/18/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import  SainiUtils

protocol BackAccountDeleteDelegate {
    func didRecievedBackAccountDeleteData(response:SuccessModel)
}

struct BackAccountDeleteViewModel {
    var delegate:BackAccountDeleteDelegate?
    
    func deleteBankAccount() {
        GCD.BANK.delete.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.BANK.delete, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecievedBackAccountDeleteData(response: success)
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
