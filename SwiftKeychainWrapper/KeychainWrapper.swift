//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 Jason Rendel. All rights reserved.
//
//    The MIT License (MIT)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import Foundation


private let SecMatchLimit: String! = kSecMatchLimit as String
private let SecReturnData: String! = kSecReturnData as String
private let SecReturnPersistentRef: String! = kSecReturnPersistentRef as String
private let SecValueData: String! = kSecValueData as String
private let SecAttrAccessible: String! = kSecAttrAccessible as String
private let SecClass: String! = kSecClass as String
private let SecAttrService: String! = kSecAttrService as String
private let SecAttrGeneric: String! = kSecAttrGeneric as String
private let SecAttrAccount: String! = kSecAttrAccount as String
private let SecAttrAccessGroup: String! = kSecAttrAccessGroup as String

/// KeychainWrapper is a class to help make Keychain access in Swift more straightforward. It is designed to make accessing the Keychain services more like using NSUserDefaults, which is much more familiar to people.
open class KeychainWrapper {
    // MARK: Private static Properties
    fileprivate struct internalVars {
        static var serviceName: String = ""
        static var accessGroup: String = ""
        static var accessLevel: CFString = kSecAttrAccessibleWhenUnlocked
    }

    // MARK: Public Properties
    
    /// ServiceName is used for the kSecAttrService property to uniquely identify this keychain accessor. If no service name is specified, KeychainWrapper will default to using the bundleIdentifier. 
    ///
    ///This is a static property and only needs to be set once
    open class var serviceName: String {
        get {
            if internalVars.serviceName.isEmpty {
                internalVars.serviceName = Bundle.main.bundleIdentifier ?? "SwiftKeychainWrapper"
            }
            return internalVars.serviceName
        }
        set(newServiceName) {
            internalVars.serviceName = newServiceName
        }
    }
    
    /// AccessGroup is used for the kSecAttrAccessGroup property to identify which Keychain Access Group this entry belongs to. This allows you to use the KeychainWrapper with shared keychain access between different applications. 
    ///
    /// Access Group defaults to an empty string and is not used until a valid value is set. 
    ///
    /// This is a static property and only needs to be set once. To remove the access group property after one has been set, set this to an empty string.
    open class var accessGroup: String {
        get {
            return internalVars.accessGroup
        }
        set(newAccessGroup){
            internalVars.accessGroup = newAccessGroup
        }
    }
    
    open class var accessLevel: AccessLevel {
        get {
            if CFStringCompare(internalVars.accessLevel, kSecAttrAccessibleAfterFirstUnlock, CFStringCompareFlags.compareCaseInsensitive) == CFComparisonResult.compareEqualTo {
                return AccessLevel.AfterFirstUnlock
            } else {
                return AccessLevel.WhenUnlocked
            }
        }
        set(newAccessLevel){
            switch newAccessLevel {
            case AccessLevel.AfterFirstUnlock:
                internalVars.accessLevel = kSecAttrAccessibleAfterFirstUnlock
            default:
                internalVars.accessLevel = kSecAttrAccessibleWhenUnlocked
            }
        }
    }
    
    fileprivate class var accessLevelValue: CFString {
        get {
            return internalVars.accessLevel
        }
    }

    // MARK: Public Methods
    
    /// Checks if keychain data exists for a specified key.
    ///
    /// - parameter keyName: The key to check for.
    /// - returns: True if a value exists for the key. False otherwise.
    open class func hasValueForKey(_ keyName: String) -> Bool {
        let keychainData: Data? = self.dataForKey(keyName)
        if keychainData != nil {
            return true
        } else {
            return false
        }
    }

    /// Returns a string value for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - returns: The String associated with the key if it exists. If no data exists, or the data found cannot be encoded as a string, returns nil.
    open class func stringForKey(_ keyName: String) -> String? {
        let keychainData: Data? = self.dataForKey(keyName)
        var stringValue: String?
        if let data = keychainData {
            stringValue = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        }

        return stringValue
    }

    
    /// Returns an object that conforms to NSCoding for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - returns: The decoded object associated with the key if it exists. If no data exists, or the data found cannot be decoded, returns nil.
    open class func objectForKey(_ keyName: String) -> NSCoding? {
        let dataValue: Data? = self.dataForKey(keyName)

        var objectValue: NSCoding?

        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSCoding
        }

