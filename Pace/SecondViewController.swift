//
//  SecondViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/8/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

let backgroundgray = UIColor(red: 245/265, green: 245/265, blue: 245/265, alpha: 1)

class SecondViewController: GAITrackedViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var scrollViewpace: UIScrollView!
    var containerViewpace: UIView!
    
    var scrollViewdist: UIScrollView!
    var containerViewdist: UIView!
    
    var pacesegmentedControl : UISegmentedControl!
    var distancesegmentedControl : UISegmentedControl!
    
    let distanceitems = ["6", "6:30", "7", "7:30", "8", "8:30", "9", "9:30", "10", "10:30", "11+"]
    let paceitems = ["3", "4", "5", "6", "7", "8", "9", "10", "11 - 15", "15+"]
    var location : CLLocationCoordinate2D?
    
    
    var congratsImg : UIImageView?
    var myTimer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundgray

        tabBarController?.tabBar.hidden = false
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "Host a pace!"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: "Oswald-Regular", size: 20)
        
        selectButton.titleLabel?.numberOfLines = 0
        selectButton.titleLabel?.lineBreakMode = .ByWordWrapping
        
        headerView.addSubview(titleButton)
        view.addSubview(headerView)
        
        self.scrollViewpace = UIScrollView()
        self.scrollViewpace.delegate = self
        self.scrollViewpace.contentSize = CGSizeMake(860, 30)
        containerViewpace = UIView()
        scrollViewpace.addSubview(containerViewpace)
        view.addSubview(scrollViewpace)
        
        self.scrollViewdist = UIScrollView()
        self.scrollViewdist.delegate = self
        self.scrollViewdist.contentSize = CGSizeMake(860, 30)
        containerViewdist = UIView()
        scrollViewdist.addSubview(containerViewdist)
        view.addSubview(scrollViewdist)
        
        distancesegmentedControl = UISegmentedControl(items: distanceitems)
        distancesegmentedControl.selectedSegmentIndex = 2
        distancesegmentedControl.frame =  CGRect(x: 0, y: 0, width: 600, height: 30)
        distancesegmentedControl.backgroundColor = UIColor.whiteColor()
        distancesegmentedControl.tintColor = tealColor
        containerViewdist.addSubview(distancesegmentedControl)
        
        pacesegmentedControl = UISegmentedControl(items: paceitems)
        pacesegmentedControl.selectedSegmentIndex = 2
        pacesegmentedControl.frame =  CGRect(x: 0, y: 0, width: 600, height: 30)
        pacesegmentedControl.backgroundColor = UIColor.whiteColor()
        pacesegmentedControl.tintColor = tealColor
        containerViewpace.addSubview(pacesegmentedControl)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 440, width: view.frame.width, height: 50))
        view1.backgroundColor = UIColor.whiteColor()
        view.addSubview(view1)
        view.sendSubviewToBack(view1)
        
        let view2 = UIView(frame: CGRect(x: 0, y: 520, width: view.frame.width, height: 50))
        view2.backgroundColor = UIColor.whiteColor()
        view.addSubview(view2)
        view.sendSubviewToBack(view2)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollViewpace.frame = CGRectMake(10, 450, 600, 30)
        scrollViewpace.backgroundColor = UIColor.whiteColor()
        containerViewpace.frame = CGRectMake(0, 0, scrollViewpace.contentSize.width, 30)
        
        scrollViewdist.frame = CGRectMake(10, 530, 600, 30)
        scrollViewdist.backgroundColor = UIColor.whiteColor()
        containerViewdist.frame = CGRectMake(0, 0, scrollViewdist.contentSize.width, 30)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.screenName = "PaceHostView"
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    @IBAction func goToMapPicker(sender: UIButton) {
        let vc = SelectHostLocation()
        navigationController?.showViewController(vc, sender: self)
    }
    
    @IBAction func createPace(sender: UIButton) {
        if AccountController.sharedInstance.getUser() != nil {
            

        let myPace = Pace()
        myPace.distance = distanceitems[distancesegmentedControl.selectedSegmentIndex]
        myPace.pace = paceitems[pacesegmentedControl.selectedSegmentIndex]
        myPace.location = location
        
        var dateFormatter = NSDateFormatter()
        var dateFormatter2 = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "HH:mm:ss"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        var strTime = dateFormatter2.stringFromDate(datePicker.date)
        myPace.time = "\(strDate)T\(strTime)"
        
        
        if let lat = myPace.location?.latitude {
            if let lon = myPace.location?.longitude {
                if let distance = myPace.distance {
                    if let pacespeed = myPace.pace {
                        if let time = myPace.time {
                            if let userid = AccountController.sharedInstance.getUser()!.id {
                                var dataString = "latitute=\(lat)&longitude=\(lon)&distance=\(distance)&pace=\(pacespeed)&runtime=\(time)&owner=\(userid)&participants=\(userid)"
                                
                                NetworkController().createPace(dataString, successHandler: {boolvar in
                                    print("worked")
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.congratsImg = UIImageView(frame: self.view.frame)
                                        let image = UIImage(named: "hostedcongrats")
                                        self.congratsImg?.image = image
                                        self.view.addSubview(self.congratsImg!)
                                        self.view.bringSubviewToFront(self.congratsImg!)
                                        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("myPerformeCode:"), userInfo: nil, repeats: false)
                                        
                                        let navVC = self.tabBarController?.viewControllers?.first as? UINavigationController
                                        let vc = navVC?.viewControllers[0] as? FirstViewController
                                        vc!.newPace = myPace
                                        
                                    })
                                    }, failureHandler: {error in
                                        print("didn't work")
                                        self.tabBarController?.selectedIndex = 0
                                })
                            }
                        }
                    }
                }
            }
        }

        } else {
            let loginVC = LoginViewController()
            navigationController?.presentViewController(loginVC, animated: true, completion: nil)
        }
    
    }

    func myPerformeCode(timer : NSTimer) {
        tabBarController?.selectedIndex = 0
        self.myTimer = nil
        congratsImg?.image = nil
        self.view.sendSubviewToBack(self.congratsImg!)
    }
    



}

