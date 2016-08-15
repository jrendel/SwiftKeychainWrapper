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
            guard let data = self.data(forKey: keyName) else {
                return nil
            }
            
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        }
        set(value) {
            if let value = value {
                self.setString(value, forKey: keyName)
            }
        }
    }
    
    /// subscript convenience access currently supports String, NSData and NSCoding return type.
    /// Primitive Types: Integer, Float, Double, Bool
    public func get<T: Any>(_ keyName: String) -> T? {
        guard let data = self.data(forKey: keyName) else {
            return nil
        }
        
        if T.self == Data.self {
            return data as? T
        }
        
        if T.self == String.self, let stringValue = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
            return stringValue as? T
        }
        
        // TODO: does not work for protocol. Sees T as TestObject in unit test... can't use ==, need to figure out if "is" works or better way
        if T.self == NSCoding.self {
            if let objectValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSCoding {
                return objectValue as? T
            }
        }
        
        // Primitive Types
        if T.self == Int.self, let numberValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber {
            return numberValue.intValue as? T
        }
        
        if T.self == Float.self, let numberValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber {
            return numberValue.floatValue as? T
        }
        
        if T.self == Double.self, let numberValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber {
            return numberValue.doubleValue as? T
        }
        
        if T.self == Bool.self, let numberValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber {
            return numberValue.boolValue as? T
        }
        
        // Unsupported type
        return nil
    }
    
}
