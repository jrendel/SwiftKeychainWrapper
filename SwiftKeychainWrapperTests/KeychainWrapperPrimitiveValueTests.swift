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
    let testKey = "primitiveValueTestKey"
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
        let valueSaved = KeychainWrapper.defaultKeychainWrapper.set(testInteger, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Integer value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
    }
    
    func testIntegerRetrieval() {
        KeychainWrapper.defaultKeychainWrapper.set(testInteger, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.defaultKeychainWrapper.integer(forKey: testKey) {
            XCTAssertEqual(retrievedValue, testInteger, "Integer value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Integer value for Key not found")
        }
    }
    
    func testBoolSave() {
        let valueSaved = KeychainWrapper.defaultKeychainWrapper.set(testBool, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Bool value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
    }
    
    func testBoolRetrieval() {
        KeychainWrapper.defaultKeychainWrapper.set(testBool, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.defaultKeychainWrapper.bool(forKey: testKey) {
            XCTAssertEqual(retrievedValue, testBool, "Bool value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Bool value for Key not found")
        }
    }
    
    func testFloatSave() {
        let valueSaved = KeychainWrapper.defaultKeychainWrapper.set(testFloat, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Float value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
    }
    
    func testFloatRetrieval() {
        KeychainWrapper.defaultKeychainWrapper.set(testFloat, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.defaultKeychainWrapper.float(forKey: testKey) {
            XCTAssertEqual(retrievedValue, testFloat, "Float value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Float value for Key not found")
        }
    }
    
    func testDoubleSave() {
        let valueSaved = KeychainWrapper.defaultKeychainWrapper.set(testDouble, forKey: testKey)
        
        XCTAssertTrue(valueSaved, "Double value did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
    }
    
    func testDoubleRetrieval() {
        KeychainWrapper.defaultKeychainWrapper.set(testDouble, forKey: testKey)
        
        if let retrievedValue = KeychainWrapper.defaultKeychainWrapper.double(forKey: testKey) {
            XCTAssertEqual(retrievedValue, testDouble, "Double value retrieved for key should equal value saved for key")
        } else {
            XCTFail("Double value for Key not found")
        }
    }
}
