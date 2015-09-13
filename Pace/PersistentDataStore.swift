//
//  PersistentDataStore.swift
//  Pace
//
//  Created by Tara Wilson on 9/3/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import Foundation


import Foundation


public class PersistentDataStore: NSObject {
    
    var dataStoreQueue:dispatch_queue_t
    
    public class var sharedInstance : PersistentDataStore {
        struct Static {
            static let instance : PersistentDataStore = PersistentDataStore()
        }
        return Static.instance
    }
    
    public override init() {
        self.dataStoreQueue = dispatch_queue_create("com.pace.app-persistent-data-store", DISPATCH_QUEUE_SERIAL);
        super.init()
    }
    
    public func retrieveUser() -> User? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let first = userDefaults.valueForKey("firstname") as? String,
        id = userDefaults.valueForKey("id") as? Int,
        fb = userDefaults.valueForKey("facebook_id") as? String,
        last = userDefaults.valueForKey("lastname") as? String,
        username = userDefaults.valueForKey("username") as? String,
        is_late = userDefaults.valueForKey("is_late") as? Int,
        work = userDefaults.valueForKey("work") as? String,
        education = userDefaults.valueForKey("education") as? String {
            let returnUser = User()
            returnUser.firstname = first
            returnUser.id = id
            returnUser.facebook_id = fb
            returnUser.lastname = last
            returnUser.username = username
            returnUser.paces_hosted = 0
            returnUser.paces_joined = 0
            returnUser.is_late = is_late
            returnUser.work = work
            returnUser.education = education
            return returnUser
        }
        
        return nil
    }
    
    public func saveUser(user:User) {
        println(user)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(user.firstname, forKey: "firstname")
        userDefaults.setObject(user.id, forKey: "id")
        userDefaults.setObject(user.facebook_id, forKey: "facebook_id")
        userDefaults.setObject(user.lastname, forKey: "lastname")
        userDefaults.setObject(user.username, forKey: "username")
        
        if user.is_late == nil {
            userDefaults.setObject(0, forKey: "is_late")
        } else {
            userDefaults.setObject(user.is_late, forKey: "is_late")
        }
        
        userDefaults.setObject(user.work, forKey: "work")
        userDefaults.setObject(user.education, forKey: "education")
    }
    
    public func saveToken(token: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        print(token)
        userDefaults.setObject(token, forKey: "token")
    }
    
    public func getToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let token = userDefaults.valueForKey("token") as? String {
            return token
        }
        return nil
    }
    

    
    
    
    
}