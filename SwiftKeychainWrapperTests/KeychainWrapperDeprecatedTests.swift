//
//  KeychainWrapperDeprecatedTests.swift
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 Jason Rendel. All rights reserved.
//
//    The MIT License (MIT)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import XCTest
import SwiftKeychainWrapper

// INFO: These tests are being maintained for 2.0 in order to ensure backwards compatibility. 
class KeychainWrapperDeprecatedTests: XCTestCase {
    let testKey = "acessorTestKey"
    let testString = "This is a test"
    
    let testKey2 = "acessorTestKey2"
    let testString2 = "Test 2 String"
    
    let defaultServiceName = KeychainWrapper.defaultKeychainWrapper().serviceName
    let testServiceName = "myTestService"
    
    let defaultAccessGroup = KeychainWrapper.defaultKeychainWrapper().accessGroup
    let testAccessGroup = "myTestAccessGroup"
    
    var keychainWrapper: KeychainWrapper?
    
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		
		// clean up keychain
		KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(testKey)
		KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(testKey2)
		
        keychainWrapper = nil
		// reset keychain service name to default
//		KeychainWrapper.defaultKeychainWrapper().serviceName = defaultServiceName

        // reset keychain access group to default
//        KeychainWrapper.defaultKeychainWrapper().accessGroup = defaultAccessGroup
		
