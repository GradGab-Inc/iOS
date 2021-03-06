//
//  TransactionDetailViewModel.swift
//  Gradgap
//
//  Created by iMac on 12/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol TransactionDetailDelegate {
    func didRecieveTransactionDetailResponse(response: BookingDetailModel)
}

struct TransactionDetailViewModel {
    var delegate: TransactionDetailDelegate?
        
    func getTransactionDetail(request : transactionDetailRequest) {
        GCD.TRANSACTION.detail.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.TRANSACTION.detail, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(BookingDetailModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveTransactionDetailResponse(response: success.self)
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
