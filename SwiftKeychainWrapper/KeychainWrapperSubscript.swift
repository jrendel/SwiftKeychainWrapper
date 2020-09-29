//
//  KeychainWrapperSubscript.swift
//  SwiftKeychainWrapper
//
//  Created by Vato Kostava on 5/10/20.
//  Copyright © 2020 Jason Rendel. All rights reserved.
//

import Foundation

#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension KeychainWrapper {
    /// Remove keychain object mathing `key`.
    ///
    /// - parameter key: A valid `Key`.
    func remove(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }
}

public extension KeychainWrapper {
    /// Store or retrieve a `String` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `String`.
    subscript(key: Key) -> String? {
        get { return string(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    /// Store or retrieve a `Bool` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Bool`.
    subscript(key: Key) -> Bool? {
        get { return bool(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    /// Store or retrieve an `Int` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Int`.
    subscript(key: Key) -> Int? {
        get { return integer(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    /// Store or retrieve a `Double` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Double`.
    subscript(key: Key) -> Double? {
        get { return double(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    /// Store or retrieve a `Float` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Float`.
    subscript(key: Key) -> Float? {
        get { return float(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    #if canImport(CoreGraphics)
    /// Store or retrieve a `CGFloat` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `CGFloat`.
    subscript(key: Key) -> CGFloat? {
        get { return cgFloat(forKey: key) }
        set {
            guard let cgValue = newValue else { return }
            let value = Float(cgValue)
            set(value, forKey: key.rawValue)
        }
    }
    #endif
    
    /// Store or retrieve some `Data` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: Some optional `Data`.
    subscript(key: Key) -> Data? {
        get { return data(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
}

public extension KeychainWrapper {
    /// Retrieve some `Data` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: Some optional `Data`.
    func data(forKey key: Key) -> Data? { return data(forKey: key.rawValue) }

    /// Retrieve a `Bool` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Bool`.
    func bool(forKey key: Key) -> Bool? { return bool(forKey: key.rawValue) }

    /// Retrieve a `Int` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Int`.
    func integer(forKey key: Key) -> Int? { return integer(forKey: key.rawValue) }

    /// Retrieve a `Float` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Float`.
    func float(forKey key: Key) -> Float? { return float(forKey: key.rawValue) }

    #if canImport(CoreGraphics)
    /// Retrieve a `CGFloat` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `CGFloat`.
    func cgFloat(forKey key: Key) -> CGFloat? { return double(forKey: key).flatMap(CGFloat.init) }
    #endif

    /// Retrieve a `Double` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `Double`.
    func double(forKey key: Key) -> Double? { return double(forKey: key.rawValue) }

    /// Retrieve a `String` in the keychain, matching `key`.
    ///
    /// - parameter key: A valid `Key`.
    /// - returns: An optional `String`.
    func string(forKey key: Key) -> String? { return string(forKey: key.rawValue) }
}

public extension KeychainWrapper {
    /// A `struct` used to persist common keys.
    ///
    /// ``` swift
    /// extension KeychainWrapper.Key {
    ///     static let myKey: KeychainWrapper.Key = "myKey"
    /// }
    /// ```
    struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
        /// The underlying value.
        public private(set) var rawValue: String

        /// Init.
        ///
        /// - parameter rawValue: A valid `String`.
        public init(rawValue: String) { self.rawValue = rawValue }

        /// Init.
        /// 
        /// - parameter value: A valid `String`.
        public init(stringLiteral value: String) { self.rawValue = value }
    }
}
