//
//  AboutViewModel.swift
//  E-Auction
//
//  Created by iMac on 10/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import  SainiUtils

protocol AboutDelegate {
    func didRecievedAboutData(response:AboutResponse)
}

struct AboutViewModel{
    var delegate:AboutDelegate?
    
    func aboutData() {
        GCD.APPDETAIL.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.APPDETAIL.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AboutResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecievedAboutData(response: success)
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


