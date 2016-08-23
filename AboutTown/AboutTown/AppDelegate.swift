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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
        
        let CognitoRegionType = AWSRegionType.USWest2
        let CognitoIdentityPoolId = Constants.CognitoIdentityPoolId
        let DefaultServiceRegionType = AWSRegionType.USWest2
        
        let configuration = AWSServiceConfiguration(
            region: DefaultServiceRegionType,
            credentialsProvider: nil)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        let serviceConfiguration = AWSServiceManager.defaultServiceManager().defaultServiceConfiguration
        
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: Constants.ClientIdAuth, clientSecret: Constants.ClientSecretAuth, poolId: Constants.PoolId)
        
        let poolKey = Constants.UserPoolName
        AWSCognitoIdentityUserPool.registerCognitoIdentityUserPoolWithConfiguration(serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: poolKey)
        let pool = AWSCognitoIdentityUserPool(forKey: poolKey)
        
        pool.delegate = self
        
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: CognitoRegionType,
            identityPoolId: CognitoIdentityPoolId,
            identityProviderManager: pool)
        
        print("\(credentialsProvider.identityId)")
        
        // Requesting access to push notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true
    }
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        
        let loginController = self.window?.rootViewController?.storyboard!.instantiateViewControllerWithIdentifier("loginController")
        self.window?.rootViewController?.presentViewController(loginController!, animated: true, completion: nil)
        
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
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("DeviceToken = \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print(notification)
    }

}

