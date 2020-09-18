//
//  BankViewDetailViewModel.swift
//  Gradgap
//
//  Created by iMac on 9/18/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import  SainiUtils

protocol BankViewDetailDelegate {
    func didRecievedBankViewDetailData(response:AboutResponse)
}

struct BankViewDetailViewModel{
    var delegate:BankViewDetailDelegate?
    
    func getBankDetail() {
        GCD.BANK.view.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.BANK.view, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AboutResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecievedBankViewDetailData(response: success)
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
