//
//  KeychainWrapperKechainOptionsTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 8/1/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperKechainOptionsTests: XCTestCase {
    let testKey = "optionsTestKey"
    let testString = "This is a test"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
        
        super.tearDown()
    }

    func testAlternateItemClass() {
//        let options = KeychainItemOptions(itemClass: .InternetPassword)
//        KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey, withOptions: options)
//        
//        if let retrievedString = KeychainWrapper.defaultKeychainWrapper().stringForKey(testKey, withOptions: options) {
//            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
//        } else {
//            XCTFail("String for Key not found")
//        }
    }
}
