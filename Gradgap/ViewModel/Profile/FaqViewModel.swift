//
//  FaqViewModel.swift
//  E-Auction
//
//  Created by iMac on 10/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import  SainiUtils

protocol FaqDelegate {
    func didRecievedFaqListData(response:FaqListResponse)
}

struct FaqViewModel{
    var delegate:FaqDelegate?
    
    func getFaqList() {
        GCD.APPDETAIL.listFaq.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.APPDETAIL.listFaq, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(FaqListResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecievedFaqListData(response: success)
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

