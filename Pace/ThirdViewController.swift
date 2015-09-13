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
    var items = ["Current Paces", "My Profile", "Pace Settings", "Activity"]
    var names = ["paces", "profile", "settings", "activity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBlueColor
        
        tableView.frame = CGRectMake(0, 70, view.frame.width, view.frame.height - 60)
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
        
        self.view.addSubview(tableView)
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
        if indexPath.row > 1  {
            cell.userInteractionEnabled = false
        }
        
        cell.nameText.text = self.items[indexPath.row]
        cell.nameText.textColor = tealColor
        cell.nameText.font = UIFont(name: "helvetica", size: 20)
        cell.iconview.image = UIImage(named: names[indexPath.row])
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
        
        nameText = UILabel(frame: CGRect(x: 100, y: 10, width: 200, height: 50))
        contentView.addSubview(nameText)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}