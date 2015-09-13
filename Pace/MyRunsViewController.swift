//
//  DetailViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/21/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class MyRunsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var titleText: String?
    var tableView: UITableView  =   UITableView()
    var items: [String] = [String]()
    var paces: [Pace] = [Pace]()
    
    override func viewDidLoad() {
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)
        
        
        view.backgroundColor = UIColor.whiteColor()
        
        let backButton = UIButton(frame: CGRect(x: 10, y: 20, width: 70, height: 50))
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 40, y: 20, width: view.frame.width - 80, height: 40))
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        view.addSubview(titleLabel)
        
        var image = UIImage(named:"placeholder")
        var profImageView = UIImageView(frame: CGRect(x: view.frame.width/2 - 50, y: 100, width: 100, height: 100))
        profImageView.image = image
        profImageView.clipsToBounds = true
        profImageView.layer.cornerRadius = 50
        view.addSubview(profImageView)
        
        if let fbid =  AccountController.sharedInstance.getUser()?.facebook_id {
        profImageView.sd_setImageWithURL(NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=large"))

            
        }

        
        tableView.frame         =   CGRectMake(0, 280, view.frame.width, 400);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        NetworkController().getPaces({paces in
            
            for pace in paces {
                var shoulddrop = false
                let currentDate = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
                
                if let timestring = pace.time as NSString? {
                    let arr = timestring.componentsSeparatedByString("T")
                    let date = arr[0].componentsSeparatedByString("-")
                    let time = arr[1].componentsSeparatedByString(":")
                    if let year = date[0] as? String {
                        var val = year.toInt()
                        if val < components.year {
                            shoulddrop = true
                        } else if val == components.year {
                            if let month = date[1] as? String {
                                var val = month.toInt()
                                if val < components.month {
                                    shoulddrop = true
                                } else if val == components.month {
                                    if let day = date[2] as? String {
                                        var val = day.toInt()
                                        if val < components.day {
                                            shoulddrop = true
                                        } else if val == components.day {
                                            if let hour = time[0] as? String {
                                                if (components.hour - val!) < 12 {
                                                    
                                                }
                                                var val = hour.toInt()
                                                if val < components.hour {
                                                    shoulddrop = true
                                                } else if val == components.hour {
                                                    if let min = time[1] as? String {
                                                        var val = min.toInt()
                                                        if val < components.minute {
                                                            shoulddrop = true
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } }
                    
                                    
                                    if shoulddrop {}
                                    else {
                                        self.items.append("\(pace.time!)")
                                        self.paces.append(pace)
                                        self.tableView.reloadData()
                                    }
                                    
            }
            
            }, failureHandler: {
                error in
                println(error)
                
        })

        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
  

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
            return self.items.count
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell!
            
            cell.textLabel?.text = self.items[indexPath.row]

            return cell

        
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = PaceDetailViewController()
        vc.paceInfo = paces[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)

    }

    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
