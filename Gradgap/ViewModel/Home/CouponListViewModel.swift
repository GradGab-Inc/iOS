//
//  CouponListViewModel.swift
//  Gradgap
//
//  Created by iMac on 12/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol CouponListDelegate {
    func didRecieveCouponListResponse(response: CouponListResponse)
}

protocol CouponDetailDelegate {
    func didRecieveApplyCouponDetailResponse(response: CouponDetailResponse)
}


struct CouponListViewModel {
    var delegate: CouponListDelegate?
    var delegate1: CouponDetailDelegate?
    
    func couponList(request : CouponListRequest) {
        GCD.COUPON.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.COUPON.list, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(CouponListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveCouponListResponse(response: success.self)
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
    
    func applyCouponCode(request : ApplyCouponRequest) {
        GCD.COUPON.detail.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.COUPON.detail, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(CouponDetailResponse.self, from: response!) // decode the response into model
                        switch success.code {
                        case 100:
                            self.delegate1?.didRecieveApplyCouponDetailResponse(response: success.self)
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
