//
//  testObject.swift
//  KeychainWrapper
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 jasonrendel. All rights reserved.
//

import Foundation

class testObject: NSObject, NSCoding {
    var objectName = "Name"
    var objectRating = 0
    
    override init() { }
    
    required init(coder decoder: NSCoder) {
        if let name = decoder.decodeObjectForKey("objectName") as? String {
            self.objectName = name
        }
        
        self.objectRating = decoder.decodeIntegerForKey("objectRating")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.objectName, forKey: "objectName")
        encoder.encodeInteger(self.objectRating, forKey: "objectRating")
    }
}