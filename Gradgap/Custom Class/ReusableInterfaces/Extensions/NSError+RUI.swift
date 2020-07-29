//
//  NSErrorAdditions.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

public extension NSError {
    
    func isNoConnectionError() -> Bool {
        return self.domain == NSURLErrorDomain && self.code == NSURLErrorNotConnectedToInternet
    }
    
    func isFileNotFoundError() -> Bool {
        return self.domain == NSCocoaErrorDomain && self.code == NSFileReadNoSuchFileError
    }
    
}
