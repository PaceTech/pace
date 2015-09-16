//
//  LoginViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/29/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    var loginButton: FBSDKLoginButton?
    var myloginbutton: UIButton!
    var signupButton: UIButton!
    var backgroundimg: UIImageView!
    var usernametextfield: UITextField!
    var passwordtextfield: UITextField!
    var shouldLoginvar = false
    var shouldseguevar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = UIColor.whiteColor()
        loginButton = FBSDKLoginButton()
        loginButton?.readPermissions = ["public_profile", "email", "user_friends", "user_education_history", "user_work_history"]
        loginButton?.delegate = self
        loginButton?.frame = CGRect(x: 50, y: view.frame.height - 300, width: view.frame.width - 100, height: 50)
        view.addSubview(loginButton!)

        backgroundimg = UIImageView(frame: CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2))
        backgroundimg.image = UIImage(named: "dropdown1")
        view.addSubview(backgroundimg)
        view.sendSubviewToBack(backgroundimg)
        
        let blueview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2 + 20))
        blueview.backgroundColor = darkBlueColor
        view.addSubview(blueview)
        view.sendSubviewToBack(blueview)
        
        myloginbutton = UIButton(frame: CGRect(x: view.frame.width/2 + 20, y: view.frame.height/2 - 50, width: view.frame.width/2 - 40, height: 50))
        myloginbutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myloginbutton.setTitle("Log in", forState: .Normal)
        myloginbutton.addTarget(self, action: "switchtologin", forControlEvents: .TouchUpInside)
        view.addSubview(myloginbutton)
        
        signupButton = UIButton(frame: CGRect(x: 20, y: view.frame.height/2 - 50, width: view.frame.width/2 - 40, height: 50))
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.setTitle("Sign up", forState: .Normal)
        signupButton.addTarget(self, action: "switchtoSingup", forControlEvents: .TouchUpInside)
        view.addSubview(signupButton)
        
        let paceimgview = UIImageView(frame: CGRect(x: 75, y: 100, width: view.frame.width - 150, height: 150))
        paceimgview.image = UIImage(named: "pace")
        paceimgview.contentMode = .ScaleAspectFit
        view.addSubview(paceimgview)
        
        let pacestring = UILabel(frame: CGRect(x: 0, y: 210, width: view.frame.width, height: 100))
        pacestring.text = "Running is social. Pace Connects."
        pacestring.textColor = tealColor
        pacestring.textAlignment = .Center
        view.addSubview(pacestring)
        
        usernametextfield = UITextField(frame: CGRect(x: 50, y: view.frame.height - 180, width: view.frame.width - 60, height: 50))
        usernametextfield.text = "Username"
        usernametextfield.textColor = UIColor.lightGrayColor()
        usernametextfield.delegate = self
        view.addSubview(usernametextfield)
        
        passwordtextfield = UITextField(frame: CGRect(x: 50, y: view.frame.height - 80, width: view.frame.width - 60, height: 50))
        passwordtextfield.textColor = UIColor.lightGrayColor()
        passwordtextfield.text = "Password"
        passwordtextfield.delegate = self
        view.addSubview(passwordtextfield)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 210
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 210
    }
    
    func switchtologin() {
        backgroundimg.image = UIImage(named: "dropdown1")
        view.addSubview(passwordtextfield)
        usernametextfield.text = "Username"
    }
    
    func switchtoSingup() {
        backgroundimg.image = UIImage(named: "dropdown2")
        passwordtextfield.removeFromSuperview()
        usernametextfield.text = "Enter your email"
        view.addSubview(loginButton!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let gobutton = UIButton(frame: CGRect(x: view.frame.width - 70, y: view.frame.height - 70, width: 50, height: 50))
        gobutton.setTitle("Go", forState: .Normal)
        gobutton.setTitleColor(darkBlueColor, forState: .Normal)
        gobutton.addTarget(self, action: "pressGo", forControlEvents: .TouchUpInside)
        view.addSubview(gobutton)
        return true
    }
    
    func pressGo() {
        if shouldLoginvar == true {
            shouldlogin()
        }
        if shouldseguevar == true {
            showcreate()
        }
    }
    
    func showcreate() {
        let vc = CreateUserViewController()
        vc.email = usernametextfield.text
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "Password" {
            textField.text = ""
            shouldLoginvar = true
        }
        if textField.text == "Enter your email" {
            textField.text = ""
            shouldseguevar = true
        }
        textField.text = ""
    }
    
    func shouldlogin() {
        if let email = usernametextfield.text {
            if let password = passwordtextfield.text {
                NetworkController().getToken(email, sentPassword: "password", successHandler: {success in
                    
                    NetworkController().getMe({user in
                        PersistentDataStore.sharedInstance.saveUser(user)
                        AccountController.sharedInstance.currentuser = user
                        self.dismissViewControllerAnimated(true, completion: nil)
                        }, failureHandler: {error in
                            println("COULDN'T LOG IN")
                    })
                    
                    }, failureHandler: {error in
                        println("NOT A USER")
                })
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, education, work"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
                 println(error)           }
            else {
                
                print(result)
                if let photo = result.valueForKey("picture") as? NSDictionary {

                    if let data = photo.valueForKey("data") as? NSDictionary {
                        if let email = result.valueForKey("email") as? String {
                            if let url = data.valueForKey("url") as? String {
                                if let id = result.valueForKey("id") as? String {
                                    if let first = result.valueForKey("first_name") as? String {
                                        if let last = result.valueForKey("last_name") as? String {
                                            
                                            var myeducation = ""
                                            if let education = result.valueForKey("education") as? NSArray {
                                                for school in education {
                                                    if let sch = school as? NSDictionary {
                                                        if sch.valueForKey("type") as! String == "College" {
                                                            if let schoolname = sch.valueForKey("school") as? NSDictionary {
                                                                myeducation = schoolname.valueForKey("name") as! String
                                                                println(myeducation)
                                                            }
                                                        }
                                                        if sch.valueForKey("type") as! String == "Graduate School" {
                                                            if let schoolname = sch.valueForKey("school") as? NSDictionary {
                                                                myeducation = schoolname.valueForKey("name") as! String
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            var mywork = ""
                                            if let work = result.valueForKey("work") as? NSArray {
                                                for job in work {
                                                    if let workjob = job as? NSDictionary {
                                                        if let employer = workjob.valueForKey("employer") as? NSDictionary {
                                                            mywork = employer.valueForKey("name") as! String
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                            var joined = "0"
                                            var hosted = "0"
                                            var isreply = "0"
                                            println(myeducation)
                                            
                                            var dataString = "password=password&username=\(email)&email=\(email)&first_name=\(first)&last_name=\(last)&facebook_id=\(id)&image_url=\(url)&paces_joined=\(joined)&paces_hosted=\(hosted)&work=\(mywork)&education=\(myeducation)&is_late=\(isreply)"
                                            
                                            NetworkController().getToken(email, sentPassword: "password", successHandler: {success in
                                                
                                                NetworkController().getMe({user in
                                                    PersistentDataStore.sharedInstance.saveUser(user)
                                                    AccountController.sharedInstance.currentuser = user
                                                    self.dismissViewControllerAnimated(true, completion: nil)
                                                    }, failureHandler: {error in
                                                })
                                                
                                                }, failureHandler: {error in
                                                    
                                                    NetworkController().createAccount(dataString, successHandler: {user in
                                                        println("try")
                                                        PersistentDataStore.sharedInstance.saveUser(user)
                                                        AccountController.sharedInstance.currentuser = user
                                                        self.dismissViewControllerAnimated(true, completion: nil)
                                                        }, failureHandler: {error in
                                                            println(error)
                                                    })
                                                    
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


    


}
