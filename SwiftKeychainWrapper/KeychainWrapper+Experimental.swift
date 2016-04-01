//
//  KeychainWrapper+Experimental.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 4/1/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import Foundation

// Trying to add subscript support. Realized subscript does not support generics, so testing the waters of generic get(key:) and set(value:forKey:) functions.

// MARK:- Subscript Extension Functions
public extension KeychainWrapper {
    public subscript(keyName: String) -> String? {
        get {
            guard let data = self.dataForKey(keyName) else {
                return nil
            }
            
            return NSString(data: data, encoding: NSUTF8StringEncoding) as String?
        }
        set(value) {
            if let value = value {
                self.setString(value, forKey: keyName)
            }
        }
    }
    
    /// subscript convenience access currently supports String, NSData and NSCoding return type.
    
    public func get<T: Any>(keyName: String) -> T? {
        guard let data = self.dataForKey(keyName) else {
            return nil
        }
        
        if T.self == NSData.self {
            return data as? T
        }
        
        if T.self == String.self, let stringValue = NSString(data: data, encoding: NSUTF8StringEncoding) as String? {
            return stringValue as? T
        }
        
        // TODO: does not work for protocol. Sees T as TestObject in unit test... can't use ==, need to figure out if "is" works or better way
        if T.self == NSCoding.self {
            if let objectValue = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSCoding {
                return objectValue as? T
            }
        }
        
        // Unsupported type
        return nil
    }
    
}
