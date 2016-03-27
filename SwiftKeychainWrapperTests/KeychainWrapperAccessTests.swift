//
//  KeychainWrapperAccessTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 3/25/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperAccessTests: XCTestCase {
    let testKey = "myTestKey"
    let testString = "This is a test"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testStringRetrieval() {
        KeychainWrapper.setString(testString, forKey: testKey)
        
        let wrapper = KeychainWrapper()
        
        if let retrievedString = wrapper[testKey] {
            XCTAssertEqual(retrievedString, testString, "String retrieved for key should equal string saved for key")
        } else {
            XCTFail("String for Key not found")
        }
    }
}
