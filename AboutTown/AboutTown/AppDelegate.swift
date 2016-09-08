//
//  AppDelegate.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/6/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSCognitoIdentityProvider
import AWSMobileAnalytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
        
        let DefaultServiceRegionType = AWSRegionType.USEast1
        
        let serviceConfiguration = AWSServiceConfiguration(
            region: DefaultServiceRegionType,
            credentialsProvider: nil)
        
        // Needed to support account registration
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = serviceConfiguration
        
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: Constants.ClientIdAuth, clientSecret: Constants.ClientSecretAuth, poolId: Constants.PoolId)
 
        AWSCognitoIdentityUserPool.registerCognitoIdentityUserPoolWithConfiguration(serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: Constants.UserPoolName)
        
        let pool = UserSessionManager.getUserPool()
        pool.delegate = self
        
        let analytics = AWSMobileAnalytics(forAppId: Constants.AnalyticsAppId, identityPoolId: Constants.CognitoIdentityPoolId)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: Constants.CognitoIdentityPoolId)
        let cognitoServiceConfig = AWSServiceConfiguration(region: DefaultServiceRegionType, credentialsProvider: credentialsProvider)
        AWSCognito.registerCognitoWithConfiguration(cognitoServiceConfig, forKey: Constants.UserPoolName)
        
        //credentialsProvider.clearCredentials()
        
        UserSessionManager.getInstance().load()
        
        return true
    }
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        
        let loginController = self.window?.rootViewController?.storyboard!.instantiateViewControllerWithIdentifier("loginController")
        self.window?.rootViewController?.showViewController(loginController!, sender: self)
        
        //return loginController;
        return loginController as! AWSCognitoIdentityPasswordAuthentication
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }


}

