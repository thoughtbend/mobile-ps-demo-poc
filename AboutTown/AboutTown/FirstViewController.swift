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

class FirstViewController: UIViewController {

    @IBAction func handleLogout(sender: UIButton) {
    
        let pool = AWSCognitoIdentityUserPool(forKey: Constants.UserPoolName)
        
        // TODO - this can't be hard-coded
        let user = pool.getUser(UserRecord.lastKnownUser)
        user.signOutAndClearLastKnownUser()
        
        // Doing this to force the UI to redisplay the login screen
        user.getDetails()
        print("signout should have completed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let pool = AWSCognitoIdentityUserPool(forKey: Constants.UserPoolName)
        
        // TODO - this can'be hard-coded
        let user = pool.getUser(UserRecord.lastKnownUser)
        
        if (!user.signedIn) {
            user.getSession()
        }
        else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}