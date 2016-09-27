//
//  ViewController.swift
//  SwiftKeychainWrapperExample
//
//  Created by Jason Rendel on 1/27/15.
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

import UIKit
import SwiftKeychainWrapper



class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var testObjectStringTextField: UITextField!
    @IBOutlet weak var testObjectIntTextField: UITextField!
    
    let keychainWrapper = KeychainWrapper(serviceName: KeychainWrapper.defaultKeychainWrapper.serviceName, accessGroup: "group.myAccessGroup")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func saveTapped(_ sender: AnyObject) {
        if let text = textfield.text, !text.isEmpty {

            if keychainWrapper.set(text, forKey: "testStringKey") {
                print("save successful")
            } else {
                print("save failed")
            }
        }
    }
   
    @IBAction func clearTapped(_ sender: AnyObject) {
        textfield.text = ""
    }
    
    @IBAction func loadTapped(_ sender: AnyObject) {
        textfield.text = keychainWrapper.string(forKey: "testStringKey")
    }
    
    
    @IBAction func saveTestObject(_ sender: AnyObject) {
        let testObject = TestObject()
        if let text = testObjectStringTextField.text, !text.isEmpty {
            testObject.objectName = text
        }
        
        if let text = testObjectIntTextField.text, let intValue = Int(text), !text.isEmpty {
            testObject.objectRating = intValue
            testObjectIntTextField.text = String(intValue)
        } else {
            // invalid int
            testObjectIntTextField.text = "0"
            testObject.objectRating = 0
        }
        
        if keychainWrapper.set(testObject, forKey: "testObjectKey") {
            print("save successful")
        } else {
            print("save failed")
        }
    }
    
    @IBAction func loadTestObject(_ sender: AnyObject) {
        if let object = keychainWrapper.object(forKey: "testObjectKey") as? TestObject {
            testObjectStringTextField.text = object.objectName
            testObjectIntTextField.text = String(object.objectRating)
        }
    }
 
    @IBAction func clearTestObject(_ sender: AnyObject) {
        testObjectStringTextField.text = ""
        testObjectIntTextField.text = ""
    }
    
}

