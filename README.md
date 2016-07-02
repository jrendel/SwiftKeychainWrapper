SwiftKeychainWrapper
===============
A simple static wrapper for the iOS Keychain to allow you to use it in a similar fashion to User Defaults. Written in Swift.

Provides a defaultKeychainWrapper() function to access singleton instance that is setup to work for most needs. 

If you need to customize the keychain access to use a custom identifier or access group, you can create your own instance instead of using the singleton access.

By default, the Keychain Wrapper saves data as a Generic Password type in the iOS Keychain. It saves items such that they can only be accessed when the app is unlocked and open. If you are not familiar with the iOS Keychain usage, this provides a safe default for using the keycain.

Users that want to deviate from this default implementation, now can do so in in version 2.0 and up. Each request to save/read a key value now allows you to specify the keychain accessibility and item class for that key.

General Usage
=====

Add a string value to keychain:
```Swift
let saveSuccessful: Bool = KeychainWrapper.defaultKeychainWrapper().setString("Some String", forKey: "myKey")
```

Retrieve a string value from keychain:
```Swift
let retrievedString: String? = KeychainWrapper.defaultKeychainWrapper().stringForKey("myKey")
```

Remove a string value from keychain:
```Swift
let removeSuccessful: Bool = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey("myKey")
```

Convenience Accessors 
=====

I find the singleton pattern can be cumbersome to use at times, so have added static accessors to the class as a convenient way to access the shared instance. This also allows the class to maintain backwards compatibility with previous releases of the library (prior to 2.0 all functions were static). Using this pattern, the examples above would be:

```Swift
let saveSuccessful: Bool = KeychainWrapper.setString("Some String", forKey: "myKey")

let retrievedString: String? = KeychainWrapper.stringForKey("myKey")

let removeSuccessful: Bool = KeychainWrapper.removeObjectForKey("myKey")
```

Custom Instance
=====

When the Keychain Wrapper is used, all keys are linked to a common identifier for your app, called the service name. By default this uses your main bundle identifier. However, you may also change it, or store multiple items to the keycahin under different identifiers.

To share keychain items between your applications, you may specify an access group and use that same access group in each application.

To set a custom service name identifier or access group, you may now create your own instance of the keychain wrapper as follows:

```Swift
let uniqueServiceName = "customServiceName"
let uniqueAccessGroup = "sharedAccessGroupName"
let customKeychainWrapperInstance = KeychainWrapper(serviceName: uniqueServiceName, accessGroup: uniqueAccessGroup)
```
The custom instance can then be used in place of the shared instance or static accessors:

```
let saveSuccessful: Bool = customKeychainWrapperInstance.setString("Some String", forKey: "myKey")

let retrievedString: String? = customKeychainWrapperInstance.stringForKey("myKey")

let removeSuccessful: Bool = customKeychainWrapperInstance.removeObjectForKey("myKey")
```

Custom Key Options
=====

// TODO


Release Notes
======
v2.0
Further changes to more closesly align the api with how NSUserDefaults works. Access to the default implementation is now done through a singleton instance. Static accessors have been included that wrap this shared instance for convenience and to maintain backwards compatibility.
Ability to change keychain service name identifier and access group on the shared instance has been deprecated. Users now have the ability to create their own instance of the keychain if they want to customize these.
Addtional options have been provided to alter the keychain type and accessibility for each key value saved.

v1.0.11
Update for Swift 2.0

v1.0.10
Update License info. Merged Pull Request with Carthage support.

v1.0.8
Update for Swift 1.2

v1.0.7
Determined that once provisioned correctly for access groups, using KeychainWrapper on the simulator with access groups works. So I removed the simulator related check and unit tests previously added.

v1.0.6 Support for Access Groups
SwiftKeychainWrapperExample has been updated to show usage with an Access Group: https://github.com/jrendel/SwiftKeychainWrapperExample

Access Groups do not work on the simulator. Apps that are built for the simulator aren't signed, so there's no keychain access group for the simulator to check. This means that all apps can see all keychain items when run on the simulator. Attempting to set an access group will result in a failure when attempting to Add or Update keychain items. Because of this, the Keychain Wrapper detects if it is being using on a simulator and will not set an access group property if one is set. This allows the Keychain Wrapper to still be used on the simulator for development of your app. To properly test Keychain Access Groups, you will need to test on a device.

v1.0.5
This version converts the project to a proper Swift Framework and adds a podspec file to be compatible with the latest CocoaPods pre-release, which now supports Swift. 

To see an example of usage with CocoaPods, I've created the repo SwiftKeychainWrapperExample: 
https://github.com/jrendel/SwiftKeychainWrapperExample

v1.0.2 
Updated for Xcode 6.1

======

I've been using an Objective-C based wrapper in my own projects for the past couple years. The original library I wrote for myself was based on the following tutorial:

http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1

This is a rewrite of that code in Swift.
