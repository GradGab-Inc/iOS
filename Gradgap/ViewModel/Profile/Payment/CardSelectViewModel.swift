//
//  CardSelectViewModel.swift
//  Gradgap
//
//  Created by iMac on 05/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol CardSelectDelegate {
    func didRecieveCardSelectResponse(response: SuccessModel)
    func didRecieveCardRemoveResponse(response: SuccessModel)
}

struct CardSelectViewModel {
    var delegate: CardSelectDelegate?
    
    func cardSelect(request : CardSelectRequest) {
        GCD.CARD.select.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CARD.select, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveCardSelectResponse(response: success.self)
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
    
    func cardRemove(request : CardSelectRequest) {
        GCD.CARD.remove.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CARD.remove, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveCardRemoveResponse(response: success.self)
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
