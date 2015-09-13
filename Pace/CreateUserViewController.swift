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
        
        usernametextfield = UITextField(frame: CGRect(x: 50, y: view.frame.height/2 + 40, width: view.frame.width - 60, height: 50))
        usernametextfield.text = email
        usernametextfield.textColor = UIColor.blackColor()
        usernametextfield.delegate = self
        view.addSubview(usernametextfield)
        
        passwordtextfield = UITextField(frame: CGRect(x: 40, y: view.frame.height - 90, width: view.frame.width - 80, height: 50))
        passwordtextfield.textColor = UIColor.lightGrayColor()
        passwordtextfield.text = "   Password"
        passwordtextfield.delegate = self
        passwordtextfield.layer.borderWidth = 2
        passwordtextfield.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(passwordtextfield)
        
        firstnametext = UITextField(frame: CGRect(x: 40, y: view.frame.height - 200, width: view.frame.width/2 - 80, height: 50))
        firstnametext.textColor = UIColor.lightGrayColor()
        firstnametext.text = "  First Name"
        firstnametext.delegate = self
        firstnametext.layer.borderWidth = 2
        firstnametext.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.addSubview(firstnametext)
        
        lastnametext = UITextField(frame: CGRect(x: view.frame.width/2 + 40, y: view.frame.height - 200, width: view.frame.width/2 - 80, height: 50))
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
