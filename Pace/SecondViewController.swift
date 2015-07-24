//
//  SecondViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/8/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

class SecondViewController: UIViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pacePicker: UISegmentedControl!
    @IBOutlet weak var distancePicker: UISegmentedControl!
    
    let distance = [3, 4, 5, 6, 7]
    let pace = [7.5, 8, 8.5, 9, 9.5]
    var location : CLLocationCoordinate2D?
    
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
    
    override func viewDidAppear(animated: Bool) {
        println(location)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    @IBAction func goToMapPicker(sender: UIButton) {
        let vc = SelectHostLocation()
        navigationController?.showViewController(vc, sender: self)
    }
    
    @IBAction func createPace(sender: UIButton) {
        let myPace = Pace()
        myPace.distance = distance[distancePicker.selectedSegmentIndex]
        myPace.pace = pace[pacePicker.selectedSegmentIndex]
        myPace.location = location
        let vc = tabBarController?.viewControllers?.first as! FirstViewController
        vc.newPace = myPace
        tabBarController?.selectedIndex = 0
    }


}

