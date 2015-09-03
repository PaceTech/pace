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
        loginButton?.frame = CGRect(x: 60, y: view.frame.height - 480, width: view.frame.width - 120, height: 50)
        view.addSubview(loginButton!)

        let signinButton = UIButton(frame: CGRect(x: 100, y: view.frame.height - 260, width: view.frame.width - 200, height: 50))
        signinButton.backgroundColor = tealColor
        signinButton.setTitle("Sign In", forState: .Normal)
        signinButton.addTarget(self, action: "signIn", forControlEvents: .TouchUpInside)
        view.addSubview(signinButton)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        AccountController.sharedInstance.userID = idText.text
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        

        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
                            }
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
                                                
                                                AccountController.sharedInstance.currentuser = user
                                                self.dismissViewControllerAnimated(true, completion: nil)
//                                                self.performSegueWithIdentifier("loginSegue", sender: self)
                                                }, failureHandler: {error in
                                            })
                                            
                                        }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
//                
//                if let email = result.valueForKey("email") as? String, let url =  data.valueForKey("url") as? String, let id =  result.valueForKey("id") as? String, first = result.valueForKey("first_name") as? String, last = result.valueForKey("last_name") as? String {
                    
                    
//                }


            }
        })
        
       
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }

    func signIn() {
        NetworkController().getUser(17, successHandler: {user in
            AccountController.sharedInstance.currentuser = user
            self.dismissViewControllerAnimated(true, completion: nil)
//            self.performSegueWithIdentifier("loginSegue", sender: self)
            }, failureHandler: {error in
        })
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
