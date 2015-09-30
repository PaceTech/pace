//
//  PaceDetailViewController.swift
//  Pace
//
//  Created by Tara Wilson on 8/10/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class PaceDetailViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource  {

    var paceInfo : Pace?
    var tableView: UITableView  =   UITableView()
    var items: [String] = ["Departing In", "Distance", "Pace", "Departing From"]
    var answers: [String] = ["...", "Distance", "Pace", ">"]
    var runners: [String] = []
    var customTime = ""
    var congratsImg : UIImageView?
    var myTimer : NSTimer?
    var ismycurrentrundetail = false
    var isowner = false
    var isparticipant = false
    var popupview: UIView!
    var joinButton: UIButton!
    var titleLabel: UILabel!
    var backview: UIView!
    var cancel: UIButton!
    var delete: UIButton!
    var cannotAttend: UIButton!
    var joined = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getPace()
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)

        tabBarController?.navigationController?.navigationBarHidden = false
        
        view.backgroundColor = UIColor.whiteColor()
        let backButton = UIButton(frame: CGRect(x: 15, y: 20, width: 20, height: 50))
        backButton.setTitleColor(tealColor, forState: .Normal)
        backButton.setTitle("<", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Oswald-Bold", size: 25)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        
        if ismycurrentrundetail {
            let shareButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: 30, width: 40, height: 30))
//            shareButton.setTitleColor(tealColor, forState: .Normal)
//            shareButton.setTitle("Update", forState: .Normal)
//            shareButton.contentMode = .ScaleAspectFi
            shareButton.setImage(UIImage(named: "message"), forState: .Normal)
            shareButton.addTarget(self, action: "updateAvailability", forControlEvents: .TouchUpInside)
            view.addSubview(shareButton)
        } else {
            
        }
        
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 20, width: view.frame.width - 10, height: 50))
        titleLabel.textAlignment = .Center
        titleLabel.text = "Selected Run"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "Oswald-Regular", size: 20)
        view.addSubview(titleLabel)
        
        tableView.frame         =   CGRectMake(0, 80, view.frame.width, 440);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(CustomTableViewCellInfo.self, forCellReuseIdentifier: "infoCell")
        tableView.registerClass(CustomTableViewCellDetails.self, forCellReuseIdentifier: "detailsCell")
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        
        
        joinButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 120, width: view.frame.width - 40, height: 50))
        joinButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        joinButton.backgroundColor = tealColor
        joinButton.setTitle("JOIN", forState: .Normal)
        joinButton.addTarget(self, action: "join", forControlEvents: .TouchUpInside)
        view.addSubview(joinButton)
        
    }
    
    func updateAvailability() {
        backview = UIView(frame: view.frame)
        backview.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        view.addSubview(backview)
        
        popupview = UIView(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 250))
        
        let instructions = UIButton(frame: CGRect(x: 10, y: 0, width: view.frame.width - 40, height: 40))
        instructions.backgroundColor = UIColor.clearColor()
        instructions.setTitle("Select an Option", forState: .Normal)
        instructions.setTitleColor(tealColor, forState: .Normal)
        instructions.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        popupview.addSubview(instructions)
        
        cannotAttend = UIButton(frame: CGRect(x: 10, y: 45, width: view.frame.width - 40, height: 40))
        cannotAttend.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        cannotAttend.setTitle("Cannot Attend", forState: .Normal)
        cannotAttend.addTarget(self, action: "leaveupdate", forControlEvents: .TouchUpInside)
        cannotAttend.setTitleColor(UIColor.blackColor(), forState: .Normal)
        popupview.addSubview(cannotAttend)
        
