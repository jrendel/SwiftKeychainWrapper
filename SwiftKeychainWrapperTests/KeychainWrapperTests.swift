//
//  KeychainWrapperTests.swift
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 4/25/16.
//  Copyright © 2016 Jason Rendel. All rights reserved.
//

import XCTest
import SwiftKeychainWrapper

class KeychainWrapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCustomInstance() {
        let uniqueServiceName = NSUUID().uuidString
        let uniqueAccessGroup = NSUUID().uuidString
        let customKeychainWrapperInstance = KeychainWrapper(serviceName: uniqueServiceName, accessGroup: uniqueAccessGroup)
        
        XCTAssertNotEqual(customKeychainWrapperInstance.serviceName, KeychainWrapper.standardKeychainAccess().serviceName, "Custom instance initialized with unique service name, should not match standardKeychainAccess Service Name")
        XCTAssertNotEqual(customKeychainWrapperInstance.accessGroup, KeychainWrapper.standardKeychainAccess().accessGroup, "Custom instance initialized with unique access group, should not match standardKeychainAccess Access Group")
    }
}
