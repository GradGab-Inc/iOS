//
//  BookingDetailViewModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol BookingDetailDelegate {
    func didRecieveBookingDetailResponse(response: BookingDetailModel)
}

struct BookingDetailViewModel {
    var delegate: BookingDetailDelegate?
    
    func getBookingDetail(request : GetBookingDetailRequest) {
        GCD.BOOKING.bookingDetail.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.bookingDetail, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(BookingDetailModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveBookingDetailResponse(response: success.self)
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
