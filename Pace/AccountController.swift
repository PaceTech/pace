//
//  AccountController.swift
//  Pace
//
//  Created by Tara Wilson on 8/10/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class AccountController: NSObject {
    
    private var currentuser : User?
    
    class var sharedInstance: AccountController {
        struct Static {
            static var instance: AccountController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AccountController()
        }
        
        return Static.instance!
    }
    
    public func getUser() -> User? {
        return PersistentDataStore.sharedInstance.retrieveUser()
    }
    
}
