//
//  LoginViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/29/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var loginButton = FBSDKLoginButton()
        loginButton.frame = CGRect(x: 60, y: view.frame.height - 80, width: view.frame.width - 120, height: 50)
        view.addSubview(loginButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
