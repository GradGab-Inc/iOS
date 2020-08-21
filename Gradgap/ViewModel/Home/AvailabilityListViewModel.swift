//
//  AvailabilityListViewModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol AvailabilityListDelegate {
    func didRecieveAvailabilityListResponse(response: AvailabiltyListModel)
}

struct AvailabilityListViewModel {
    var delegate: AvailabilityListDelegate?
    
    func availabilityList() {
        GCD.AVAILABILITY.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.AVAILABILITY.list, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AvailabiltyListModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveAvailabilityListResponse(response: success.self)
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
