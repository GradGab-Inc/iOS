//
//  HomeBookingListViewModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol HomeBookingListDelegate {
    func didRecieveHomeBookingListResponse(response: SuccessModel)
}

struct HomeBookingListViewModel {
    var delegate: HomeBookingListDelegate?
    
    func getBookingList(signUpRequest: SignUpRequest) {
        GCD.BOOKING.bookingList.async {
            APIManager.sharedInstance.I_AM_COOL(params: signUpRequest.toJSON(), api: API.BOOKING.bookingList, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveHomeBookingListResponse(response: success.self)
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
