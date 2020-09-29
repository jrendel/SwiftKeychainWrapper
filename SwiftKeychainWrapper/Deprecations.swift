//
//  Deprecations.swift
//  SwiftKeychainWrapper
//
//  Created by Stefano Bertagno on 29/09/20.
//  Copyright © 2020 Jason Rendel. All rights reserved.
//

import Foundation

/// An `extension` for deprecated methods.
public extension KeychainWrapper {
    // MARK: Getters
    
    /// Check for the existence of a stored object matching `key`.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if a stored object was found, `false` otherwise.
    @available(*, deprecated, renamed: "contains(key:accessible:isSynchronizable:)")
    func hasValue(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        return contains(key: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Find the `KeychainItemAccessibility` for a given `key`.
    ///
    /// - parameter key: A valid `String`.
    /// - returns: The related `KeychainItemAccessibility`, if a match was found, `nil` otherwise.
    @available(*, deprecated, renamed: "accessibility(forKey:)")
    func accessibilityOfKey(_ key: String) -> KeychainItemAccessibility? {
        return accessibility(forKey: key)
    }
    
    /// Returns some `Data` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: Some `Data` stored in the keychain if found, `nil` otherwise.
    @available(*, deprecated, renamed: "data(forKey:accessible:synchronized:)")
    func data(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> Data? {
        return data(forKey: key, accessible: accessibility, synchronized: false)
    }
    
    /// Returns some `Data` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: Some `Data` stored in the keychain if found, `nil` otherwise.
    @available(*, deprecated, renamed: "data(forKey:accessible:synchronized:)")
    func data(forKey key: String, isSynchronizable: Bool) -> Data? {
        return data(forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Returns some `Data` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: Some `Data` stored in the keychain if found, `nil` otherwise.
    @available(*, deprecated, renamed: "data(forKey:accessible:synchronized:)")
    func data(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> Data? {
        return data(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Returns an object matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: An object conforming to `NSCoding` if found, `nil` otherwise.
    @available(*, deprecated, renamed: "object(forKey:accessible:synchronized:)")
    func object(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> NSCoding? {
        return object(forKey: key, accessible: accessibility, synchronized: false) as? NSCoding
    }
    
    /// Returns an object matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: An object conforming to `NSCoding` if found, `nil` otherwise.
    @available(*, deprecated, renamed: "object(forKey:accessible:synchronized:)")
    func object(forKey key: String, isSynchronizable: Bool) -> NSCoding? {
        return object(forKey: key, accessible: nil, synchronized: isSynchronizable) as? NSCoding
    }
    
    /// Returns an object matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: An object conforming to `NSCoding` if found, `nil` otherwise.
    @available(*, deprecated, renamed: "object(forKey:accessible:synchronized:)")
    func object(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> NSCoding? {
        return object(forKey: key, accessible: accessibility, synchronized: isSynchronizable) as? NSCoding
    }
    
    /// Returns an `Int` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: An `Int` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func integer(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> Int? {
        return integer(forKey: key, accessible: accessibility, synchronized: false)
    }
    
    /// Returns an `Int` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: An `Int` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func integer(forKey key: String, isSynchronizable: Bool) -> Int? {
        return integer(forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Returns an `Int` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: An `Int` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func integer(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> Int? {
        return integer(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Returns a `Float` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: A `Float` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func float(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> Float? {
        return float(forKey: key, accessible: accessibility, synchronized: false)
    }
    
    /// Returns a `Float` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Float` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func float(forKey key: String, isSynchronizable: Bool) -> Float? {
        return float(forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Returns a `Float` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Float` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func float(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> Float? {
        return float(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Returns a `Double` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: A `Double` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func double(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> Double? {
        return double(forKey: key, accessible: accessibility, synchronized: false)
    }
    
    /// Returns a `Double` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Double` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func double(forKey key: String, isSynchronizable: Bool) -> Double? {
        return double(forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Returns a `Double` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Double` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func double(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> Double? {
        return double(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Returns a `Bool` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: A `Bool` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func bool(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> Bool? {
        return bool(forKey: key, accessible: accessibility, synchronized: false)
    }
    
    /// Returns a `Bool` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Bool` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func bool(forKey key: String, isSynchronizable: Bool) -> Bool? {
        return bool(forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Returns a `Bool` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `Bool` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "integer(forKey:accessible:synchronized:)")
    func bool(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> Bool? {
        return bool(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Returns a `String` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: A `String` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "string(forKey:accessible:synchronized:)")
    func string(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?) -> String? {
        return string(forKey: key, accessible: accessibility, synchronized: false)
    }
    
    /// Returns a `String` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `String` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "string(forKey:accessible:synchronized:)")
    func string(forKey key: String, isSynchronizable: Bool) -> String? {
        return string(forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Returns a `String` matching `key`, `accessibility` and synchronization settings.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: A `String` if a stored object was found, `nil` otherwise.
    @available(*, deprecated, renamed: "string(forKey:accessible:synchronized:)")
    func string(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool) -> String? {
        return string(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    /// Returns a persistent data reference object for a specified key.
    ///
    /// - parameters:
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: Some persistent `Data` reference if found, `nil` otherwise.
    @available(*, deprecated, renamed: "reference(forKey:accessible:synchronized:)")
    func dataRef(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Data? {
        return reference(forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
    
    // MARK: Setters
    
    /// Store `value` into the keychain.
    ///
    /// - parameters:
    ///     - value: Some value.
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    func set<T>(_ value: T,
                forKey key: String,
                withAccessibility accessibility: KeychainItemAccessibility?) -> Bool {
        return set(value, forKey: key, accessible: accessibility, synchronized: false)
    }

    /// Store `value` into the keychain.
    ///
    /// - parameters:
    ///     - value: Some value.
    ///     - key: A valid `String`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    func set<T>(_ value: T,
                forKey key: String,
                isSynchronizable: Bool) -> Bool {
        return set(value, forKey: key, accessible: nil, synchronized: isSynchronizable)
    }
    
    /// Store `value` into the keychain.
    ///
    /// - parameters:
    ///     - value: Some value.
    ///     - key: A valid `String`.
    ///     - accessibility: An optional instance of `KeychainItemAccessibility`. Defaults to `nil`.
    ///     - isSynchronizable: A valid `Bool`. Defaults to `false`.
    /// - returns: `true` if it was successful, `false` otherwise.
    @discardableResult
    func set<T>(_ value: T,
                forKey key: String,
                withAccessibility accessibility: KeychainItemAccessibility?,
                isSynchronizable: Bool) -> Bool {
        return set(value, forKey: key, accessible: accessibility, synchronized: isSynchronizable)
    }
}
