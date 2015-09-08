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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        loginButton = FBSDKLoginButton()
        loginButton?.readPermissions = ["public_profile", "email"]
        loginButton?.delegate = self
        loginButton?.frame = CGRect(x: 50, y: view.frame.height - 260, width: view.frame.width - 100, height: 50)
        view.addSubview(loginButton!)

        let blueview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        blueview.backgroundColor = darkBlueColor
        view.addSubview(blueview)
        
        let paceimgview = UIImageView(frame: CGRect(x: 75, y: 100, width: view.frame.width - 150, height: 150))
        paceimgview.image = UIImage(named: "pace")
        paceimgview.contentMode = .ScaleAspectFit
        view.addSubview(paceimgview)
        
        let pacestring = UILabel(frame: CGRect(x: 0, y: 250, width: view.frame.width, height: 100))
        pacestring.text = "Running is social. Pace Connects."
        pacestring.textColor = tealColor
        pacestring.textAlignment = .Center
        view.addSubview(pacestring)
        
//        let signinButton = UIButton(frame: CGRect(x: 50, y: view.frame.height - 260, width: view.frame.width - 100, height: 50))
//        signinButton.backgroundColor = tealColor
//        signinButton.setTitle("Sign In", forState: .Normal)
//        signinButton.addTarget(self, action: "signIn", forControlEvents: .TouchUpInside)
//        view.addSubview(signinButton)
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        

        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
                 println(error)           }
            else {
                if let photo = result.valueForKey("picture") as? NSDictionary {

                    if let data = photo.valueForKey("data") as? NSDictionary {
                        if let email = result.valueForKey("email") as? String {
                            if let url = data.valueForKey("url") as? String {
                                if let id = result.valueForKey("id") as? String {
                                    if let first = result.valueForKey("first_name") as? String {
                                        if let last = result.valueForKey("last_name") as? String {
                                            
                                            var dataString = "password=password&username=\(email)&email=\(email)&first_name=\(first)&last_name=\(last)&facebook_id=\(id)&image_url=\(url)"
                                            
                                            NetworkController().createAccount(dataString, successHandler: {user in
                                                println("try")
                                                PersistentDataStore.sharedInstance.saveUser(user)
                                                AccountController.sharedInstance.currentuser = user
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                                }, failureHandler: {error in
                                                    println(error)
                                            })
                                            
                                        }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }


            }
        })
        
       
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }

    func signIn() {
        NetworkController().getUser(1, successHandler: {user in
            PersistentDataStore.sharedInstance.saveUser(user)
            AccountController.sharedInstance.currentuser = user
            self.dismissViewControllerAnimated(true, completion: nil)
            }, failureHandler: {error in
        })
    }
    


}
