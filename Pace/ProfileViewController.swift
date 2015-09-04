//
//  DetailViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/21/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var titleText: String?
    var tableView: UITableView  =   UITableView()
    var items: [String] = [ "33 friends on pace", "5 paces joined", "6 paces hosted"]
    var runners: [String] = ["Nick", "Taylor"]
    var profImageView: UIImageView!

    override func viewDidLoad() {
        tableView.frame         =   CGRectMake(0, 200, view.frame.width, 400);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(CustomTableViewCellInfo.self, forCellReuseIdentifier: "infoCell")
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
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
        
//        var image = UIImage(named:"placeholder")
        profImageView = UIImageView(frame: CGRect(x: view.frame.width/2 - 50, y: 100, width: 100, height: 100))
//        profImageView.image = image
        profImageView.clipsToBounds = true
        profImageView.layer.cornerRadius = 50
        view.addSubview(profImageView)
        addprofimage()
        
        
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            if ((error) != nil){}
//            else {
//                println("fetched user: \(result)")
//                    if let data = photo.valueForKey("data") as? NSDictionary {
//                        let url = NSURL(string: data.valueForKey("url") as String!)
//                        println(url)
//                        profImageView.sd_setImageWithURL(url)
//                    }
                    
//                }
//
//            }
//        })


    }
    
    func addprofimage() {
        if let photo = AccountController.sharedInstance.getUser()?.imageurl {
            if let url = NSURL(string: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/v/t1.0-1/p200x200/10940434_10153602476883975_4314529171487600602_n.jpg?oh=3c6605130e181bba1d49c0a52c0bf850&oe=563C6711&__gda__=1449959808_d348aa819575656eccf5a5c2376d174c") {
                println(url)
                if let imageview = profImageView {
                    imageview.sd_setImageWithURL(url)
                }
                
            }

            
        }
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.items.count
        } else {
            return runners.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell!
        if indexPath.section == 0 {
            cell.textLabel?.text = self.items[indexPath.row]
        } else {
            cell.textLabel?.text = self.runners[indexPath.row]
        }
        
        
        return cell!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return "Friends"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
