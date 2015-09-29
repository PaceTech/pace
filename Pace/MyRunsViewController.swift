//
//  DetailViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/21/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class MyRunsViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var titleText: String?
    var tableView: UITableView  =   UITableView()
    var items: [String] = [String]()
    var paces: [Pace] = [Pace]()
    
    override func viewDidLoad() {
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)
        
        
        view.backgroundColor = UIColor.whiteColor()
        
        let backButton = UIButton(frame: CGRect(x: 15, y: 20, width: 20, height: 50))
        backButton.setTitleColor(tealColor, forState: .Normal)
        backButton.setTitle("<", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Oswald-Bold", size: 25)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 40, y: 25, width: view.frame.width - 80, height: 40))
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Oswald-Regular", size: 20)
        view.addSubview(titleLabel)

        
        tableView.frame         =   CGRectMake(0, 100, view.frame.width, view.frame.height - 100);
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
                
                var startstring = "Attending a"
                
                if let id = AccountController.sharedInstance.getUser()?.id {
                    if pace.owner == "\(id)" {
                        startstring = "Hosting a"
                    }
                }
                
                
                var date = []
                var time = []
                if let timestring = pace.time as NSString? {
                    let arr = timestring.componentsSeparatedByString("T")
                    date = arr[0].componentsSeparatedByString("-")
                    time = arr[1].componentsSeparatedByString(":")
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
                if let runners = pace.participants {
                    for runner in runners {
                        if "\(runner)" == "18" {
                            shoulddrop = true
                        }
                    }
                }
                
                
                                    if shoulddrop {}
                                    else {
                                     
                                        
                                        self.items.append("\(startstring) run on \(date[1])/\(date[2]) at \(time[0]):\(time[1])")
                                        self.paces.append(pace)
                                        self.tableView.reloadData()
                                    }
                                    
            }
            
            }, failureHandler: {
                error in
                println(error)
                
        })

        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.screenName = "MyRunsView"
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
        vc.ismycurrentrundetail = true
        navigationController?.pushViewController(vc, animated: true)

    }

    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
