//
//  RegistrationViewController.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/6/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    // Event Handlers
    @IBAction func handleCreateAccount(sender: UIButton) {
        
        print("create clicked")
        print("emailField is \(emailField.text!)")
        print("passwordField is \(passwordField.text!)")
    }
    
    // Common Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("preparing segue")
        
        /*if (emailField.text != nil && emailField.text.isEmpty) {
            let alert = UIAlertView()
            alert.title = "No Text"
            alert.message = "Please Enter Text In The Box"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }*/
    }
}
