//
//  RegistrationViewController.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/6/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider


class RegistrationViewController: UIViewController {
    
    // Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var registrationError:RegistrationErrors!
    var proceed = false
    
    // Event Handlers
    @IBAction func handleCreateAccount(sender: UIButton) {
        
        let emailValue = emailField.text!
        let passwordValue = passwordField.text!
        let confirmPasswordValue = confirmPasswordField.text!
        
        let passwordsMatch = (confirmPasswordValue == passwordValue)
        
        print("create clicked")
        print("emailField is \(emailValue)")
        print("passwordField is \(passwordValue)")
        print("Did passwords match? \(passwordsMatch)")
        
        if (!passwordsMatch) {
            
            showInfoAlert("Passwords do not match", title: "No Text")
         }
        else {
            proceed = true
        }
        
        let cognitoIP = AWSCognitoIdentityProvider.defaultCognitoIdentityProvider()
        let signupRequest = AWSCognitoIdentityProviderSignUpRequest()
        
        /* App credentials */
        signupRequest.clientId = Constants.ClientIdRegistration
        
        signupRequest.username = emailValue
        signupRequest.password = passwordValue
        
        let emailUserAttr = AWSCognitoIdentityUserAttributeType();
        emailUserAttr.name = "email"
        emailUserAttr.value = emailValue;
        
        var userAttributeEntires = [AWSCognitoIdentityUserAttributeType]();
        userAttributeEntires.append(emailUserAttr)
        
        // IMPORTANT - Build the array before this, and then assign instead of manipulating the initial array
        signupRequest.userAttributes = userAttributeEntires
        
        let signupResponse = cognitoIP.signUp(signupRequest)
        
        signupResponse.waitUntilFinished()
        
        // QUESTION - Do we need this check after doing the waitUntilFinsihed() call?
        if (signupResponse.completed) {
            
            let error = signupResponse.error
            //var ex = signupResponse.exception
            let result = signupResponse.result as? AWSCognitoIdentityProviderSignUpResponse
            
            if error != nil {
                
                //let detailedError = error as? AWSCognitoIdentityProviderErrorDomain
                var displayErrorMessage = ""
                
                let errorCode = error!.code
                
                switch errorCode {
                case AWSCognitoIdentityProviderErrorType.InvalidPassword.rawValue:
                    displayErrorMessage = "Your password does not match the expected condition"
                case AWSCognitoIdentityProviderErrorType.UsernameExists.rawValue:
                    displayErrorMessage = "An account exists for the email address you have entered"
                default:
                    displayErrorMessage = "We are unsure of what went wrong"
                }
                
                self.proceed = false;
                showInfoAlert(displayErrorMessage, title: "Alert")
            }
            else {
                
                print("\(result?.userConfirmed)")
                // We should be going to the login screen on success, not into the application
                self.proceed = true;
            }
        }
        
    }
    
    private func showInfoAlert(message: String, title: String!) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {

        print("we are segueing to \(identifier)")
        return self.proceed;
    }
}

enum RegistrationErrors: ErrorType {
    case GeneralError
}
