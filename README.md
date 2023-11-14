:no_entry: [DEPRECATED] This library is not being kept up to date. This was created when Swift was first released as a simple way to work with the Keychain. But the approach was restricted and not suited to more advanced keychain usage.

# SwiftKeychainWrapper

A simple wrapper for the iOS / tvOS Keychain to allow you to use it in a similar fashion to User Defaults. Written in Swift.

Provides singleton instance that is setup to work for most needs. Use `KeychainWrapper.standard` to access the singleton instance.

If you need to customize the keychain access to use a custom identifier or access group, you can create your own instance instead of using the singleton instance.

By default, the Keychain Wrapper saves data as a Generic Password type in the iOS Keychain. It saves items such that they can only be accessed when the app is unlocked and open. If you are not familiar with the iOS Keychain usage, this provides a safe default for using the keychain.

Users that want to deviate from this default implementation, now can do so in version 2.0 and up. Each request to save/read a key value now allows you to specify the keychain accessibility for that key.

## General Usage

Add a string value to keychain:
``` swift
let saveSuccessful: Bool = KeychainWrapper.standard.set("Some String", forKey: "myKey")
```

Retrieve a string value from keychain:
``` swift
let retrievedString: String? = KeychainWrapper.standard.string(forKey: "myKey")
```

Remove a string value from keychain:
``` swift
let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "myKey")
```

## Custom Instance

When the Keychain Wrapper is used, all keys are linked to a common identifier for your app, called the service name. By default this uses your main bundle identifier. However, you may also change it, or store multiple items to the keychain under different identifiers.

To share keychain items between your applications, you may specify an access group and use that same access group in each application.

To set a custom service name identifier or access group, you may now create your own instance of the keychain wrapper as follows:

``` swift
let uniqueServiceName = "customServiceName"
let uniqueAccessGroup = "sharedAccessGroupName"
let customKeychainWrapperInstance = KeychainWrapper(serviceName: uniqueServiceName, accessGroup: uniqueAccessGroup)
```
The custom instance can then be used in place of the shared instance or static accessors:

``` swift
let saveSuccessful: Bool = customKeychainWrapperInstance.set("Some String", forKey: "myKey")

let retrievedString: String? = customKeychainWrapperInstance.string(forKey: "myKey")

let removeSuccessful: Bool = customKeychainWrapperInstance.removeObject(forKey: "myKey")
```

## Subscript usage

Keychain can also be accessed with subscript as it is in dictionary. Keys can be predefined and listed in one place for convenience.

Firstly, let's define the key to use later.

``` swift
extension KeychainWrapper.Key {
    static let myKey: KeychainWrapper.Key = "myKey"
}
```

And now we can use this key as follows:

``` swift
KeychainWrapper.standard[.myKey] = "some string"

let myValue: String? = KeychainWrapper.standard[.myKey]

KeychainWrapper.standard.remove(forKey: .myKey)

```


## Accessibility Options

By default, all items saved to keychain can only be accessed when the device is unlocked. To change this accessibility, an optional `withAccessibility` param can be set on all requests. The enum `KeychainItemAccessibilty` provides an easy way to select the accessibility level desired:

``` swift
KeychainWrapper.standard.set("Some String", forKey: "myKey", withAccessibility: .AfterFirstUnlock)
```

## Synchronizable Option

By default, all items saved to keychain are not synchronizable, so they are not synced with the iCloud. To change this, an  `isSynchronizable` bool param can be set on all requests. You need the item to be synchronized with the iCloud if you want to have it on all of your devices:
 
``` swift
KeychainWrapper.standard.set("Some String", forKey: "myKey", isSynchronizable: true)
```

**Important:** You can't modify value for key if it was previously set with different accessibility option. Remove the value for key and set it with new accessibility option. (Otherwise the value will not change).  
For example:
``` swift
KeychainWrapper.standard.set("String one", forKey: "myKey", withAccessibility: .AfterFirstUnlock)
KeychainWrapper.standard.removeObject(forKey: "myKey")
KeychainWrapper.standard.set("String two", forKey: "myKey", withAccessibility: .Always)
```

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install SwiftKeychainWrapper by adding it to your `Podfile`:

