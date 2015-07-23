//
//  SecondViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/8/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pacePicker: UISegmentedControl!
    @IBOutlet weak var distancePicker: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.hidden = false
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 60))
        headerView.backgroundColor = darkBlueColor
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "Host a pace!"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: titleButton.font.fontName, size: 14)
        
        selectButton.titleLabel?.numberOfLines = 0
        selectButton.titleLabel?.lineBreakMode = .ByWordWrapping
        
        headerView.addSubview(titleButton)
        view.addSubview(headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    @IBAction func goToMapPicker(sender: UIButton) {
        let vc = SelectHostLocation()
        navigationController?.showViewController(vc, sender: self)
    }
    
    @IBAction func createPace(sender: UIButton) {
        println(pacePicker.selectedSegmentIndex)
        tabBarController?.selectedIndex = 0
    }


}