        return objectValue;
    }

    
    /// Returns a NSData object for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - returns: The NSData object associated with the key if it exists. If no data exists, returns nil.
    open class func dataForKey(_ keyName: String) -> Data? {
        var keychainQueryDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        var result: AnyObject?

        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne

        // Specify we want NSData/CFData returned
        keychainQueryDictionary[SecReturnData] = kCFBooleanTrue

        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary as CFDictionary, UnsafeMutablePointer($0))
        }

        return status == noErr ? result as? Data : nil
    }
    
    
    /// Returns a persistent data reference object for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - returns: The persistent data reference object associated with the key if it exists. If no data exists, returns nil.
    open class func dataRefForKey(_ keyName: String) -> Data? {
        var keychainQueryDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        var result: AnyObject?
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want persistent NSData/CFData reference returned
        keychainQueryDictionary[SecReturnPersistentRef] = kCFBooleanTrue
        
        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary as CFDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    

    /// Save a String value to the keychain associated with a specified key. If a String value already exists for the given keyname, the string will be overwritten with the new value.
    ///
    /// - parameter value: The String value to save.
    /// - parameter forKey: The key to save the String under.
    /// - returns: True if the save was successful, false otherwise.
    open class func setString(_ value: String, forKey keyName: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return self.setData(data, forKey: keyName)
        } else {
            return false
        }
    }

    /// Save an NSCoding compliant object to the keychain associated with a specified key. If an object already exists for the given keyname, the object will be overwritten with the new value.
    ///
    /// - parameter value: The NSCoding compliant object to save.
    /// - parameter forKey: The key to save the object under.
    /// - returns: True if the save was successful, false otherwise.
    open class func setObject(_ value: NSCoding, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)

        return self.setData(data, forKey: keyName)
    }

    /// Save a NSData object to the keychain associated with a specified key. If data already exists for the given keyname, the data will be overwritten with the new value.
    ///
    /// - parameter value: The NSData object to save.
    /// - parameter forKey: The key to save the object under.
    /// - returns: True if the save was successful, false otherwise.
    open class func setData(_ value: Data, forKey keyName: String) -> Bool {
        var keychainQueryDictionary: [String:AnyObject] = self.setupKeychainQueryDictionaryForKey(keyName)

        keychainQueryDictionary[SecValueData] = value as AnyObject?

        // Protect the keychain entry so it's only valid when the device is unlocked or when the device is unlocked after it was restarted (only recommended for watchkit extensions that need access when app runs in background)
        keychainQueryDictionary[SecAttrAccessible] = self.accessLevelValue

        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)

        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return self.updateData(value, forKey: keyName)
        } else {
            return false
        }
    }

    /// Remove an object associated with a specified key.
    ///
    /// - parameter keyName: The key value to remove data for.
    /// - returns: True if successful, false otherwise.
    open class func removeObjectForKey(_ keyName: String) -> Bool {
        let keychainQueryDictionary: [String:AnyObject] = self.setupKeychainQueryDictionaryForKey(keyName)

        // Delete
        let status: OSStatus =  SecItemDelete(keychainQueryDictionary as CFDictionary);

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    // MARK: Private Methods
    
    /// Update existing data associated with a specified key name. The existing data will be overwritten by the new data
    fileprivate class func updateData(_ value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: [String:AnyObject] = self.setupKeychainQueryDictionaryForKey(keyName)
        let updateDictionary = [SecValueData:value]

        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    /// Setup the keychain query dictionary used to access the keychain on iOS for a specified key name. Takes into account the Service Name and Access Group if one is set.
    ///
    /// - parameter keyName: The key this query is for
    /// - returns: A dictionary with all the needed properties setup to access the keychain on iOS
    fileprivate class func setupKeychainQueryDictionaryForKey(_ keyName: String) -> [String:AnyObject] {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [String:AnyObject] = [SecClass:kSecClassGenericPassword]

        // Uniquely identify this keychain accessor
        keychainQueryDictionary[SecAttrService] = KeychainWrapper.serviceName as AnyObject?

        // Set the keychain access group if defined
        if !KeychainWrapper.accessGroup.isEmpty {
            keychainQueryDictionary[SecAttrAccessGroup] = KeychainWrapper.accessGroup as AnyObject?
        }

        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = keyName.data(using: String.Encoding.utf8)

        keychainQueryDictionary[SecAttrGeneric] = encodedIdentifier as AnyObject?

        keychainQueryDictionary[SecAttrAccount] = encodedIdentifier as AnyObject?

        return keychainQueryDictionary
    }
    
    public enum AccessLevel : String {
        case WhenUnlocked = "WhenUnlocked"
        case AfterFirstUnlock = "AfterFirstUnlock"
    }
}