//        let detail = UIButton(frame: CGRect(x: 10, y: 90, width: view.frame.width - 40, height: 40))
//        detail.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
//        detail.setTitle("5 Minutes Late", forState: .Normal)
//        detail.addTarget(self, action: "lateUpdate", forControlEvents: .TouchUpInside)
//        detail.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        popupview.addSubview(detail)
        
        delete = UIButton(frame: CGRect(x: 10, y: 90, width: view.frame.width - 40, height: 40))
        delete.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        delete.setTitle("Delete", forState: .Normal)
        delete.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        if isowner {
            delete.setTitleColor(UIColor.blackColor(), forState: .Normal)
            delete.addTarget(self, action: "deleteupdate", forControlEvents: .TouchUpInside)
        }
        
        popupview.addSubview(delete)
        
        cancel = UIButton(frame: CGRect(x: 10, y: 135, width: view.frame.width - 40, height: 40))
        cancel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        cancel.setTitle("Cancel", forState: .Normal)
        cancel.addTarget(self, action: "cancelupdate", forControlEvents: .TouchUpInside)
        cancel.setTitleColor(UIColor.blackColor(), forState: .Normal)
        popupview.addSubview(cancel)
        popupview.bringSubviewToFront(cancel)
        
        view.addSubview(popupview)
        view.bringSubviewToFront(popupview)
        UIView.animateWithDuration(0.5, animations: {
            self.popupview.frame = CGRect(x: 10, y: self.view.frame.height - 240, width: self.view.frame.width - 20, height: 250)
        })

    }
    
    func lateUpdate() {
   
        if let id = paceInfo?.id?.toInt() {
            NetworkController().updateLate(id, successHandler: { success in
                print("worked!! late")
                }, failureHandler: {error in
                    print(error)
            })
        }
        UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
            self.backview.removeFromSuperview()
            self.popupview.frame = CGRect(x: 0, y: self.view.frame.height + 50, width: self.view.frame.width, height: 180)
            }, completion: nil)
        getPace()
    }
    
    func leaveupdate() {
        cannotAttend.backgroundColor = UIColor.lightGrayColor()
        if let pace = paceInfo {
            NetworkController().leavePace(pace, successHandler: { variable in
                "Alert left pace"
                self.getPace()
                }, failureHandler: { variable in
                   "Alert did not leave pace"
            })
        }
        UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
            self.backview.removeFromSuperview()
            self.popupview.frame = CGRect(x: 0, y: self.view.frame.height + 50, width: self.view.frame.width, height: 180)
        }, completion: nil)
        getPace()
    }
    
    func deleteupdate() {
        delete.backgroundColor = UIColor.lightGrayColor()
        if let pace = paceInfo {
            NetworkController().deletePace(pace, successHandler: { variable in
                self.goBack()
                "Alert delete pace"
                }, failureHandler: { variable in
                    "Alert did not delete pace"
            })
        }
        UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
            self.backview.removeFromSuperview()
            self.popupview.frame = CGRect(x: 0, y: self.view.frame.height + 50, width: self.view.frame.width, height: 180)
            }, completion: nil)
        getPace()
    }
    
    func cancelupdate() {
        print("cancel")
        cancel.backgroundColor = UIColor.lightGrayColor()
        UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
            self.backview.removeFromSuperview()
            self.popupview.frame = CGRect(x: 0, y: self.view.frame.height + 50, width: self.view.frame.width, height: 180)
            }, completion: nil)
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
                                            printstring = "\(daysnum) days"
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
                                                    printstring = "\(hoursnum) hours"
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
                                                            printstring = "\(minnum) minutes"
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
            if let hour =  time[0] as? String {
                if hour.toInt() > 12 {
                    customTime = "\(24 - hour.toInt()! - 1):\(time[1])"
                } else {
                    customTime = "\(time[0]):\(time[1])"
                }
                
            }
            
            
            
            answers[0] = printstring
        }
        
        if let info = paceInfo?.pace {
            answers[1] = "\(info) miles"
        }
        
        if let speedinfo = paceInfo?.distance {
            answers[2] = "\(speedinfo) mins / mile"
        }
        
        
        self.runners = []
        if let myrunners = paceInfo?.participants {
            for runner in myrunners {
                if let id = AccountController.sharedInstance.getUser()?.id {
                    if "\(runner)" == "\(id)" {
                        self.canInvite()
                    }
                }
                
                self.runners.append("\(runner)")
            }
        }

    }
    
    func canInvite() {
        if !ismycurrentrundetail {
            let shareButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 120, width: view.frame.width - 40, height: 50))
            shareButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            shareButton.backgroundColor = tealColor
            shareButton.setTitle("Invite", forState: .Normal)
            shareButton.addTarget(self, action: "inviteFriends", forControlEvents: .TouchUpInside)
            view.addSubview(shareButton)
        }
        joinButton.removeFromSuperview()
    }
    
    func inviteFriends() {
        if let id = paceInfo?.id {
            let sharetext = "Let's run together! Join my pace at paceapp://\(id)"
            let activityVC = UIActivityViewController(activityItems: [sharetext], applicationActivities: nil)
            navigationController!.presentViewController(activityVC, animated: true, completion: nil)
        }

    }
    
    func getPace() {
        let activityind = UIActivityIndicatorView(frame: CGRect(x: view.frame.width/2 - 20, y: view.frame.height/2 - 20, width: 40, height: 40))
        activityind.tintColor = darkBlueColor
        view.addSubview(activityind)
        activityind.startAnimating()
        if let paceinfoid = paceInfo?.id {
            NetworkController().getAPace(paceinfoid.toInt()!, successHandler: {paces in
            
                for pace in paces {
                    
                    if let id = AccountController.sharedInstance.getUser()?.id {
                        if pace.owner == "\(id)" {
                            self.isowner = true
                        }
                    }
                    
                    self.paceInfo = pace
                
                    self.reloadinfo()
                    activityind.stopAnimating()
                    self.tableView.reloadData()
                }
                }, failureHandler: {
                    error in
                    println("error")
                    let alertController = UIAlertController(title: NSLocalizedString("Uh oh!", comment: ""), message: NSLocalizedString("Something went wrong loading this pace.", comment: ""), preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("I'll check back later.", comment: ""), style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        
                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
            })
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        self.screenName = "PaceDetailView"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func join() {
        joined = true
        if AccountController.sharedInstance.getUser() != nil {
     
        
        
        NetworkController().updatePace(paceInfo!, successHandler: {
            boolval in
            self.titleLabel.text = "Current Run"
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
        
        
        self.myTimer = nil
        congratsImg?.image = nil
        self.view.sendSubviewToBack(self.congratsImg!)
        self.canInvite()
        getPace()
        reloadinfo()
        tableView.reloadData()
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
            cell.typeLabel.font = UIFont(name: "Lato-Bold", size: 15)
            cell.detailLabel.text = self.answers[indexPath.row]
            cell.detailLabel.font = UIFont(name: "Lato-Bold", size: 15)
            
            if indexPath.row == 0 {
                cell.extratypeLabel.text = "This run will depart at"
                cell.extratypeLabel.font = UIFont(name: "Lato-LightItalic", size: 15)
                cell.extradetailLabel.font = UIFont(name: "Lato-LightItalic", size: 15)
                cell.extradetailLabel.text = customTime
            }
            
             return cell
        } else {
            
            var cell:CustomTableViewCellInfo = tableView.dequeueReusableCellWithIdentifier("infoCell") as! CustomTableViewCellInfo!
            
            if let userid = runners[indexPath.row].toInt() {
                NetworkController().getUser(userid, successHandler: {user in
                    
                    if let frst = user.firstname {
                        if let lst = user.lastname {
                            
                         
                            let idx = advance(lst.startIndex, 0)
                            let lastletter = lst[idx]
                            let name = "\(frst) \(lastletter).   "
                            cell.nameText.text = name
                            cell.nameText.font = UIFont(name: "Lato-Bold", size: 15)
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
                    if self.joined == false {
                        if "\(userid)" == self.paceInfo?.owner {
                            cell.iconImageView.image = UIImage(named: "profhost")
                            cell.iconImageView.backgroundColor = UIColor.whiteColor()
                            cell.hostText.text = "Host   "
                            cell.hostText.font = UIFont(name: "Lato-BoldItalic", size: 15)
                        }
                    } else {
                        cell.iconImageView.image = UIImage(named: "profileyesicon")
                        cell.hostText.text = ""
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 70
            } else {
                return 55
            }
        }
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }

}

class CustomTableViewCellInfo: UITableViewCell {
    
    var message: UILabel = UILabel()
    var nameText = UILabel()
    var hostText = UILabel()
    var profImageView: UIImageView!
    var iconImageView: UIImageView!
    var arrow: UILabel!
    
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
        
        arrow = UILabel(frame: CGRect(x: contentView.frame.width + 24, y: 0 , width: 10, height: 65))
        arrow.text = ">"
        arrow.textColor = tealColor
        arrow.font = UIFont(name: "Oswald-Bold", size: 24)
        contentView.addSubview(arrow)
        contentView.bringSubviewToFront(arrow)
        
        nameText = UILabel(frame: CGRect(x: 40, y: 0, width: contentView.frame.width - 20, height: 65))
        nameText.textAlignment = .Right
        hostText = UILabel(frame: CGRect(x: 25, y: 20, width: contentView.frame.width - 20, height: 65))
        hostText.textAlignment = .Right
        hostText.textColor = UIColor.lightGrayColor()
    
        contentView.addSubview(nameText)
        contentView.addSubview(hostText)
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
    
    var extratypeLabel = UILabel()
    var extradetailLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        typeLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 45))
        detailLabel = UILabel(frame: CGRect(x: 150, y: 0, width: 200, height: 45))
        detailLabel.textColor = UIColor.lightGrayColor()
        detailLabel.textAlignment = .Right
        
        extratypeLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 50))
        extratypeLabel.textColor = UIColor.lightGrayColor()
        extradetailLabel = UILabel(frame: CGRect(x: 150, y: 20, width: 200, height: 50))
        extradetailLabel.textColor = UIColor.lightGrayColor()
        extradetailLabel.textAlignment = .Right
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(extratypeLabel)
        contentView.addSubview(extradetailLabel)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
