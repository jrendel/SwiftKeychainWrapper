//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 jasonrendel. All rights reserved.
//

import Foundation

class KeychainWrapper {
    private struct internalVars {
        static var serviceName: String = ""
    }
    
    // MARK: Public Properties
    
    /*!
    @var serviceName
    @abstract Used for the kSecAttrService property to uniquely identify this keychain accessor.
    @discussion Service Name will default to the app's bundle identifier if it can
    */
    class var serviceName: String {
        get {
        if internalVars.serviceName.isEmpty {
        internalVars.serviceName = NSBundle.mainBundle().bundleIdentifier ?? "SwiftKeychainWrapper"
        }
        return internalVars.serviceName
        }
        set(newServiceName) {
            internalVars.serviceName = newServiceName
        }
    }
    
    // MARK: Public Methods
    class func hasValueForKey(key: String) -> Bool {
        var keychainData: NSData? = self.dataForKey(key)
        if let data = keychainData {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Getting Values
    class func stringForKey(keyName: String) -> String? {
        var keychainData: NSData? = self.dataForKey(keyName)
        var stringValue: String?
        if let data = keychainData {
            stringValue = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
        }
        
        return stringValue
    }
    
    class func objectForKey(keyName: String) -> NSCoding? {
        let dataValue: NSData? = self.dataForKey(keyName)
        
        var objectValue: NSCoding?
        
        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSCoding?
        }
        
        return objectValue;
    }
    
    class func dataForKey(keyName: String) -> NSData? {
        var keychainQueryDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        // Limit search results to one
        let SecMatchLimit: String! = kSecMatchLimit as String
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want NSData/CFData returned
        let SecReturnData: String! = kSecReturnData as String
        keychainQueryDictionary[SecReturnData] = kCFBooleanTrue
        
        // Search
        var searchResultRef: Unmanaged<AnyObject>?
        var keychainValue: NSData?
        
        let status: OSStatus = SecItemCopyMatching(keychainQueryDictionary, &searchResultRef)
        
        if status == noErr {
            if let resultRef = searchResultRef {
                keychainValue = resultRef.takeUnretainedValue() as? NSData
            }
        }
        
        return keychainValue;
    }
    
    // MARK: Setting Values
    class func setString(value: String, forKey keyName: String) -> Bool {
        if let data = value.dataUsingEncoding(NSUTF8StringEncoding) {
            return self.setData(data, forKey: keyName)
        } else {
            return false
        }
    }
    
    class func setObject(value: NSCoding, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(value)
        
        return self.setData(data, forKey: keyName)
    }
    
    class func setData(value: NSData, forKey keyName: String) -> Bool {
        var keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        let SecValueData: String! = kSecValueData as String
        keychainQueryDictionary[SecValueData] = value
        
        // Protect the keychain entry so it's only valid when the device is unlocked
        let SecAttrAccessible: String! = kSecAttrAccessible as String
        keychainQueryDictionary[SecAttrAccessible] = kSecAttrAccessibleWhenUnlocked
        
        let status: OSStatus = SecItemAdd(keychainQueryDictionary, nil)
        
        let SecSuccess: Int! = Int(errSecSuccess)
        let SecDuplicateItem: Int! = Int(errSecDuplicateItem)
        if Int(status) == SecSuccess {
            return true
        } else if Int(status) == SecDuplicateItem {
            return self.updateData(value, forKey: keyName)
        } else {
            return false
        }
    }
    
    // MARK: Removing Values
    class func removeObjectForKey(keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        // Delete
        let status: OSStatus =  SecItemDelete(keychainQueryDictionary);
        
        let SecSuccess: Int! = Int(errSecSuccess)
        if Int(status) == SecSuccess {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Private Methods
    private class func updateData(value: NSData, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        let SecValueData: String! = kSecValueData as String
        let updateDictionary = [SecValueData:value]
        
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary, updateDictionary)
        
        let SecSuccess: Int! = Int(errSecSuccess)
        if Int(status) == SecSuccess {
            return true
        } else {
            return false
        }
    }
    
    private class func setupKeychainQueryDictionaryForKey(keyName: String) -> NSMutableDictionary {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        let SecClass: String! = kSecClass as String
        var keychainQueryDictionary: NSMutableDictionary = [SecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        let SecAttrService: String! = kSecAttrService as String
        keychainQueryDictionary[SecAttrService] = KeychainWrapper.serviceName
        
        // Uniquely identify the account who will be accessing the keychain
        var encodedIdentifier: NSData? = keyName.dataUsingEncoding(NSUTF8StringEncoding)
        
        let SecAttrGeneric: String! = kSecAttrGeneric as String
        keychainQueryDictionary[SecAttrGeneric] = encodedIdentifier
        
        let SecAttrAccount: String! = kSecAttrAccount as String
        keychainQueryDictionary[SecAttrAccount] = encodedIdentifier
        
        return keychainQueryDictionary
    }
}