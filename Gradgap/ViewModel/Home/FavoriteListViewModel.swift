//
//  FavoriteListViewModel.swift
//  Gradgap
//
//  Created by iMac on 19/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils

protocol FavoriteListDelegate {
    func didRecieveFavoriteListResponse(response: FavoriteListModel)
}

struct FavoriteListViewModel {
    var delegate: FavoriteListDelegate?
    
    func getFavoriteList() {
        GCD.FAVOURITES.favList.async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.FAVOURITES.favList, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(FavoriteListModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFavoriteListResponse(response: success.self)
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
