//
//  EarningViewModel.swift
//  Gradgap
//
//  Created by iMac on 14/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol EarningListDelegate {
    func didRecieveEarningListResponse(response: CouponListResponse)
}

struct EarningViewModel {
    var delegate: EarningListDelegate?
    
    func couponList(request : MorePageRequest) {
        GCD.TRANSACTION.earning.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.TRANSACTION.earning, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(CouponListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveEarningListResponse(response: success.self)
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
