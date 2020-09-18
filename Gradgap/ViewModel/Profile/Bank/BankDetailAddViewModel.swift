//
//  BankDetailAddViewModel.swift
//  Gradgap
//
//  Created by iMac on 9/18/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import  SainiUtils

protocol BankDetailAddDelegate {
    func didRecievedBankDetailAddData(response:SuccessModel)
}

struct BankDetailAddViewModel{
    var delegate:BankDetailAddDelegate?
    
    func addBankDetail(request : AddBankRequest, imageData: Data, imageData1: Data) {
        GCD.BANK.add.async {
            APIManager.sharedInstance.MULTIPART_IS_COOL_With_ID_Pictures(imageData, imageData1, param: request.toJSON(), api: API.BANK.add, login: true) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecievedBankDetailAddData(response: success)
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
            
//            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BANK.add, Loader: false, isMultipart: false) { (response) in
//                if response != nil{                             //if response is not empty
//                    do {
//                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
//                        switch success.code{
//                        case 100:
//                            self.delegate?.didRecievedBankDetailAddData(response: success)
//                            break
//                        default:
//                            log.error("\(Log.stats()) \(success.message)")/
//                        }
//                    }
//                    catch let err {
//                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
//                    }
//                }
//            }
        }
    }
 
}
