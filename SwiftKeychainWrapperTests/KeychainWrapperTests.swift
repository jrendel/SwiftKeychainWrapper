//
//  KeychainWrapperTests.swift
//  KeychainWrapperTests
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 jasonrendel. All rights reserved.
//

import SwiftKeychainWrapper
import XCTest

let testKey = "myTestKey"
let testString = "This is a test"

let testKey2 = "testKey2"
let testString2 = "Test 2 String"

let defaultServiceName = KeychainWrapper.serviceName
let testServiceName = "myTestService"

let defaultAccessGroup = KeychainWrapper.accessGroup
let testAccessGroup = "myTestAccessGroup"

class KeychainWrapperTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		
		// clean up keychain
		KeychainWrapper.removeObjectForKey(testKey)
		KeychainWrapper.removeObjectForKey(testKey2)
		
		// reset keychain service name to default
		KeychainWrapper.serviceName = defaultServiceName

        // reset keychain access group to default
        KeychainWrapper.accessGroup = defaultAccessGroup
		
		super.tearDown()
	}
	
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
    
    func testDefaultAccessGroup() {
        XCTAssertTrue(KeychainWrapper.accessGroup.isEmpty, "Access Group should be empty when nothing is set")
    }

    func testSettingAccessGroup() {
        KeychainWrapper.accessGroup = testAccessGroup

        XCTAssertEqual(KeychainWrapper.accessGroup, testAccessGroup, "Access Group should have been set to our custom access group")
    }

    func testHasValueForKey() {
        XCTAssertFalse(KeychainWrapper.hasValueForKey(testKey), "Keychain should not have a value for the test key")
        
        KeychainWrapper.setString(testString, forKey: testKey)
        
        XCTAssertTrue(KeychainWrapper.hasValueForKey(testKey), "Keychain should have a value for the test key after it is set")
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
    }
    
    func testStringSaveToAccessGroupDoesNotFailOnSimulator() {
        // Unit Tests run on the simulator aren't signed, so there's no keychain access group for the simulator to check. This means that all apps can see all keychain items when run on the simulator. Trying to set an access group on the simulator will cause the keychain access to fail, so KeychainWrapper takes into account when being used on the simulator and does not set the Access Group property. This tests confirms that it will work on the simulator.
        KeychainWrapper.accessGroup = testAccessGroup
        let stringSaved = KeychainWrapper.setString(testString, forKey: testKey)
        
        XCTAssertTrue(stringSaved, "String did not save to Keychain")
        
        // clean up keychain
        KeychainWrapper.removeObjectForKey(testKey)
    }
    
    func testStringRetrievalFromAccessGroup() {
        // Unit Tests run on the simulator aren't signed, so there's no keychain access group for the simulator to check. This means that all apps can see all keychain items when run on the simulator. Trying to set an access group on the simulator will cause the keychain access to fail, so KeychainWrapper takes into account when being used on the simulator and does not set the Access Group property. This tests confirms that it will work on the simulator.
        KeychainWrapper.accessGroup = testAccessGroup
        KeychainWrapper.setString(testString, forKey: testKey)
        
        if let retrievedString = KeychainWrapper.stringForKey(testKey) {
            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
        } else {
            XCTFail("String for Key not found")
        }
    }
    
    func testStringRetrievalWhenValueDoesNotExist() {
        if let retrievedString = KeychainWrapper.stringForKey(testKey) {
            XCTFail("String for Key should not exist")
        } else {
            XCTAssert(true, "Pass")
        }
    }

	func testMultipleStringSave() {
		KeychainWrapper.serviceName = "com.yaddayadda.whatever"
		
		if !KeychainWrapper.setString(testString, forKey: testKey) {
			XCTFail("String for testKey did not save")
		}
		
		if !KeychainWrapper.setString(testString2, forKey: testKey2) {
			XCTFail("String for testKey2 did not save")
		}
		
		if let string1Retrieved = KeychainWrapper.stringForKey(testKey) {
			XCTAssertEqual(string1Retrieved, testString, "String retrieved for testKey should match string saved to testKey")
		} else {
			XCTFail("String for testKey could not be retrieved")
		}
		
		if let string2Retrieved = KeychainWrapper.stringForKey(testKey2) {
			XCTAssertEqual(string2Retrieved, testString2, "String retrieved for testKey2 should match string saved to testKey2")
		} else {
			XCTFail("String for testKey2 could not be retrieved")
		}
	}
	
	func testMultipleStringsSavedToSameKey() {
		KeychainWrapper.serviceName = "com.yaddayadda.whatever"
		
		if !KeychainWrapper.setString(testString, forKey: testKey) {
			XCTFail("String for testKey did not save")
		}
		
		if let string1Retrieved = KeychainWrapper.stringForKey(testKey) {
			XCTAssertEqual(string1Retrieved, testString, "String retrieved for testKey after first save should match first string saved testKey")
		} else {
			XCTFail("String for testKey could not be retrieved")
		}
		
		if !KeychainWrapper.setString(testString2, forKey: testKey) {
			XCTFail("String for testKey did not update")
		}
		
		if let string2Retrieved = KeychainWrapper.stringForKey(testKey) {
			XCTAssertEqual(string2Retrieved, testString2, "String retrieved for testKey after update should match secind string saved to testKey")
		} else {
			XCTFail("String for testKey could not be retrieved after update")
		}
	}
	
    func testNSCodingObjectSave() {
        let myTestObject = testObject()
        let objectSaved = KeychainWrapper.setObject(myTestObject, forKey: testKey)
        
        XCTAssertTrue(objectSaved, "Object that implements NSCoding should save to Keychain")
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
    }
    
    func testNSCodingObjectRetrievalWhenValueDoesNotExist() {
        if let retrievedObject = KeychainWrapper.objectForKey(testKey) as? testObject{
            XCTFail("Object for Key should not exist")
        } else {
            XCTAssert(true, "Pass")
        }
    }
    
    func testNSDataSave() {
        let testData = testString.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = testData {
            let dataSaved = KeychainWrapper.setData(data, forKey: testKey)
            
            XCTAssertTrue(dataSaved, "Data did not save to Keychain")
        } else {
            XCTFail("Failed to create NSData")
        }
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
    }
    
    func testNSDataRetrievalWhenValueDoesNotExist() {
        if let retrievedData = KeychainWrapper.dataForKey(testKey) {
            XCTFail("Data for Key should not exist")
        } else {
            XCTAssert(true, "Pass")
        }
    }
}
