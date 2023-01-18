//
//  KeychainWrapperDeleteTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 3/25/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperDeleteTests: XCTestCase {
    let testKey = "deleteTestKey"
    let testString = "This is a test"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRemoveAllKeysDeletesSpecificKey() {
        // save a value we can test delete on
        XCTAssertNoThrow(try KeychainWrapper.standard.set(testString, forKey: testKey))

        // delete all
        XCTAssertNoThrow(try KeychainWrapper.standard.removeAllKeys())

        // confirm our test value was deleted
        let retrievedValue = KeychainWrapper.standard.string(forKey: testKey)
        
        XCTAssertNil(retrievedValue, "Test value was not deleted")
    }
    
    func testWipeKeychainDeletesSpecificKey() {
        // save a value we can test delete on
        XCTAssertNoThrow(try KeychainWrapper.standard.set(testString, forKey: testKey))

        // delete all
        KeychainWrapper.wipeKeychain()
        
        // confirm our test value was deleted
        let retrievedValue = KeychainWrapper.standard.string(forKey: testKey)
        
        XCTAssertNil(retrievedValue, "Test value was not deleted")
        
        // clean up keychain
        try? KeychainWrapper.standard.removeObject(forKey: testKey)
    }
    
//    func testRemoveAllKeysOnlyRemovesKeysForCurrentServiceName() {
//        
//    }
//    
//    func testRemoveAllKeysOnlyRemovesKeysForCurrentAccessGroup() {
//        
//    }
}
