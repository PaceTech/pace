//
//  PaceDetailViewController.swift
//  Pace
//
//  Created by Tara Wilson on 8/10/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class PaceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var paceInfo : Pace?
    var tableView: UITableView  =   UITableView()
    var items: [String] = ["Departing In", "Distance", "Pace", "Location"]
    var answers: [String] = ["...", "Distance", "Pace", ">"]
    var runners: [String] = []
    var congratsImg : UIImageView?
    var myTimer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getPace()
        
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
        
        let shareButton = UIButton(frame: CGRect(x: view.frame.width - 80, y: 20, width: 70, height: 50))
        shareButton.setTitleColor(tealColor, forState: .Normal)
        shareButton.setTitle("Invite", forState: .Normal)
        shareButton.addTarget(self, action: "inviteFriends", forControlEvents: .TouchUpInside)
        view.addSubview(shareButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 20, width: view.frame.width - 10, height: 50))
        titleLabel.textAlignment = .Center
        titleLabel.text = "Selected Pace"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 18)
        view.addSubview(titleLabel)
        
        tableView.frame         =   CGRectMake(0, 80, view.frame.width, 400);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(CustomTableViewCellInfo.self, forCellReuseIdentifier: "infoCell")
        tableView.registerClass(CustomTableViewCellDetails.self, forCellReuseIdentifier: "detailsCell")
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        
        
        let joinButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 120, width: view.frame.width - 40, height: 50))
        joinButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        joinButton.backgroundColor = tealColor
        joinButton.setTitle("JOIN", forState: .Normal)
        joinButton.addTarget(self, action: "join", forControlEvents: .TouchUpInside)
        view.addSubview(joinButton)
        
    }

    func reloadinfo() {
        if let datetime = paceInfo?.time as NSString? {
        
            var printstring = "..."
            let currentDate = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
            
           
                let arr = datetime.componentsSeparatedByString("T")
                let date = arr[0].componentsSeparatedByString("-")
                let time = arr[1].componentsSeparatedByString(":")
                if let year = date[0] as? String {
                    var val = year.toInt()
                    if val > components.year {
                        printstring = "Next year..."
                    } else {
                        if let month = date[1] as? String {
                            var val = month.toInt()
                            if val > components.month {
                                if printstring == "..." {
                                  printstring = "Next month..."
                                }
                            } else  {
                                if let day = date[2] as? String {
                                    var val = day.toInt()
                                    if val > components.day {
                                        let daysnum = val! - components.day
                                        if printstring == "..." {
                                        if daysnum == 1 {
                                            printstring = "Tomorrow"
                                        } else {
                                            printstring = "In \(daysnum) days"
                                        }
                                        }
                                    } else  {
                                        if let hour = time[0] as? String {
                                            var val = hour.toInt()
                                            if val > components.hour {
                                                if printstring == "..." {
                                                let hoursnum = val! - components.hour
                                                if hoursnum == 1 {
                                                    printstring = "1 hour"
                                                } else {
                                                    printstring = "In \(hoursnum) hours"
                                                }
                                                }
                                            } else  {
                                                if let min = time[1] as? String {
                                                    var val = min.toInt()
                                                    if val > components.minute {
                                                        let minnum = val! - components.minute
                                                        if printstring == "..." {
                                                        if minnum == 1 {
                                                            printstring = "1 minute"
                                                        } else {
                                                            printstring = "In \(minnum) minutes"
                                                        }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            
            
            
            answers[0] = printstring
        }
        
        if let info = paceInfo?.distance {
            answers[1] = "\(info) miles"
        }
        
        if let speedinfo = paceInfo?.pace {
            answers[2] = "\(speedinfo) minutes per mile"
        }
        
        
        
        if let myrunners = paceInfo?.participants {
            for runner in myrunners {
                self.runners.append("\(runner)")
            }
        }

    }
    
    func inviteFriends() {
        if let id = paceInfo?.id {
            let sharetext = "Let's run together! Join my pace at http://pace:runs/\(id)"
            let activityVC = UIActivityViewController(activityItems: [sharetext], applicationActivities: nil)
            navigationController!.presentViewController(activityVC, animated: true, completion: nil)
        }

    }
    
    func getPace() {
        if let paceinfoid = paceInfo?.id {
            NetworkController().getAPace(paceinfoid.toInt()!, successHandler: {paces in
            
                for pace in paces {
                    self.paceInfo = pace
                
                    self.reloadinfo()
                    self.tableView.reloadData()
                }
                }, failureHandler: {
                    error in
                    println("error")
                    
            })
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func join() {
        if AccountController.sharedInstance.getUser() != nil {
     
        
        
        NetworkController().updatePace(paceInfo!, successHandler: {
            boolval in
      
            self.getPace()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.congratsImg = UIImageView(frame: self.view.frame)
            let image = UIImage(named: "congrats")
            self.congratsImg?.image = image
            self.view.addSubview(self.congratsImg!)
            self.view.bringSubviewToFront(self.congratsImg!)
            self.myTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("myPerformeCode:"), userInfo: nil, repeats: false)
            })
            }, failureHandler: {
                error in
                println(error)
        })
            
        } else {
            let loginVC = LoginViewController()
            navigationController?.presentViewController(loginVC, animated: true, completion: nil)
        }
//        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func myPerformeCode(timer : NSTimer) {
        reloadinfo()
        tableView.reloadData()
        self.myTimer = nil
        congratsImg?.image = nil
        self.view.sendSubviewToBack(self.congratsImg!)
    }
    
    func goBack() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.items.count
        } else {
            return runners.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell:CustomTableViewCellDetails = tableView.dequeueReusableCellWithIdentifier("detailsCell") as! CustomTableViewCellDetails!

            cell.typeLabel.text = self.items[indexPath.row]
            cell.detailLabel.text = self.answers[indexPath.row]
             return cell
        } else {
            
            var cell:CustomTableViewCellInfo = tableView.dequeueReusableCellWithIdentifier("infoCell") as! CustomTableViewCellInfo!
            
            if let userid = runners[indexPath.row].toInt() {
                NetworkController().getUser(userid, successHandler: {user in
                    
                    if let frst = user.firstname {
                        if let lst = user.lastname {
                            cell.nameText.text = "\(frst) \(lst)"
                            cell.profImageView.image = UIImage(named: "placeholder")
                        }
                    }

                    if let fbid = user.facebook_id {
                        if fbid == "" {
                            cell.profImageView.image = UIImage(named: "profile")
                        }
                        if fbid != "" {
                            cell.profImageView.sd_setImageWithURL(NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=large"))
                        }
                    }
                    
                    }, failureHandler: {
                        error in
                        println(error)
                })
            }
            
            
             return cell
        }
        
        
       
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return "Runners"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  
        if indexPath.section == 1 {
            let vc = DetailViewController()
            vc.titleText = items[indexPath.row]
            if let runner = runners[indexPath.row].toInt() {
                vc.profileID = runner
            }
            navigationController!.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = LocationDetailViewController()
            if let loc = paceInfo?.location {
                vc.savedLocation = loc
            }
            navigationController?.showViewController(vc, sender: self)
        }
        
    }

}

class CustomTableViewCellInfo: UITableViewCell {
    
    var message: UILabel = UILabel()
    var nameText = UILabel()
    var profImageView: UIImageView!
    var iconImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var image = UIImage(named:"placeholder")
        profImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        profImageView.image = image
        profImageView.clipsToBounds = true
        profImageView.layer.cornerRadius = 25
        contentView.addSubview(profImageView)
        
        iconImageView = UIImageView(frame: CGRect(x: 40, y: 40, width: 20, height: 20))
        iconImageView.image = UIImage(named: "profileyesicon")
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 10
        contentView.addSubview(iconImageView)
        
        nameText = UILabel(frame: CGRect(x: 50, y: 0, width: contentView.frame.width - 50, height: 40))
        nameText.textAlignment = .Center
    
        contentView.addSubview(nameText)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}


class CustomTableViewCellDetails: UITableViewCell {
    
    var typeLabel = UILabel()
    var detailLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        typeLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 50))
        
        detailLabel = UILabel(frame: CGRect(x: 150, y: 10, width: 200, height: 50))
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(detailLabel)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