		super.tearDown()
	}
	
    func testDefaultServiceName() {
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
        if let bundleIdentifierString = bundleIdentifier {
            XCTAssertEqual(KeychainWrapper.defaultKeychainWrapper().serviceName, bundleIdentifierString, "Service Name should be equal to the bundle identifier when it is accessible")
        } else {
            XCTAssertEqual(KeychainWrapper.defaultKeychainWrapper().serviceName, "SwiftKeychainWrapper", "Service Name should be equal to SwiftKeychainWrapper when the bundle identifier is not accessible")
        }
    }
    
    func testSettingServiceName() {
        keychainWrapper = KeychainWrapper(serviceName: testServiceName)
        XCTAssertEqual(keychainWrapper?.serviceName, testServiceName, "Service Name should have been set to our custom service name")
    }
    
    func testDefaultAccessGroup() {
        XCTAssertNil(KeychainWrapper.defaultKeychainWrapper().accessGroup, "Access Group should be nil when nothing is set")
    }

    func testSettingAccessGroup() {
        keychainWrapper = KeychainWrapper(serviceName: "", accessGroup: testAccessGroup)
        XCTAssertEqual(keychainWrapper?.accessGroup, testAccessGroup, "Access Group should have been set to our custom access group")
    }

    func testHasValueForKey() {
        XCTAssertFalse(KeychainWrapper.defaultKeychainWrapper().hasValueForKey(testKey), "Keychain should not have a value for the test key")
        
        KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.defaultKeychainWrapper().hasValueForKey(testKey), "Keychain should have a value for the test key after it is set")
    }
    
    func testRemoveObjectFromKeychain() {
        KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.defaultKeychainWrapper().hasValueForKey(testKey), "Keychain should have a value for the test key after it is set")
        
        KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(testKey)
        
        XCTAssertFalse(KeychainWrapper.defaultKeychainWrapper().hasValueForKey(testKey), "Keychain should not have a value for the test key after it is removed")
    }
    
    func testStringSave() {
        let stringSaved = KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey)
        
        XCTAssertTrue(stringSaved, "String did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(testKey)
    }
    
    func testStringRetrieval() {
        KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey)
        
        if let retrievedString = KeychainWrapper.defaultKeychainWrapper().stringForKey(testKey) {
            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
        } else {
            XCTFail("String for Key not found")
        }
    }
    
    func testStringRetrievalWhenValueDoesNotExist() {
        let retrievedString = KeychainWrapper.defaultKeychainWrapper().stringForKey(testKey)
        XCTAssertNil(retrievedString, "String for Key should not exist")
    }

	func testMultipleStringSave() {
        let keychainWrapper = KeychainWrapper(serviceName: "com.yaddayadda.whatever")
		
		if !keychainWrapper.setString(testString, forKey: testKey) {
			XCTFail("String for testKey did not save")
		}
		
		if !keychainWrapper.setString(testString2, forKey: testKey2) {
			XCTFail("String for testKey2 did not save")
		}
		
		if let string1Retrieved = keychainWrapper.stringForKey(testKey) {
			XCTAssertEqual(string1Retrieved, testString, "String retrieved for testKey should match string saved to testKey")
		} else {
			XCTFail("String for testKey could not be retrieved")
		}
		
		if let string2Retrieved = keychainWrapper.stringForKey(testKey2) {
			XCTAssertEqual(string2Retrieved, testString2, "String retrieved for testKey2 should match string saved to testKey2")
		} else {
			XCTFail("String for testKey2 could not be retrieved")
		}
	}
	
	func testMultipleStringsSavedToSameKey() {
		
		if !KeychainWrapper.defaultKeychainWrapper().setString(testString, forKey: testKey) {
			XCTFail("String for testKey did not save")
		}
		
		if let string1Retrieved = KeychainWrapper.defaultKeychainWrapper().stringForKey(testKey) {
			XCTAssertEqual(string1Retrieved, testString, "String retrieved for testKey after first save should match first string saved testKey")
		} else {
			XCTFail("String for testKey could not be retrieved")
		}
		
		if !KeychainWrapper.defaultKeychainWrapper().setString(testString2, forKey: testKey) {
			XCTFail("String for testKey did not update")
		}
		
		if let string2Retrieved = KeychainWrapper.defaultKeychainWrapper().stringForKey(testKey) {
			XCTAssertEqual(string2Retrieved, testString2, "String retrieved for testKey after update should match secind string saved to testKey")
		} else {
			XCTFail("String for testKey could not be retrieved after update")
		}
	}
	
    func testNSCodingObjectSave() {
        let myTestObject = TestObject()
        let objectSaved = KeychainWrapper.defaultKeychainWrapper().setObject(myTestObject, forKey: testKey)
        
        XCTAssertTrue(objectSaved, "Object that implements NSCoding should save to Keychain")
    }
    
    func testNSCodingObjectRetrieval() {
        let testInt: Int = 9
        let myTestObject = TestObject()
        myTestObject.objectName = testString
        myTestObject.objectRating = testInt
        
        KeychainWrapper.defaultKeychainWrapper().setObject(myTestObject, forKey: testKey)
        
        if let retrievedObject = KeychainWrapper.defaultKeychainWrapper().objectForKey(testKey) as? TestObject{
            XCTAssertEqual(retrievedObject.objectName, testString, "NSCoding compliant object retrieved for key should have objectName property equal to what it was stored with")
            XCTAssertEqual(retrievedObject.objectRating, testInt, "NSCoding compliant object retrieved for key should have objectRating property equal to what it was stored with")
        } else {
            XCTFail("Object for Key not found")
        }
    }
    
    func testNSCodingObjectRetrievalWhenValueDoesNotExist() {
        let retrievedObject = KeychainWrapper.defaultKeychainWrapper().objectForKey(testKey) as? TestObject
        XCTAssertNil(retrievedObject, "Object for Key should not exist")
    }
    
    func testNSDataSave() {
        let testData = testString.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = testData {
            let dataSaved = KeychainWrapper.defaultKeychainWrapper().setData(data, forKey: testKey)
            
            XCTAssertTrue(dataSaved, "Data did not save to Keychain")
        } else {
            XCTFail("Failed to create NSData")
        }
    }
    
    func testNSDataRetrieval() {
        guard let testData = testString.dataUsingEncoding(NSUTF8StringEncoding) else {
            XCTFail("Failed to create NSData")
            return
        }
        
        KeychainWrapper.defaultKeychainWrapper().setData(testData, forKey: testKey)
        
        guard let retrievedData = KeychainWrapper.defaultKeychainWrapper().dataForKey(testKey) else {
            XCTFail("Data for Key not found")
            return
        }
        
        if KeychainWrapper.defaultKeychainWrapper().dataRefForKey(testKey) == nil {
            XCTFail("Data references for Key not found")
        }
        
        if let retrievedString = NSString(data: retrievedData, encoding: NSUTF8StringEncoding) {
            XCTAssertEqual(retrievedString, testString, "String retrieved from data for key should equal string saved as data for key")
        } else {
            XCTFail("Output Data for key does not match input. ")
        }
    }
    
    func testNSDataRetrievalWhenValueDoesNotExist() {
        let retrievedData = KeychainWrapper.defaultKeychainWrapper().dataForKey(testKey)
        XCTAssertNil(retrievedData, "Data for Key should not exist")
        
        let retrievedDataRef = KeychainWrapper.defaultKeychainWrapper().dataRefForKey(testKey)
        XCTAssertNil(retrievedDataRef, "Data ref for Key should not exist")
    }
}
