//
//  KeychainWrapperSubscriptTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 3/29/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperSubscriptTests: XCTestCase {
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
        KeychainWrapper.standardKeychainAccess().setString(testString, forKey: testKey)
        
        if let retrievedString: String = KeychainWrapper.standardKeychainAccess().get(testKey) {
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
        
        KeychainWrapper.standardKeychainAccess().setObject(myTestObject, forKey: testKey)
        
        if let retrievedObject: TestObject = KeychainWrapper.standardKeychainAccess().get(testKey){
            XCTAssertEqual(retrievedObject.objectName, testString, "NSCoding compliant object retrieved for key should have objectName property equal to what it was stored with")
            XCTAssertEqual(retrievedObject.objectRating, testInt, "NSCoding compliant object retrieved for key should have objectRating property equal to what it was stored with")
        } else {
            XCTFail("Object for Key not found")
        }
    }
    
    func testDataSubscript() {
        guard let testData = testString.data(using: .utf8) else {
            XCTFail("Failed to create Data")
            return
        }
        
        KeychainWrapper.standardKeychainAccess().setData(testData, forKey: testKey)
        
        guard let retrievedData: Data = KeychainWrapper.standardKeychainAccess().get(testKey) else {
            XCTFail("Data for Key not found")
            return
        }
        
        if let retrievedString = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue) as? String {
            XCTAssertEqual(retrievedString, testString, "String retrieved from data for key should equal string saved as data for key")
        } else {
            XCTFail("Output Data for key does not match input. ")
        }
    }

    func testIntegerValueSubscript() {
        let testInt: Int = 967
        KeychainWrapper.standardKeychainAccess().setObject(testInt, forKey: testKey)
        
        if let retrievedInteger: Int = KeychainWrapper.standardKeychainAccess().get(testKey) {
            XCTAssertEqual(retrievedInteger, testInt, "Int retrieved for key should equal Int saved for key")
        } else {
            XCTFail("Int for Key not found")
        }
    }
    
    func testFloatValueSubscript() {
        let testFloat: Float = 87.00
        KeychainWrapper.standardKeychainAccess().setObject(testFloat, forKey: testKey)
        
        if let retrievedFloat: Float = KeychainWrapper.standardKeychainAccess().get(testKey) {
            XCTAssertEqual(retrievedFloat, testFloat, "Float retrieved for key should equal Float saved for key")
        } else {
            XCTFail("Float for Key not found")
        }
    }
    
    func testDoubleValueSubscript() {
        let testDouble: Double = 42.00
        KeychainWrapper.standardKeychainAccess().setObject(testDouble, forKey: testKey)
        
        if let retrievedDouble: Double = KeychainWrapper.standardKeychainAccess().get(testKey) {
            XCTAssertEqual(retrievedDouble, testDouble, "Double retrieved for key should equal Double saved for key")
        } else {
            XCTFail("Double for Key not found")
        }
    }

    func testBoolValueSubscript() {
        let testBoolFalse: Bool = false
        let testBoolTrue: Bool = true
        KeychainWrapper.standardKeychainAccess().setObject(testBoolFalse, forKey: testKey)
        KeychainWrapper.standardKeychainAccess().setObject(testBoolTrue, forKey: testKey2)
        
        if let retrievedBool: Bool = KeychainWrapper.standardKeychainAccess().get(testKey) {
            XCTAssertEqual(retrievedBool, testBoolFalse, "Bool value retrieved for first key should equal Bool value saved for first key")
        } else {
            XCTFail("Bool for First Key not found")
        }
        
        if let retrievedBool2: Bool = KeychainWrapper.standardKeychainAccess().get(testKey2) {
            XCTAssertEqual(retrievedBool2, testBoolTrue, "Bool value retrieved for second key should equal Bool value saved for second key")
        } else {
            XCTFail("Bool for Second Key not found")
        }
    }


}
