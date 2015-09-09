//
//  InputViewController.swift
//  Pace
//
//  Created by Tara Wilson on 9/8/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    var pageTitle: String!
    var textfield: UITextField?
    var iswork = false
    var iseducation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)
        
        tabBarController?.navigationController?.navigationBarHidden = false
        
        view.backgroundColor = UIColor.whiteColor()
        let backButton = UIButton(frame: CGRect(x: 10, y: 20, width: 70, height: 50))
        backButton.setTitleColor(tealColor, forState: .Normal)
        backButton.setTitle("Close", forState: .Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 20, width: view.frame.width - 10, height: 50))
        titleLabel.textAlignment = .Center
        titleLabel.text = pageTitle
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 18)
        view.addSubview(titleLabel)
        
        textfield = UITextField(frame: CGRect(x: 10, y: 120, width: view.frame.width - 40, height: 30))
        textfield?.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
        view.addSubview(textfield!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        if let vc = navigationController?.viewControllers[1] as? DetailViewController {
            if iseducation {
                vc.educationstring = textfield?.text
            }
            if iswork {
                vc.workstring = textfield?.text
            }
            navigationController?.popToViewController(vc, animated: true)
        }
        
    }

}
