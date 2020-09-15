//
//  ContectAdminViewModel.swift
//  E-Auction
//
//  Created by iMac on 09/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
//import  SainiUtils
//
//protocol ContactAdminDelegate {
//    func didRecievedContactAdminData(response:ContactAdminResponse)
//}
//
//struct ContactAdminViewModel{
//    var delegate:ContactAdminDelegate?
//    
//    func contactAdmin(request:ContactAdminRequest) {
//        GCD.USER.contactAdmin.async {
//            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.contactAdmin, Loader: false, isMultipart: false) { (response) in
//                if response != nil{                             //if response is not empty
//                    do {
//                        let success = try JSONDecoder().decode(ContactAdminResponse.self, from: response!) // decode the response into success model
//                        switch success.code{
//                        case 100:
//                            self.delegate?.didRecievedContactAdminData(response: success)
//                            break
//                        default:
//                            log.error("\(Log.stats()) \(success.message)")/
//                        }
//                    }
//                    catch let err {
//                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
//                    }
//                }
//            }
//        }
//    }
// 
//}
