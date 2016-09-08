//
//  UserSessionManager.swift
//  AboutTown
//
//  Created by Mike Nolan on 8/26/16.
//  Copyright © 2016 Thoughtbend. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class UserSessionManager {
    
    static let singletonInstance = UserSessionManager()
    
    var userData: UserData? = nil
    var userPool = AWSCognitoIdentityUserPool(forKey: Constants.UserPoolName)
    var credentialsProvider: AWSCognitoCredentialsProvider? = nil
    
    private init() {
        
    }
    
    static func getInstance() -> UserSessionManager {
    
        return singletonInstance
    }
    
    static func getUserPool() -> AWSCognitoIdentityUserPool {
        return UserSessionManager.getInstance().userPool
    }
    
    static func getCredentialsProvider() -> AWSCognitoCredentialsProvider {

        return (singletonInstance.credentialsProvider == nil) ?
            AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: Constants.CognitoIdentityPoolId/*, identityProviderManager: singletonInstance.userPool*/) :
            singletonInstance.credentialsProvider!
    }
    
    func getLastKnownLogin() -> String? {
        return userData?.lastKnownLogin
    }
    
    func setLastKnownLogin(login: String) {
        self.userData?.lastKnownLogin = login
    }
    
    func clearLastKnownLogin() {
        self.userData?.lastKnownLogin = nil
    }
    
    func load() {
        self.userData = NSKeyedUnarchiver.unarchiveObjectWithFile(UserData.ArchiveURL.path!) as? UserData
        if self.userData == nil {
            self.userData = UserData(lastKnownLogin: nil)
            self.store()
        }
    }
    
    func store() {
        if self.userData != nil {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.userData!, toFile: UserData.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save last known login")
            }
        }
    }
}

class UserData: NSObject, NSCoding {
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("lastKnownLogin")
    
    var lastKnownLogin: String? = nil
    
    init(lastKnownLogin: String?) {
        self.lastKnownLogin = lastKnownLogin
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let lastKnownLoginValue = aDecoder.decodeObjectForKey("lastKnownLogin") as? String;
        self.init(lastKnownLogin: lastKnownLoginValue)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lastKnownLogin, forKey: "lastKnownLogin")
    }
}