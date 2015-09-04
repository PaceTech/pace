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
        image = userDefaults.valueForKey("imageurl") as? String {
            let returnUser = User()
            returnUser.firstname = first
            returnUser.id = id
            returnUser.facebook_id = fb
            returnUser.lastname = last
            returnUser.username = username
            returnUser.imageurl = image
            return returnUser
        }
        
        return nil
    }
    
    public func saveUser(user:User) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(user.firstname, forKey: "firstname")
        userDefaults.setObject(user.id, forKey: "id")
        userDefaults.setObject(user.facebook_id, forKey: "facebook_id")
        userDefaults.setObject(user.lastname, forKey: "lastname")
        userDefaults.setObject(user.username, forKey: "username")
        userDefaults.setObject(user.imageurl, forKey: "imageurl")
    }
    
    public func saveToken(token: Int) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(token, forKey: "token")
    }
    
    public func getToken() -> Int? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let token = userDefaults.valueForKey("token") as? Int {
            return token
        }
        return nil
    }
    

    
    
    
    
}