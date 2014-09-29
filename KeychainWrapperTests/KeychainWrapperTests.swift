//
//  KeychainWrapperTests.swift
//  KeychainWrapperTests
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 jasonrendel. All rights reserved.
//

import UIKit
import XCTest

let testKey = "myTestKey"
let testString = "This is a test"
let testServiceName = "myTestService"

class KeychainWrapperTests: XCTestCase {
   
    func testDefaultServiceName() {
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
        if let bundleIdentifierString = bundleIdentifier {
            XCTAssertEqual(KeychainWrapper.serviceName, bundleIdentifierString, "Service Name should be equal to the bundle identifier when it is accessible")
        } else {
            XCTAssertEqual(KeychainWrapper.serviceName, "SwiftKeychainWrapper", "Service Name should be equal to SwiftKeychainWrapper when the bundle identifier is not accessible")
        }
    }
    
    func testSettingServiceName() {
        KeychainWrapper.serviceName = testServiceName;
        
        XCTAssertEqual(KeychainWrapper.serviceName, testServiceName, "Service Name should have been set to our custom service name")
    }
    
    func testHasValueForKey() {
        XCTAssertFalse(KeychainWrapper.hasValueForKey(testKey), "Keychain should not have a value for the test key")
        
        KeychainWrapper.setString(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.hasValueForKey(testKey), "Keychain should have a value for the test key after it is set")
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testRemoveObjectFromKeychain() {
        KeychainWrapper.setString(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.hasValueForKey(testKey), "Keychain should have a value for the test key after it is set")
        
        KeychainWrapper.removeObjectForKey(testKey)
        
        XCTAssertFalse(KeychainWrapper.hasValueForKey(testKey), "Keychain should not have a value for the test key after it is removed")
    }
    
    func testStringSave() {
        let stringSaved = KeychainWrapper.setString(testString, forKey: testKey)
        
        XCTAssertTrue(stringSaved, "String did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testStringRetrieval() {
        KeychainWrapper.setString(testString, forKey: testKey)
        
        if let retrievedString = KeychainWrapper.stringForKey(testKey) {
            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
        } else {
            XCTFail("String for Key not found")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testStringRetrievalWhenValueDoesNotExist() {
        if let retrievedString = KeychainWrapper.stringForKey(testKey) {
            XCTFail("String for Key should not exist")
        } else {
            XCTAssert(true, "Pass")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }

    func testNSCodingObjectSave() {
        let myTestObject = testObject()
        let objectSaved = KeychainWrapper.setObject(myTestObject, forKey: testKey)
        
        XCTAssertTrue(objectSaved, "Object that implements NSCoding should save to Keychain")
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testNSCodingObjectRetrieval() {
        var testInt: Int = 9
        var myTestObject = testObject()
        myTestObject.objectName = testString
        myTestObject.objectRating = testInt
        
        KeychainWrapper.setObject(myTestObject, forKey: testKey)
        
        if let retrievedObject = KeychainWrapper.objectForKey(testKey) as? testObject{
            XCTAssertEqual(retrievedObject.objectName, testString, "NSCoding compliant object retrieved for key should have objectName property equal to what it was stored with")
            XCTAssertEqual(retrievedObject.objectRating, testInt, "NSCoding compliant object retrieved for key should have objectRating property equal to what it was stored with")
        } else {
            XCTFail("Object for Key not found")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testNSCodingObjectRetrievalWhenValueDoesNotExist() {
        if let retrievedObject = KeychainWrapper.objectForKey(testKey) as? testObject{
            XCTFail("Object for Key should not exist")
        } else {
            XCTAssert(true, "Pass")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testNSDataSave() {
        let testData = testString.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = testData {
            let dataSaved = KeychainWrapper.setData(data, forKey: testKey)
            
            XCTAssertTrue(dataSaved, "Data did not save to Keychain")
        } else {
            XCTFail("Failed to create NSData")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testNSDataRetrieval() {
        let testData = testString.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = testData {
            KeychainWrapper.setData(data, forKey: testKey)
            
            if let retrievedData = KeychainWrapper.dataForKey(testKey) {
                let retrievedString = NSString(data: retrievedData, encoding: NSUTF8StringEncoding) as String
                XCTAssertEqual(retrievedString, testString, "String retrieved from data for key should equal string saved as data for key")
            } else {
                XCTFail("Data for Key not found")
            }
        } else {
            XCTFail("Failed to create NSData")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testNSDataRetrievalWhenValueDoesNotExist() {
        if let retrievedData = KeychainWrapper.dataForKey(testKey) {
            XCTFail("Data for Key should not exist")
        } else {
            XCTAssert(true, "Pass")
        }
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
}
