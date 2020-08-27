//
//  LanguageListViewModel.swift
//  Gradgap
//
//  Created by iMac on 18/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils


protocol LanguageListSuccessDelegate {
    func didReceivedLanguageData(response: MajorListModel)
}

struct LanguageListViewModel {
    var delegate: LanguageListSuccessDelegate?
    
    func languageList(request : MorePageRequest) {
        GCD.LANGUAGES.languageList.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.LANGUAGES.languageList, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MajorListModel.self, from: response!) // decode the response into success model
                        switch success.code {
                        case 100:
                            self.delegate?.didReceivedLanguageData(response: success)
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
