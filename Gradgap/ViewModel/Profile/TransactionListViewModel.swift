//
//  TransactionListViewModel.swift
//  Gradgap
//
//  Created by iMac on 12/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol TransactionListDelegate {
    func didRecieveTransactionListResponse(response: TransactionResponse)
}

struct TransactionListViewModel {
    var delegate: TransactionListDelegate?
        
    func getTransactionList(request : MorePageRequest) {
        GCD.TRANSACTION.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.TRANSACTION.list, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(TransactionResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveTransactionListResponse(response: success.self)
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
