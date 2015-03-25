SwiftKeychainWrapper
===============
A simple static wrapper for the iOS Keychain to allow you to use it in a similar fashion to user defaults. Written in Swift.

Supports adding and retrieving Strings, NSData and objects that implement NSCoding. 

Usage
=====

Add a string value to keychain:
```Swift
let saveSuccessful: Bool = KeychainWrapper.setString("Some String", forKey: "myKey")
```

Retrieve a string value from keychain:
```Swift
let retrievedString: String? = KeychainWrapper.stringForKey("myKey")
```

Remove a string value from keychain:
```Swift
let removeSuccessful: Bool = KeychainWrapper.removeObjectForKey("myKey")
```

Notes
======
v1.0.6 has been released with support for Access Groups

Access Groups do not work on the simulator. Apps that are built for the simulator aren't signed, so there's no keychain access group for the simulator to check. This means that all apps can see all keychain items when run on the simulator. Attempting to set an access group will result in a failure when attempting to Add or Update keychain items. Because of this, the Keychain Wrapper detects if it is being using on a simulator and will not set an access group property if one is set. This allows the Keychain Wrapper to still be used on the simulator for development of your app. To properly test Keychain Access Groups, you will need to test on a device.

v1.0.5 has been tagged in master

This version converts the project to a proper Swift Framework and adds a podspec file to be compatible with the latest CocoaPods pre-release, which now supports Swift. 

To see an example of usage with Cocoapods, I've created the repo SwiftKeychainWrapperExample: 
https://github.com/jrendel/SwiftKeychainWrapperExample

======

v1.0.2 has been updated for Xcode 6.1

Currently this is not a static library, as static libraries do not support swift code when I created this. I intend to update this project to a static library and make it a cocoapod once supported.

I've been using an Objective-C based wrapper in my own projects for the past couple years. The original library I wrote for myself was based on the following tutorial:

http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1

This is a rewrite of that code in Swift.
