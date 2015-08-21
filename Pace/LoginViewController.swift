//
//  LoginViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/29/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    var loginButton: FBSDKLoginButton?
    
    @IBOutlet weak var idText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton = FBSDKLoginButton()
        loginButton?.readPermissions = ["public_profile", "email"]
        loginButton?.delegate = self
        loginButton?.frame = CGRect(x: 60, y: view.frame.height - 80, width: view.frame.width - 120, height: 50)
        view.addSubview(loginButton!)
        idText.layer.borderColor = UIColor.redColor().CGColor
        idText.layer.borderWidth = 3.0

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        AccountController.sharedInstance.userID = idText.text
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
