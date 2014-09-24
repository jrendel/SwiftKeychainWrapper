//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 jasonrendel. All rights reserved.
//

import Foundation

class KeychainWrapper {
    private struct Internal {
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
            if Internal.serviceName.isEmpty {
                let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
                if let bundleIdentifierString = bundleIdentifier {
                    Internal.serviceName = bundleIdentifierString
                } else {
                    Internal.serviceName = "SwiftKeychainWrapper"
                }
            }
            return Internal.serviceName
        }
        set(newServiceName) {
            Internal.serviceName = newServiceName
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
    
    class func objectForKey(keyName: String) -> AnyObject? {
        let dataValue: NSData? = self.dataForKey(keyName)
        
        var objectValue: AnyObject?
        
        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        }
        
        return objectValue;
    }
    
    class func dataForKey(keyName: String) -> NSData? {
        var keychainQueryDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        // Limit search results to one
        keychainQueryDictionary[kSecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want NSData/CFData returned
        keychainQueryDictionary[kSecReturnData] = kCFBooleanTrue
        
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
    
    class func setObject(value: AnyObject, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(value)
            
        return self.setData(data, forKey: keyName)
    }

    class func setData(value: NSData, forKey keyName: String) -> Bool {
        var keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        keychainQueryDictionary[kSecValueData] = value
        
        // Protect the keychain entry so it's only valid when the device is unlocked
        keychainQueryDictionary[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlocked
        
        let status: OSStatus = SecItemAdd(keychainQueryDictionary, nil)
        
        if Int(status) == errSecSuccess {
            return true
        } else if Int(status) == errSecDuplicateItem {
            return self.updateData(value, forKey: keyName)
        } else {
            return false
        }
    }
    
// MARK: Removing Values
    class func removeObjectForKey(keyName: String) -> Bool {
         let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        //Delete
        let status: OSStatus =  SecItemDelete(keychainQueryDictionary);
        
        if Int(status) == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
// MARK: Private Methods
    private class func updateData(value: NSData, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        let updateDictionary = [kSecValueData:value]
        
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary, updateDictionary)
        
        if Int(status) == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    private class func setupKeychainQueryDictionaryForKey(keyName: String) -> NSMutableDictionary {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: NSMutableDictionary = [kSecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[kSecAttrService] = KeychainWrapper.serviceName

        // Uniquely identify the account who will be accessing the keychain
        var encodedIdentifier: NSData? = keyName.dataUsingEncoding(NSUTF8StringEncoding)
            
        keychainQueryDictionary[kSecAttrGeneric] = encodedIdentifier
        keychainQueryDictionary[kSecAttrAccount] = encodedIdentifier
        
        return keychainQueryDictionary
    }
}