``` ruby
use_frameworks!
platform :ios, '8.0'

target 'target_name' do
   pod 'SwiftKeychainWrapper'
end
```

To use the keychain wrapper in your app, import SwiftKeychainWrapper into the file(s) where you want to use it.

``` swift
import SwiftKeychainWrapper
```

#### Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install SwiftKeychainWrapper by adding it to your `Cartfile`.

Swift 3.0:
```
github "jrendel/SwiftKeychainWrapper" ~> 3.0
```

Swift 2.3:
```
github "jrendel/SwiftKeychainWrapper" == 2.1.1
```

#### Swift Package Manager
You can use [Swift Package Manager](https://swift.org/package-manager/) to install SwiftKeychainWrapper using Xcode:

1. Open your project in Xcode

2. Click "File" -> "Swift Packages" -> "Add Package Dependency..."

3. Paste the following URL: https://github.com/jrendel/SwiftKeychainWrapper

4. Click "Next" -> "Next" -> "Finish"


#### Manually
Download and drop ```KeychainWrapper.swift``` and ```KeychainItemAcessibility.swift``` into your project.


## Release History

* 4.0.1
Added conditional logic for CGFloat accessories for when package is used where CGFloat is not available

* 4.0
Updated with SPM support and other community PRs. Minimum iOS version is now 9.0. 

* 3.4
* Changed how Swift version is defined for CocoaPods

* 3.3
* Updates for Swift 5.0 and Xcode 10.2

* 3.2
* Updates for Swift 4.2 and Xcode 10

* 3.1
    * Updates for Swift 3.1

* 3.0.1
    * Added a host app for the unit tests to get around the issue with keychain access not working the same on iOS 10 simulators
    * Minor update to readme instructions    

* 3.0
    * Swift 3.0 update. Contains breaking API changes. 2.2.0 and 2.2.1 are now rolled into 3.0

* 2.2.1 (Removed from Cocoapods)
    * Syntax updates to be more Swift 3 like

* 2.2 (Removed from Cocoapods)
    * Updated to support Swift 3.0
    * Remove deprecated functions (static access)

* 2.1
    * Updated to support Swift 2.3

* 2.0
    * Further changes to more closely align the API with how `NSUserDefaults` works. Access to the default implementation is now done through a singleton instance. Static accessors have been included that wrap this shared instance to maintain backwards compatibility. These will be removed in the next update
    * Ability to change keychain service name identifier and access group on the shared instance has been deprecated. Users now have the ability to create their own instance of the keychain if they want to customize these.
    * Addtional options have been provided to alter the keychain accessibility for each key value saved.

* 1.0.11
    * Update for Swift 2.0

* 1.0.10
    * Update License info. Merged Pull Request with Carthage support.

* 1.0.8
    * Update for Swift 1.2

* 1.0.7
    * Determined that once provisioned correctly for access groups, using KeychainWrapper on the simulator with access groups works. So I removed the simulator related check and unit tests previously added.

* 1.0.6
    * Support for Access Groups
    * SwiftKeychainWrapperExample has been updated to show usage with an Access Group: https://github.com/jrendel/SwiftKeychainWrapperExample

    * Access Groups do not work on the simulator. Apps that are built for the simulator aren't signed, so there's no keychain access group for the simulator to check. This means that all apps can see all keychain items when run on the simulator. Attempting to set an access group will result in a failure when attempting to Add or Update keychain items. Because of this, the Keychain Wrapper detects if it is being using on a simulator and will not set an access group property if one is set. This allows the Keychain Wrapper to still be used on the simulator for development of your app. To properly test Keychain Access Groups, you will need to test on a device.

* 1.0.5
    * This version converts the project to a proper Swift Framework and adds a podspec file to be compatible with the latest CocoaPods pre-release, which now supports Swift.

    * To see an example of usage with CocoaPods, I've created the repo SwiftKeychainWrapperExample:  https://github.com/jrendel/SwiftKeychainWrapperExample

* 1.0.2
    * Updated for Xcode 6.1

---

I've been using an Objective-C based wrapper in my own projects for the past couple years. The original library I wrote for myself was based on the following tutorial:

http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1

This is a rewrite of that code in Swift.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
