//
//  KeychainWrapperGenericAccessTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 3/29/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperGenericAccessTests: XCTestCase {
    let testKey = "myTestKey"
    let testKey2 = "myTestKey2"
    let testString = "This is a test"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringSubscript() {
        KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey)
        
        if let retrievedString: String = KeychainWrapper.defaultKeychainWrapper().get(testKey) {
            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
        } else {
            XCTFail("String for Key not found")
        }
    }
    
    func testNSCodingSubscript() {
        let testInt: Int = 9
        let myTestObject = TestObject()
        myTestObject.objectName = testString
        myTestObject.objectRating = testInt
        
        KeychainWrapper.defaultKeychainWrapper().setObject(myTestObject, forKey: testKey)
        
        if let retrievedObject: TestObject = KeychainWrapper.defaultKeychainWrapper().get(testKey){
            XCTAssertEqual(retrievedObject.objectName, testString, "NSCoding compliant object retrieved for key should have objectName property equal to what it was stored with")
            XCTAssertEqual(retrievedObject.objectRating, testInt, "NSCoding compliant object retrieved for key should have objectRating property equal to what it was stored with")
        } else {
            XCTFail("Object for Key not found")
        }
    }
    
    func testNSDataSubscript() {
        guard let testData = testString.dataUsingEncoding(NSUTF8StringEncoding) else {
            XCTFail("Failed to create NSData")
            return
        }
        
        KeychainWrapper.defaultKeychainWrapper().setData(testData, forKey: testKey)
        
        guard let retrievedData: NSData = KeychainWrapper.defaultKeychainWrapper().get(testKey) else {
            XCTFail("Data for Key not found")
            return
        }
        
        if let retrievedString = NSString(data: retrievedData, encoding: NSUTF8StringEncoding) {
            XCTAssertEqual(retrievedString, testString, "String retrieved from data for key should equal string saved as data for key")
        } else {
            XCTFail("Output Data for key does not match input. ")
        }
    }
    
    func testIntegerValueSubscript() {
        let testInt: Int = 967
        KeychainWrapper.defaultKeychainWrapper().setInteger(testInt, forKey: testKey)
        
        if let retrievedInteger: Int = KeychainWrapper.defaultKeychainWrapper().get(testKey) {
            XCTAssertEqual(retrievedInteger, testInt, "Int retrieved for key should equal Int saved for key")
        } else {
            XCTFail("Int for Key not found")
        }
    }
    
    func testFloatValueSubscript() {
        let testFloat: Float = 87.00
        KeychainWrapper.defaultKeychainWrapper().setFloat(testFloat, forKey: testKey)
        
        if let retrievedFloat: Float = KeychainWrapper.defaultKeychainWrapper().get(testKey) {
            XCTAssertEqual(retrievedFloat, testFloat, "Float retrieved for key should equal Float saved for key")
        } else {
            XCTFail("Float for Key not found")
        }
    }
    
    func testDoubleValueSubscript() {
        let testDouble: Double = 42.00
        KeychainWrapper.defaultKeychainWrapper().setDouble(testDouble, forKey: testKey)
        
        if let retrievedDouble: Double = KeychainWrapper.defaultKeychainWrapper().get(testKey) {
            XCTAssertEqual(retrievedDouble, testDouble, "Double retrieved for key should equal Double saved for key")
        } else {
            XCTFail("Double for Key not found")
        }
    }
    
    func testBoolValueSubscript() {
        let testBoolFalse: Bool = false
        let testBoolTrue: Bool = true
        KeychainWrapper.defaultKeychainWrapper().setBool(testBoolFalse, forKey: testKey)
        KeychainWrapper.defaultKeychainWrapper().setBool(testBoolTrue, forKey: testKey2)
        
        if let retrievedBool: Bool = KeychainWrapper.defaultKeychainWrapper().get(testKey) {
            XCTAssertEqual(retrievedBool, testBoolFalse, "Bool value retrieved for first key should equal Bool value saved for first key")
        } else {
            XCTFail("Bool for First Key not found")
        }
        
        if let retrievedBool2: Bool = KeychainWrapper.defaultKeychainWrapper().get(testKey2) {
            XCTAssertEqual(retrievedBool2, testBoolTrue, "Bool value retrieved for second key should equal Bool value saved for second key")
        } else {
            XCTFail("Bool for Second Key not found")
        }
    }
    
    
}
