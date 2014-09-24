KeychainWrapper
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
=====
The one thing I am unsure of at this point, is how Swift handles bridging objects between NS objects and Core Foundation objects. In Objective C I had to bridge them with a cast, but the compiler didn't complain in Swift about bridging.

Currently this is not a static library, as static libraries do not support swift code when I created this. I intend to update this project to a static library and make it a cocoapod once supported.

I've been using an Objective-C based wrapper in my own projects for the past couple years. The original library I wrote for myself was based on the following tutorial:

http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1

This is a rewrite of that code in Swift.
