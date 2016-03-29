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
    
    func testNSDataSubscript() {
        guard let testData = testString.dataUsingEncoding(NSUTF8StringEncoding) else {
            XCTFail("Failed to create NSData")
            return
        }
        
        KeychainWrapper.standardKeychainAccess().setData(testData, forKey: testKey)
        
        guard let retrievedData: NSData = KeychainWrapper.standardKeychainAccess().get(testKey) else {
            XCTFail("Data for Key not found")
            return
        }
        
        if let retrievedString = NSString(data: retrievedData, encoding: NSUTF8StringEncoding) {
            XCTAssertEqual(retrievedString, testString, "String retrieved from data for key should equal string saved as data for key")
        } else {
            XCTFail("Output Data for key does not match input. ")
        }
    }

}
