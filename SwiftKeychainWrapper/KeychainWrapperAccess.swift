//
//  KeychainWrapperAccess.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 3/25/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import Foundation

public extension KeychainWrapper {

    public subscript(keyName: String) -> String? {
        return KeychainWrapper.stringForKey(keyName)
    }
    
}
