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
private let SecReturnAttributes: String = kSecReturnAttributes as String
private let SecAttrSynchronizable: String = kSecAttrSynchronizable as String

/// A `class` wrapping keychain access into a `Swift` container.
/// It is designed to mimic `UserDefaults`, which is way more familiar to people.
open class KeychainWrapper {
    /// A shared instance of `KeychainWrapper`.
    @available(*, deprecated, renamed: "standard", message: "`defaultKeychainWrapper` will be removed in a future version")
    public static let defaultKeychainWrapper = KeychainWrapper.standard
    
    /// A shared instance of `KeychainWrapper`.
    public static let standard = KeychainWrapper()
    
    /// A `String` passed as the `kSecAttrService`, identifiying this keychain accessor
    /// When no `serviceName` is passed during `init`, `Self.defaultServiceName` is used instead.
    public private(set) var serviceName: String
    
    /// A `String` passed as the `kSecAttrAccessGroup`, identifying the access group for this keychain accessor, in order to share stored values between apps.
    /// Defaults to `nil`.
    public private(set) var accessGroup: String?
    
    /// A `String` used when no `serviceName` was passed during `init`.
    /// - note: This is implemented as a `class` read-only property, instead of a `static` one, so `KeychainWrapper` sub-`class`es can override it.
    open class var defaultServiceName: String { Bundle.main.bundleIdentifier ?? "SwiftKeychainWrapper" }
    
    // MARK: Lifecycle
    
    /// Init.
    ///
    /// - parameters:
    ///     - serviceName: An optional `String`. Defaults to `nil`, meaning `Self.defaultServiceName` will be used as `kSecAttrService`.
    ///     - accessGroup: An optional `String`. Defaults to `nil`, meaning no specific value will be passed to `kSecAttrAccessGroup`.
    public init(serviceName: String? = nil, accessGroup: String? = nil) {
        self.serviceName = serviceName ?? Self.defaultServiceName
        self.accessGroup = accessGroup
    }
    
    // MARK: Accessories
    
    /// Check for the existence of a stored object matching `key`.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if a stored object was found, `false` otherwise.
    open func contains(key: String,
                       accessible accessibility: KeychainItemAccessibility? = nil,
                       synchronized isSynchronizable: Bool = false) -> Bool {
        return data(forKey: key, accessible: accessibility, synchronized: isSynchronizable) != nil
    }
    
    /// Find the `KeychainItemAccessibility` for a given `key`.
    ///
    /// - parameter key: A valid `String`.
    /// - returns: The related `KeychainItemAccessibility`, if a match was found, `nil` otherwise.
    open func accessibility(forKey key: String) -> KeychainItemAccessibility? {
        // Prepare query.
        var query = keychainQuery(forKey: key)
        query.removeValue(forKey: SecAttrAccessible)
        query[SecMatchLimit] = kSecMatchLimitOne
        query[SecReturnAttributes] = kCFBooleanTrue
        // Fetch result.
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess else {
            return nil
        }
        // Return accessibility.
        return (result as? [String: AnyObject])
            .flatMap { ($0[SecAttrAccessible] as? String) as CFString? }
            .flatMap(KeychainItemAccessibility.accessibilityForAttributeValue)
    }
    
