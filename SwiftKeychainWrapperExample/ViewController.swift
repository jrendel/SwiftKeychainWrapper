//
//  ViewController.swift
//  SwiftKeychainWrapperExample
//
//  Created by Jason Rendel on 1/27/15.
//
//

import UIKit
import SwiftKeychainWrapper

class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        KeychainWrapper.accessGroup = "group.myAccessGroup"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func saveTapped(sender: AnyObject) {
        if count(textfield.text) > 0 {
            //KeychainWrapper.save
            if KeychainWrapper.setString(textfield.text, forKey: "key") {
                println("save successful")
            } else {
                println("save failed")
            }
        }
    }
   
    @IBAction func clearTapped(sender: AnyObject) {
        textfield.text = ""
    }
    
    @IBAction func loadTapped(sender: AnyObject) {
        textfield.text = KeychainWrapper.stringForKey("key")
    }
    
}

