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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func saveTapped(sender: AnyObject) {
        if countElements(textfield.text) > 0 {
            //KeychainWrapper.save
            KeychainWrapper.setString(textfield.text, forKey: "key")
        }
    }
   
    @IBAction func clearTapped(sender: AnyObject) {
        textfield.text = ""
    }
    
    @IBAction func loadTapped(sender: AnyObject) {
        textfield.text = KeychainWrapper.stringForKey("key")
    }
    
}

