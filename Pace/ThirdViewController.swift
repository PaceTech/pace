//
//  ThirdViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/9/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var items = ["Current Paces", "My Profile", "Pace Settings\n(coming soon!)", "Activity\n(coming soon!)"]
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
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "HOME"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: titleButton.font.fontName, size: 14)
        view.addSubview(titleButton)
        
        var attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(13.0),
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSUnderlineStyleAttributeName : 1]
        
        var attributedString = NSMutableAttributedString(string:"Log Out", attributes: attrs)
        var attributedString1 = NSMutableAttributedString(string:"Privacy Policy", attributes: attrs)
        var attributedString2 = NSMutableAttributedString(string:"Terms of Service", attributes: attrs)
        
        let logoutbutton = UIButton(frame: CGRect(x: 80, y: 530, width: view.frame.width - 160, height: 50))
        logoutbutton.setAttributedTitle(attributedString, forState: .Normal)
        logoutbutton.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
        
        let privacybutton = UIButton(frame: CGRect(x: 40, y: 560, width: view.frame.width/2 - 20, height: 50))
        privacybutton.setAttributedTitle(attributedString1, forState: .Normal)
        privacybutton.addTarget(self, action: "showprivacy", forControlEvents: .TouchUpInside)
        
        let termsofservice = UIButton(frame: CGRect(x: view.frame.width/2, y: 560, width: view.frame.width/2 - 40, height: 50))
        termsofservice.setAttributedTitle(attributedString2, forState: .Normal)
        termsofservice.addTarget(self, action: "showtos", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(tableView)
        
        view.addSubview(logoutbutton)
        view.addSubview(termsofservice)
        view.addSubview(privacybutton)
        
    }
    
    func showtos() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://joinapace.quip.com/MmdsAuIrYmXo")!)
    }
    
    func showprivacy() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://joinapace.quip.com/5CXzA77jHOX9")!)
    }
    
    func logout() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let loginVC = LoginViewController()
        navigationController?.presentViewController(loginVC, animated: true, completion: nil)
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
        
        
        cell.nameText.text = self.items[indexPath.row]
        cell.nameText.textColor = tealColor
        cell.nameText.font = UIFont(name: "helvetica", size: 20)
        cell.iconview.image = UIImage(named: names[indexPath.row])
        
        if indexPath.row > 1  {
            cell.userInteractionEnabled = false
            cell.nameText.textColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6)
        }
        
        return cell
        
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return ""
//    }
    
    
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
    
    }


    
}


class SettingsViewCell: UITableViewCell {
    
    var nameText = UILabel()
    var iconview: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var image = UIImage(named:"profile")
        iconview = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        iconview.contentMode = .ScaleAspectFit
        contentView.addSubview(iconview)
        
        nameText = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 80))
        nameText.numberOfLines = 0
        contentView.addSubview(nameText)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}