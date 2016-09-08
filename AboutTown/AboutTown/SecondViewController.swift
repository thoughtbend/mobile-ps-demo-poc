//
//  SecondViewController.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/6/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider
import AWSMobileAnalytics

class SecondViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBAction func handleAccountSave(sender: UIButton) {
        
        let pool = UserSessionManager.getUserPool()
        let cognitoClient = AWSCognito(forKey: Constants.UserPoolName)
        let userProfileDataset = cognitoClient.openOrCreateDataset("userProfile")
        
        let user = pool.getUser(UserSessionManager.getInstance().getLastKnownLogin()!)
        let userDetailsTask = user.getDetails()
        userDetailsTask.waitUntilFinished()
        
        let userDetails = userDetailsTask.result! as? AWSCognitoIdentityUserGetDetailsResponse
        
        let firstNameValue = firstNameField.text!
        let lastNameValue = lastNameField.text!
        
        userProfileDataset.setString(firstNameValue, forKey: "firstName")
        userProfileDataset.setString(lastNameValue, forKey: "lastName")
        
        let syncUserProfileDatasetTask = userProfileDataset.synchronize()
        syncUserProfileDatasetTask.continueWithSuccessBlock { (task: AWSTask) -> AnyObject? in
            
            self.showInfoAlert("Completed data sync", title: "Alert")
            return nil
        }
    }
    
    @IBAction func handleLogout(sender: UIButton) {
        
        let pool = AWSCognitoIdentityUserPool(forKey: Constants.UserPoolName)
        
        // TODO - this can't be hard-coded
        let userSessionManager = UserSessionManager.getInstance()
        let lastKnownLogin = userSessionManager.getLastKnownLogin()
        if lastKnownLogin != nil {
            let user = pool.getUser(lastKnownLogin!)
            user.signOutAndClearLastKnownUser()
            userSessionManager.clearLastKnownLogin()
            userSessionManager.store()
            
            // Doing this to force the UI to redisplay the login screen
            user.getSession()
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: Constants.CognitoIdentityPoolId, identityProviderManager: UserSessionManager.getUserPool())
            
            credentialsProvider.clearCredentials()
            
            print("signout should have completed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let eventClient = AWSMobileAnalytics(forAppId: Constants.AnalyticsAppId, identityPoolId: Constants.CognitoIdentityPoolId).eventClient
        
        let formViewEvent = eventClient.createEventWithEventType("formViewEvent")
        formViewEvent.addAttribute("pageName", forKey: "Second View")
        eventClient.recordEvent(formViewEvent)
        
        let cognitoClient = AWSCognito(forKey: Constants.UserPoolName)
        let userProfileDataset = cognitoClient.openOrCreateDataset("userProfile")
        userProfileDataset.synchronize().waitUntilFinished()
        
        let firstNameValue = userProfileDataset.stringForKey("firstName")
        let lastNameValue = userProfileDataset.stringForKey("lastName")
        
        if firstNameValue != nil {
            self.firstNameField.text = firstNameValue
        }
        
        if lastNameValue != nil {
            self.lastNameField.text = lastNameValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func showInfoAlert(message: String, title: String!) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