    /// Return a set of keys stored in the keychain.
    ///
    /// - returns: A `Set` of `String` representing all stored keys.
    open func allKeys() -> Set<String> {
        // Prepare the query.
        var query: [String: Any] = [
            SecClass: kSecClassGenericPassword,
            SecAttrService: serviceName,
            SecReturnAttributes: kCFBooleanTrue!,
            SecMatchLimit: kSecMatchLimitAll,
        ]
        if let accessGroup = self.accessGroup { query[SecAttrAccessGroup] = accessGroup }
        // Fetch results.
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return [] }
        // Return values.
        return (result as? [[AnyHashable: Any]])?
            .reduce(into: Set<String>()) { set, attributes in
                guard let data = (attributes[SecAttrAccount] as? Data) ?? (attributes[kSecAttrAccount] as? Data),
                      let key = String(data: data, encoding: .utf8) else { return }
                set.insert(key)
            } ?? []
    }
    
    // MARK: Getters
    
    /// Returns an `Int` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: An `Int` if a stored object was found, `nil` otherwise.
    open func integer(forKey key: String,
                      accessible accessibility: KeychainItemAccessibility? = nil,
                      synchronized isSynchronizable: Bool = false) -> Int? {
        return (object(forKey: key, accessible: accessibility, synchronized: isSynchronizable) as? NSNumber)?.intValue
    }
    
    /// Returns a `Float` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Float` if a stored object was found, `nil` otherwise.
    open func float(forKey key: String,
                    accessible accessibility: KeychainItemAccessibility? = nil,
                    synchronized isSynchronizable: Bool = false) -> Float? {
        return (object(forKey: key, accessible: accessibility, synchronized: isSynchronizable) as? NSNumber)?.floatValue
    }
    
    /// Returns a `Double` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Double` if a stored object was found, `nil` otherwise.
    open func double(forKey key: String,
                     accessible accessibility: KeychainItemAccessibility? = nil,
                     synchronized isSynchronizable: Bool = false) -> Double? {
        return (object(forKey: key, accessible: accessibility, synchronized: isSynchronizable) as? NSNumber)?.doubleValue
    }
    
    /// Returns a `Bool` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Bool` if a stored object was found, `nil` otherwise.
    open func bool(forKey key: String,
                   accessible accessibility: KeychainItemAccessibility? = nil,
                   synchronized isSynchronizable: Bool = false) -> Bool? {
        return (object(forKey: key, accessible: accessibility, synchronized: isSynchronizable) as? NSNumber)?.boolValue
    }
    
    /// Returns a `String` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `String` if a stored object was found, `nil` otherwise.
    open func string(forKey key: String,
                     accessible accessibility: KeychainItemAccessibility? = nil,
                     synchronized isSynchronizable: Bool = false) -> String? {
        return data(forKey: key, accessible: accessibility, synchronized: isSynchronizable).flatMap { String(data: $0, encoding: .utf8) }
    }
    
    /// Returns some instance matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: Some instance stored in the keychain if found, `nil` otherwise.
    open func object(forKey key: String,
                     accessible accessibility: KeychainItemAccessibility? = nil,
                     synchronized isSynchronizable: Bool = false) -> Any? {
        return data(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
            .flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) }
    }
    
    /// Returns some `Data` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: Some `Data` stored in the keychain if found, `nil` otherwise.
    open func data(forKey key: String,
                   accessible accessibility: KeychainItemAccessibility? = nil,
                   synchronized isSynchronizable: Bool = false) -> Data? {
        // Prepare the query.
        var query = keychainQuery(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        query[SecMatchLimit] = kSecMatchLimitOne
        query[SecReturnData] = kCFBooleanTrue
        // Fetch results.
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        // Return value.
        return status == noErr ? result as? Data : nil
    }
    
    /// Returns a persistent data reference object for a specified key.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: Some persistent `Data` reference if found, `nil` otherwise.
    open func reference(forKey key: String,
                        accessible accessibility: KeychainItemAccessibility? = nil,
                        synchronized isSynchronizable: Bool = false) -> Data? {
        // Prepare the query.
        var query = keychainQuery(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        query[SecMatchLimit] = kSecMatchLimitOne
        query[SecReturnPersistentRef] = kCFBooleanTrue
        // Fetch results.
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        // Return value.
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Setters
    
    /// Store `value` into the keychain.
    ///
    /// - parameters:
    ///     - value: Some value.
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    open func set<T>(_ value: T,
                     forKey key: String,
                     accessible accessibility: KeychainItemAccessibility? = nil,
                     synchronized isSynchronizable: Bool = false) -> Bool {
        switch value {
        case let data as Data:
            // Prepare the query.
            var query: [String: Any] = keychainQuery(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
            query[SecValueData] = data
            query[SecAttrAccessible] = accessibility?.keychainAttrValue ?? KeychainItemAccessibility.whenUnlocked.keychainAttrValue
            // Store results.
            let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else if status == errSecDuplicateItem {
                return update(data, forKey: key, accessible: accessibility, synchronized: isSynchronizable)
            } else {
                return false
            }
        case let string as String:
            // Encode `string`.
            return string.data(using: .utf8).flatMap { set($0, forKey: key, accessible: accessibility, synchronized: isSynchronizable) } ?? false
        default:
            // Archive `value`.
            var archivedData: Data?
            if #available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *) {
                archivedData = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            } else {
                archivedData = NSKeyedArchiver.archivedData(withRootObject: value)
            }
            // Store results.
            return archivedData.flatMap { set($0, forKey: key, accessible: accessibility, synchronized: isSynchronizable) } ?? false
        }
    }
    
    // MARK: Deletion
    
    /// Remove an item matching `key` from the keychain.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    open func removeObject(forKey key: String,
                           accessible accessibility: KeychainItemAccessibility? = nil,
                           synchronized isSynchronizable: Bool = false) -> Bool {
        // Prepare query.
        let query: [String: Any] = keychainQuery(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        // Remove item.
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
    
    /// Remove all items from the keychain, added through this wrapper..
    ///
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    open func removeAllKeys() -> Bool {
        // Prepare query.
        var keychainQueryDictionary: [String: Any] = [SecClass: kSecClassGenericPassword]
        keychainQueryDictionary[SecAttrService] = serviceName
        keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        // Remove items.
        return SecItemDelete(keychainQueryDictionary as CFDictionary) == errSecSuccess
    }
    
    /// Remove all keyhcain items, even the ones you did not add thorugh this wrapper.
    ///
    /// - warning: This may delete more than just the items you've added through `KeychainWrapper`.
    open class func wipeKeychain() {
        deleteKeychainSecClass(kSecClassGenericPassword) // Generic password items
        deleteKeychainSecClass(kSecClassInternetPassword) // Internet password items
        deleteKeychainSecClass(kSecClassCertificate) // Certificate items
        deleteKeychainSecClass(kSecClassKey) // Cryptographic key items
        deleteKeychainSecClass(kSecClassIdentity) // Identity items
    }
    
    // MARK:- Private Methods
    
    /// Remove all items for a given Keychain Item Class
    ///
    /// - parameter secClass: A valid Keychain Item Class
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    private class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
        return SecItemDelete([SecClass: secClass] as CFDictionary) == errSecSuccess
    }
    
    /// Update `value` associated with `key`.
    ///
    /// - parameters:
    ///     - value: Some value.
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if it was successful, `false` otherwise.
    private func update(_ value: Data,
                        forKey key: String,
                        accessible accessibility: KeychainItemAccessibility? = nil,
                        synchronized isSynchronizable: Bool = false) -> Bool {
        // Prepare query.
        var query: [String: Any] = keychainQuery(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        query[SecAttrAccessible] = accessibility?.keychainAttrValue // Do not fallback in this case.
        // Update attributes.
        let updateDictionary = [SecValueData: value]
        return SecItemUpdate(query as CFDictionary, updateDictionary as CFDictionary) == errSecSuccess
    }
    
    /// Return a valid dictionary from starting parameters.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A valid dictionary.
    private func keychainQuery(forKey key: String,
                               withAccessibility accessibility: KeychainItemAccessibility? = nil,
                               isSynchronizable: Bool = false) -> [String: Any] {
        // Prepare the query for a generic password (rather than a certificate, internet password, etc)
        var query: [String: Any] = [SecClass: kSecClassGenericPassword]
        query[SecAttrService] = serviceName
        query[SecAttrAccessible] = accessibility?.keychainAttrValue
        query[SecAttrAccessGroup] = accessGroup
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
        query[SecAttrGeneric] = encodedIdentifier
        query[SecAttrAccount] = encodedIdentifier
        query[SecAttrSynchronizable] = isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse
        // Return dictionary.
        return query
    }
}
