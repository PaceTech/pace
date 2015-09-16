//
//  CreateUserViewController.swift
//  Pace
//
//  Created by Tara Wilson on 9/12/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, UITextFieldDelegate {
    
    var email: String?
    var usernametextfield: UITextField!
    var passwordtextfield: UITextField!
    var firstnametext: UITextField!
    var lastnametext: UITextField!
    var worktext: UITextField!
    var educationtext: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)
        
        let backButton = UIButton(frame: CGRect(x: 10, y: 20, width: 70, height: 50))
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 40, y: 20, width: view.frame.width - 80, height: 40))
        titleLabel.text = "Sign Up"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        view.addSubview(titleLabel)
        
        let topImage = UIImageView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height/2))
        topImage.image = UIImage(named: "topofpace")
        view.addSubview(topImage)
        
        usernametextfield = UITextField(frame: CGRect(x: 40, y: view.frame.height/2 + 20, width: view.frame.width - 60, height: 50))
        usernametextfield.text = email
        usernametextfield.textColor = UIColor.blackColor()
        usernametextfield.delegate = self
        view.addSubview(usernametextfield)
        
        worktext = UITextField(frame: CGRect(x: 40, y: view.frame.height - 100, width: view.frame.width/2 - 50, height: 50))
        worktext.textColor = UIColor.lightGrayColor()
        worktext.text = "   Work"
        worktext.delegate = self
        worktext.layer.borderWidth = 2
        worktext.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(worktext)
        
        educationtext = UITextField(frame: CGRect(x: view.frame.width/2 + 20, y: view.frame.height - 100, width: view.frame.width/2 - 50, height: 50))
        educationtext.textColor = UIColor.lightGrayColor()
        educationtext.text = "   Education"
        educationtext.delegate = self
        educationtext.layer.borderWidth = 2
        educationtext.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(educationtext)
        
        passwordtextfield = UITextField(frame: CGRect(x: 40, y: view.frame.height - 175, width: view.frame.width - 80, height: 50))
        passwordtextfield.textColor = UIColor.lightGrayColor()
        passwordtextfield.text = "   Password"
        passwordtextfield.delegate = self
        passwordtextfield.layer.borderWidth = 2
        passwordtextfield.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(passwordtextfield)
        
        firstnametext = UITextField(frame: CGRect(x: 40, y: view.frame.height - 250, width: view.frame.width/2 - 50, height: 50))
        firstnametext.textColor = UIColor.lightGrayColor()
        firstnametext.text = "  First Name"
        firstnametext.delegate = self
        firstnametext.layer.borderWidth = 2
        firstnametext.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(firstnametext)
        
        lastnametext = UITextField(frame: CGRect(x: view.frame.width/2 + 20, y: view.frame.height - 250, width: view.frame.width/2 - 50, height: 50))
        lastnametext.textColor = UIColor.lightGrayColor()
        lastnametext.text = "  Last Name"
        lastnametext.delegate = self
        lastnametext.layer.borderWidth = 2
        lastnametext.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(lastnametext)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let gobutton = UIButton(frame: CGRect(x: view.frame.width - 50, y: view.frame.height - 50, width: 50, height: 50))
        gobutton.setTitle("Go", forState: .Normal)
        gobutton.setTitleColor(darkBlueColor, forState: .Normal)
        gobutton.addTarget(self, action: "pressGo", forControlEvents: .TouchUpInside)
        view.addSubview(gobutton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func pressGo() {
      
            
      
                if let email = email {
                    let url = ""
                    
                    
                            if let first = firstnametext.text {
                                if let last = lastnametext.text {
                                    if let password = passwordtextfield.text {
                                    
                                    var id = -1
                                    var joined = "0"
                                    var hosted = "0"
                                    var isreply = "0"
                                    var work = "Work"
                                    var education = "Education"
                                    
                                    var dataString = "password=\(password)&username=\(email)&email=\(email)&first_name=\(first)&last_name=\(last)&facebook_id=\(id)&image_url=\(url)&paces_joined=\(joined)&paces_hosted=\(hosted)&work=\(work)&education=\(education)&is_late=\(isreply)"
                                    
                                    
                                    
                                            
                                            NetworkController().createAccount(dataString, successHandler: {user in
                                                println("didn't fail step one")
                                                
                                                
                                                NetworkController().getToken(email, sentPassword: "password", successHandler: {success in
                                                    
                                                    NetworkController().getMe({user in
                                                        PersistentDataStore.sharedInstance.saveUser(user)
                                                        AccountController.sharedInstance.currentuser = user
                                                        self.dismissViewControllerAnimated(true, completion: nil)
                                                        }, failureHandler: {error in
                                                    })

                                                }, failureHandler: {error in
                                                    println(error)
                                                })
                                                
                                                }, failureHandler: {error in
                                                    println(error)
                                            })
                                    }
                                }
                    }
        }
             

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}
