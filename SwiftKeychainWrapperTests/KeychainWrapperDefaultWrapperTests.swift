//
//  KeychainWrapperDefaultWrapperTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 8/8/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperDefaultWrapperTests: XCTestCase {
    let testKey = "acessorTestKey"
    let testString = "This is a test"
    
    let testKey2 = "acessorTestKey2"
    let testString2 = "Test 2 String"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey2)
        
        super.tearDown()
    }
    
    func testDefaultServiceName() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        if let bundleIdentifierString = bundleIdentifier {
            XCTAssertEqual(KeychainWrapper.defaultKeychainWrapper.serviceName, bundleIdentifierString, "Service Name should be equal to the bundle identifier when it is accessible")
        } else {
            XCTAssertEqual(KeychainWrapper.defaultKeychainWrapper.serviceName, "SwiftKeychainWrapper", "Service Name should be equal to SwiftKeychainWrapper when the bundle identifier is not accessible")
        }
    }
    
    func testDefaultAccessGroup() {
        XCTAssertNil(KeychainWrapper.defaultKeychainWrapper.accessGroup, "Access Group should be nil when nothing is set")
    }
    
    func testHasValueForKey() {
        XCTAssertFalse(KeychainWrapper.defaultKeychainWrapper.hasValue(forKey: testKey), "Keychain should not have a value for the test key")
        
        KeychainWrapper.defaultKeychainWrapper.set(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.defaultKeychainWrapper.hasValue(forKey: testKey), "Keychain should have a value for the test key after it is set")
    }
    
    func testRemoveObjectFromKeychain() {
        KeychainWrapper.defaultKeychainWrapper.set(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.defaultKeychainWrapper.hasValue(forKey: testKey), "Keychain should have a value for the test key after it is set")
        
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
        
        XCTAssertFalse(KeychainWrapper.defaultKeychainWrapper.hasValue(forKey: testKey), "Keychain should not have a value for the test key after it is removed")
    }
    
    func testStringSave() {
        let stringSaved = KeychainWrapper.defaultKeychainWrapper.set(testString, forKey: testKey)
        
        XCTAssertTrue(stringSaved, "String did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper.remove(key: testKey)
    }
    
    func testStringRetrieval() {
        KeychainWrapper.defaultKeychainWrapper.set(testString, forKey: testKey)
        
        if let retrievedString = KeychainWrapper.defaultKeychainWrapper.string(forKey: testKey) {
            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
        } else {
            XCTFail("String for Key not found")
        }
    }
    
    func testStringRetrievalWhenValueDoesNotExist() {
        let retrievedString = KeychainWrapper.defaultKeychainWrapper.string(forKey: testKey)
        XCTAssertNil(retrievedString, "String for Key should not exist")
    }
    
    func testMultipleStringSave() {
        if !KeychainWrapper.defaultKeychainWrapper.set(testString, forKey: testKey) {
            XCTFail("String for testKey did not save")
        }
        
        if !KeychainWrapper.defaultKeychainWrapper.set(testString2, forKey: testKey2) {
            XCTFail("String for testKey2 did not save")
        }
        
        if let string1Retrieved = KeychainWrapper.defaultKeychainWrapper.string(forKey: testKey) {
            XCTAssertEqual(string1Retrieved, testString, "String retrieved for testKey should match string saved to testKey")
        } else {
            XCTFail("String for testKey could not be retrieved")
        }
        
        if let string2Retrieved = KeychainWrapper.defaultKeychainWrapper.string(forKey: testKey2) {
            XCTAssertEqual(string2Retrieved, testString2, "String retrieved for testKey2 should match string saved to testKey2")
        } else {
            XCTFail("String for testKey2 could not be retrieved")
        }
    }
    
    func testMultipleStringsSavedToSameKey() {
        
        if !KeychainWrapper.defaultKeychainWrapper.set(testString, forKey: testKey) {
            XCTFail("String for testKey did not save")
        }
        
        if let string1Retrieved = KeychainWrapper.defaultKeychainWrapper.string(forKey: testKey) {
            XCTAssertEqual(string1Retrieved, testString, "String retrieved for testKey after first save should match first string saved testKey")
        } else {
            XCTFail("String for testKey could not be retrieved")
        }
        
        if !KeychainWrapper.defaultKeychainWrapper.set(testString2, forKey: testKey) {
            XCTFail("String for testKey did not update")
        }
        
        if let string2Retrieved = KeychainWrapper.defaultKeychainWrapper.string(forKey: testKey) {
            XCTAssertEqual(string2Retrieved, testString2, "String retrieved for testKey after update should match second string saved to testKey")
        } else {
            XCTFail("String for testKey could not be retrieved after update")
        }
    }
    
    func testNSCodingObjectSave() {
        let myTestObject = TestObject()
        let objectSaved = KeychainWrapper.defaultKeychainWrapper.set(myTestObject, forKey: testKey)
        
        XCTAssertTrue(objectSaved, "Object that implements NSCoding should save to Keychain")
    }
    
    func testNSCodingObjectRetrieval() {
        let testInt: Int = 9
        let myTestObject = TestObject()
        myTestObject.objectName = testString
        myTestObject.objectRating = testInt
        
        KeychainWrapper.defaultKeychainWrapper.set(myTestObject, forKey: testKey)
        
        if let retrievedObject = KeychainWrapper.defaultKeychainWrapper.object(forKey: testKey) as? TestObject{
            XCTAssertEqual(retrievedObject.objectName, testString, "NSCoding compliant object retrieved for key should have objectName property equal to what it was stored with")
            XCTAssertEqual(retrievedObject.objectRating, testInt, "NSCoding compliant object retrieved for key should have objectRating property equal to what it was stored with")
        } else {
            XCTFail("Object for Key not found")
        }
    }
    
    func testNSCodingObjectRetrievalWhenValueDoesNotExist() {
        let retrievedObject = KeychainWrapper.defaultKeychainWrapper.object(forKey: testKey) as? TestObject
        XCTAssertNil(retrievedObject, "Object for Key should not exist")
    }
    
    func testNSDataSave() {
        let testData = testString.data(using: String.Encoding.utf8)
        
        if let data = testData {
            let dataSaved = KeychainWrapper.defaultKeychainWrapper.set(data, forKey: testKey)
            
            XCTAssertTrue(dataSaved, "Data did not save to Keychain")
        } else {
            XCTFail("Failed to create NSData")
        }
    }
    
    func testNSDataRetrieval() {
        guard let testData = testString.data(using: String.Encoding.utf8) else {
            XCTFail("Failed to create NSData")
            return
        }
        
        KeychainWrapper.defaultKeychainWrapper.set(testData, forKey: testKey)
        
        guard let retrievedData = KeychainWrapper.defaultKeychainWrapper.data(forKey: testKey) else {
            XCTFail("Data for Key not found")
            return
        }
        
        if KeychainWrapper.defaultKeychainWrapper.dataRef(forKey: testKey) == nil {
            XCTFail("Data references for Key not found")
        }
        
        if let retrievedString = String(data: retrievedData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            XCTAssertEqual(retrievedString, testString, "String retrieved from data for key should equal string saved as data for key")
        } else {
            XCTFail("Output Data for key does not match input. ")
        }
    }
    
    func testNSDataRetrievalWhenValueDoesNotExist() {
        let retrievedData = KeychainWrapper.defaultKeychainWrapper.data(forKey: testKey)
        XCTAssertNil(retrievedData, "Data for Key should not exist")
        
        let retrievedDataRef = KeychainWrapper.defaultKeychainWrapper.dataRef(forKey: testKey)
        XCTAssertNil(retrievedDataRef, "Data ref for Key should not exist")
    }
}
