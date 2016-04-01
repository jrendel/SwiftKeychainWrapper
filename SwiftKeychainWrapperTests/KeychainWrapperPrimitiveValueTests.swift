//
//  KeychainWrapperPrimitiveValueTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 4/1/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperPrimitiveValueTests: XCTestCase {
    let testKey = "myTestKey"
    let testInteger: Int = 42
    let testBool: Bool = false
    let testFloat: Float = 5.25
    let testDouble: Double = 10.75
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIntegerSave() {
        let valueSaved = KeychainWrapper.standardKeychainAccess().setInteger(testInteger, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Integer value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.standardKeychainAccess().removeObjectForKey(testKey)
    }
    
    func testIntegerRetrieval() {
        KeychainWrapper.standardKeychainAccess().setInteger(testInteger, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.standardKeychainAccess().integerForKey(testKey) {
            XCTAssertEqual(retrievedValue, testInteger, "Integer value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Integer value for Key not found")
        }
    }
    
    func testBoolSave() {
        let valueSaved = KeychainWrapper.standardKeychainAccess().setBool(testBool, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Bool value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.standardKeychainAccess().removeObjectForKey(testKey)
    }
    
    func testBoolRetrieval() {
        KeychainWrapper.standardKeychainAccess().setBool(testBool, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.standardKeychainAccess().boolForKey(testKey) {
            XCTAssertEqual(retrievedValue, testBool, "Bool value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Bool value for Key not found")
        }
    }
    
    func testFloatSave() {
        let valueSaved = KeychainWrapper.standardKeychainAccess().setFloat(testFloat, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Float value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.standardKeychainAccess().removeObjectForKey(testKey)
    }
    
    func testFloatRetrieval() {
        KeychainWrapper.standardKeychainAccess().setFloat(testFloat, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.standardKeychainAccess().floatForKey(testKey) {
            XCTAssertEqual(retrievedValue, testFloat, "Float value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Float value for Key not found")
        }
    }
    
    func testDoubleSave() {
        let valueSaved = KeychainWrapper.standardKeychainAccess().setDouble(testDouble, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Double value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.standardKeychainAccess().removeObjectForKey(testKey)
    }
    
    func testDoubleRetrieval() {
        KeychainWrapper.standardKeychainAccess().setDouble(testDouble, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.standardKeychainAccess().doubleForKey(testKey) {
            XCTAssertEqual(retrievedValue, testDouble, "Double value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Double value for Key not found")
        }
    }
}
