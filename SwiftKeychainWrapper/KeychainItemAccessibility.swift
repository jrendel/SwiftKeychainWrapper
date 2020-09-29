//
//  KeychainOptions.swift
//  SwiftKeychainWrapper
//
//  Created by James Blair on 4/24/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
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

protocol KeychainAttrRepresentable {
    /// The underlying keychain attribute value.
    var rawValue: CFString { get }
    
    /// Init from `rawValue`.
    init(rawValue: CFString)
}

// MARK: - KeychainItemAccessibility
public struct KeychainItemAccessibility: Equatable {
    /// The underlying string.
    var rawValue: CFString
    
    /// Init.
    /// - parameter rawValue: A valid `CFString`.
    init(rawValue: CFString) { self.rawValue = rawValue }
    
    /**
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
     */
    @available(iOS 4, macOS 10.9, tvOS 9, watchOS 2, *)
    public static let afterFirstUnlock: KeychainItemAccessibility = .init(rawValue: kSecAttrAccessibleAfterFirstUnlock)
    
    /**
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, macOS 10.9, tvOS 9, watchOS 2, *)
    public static let afterFirstUnlockThisDeviceOnly: KeychainItemAccessibility = .init(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
    
    /**
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute migrate to a new device when using encrypted backups.
     */
    @available(*, unavailable, message: "unavailable because of security concerns; prefer `.afterFirstUnlock` or use `.custom(kSecAttrAccessibleAlways)`")
    public static let always: KeychainItemAccessibility = .init(rawValue: "" as CFString)
    
    /**
     The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
     
     This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
     */
    @available(iOS 8, macOS 10.10, tvOS 9, watchOS 2, *)
    public static let whenPasscodeSetThisDeviceOnly: KeychainItemAccessibility = .init(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
    
    /**
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(*, unavailable, message: "unavailable because of security concerns; prefer `.afterFirstUnlockThisDeviceOnly` or use `.custom(kSecAttrAccessibleAlwaysThisDeviceOnly)`")
    public static let alwaysThisDeviceOnly: KeychainItemAccessibility = .init(rawValue: "" as CFString)
    
    /**
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
     
     This is the default value for keychain items added without explicitly setting an accessibility constant.
     */
    @available(iOS 4, macOS 10.9, tvOS 9, watchOS 2, *)
    public static let whenUnlocked: KeychainItemAccessibility = .init(rawValue: kSecAttrAccessibleWhenUnlocked)
    
    /**
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, macOS 10.9, tvOS 9, watchOS 2, *)
    public static let whenUnlockedThisDeviceOnly: KeychainItemAccessibility = .init(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
    
    /**
     A custom `KeychainItemAccessibility` instance, allowing for specific security attributes.
     
     You can use this to force, for instance, `kSecAttrAccessibleAlways`, despite being unsafe and unavailable in `KeychainItemAccessibility`.
     */
    public static func custom(_ accessibility: CFString) -> KeychainItemAccessibility { return .init(rawValue: accessibility) }
}

extension KeychainItemAccessibility: KeychainAttrRepresentable { }
