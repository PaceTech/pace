//
//  ThirdViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/9/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class ThirdViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var items = ["Current Runs", "My Profile", "Pace Settings", "Activity"]
    var names = ["paces", "profile", "settings", "activity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)
        
        tableView.frame = CGRectMake(0, 70, view.frame.width, 320)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(SettingsViewCell.self, forCellReuseIdentifier: "setingscell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        var titleButton = UILabel(frame: CGRectMake(20, 26, view.frame.width - 40, 30))
        titleButton.text = "Home"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: "Oswald-Regular", size: 20)
        view.addSubview(titleButton)
        
        var attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(13.0),
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSUnderlineStyleAttributeName : 1]
        
        var attributedString = NSMutableAttributedString(string:"Log Out", attributes: attrs)
        var attributedString1 = NSMutableAttributedString(string:"Privacy Policy", attributes: attrs)
        var attributedString2 = NSMutableAttributedString(string:"Terms of Service", attributes: attrs)
        var attributedString3 = NSMutableAttributedString(string:"Feedback", attributes: attrs)
        
        let logoutbutton = UIButton(frame: CGRect(x: 80, y: 530, width: view.frame.width - 160, height: 50))
        logoutbutton.setAttributedTitle(attributedString, forState: .Normal)
        logoutbutton.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
        
        let privacybutton = UIButton(frame: CGRect(x: 10, y: 560, width: view.frame.width/3, height: 50))
        privacybutton.setAttributedTitle(attributedString1, forState: .Normal)
        privacybutton.addTarget(self, action: "showprivacy", forControlEvents: .TouchUpInside)
        
        let termsofservice = UIButton(frame: CGRect(x: view.frame.width/3 + 10, y: 560, width: view.frame.width/3, height: 50))
        termsofservice.setAttributedTitle(attributedString2, forState: .Normal)
        termsofservice.addTarget(self, action: "showtos", forControlEvents: .TouchUpInside)
        
        let feedback = UIButton(frame: CGRect(x: view.frame.width * 2/3 + 10, y: 560, width: view.frame.width/3, height: 50))
        feedback.setAttributedTitle(attributedString3, forState: .Normal)
        feedback.addTarget(self, action: "showFeedback", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(tableView)
        
        view.addSubview(logoutbutton)
        view.addSubview(termsofservice)
        view.addSubview(feedback)
        view.addSubview(privacybutton)
        
    }
    
    func showFeedback() {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.joinapace.com/contact/")!)
    }
    
    func showtos() {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.joinapace.com/terms")!)
    }
    
    func showprivacy() {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.joinapace.com/privacy")!)
    }
    
    func logout() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let loginVC = LoginViewController()
        navigationController?.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.screenName = "HomeView"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:SettingsViewCell = tableView.dequeueReusableCellWithIdentifier("setingscell") as! SettingsViewCell!
        
        cell.arrowText.textColor = tealColor
        cell.nameText.text = self.items[indexPath.row]
        cell.nameText.textColor = tealColor
        cell.nameText.font = UIFont(name: "helvetica", size: 20)
        cell.iconview.image = UIImage(named: names[indexPath.row])
        
        if indexPath.row > 1  {
            cell.userInteractionEnabled = false
            cell.arrowText.textColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6)
            cell.nameText.textColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6)
            cell.comingSoonText.text = "Coming soon!"
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          if AccountController.sharedInstance.getUser() != nil {
        
        if indexPath.row == 1 {
            let vc = DetailViewController()
            vc.titleText = items[indexPath.row]
            vc.profileID = AccountController.sharedInstance.getUser()?.id
            navigationController!.pushViewController(vc, animated: true)
        } else if indexPath.row == 0 {
            let vc = MyRunsViewController()
            vc.titleText = items[indexPath.row]
            navigationController!.pushViewController(vc, animated: true)
        }
        
            } else {
            let loginVC = LoginViewController()
            navigationController?.presentViewController(loginVC, animated: true, completion: nil)
            }
        var cellToDeSelect:SettingsViewCell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsViewCell
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    
    
    }



    
}


class SettingsViewCell: UITableViewCell {
    
    var nameText = UILabel()
    var iconview: UIImageView!
    var arrowText: UILabel!
    var comingSoonText: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var image = UIImage(named:"profile")
        iconview = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        iconview.contentMode = .ScaleAspectFit
        contentView.addSubview(iconview)
        
        arrowText = UILabel(frame: CGRect(x: contentView.frame.width, y: contentView.frame.height/2 + 5, width: 30, height: 30))
        arrowText.text = ">"
        contentView.addSubview(arrowText)
        
        nameText = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 80))
        nameText.numberOfLines = 0
        contentView.addSubview(nameText)
        
        comingSoonText = UILabel(frame: CGRect(x: 100, y: 20, width: 200, height: 80))
        comingSoonText.font = UIFont(name: "Lato-LightItalic", size: 13)
        comingSoonText.textColor = UIColor.lightGrayColor()
        contentView.addSubview(comingSoonText)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}