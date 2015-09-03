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
    
    var congratsImg : UIImageView?
    var myTimer : NSTimer?
    
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
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    @IBAction func goToMapPicker(sender: UIButton) {
        let vc = SelectHostLocation()
        navigationController?.showViewController(vc, sender: self)
    }
    
    @IBAction func createPace(sender: UIButton) {
        if AccountController.sharedInstance.currentuser != nil {
            

        let myPace = Pace()
        myPace.distance = String(distance[distancePicker.selectedSegmentIndex])
        myPace.pace = "\(pace[pacePicker.selectedSegmentIndex])"
        myPace.location = location
        
        var dateFormatter = NSDateFormatter()
        var dateFormatter2 = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "HH:mm:ss"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        var strTime = dateFormatter2.stringFromDate(datePicker.date)
        myPace.time = "\(strDate)T\(strTime)"
        
        let navVC = tabBarController?.viewControllers?.first as? UINavigationController
        let vc = navVC?.viewControllers[0] as? FirstViewController
        vc!.newPace = myPace
        
        if let lat = myPace.location?.latitude {
            if let lon = myPace.location?.longitude {
                if let distance = myPace.distance {
                    if let pacespeed = myPace.pace {
                        if let time = myPace.time {
                            if let userid = AccountController.sharedInstance.currentuser?.id {
                                var dataString = "latitute=\(lat)&longitude=\(lon)&distance=\(distance)&pace=\(pacespeed)&runtime=\(time)&owner=\(userid)&participants=\(userid)"
                                
                                NetworkController().createPace(dataString, successHandler: {boolvar in
                                    print("worked")
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.congratsImg = UIImageView(frame: self.view.frame)
                                        let image = UIImage(named: "congrats")
                                        self.congratsImg?.image = image
                                        self.view.addSubview(self.congratsImg!)
                                        self.view.bringSubviewToFront(self.congratsImg!)
                                        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("myPerformeCode:"), userInfo: nil, repeats: false)
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
    //
    //        if let lat = myPace.location?.latitude, lon = myPace.location?.longitude, distance = myPace.distance, pacespeed = myPace.pace, time = myPace.time, userid = AccountController.sharedInstance.currentuser?.id {
            
            
                
            
    //        }
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

