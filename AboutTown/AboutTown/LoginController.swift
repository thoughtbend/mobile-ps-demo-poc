//
//  LoginController.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/10/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class LoginController: UIViewController, AWSCognitoIdentityPasswordAuthentication {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var loginSuccess = false
    var passwordAuthenticationCompletionSource = AWSTaskCompletionSource();
    
    @IBAction func handleLoginSubmit(sender: UIButton) {
        
        let emailValue = self.emailField.text!
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: emailValue, password: self.passwordField.text!)
        
        self.passwordAuthenticationCompletionSource.setResult(authDetails)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        var proceed = false
        
        if (identifier == "loginSuccessSegue") {
            proceed = self.loginSuccess
        }
        else {
            proceed = true
        }
        
        return proceed;
    }
    
    //This code goes in your Login UI
    func getPasswordAuthenticationDetails(authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource) {
        
        // Assigning the completion source so we can set the credentials when the form is submitted
        self.passwordAuthenticationCompletionSource = passwordAuthenticationCompletionSource
    }
     
    func didCompletePasswordAuthenticationStepWithError(error: NSError?) {
    
        dispatch_async(dispatch_get_main_queue()) {
            if (error != nil) {
                self.showInfoAlert("Authentication Failed", title: "Info")
            }
            else {
                
                self.loginSuccess = true
                self.dismissViewControllerAnimated(true, completion: {
                    
                    let mainTabNavView = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabNav")
                    self.presentViewController(mainTabNavView!, animated: true, completion: nil)
                })
            }
        }
    }
    
    private func showInfoAlert(message: String, title: String!) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
