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
    var items: [String] = [ "Work", "Education", "0 friends on pace", "paces joined", "paces hosted"]
    var runners: [Int] = [18]
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
        
        profImageView = UIImageView(frame: CGRect(x: view.frame.width/2 - 50, y: 100, width: 100, height: 100))
        profImageView.clipsToBounds = true
        profImageView.layer.cornerRadius = 50
        view.addSubview(profImageView)
        addprofimage()
        

        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
            println(error)
            }
            else {
                println("fetched user: \(result)")
                
                }

        })


    }
    
    
    func addprofimage() {
        if let photo = AccountController.sharedInstance.getUser()?.imageurl {
            if let fbid =  AccountController.sharedInstance.getUser()?.facebook_id {
                if let imageview = profImageView {
                    imageview.sd_setImageWithURL(NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=large"))
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell!
        if indexPath.section == 0 {
            cell.textLabel?.text = self.items[indexPath.row]
            if indexPath.row == 0 {
                cell.textLabel?.enabled = false
            }
            if indexPath.row == 1 {
                cell.textLabel?.enabled = false
            }
            cell.textLabel?.textAlignment = .Center
        } else {
            var cell:CustomTableViewCellInfo = tableView.dequeueReusableCellWithIdentifier("infoCell") as! CustomTableViewCellInfo!
            
            let userid = runners[indexPath.row]
                NetworkController().getUser(userid, successHandler: {user in
                    
                    if let frst = user.firstname {
                        if let lst = user.lastname {
                            cell.nameText.text = "\(frst) \(lst)"
                            cell.profImageView.image = UIImage(named: "placeholder")
                        }
                    }
            
                    if let fbid = user.facebook_id {
                        if fbid == "" {
                            cell.profImageView.image = UIImage(named: "placeholder")
                        }
                        if fbid != "" {
                            cell.profImageView.sd_setImageWithURL(NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=large"))
                        }
                    } else {
                        cell.profImageView.image = UIImage(named: "placeholder")
                    
                    }
            
                    }, failureHandler: {
                        error in
                        println(error)
                })
            
            
            
            return cell
        }
        
        
        return cell!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
