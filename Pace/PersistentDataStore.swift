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
        if let myuser = userDefaults.valueForKey("user") as? User
        {
            return myuser
        }
        
        return nil
    }
    
    
    public func saveUser(user:User) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(user, forKey: "user")

    }
    

    
    
    
    
}