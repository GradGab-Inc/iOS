//
//  DateAvailabilityListViewModel.swift
//  Gradgap
//
//  Created by iMac on 9/23/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol DateAvailabilityListDelegate {
    func didRecieveDateAvailabilityListResponse(response: AvailabiltyListModel)
}

struct DateAvailabilityListViewModel {
    var delegate: DateAvailabilityListDelegate?
    
    func availabilityList(request : SelectDateAvailabiltyRequest) {
        GCD.AVAILABILITY.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.AVAILABILITY.list, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AvailabiltyListModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveDateAvailabilityListResponse(response: success.self)
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
