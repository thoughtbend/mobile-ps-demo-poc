//
//  FirstViewController.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/6/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider
import AWSMobileAnalytics

class FirstViewController: UIViewController {

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
            print("signout should have completed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let pool = AWSCognitoIdentityUserPool(forKey: Constants.UserPoolName)
        let userSessionManager = UserSessionManager.getInstance()
        let lastKnownUser = userSessionManager.getLastKnownLogin()
        
        // TODO - this can'be hard-coded
        let user = (lastKnownUser != nil) ? pool.getUser(lastKnownUser!) : pool.getUser()
        
        if (!user.signedIn) {
            user.getSession()
        }
        else {
            print("username is \(user.username)")
            let userDetailsTask = user.getDetails()
            userDetailsTask.waitUntilFinished()
            let userDetails = userDetailsTask.result as! AWSCognitoIdentityUserGetDetailsResponse;
            print("user details \(userDetails)")
            let email = userDetails.userAttributes![2]
            print("email is \(email.value)")
        }
        
        //let eventClient = AWSMobileAnalytics.defaultMobileAnalytics().eventClient
        let eventClient = AWSMobileAnalytics(forAppId: Constants.AnalyticsAppId, identityPoolId: Constants.CognitoIdentityPoolId).eventClient
        let formViewEvent = eventClient.createEventWithEventType("formViewEvent")
        formViewEvent.addAttribute("pageName", forKey: "First View")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}