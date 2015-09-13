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
    var items: [String] = [ "Work", "Education", "0 friends on pace", "0 paces joined", "0 paces hosted"]
    var iconnames: [String] = ["profwork", "profeducation", "profpacefriends", "profjoin", "profhost"]
    var profileID: Int!
    var profImageView: UIImageView!
    var workstring : String?
    var educationstring: String?
    var namelabel: UILabel!
    var locationlabel: UILabel!
    var friendsnames: [String] = []
    var friendsids: [String] = []
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        titleLabel = UILabel(frame: CGRect(x: 40, y: 30, width: view.frame.width - 80, height: 40))
        
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        view.addSubview(titleLabel)
        
        let nameview = UIView(frame: CGRect(x: 0, y: 225, width: view.frame.width, height: 80))
        nameview.backgroundColor = UIColor.whiteColor()
        
        namelabel = UILabel(frame: CGRect(x: 0, y: 220, width: view.frame.width, height: 50))
        namelabel.textColor = tealColor
        namelabel.textAlignment = .Center
        
        locationlabel = UILabel(frame: CGRect(x: 0, y: 250, width: view.frame.width, height: 50))
        locationlabel.textColor = UIColor.blackColor()
        locationlabel.textAlignment = .Center
        locationlabel.text = "25, New York, NY"
        
        view.addSubview(nameview)
        view.addSubview(namelabel)
        view.addSubview(locationlabel)
        
        
        tableView.frame         =   CGRectMake(0, 305, view.frame.width, 400);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
  
        tableView.registerClass(CustomTableViewCellInfo.self, forCellReuseIdentifier: "infoCell")
        
        tableView.registerClass(profinfocell.self, forCellReuseIdentifier: "profinfocell")
        
        self.view.addSubview(tableView)
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        updateItems()
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        view.addSubview(headerView)


        let backButton = UIButton(frame: CGRect(x: 10, y: 20, width: 70, height: 50))
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        
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
                if let res = result["data"] as? NSArray {
                    if let dc = res[0] as? NSDictionary {
                        if let name: AnyObject = dc["name"] {
                           if let id : AnyObject = dc["id"] {
                                self.friendsnames.append(name as! String)
                                self.friendsids.append(id as! String)
                            }
                        }
                    }
                }
                
               
                
                }

        })
        updateNumbers()

    }
    
    func updateItems() {
        NetworkController().getUser(profileID, successHandler: { user in
            if let first = user.firstname, last = user.lastname {
                self.namelabel.text = "\(first) \(last)"
                self.titleLabel.text = "\(first) \(last)"
                self.view.bringSubviewToFront(self.titleLabel)
            }
            if let work = user.work {
                self.items[0] = work
            }
            if let education = user.education {
                self.items[1] = education
            }
            self.tableView.reloadData()
            }, failureHandler: {error in
                
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if (workstring != nil) {
            NetworkController().getUser(profileID, successHandler: { user in

                
                user.work = self.workstring
                NetworkController().updateUserWork(user, successHandler: {bool in
                    PersistentDataStore.sharedInstance.saveUser(user)
                    }, failureHandler: {error in
                })
                }, failureHandler: {error in
                    
            })
        }
        if (educationstring != nil) {
            NetworkController().getUser(profileID, successHandler: { user in
                user.work = self.educationstring
                NetworkController().updateUserEducation(user, successHandler: {bool in
                    PersistentDataStore.sharedInstance.saveUser(user)
                    }, failureHandler: {error in
                })
                }, failureHandler: {error in
                    
            })
        }
        updateItems()
        updateNumbers()
    }
    
    func updateNumbers() {
        var joincount = 0
        var hostcount = 0
        
        
        NetworkController().getPaces({paces in
        
            for pace in paces {
              
                NetworkController().getUser(self.profileID, successHandler: { user in
                    if let owner = pace.owner {
                        if user.id == owner.toInt() {
                            hostcount = hostcount + 1
                        }
                        
                        if let participants = pace.participants {
                            for runner in participants {
                                if let id = user.id {
                                    if "\(runner)" == "\(id)" {
                                        joincount = joincount + 1
                                    }
                                }
                                
                            }
                        }
                        
                        
                        self.updaterows(joincount, host: hostcount)
                    }
                    }, failureHandler: {error in
                        
                })
            }
            }, failureHandler: {
                error in
                println(error)
                
        })
    }
    
    func updaterows(join: Int, host: Int) {
    
        items[3] = "\(join) paces joined"
        items[4] = "\(host) paces hosted"
        
        tableView.reloadData()
    }
    
    func addprofimage() {
        NetworkController().getUser(self.profileID, successHandler: { user in

            if let fbid =  user.facebook_id {
                if let imageview = self.profImageView {
                    imageview.sd_setImageWithURL(NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=large"))
                }
            }
        }, failureHandler: {error in})
    
    }

    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.items.count
        } else {
            return friendsnames.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        }
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:profinfocell = tableView.dequeueReusableCellWithIdentifier("profinfocell") as! profinfocell!
        if indexPath.section == 0 {
            cell.nameText.text = self.items[indexPath.row]
            cell.iconview.image = UIImage(named: self.iconnames[indexPath.row])
            if indexPath.row == 0 {
                if self.items[indexPath.row] == "Work" {
                    cell.textLabel?.enabled = false
                }
            }
            if indexPath.row == 1 {
                if self.items[indexPath.row] == "Education" {
                    cell.textLabel?.enabled = false
                }
            }
            cell.textLabel?.textAlignment = .Center
            return cell
        } else {
            var cell:CustomTableViewCellInfo = tableView.dequeueReusableCellWithIdentifier("infoCell") as! CustomTableViewCellInfo!
            
            
            let name = friendsnames[indexPath.row]
            
            cell.nameText.text = name
            cell.profImageView.sd_setImageWithURL(NSURL(string: "http://graph.facebook.com/\(friendsids[indexPath.row])/picture?type=large"))

            
            return cell
        }
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Member Since January 2015"
        } else {
            return "Friends"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let vc = InputViewController()
                vc.pageTitle = "Enter Education"
                vc.iseducation = true
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 0 {
                let vc = InputViewController()
                vc.pageTitle = "Enter Education"
                vc.iswork = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


class profinfocell: UITableViewCell {
    
    var nameText = UILabel()
    var iconview: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconview = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        iconview.contentMode = .ScaleAspectFit
        contentView.addSubview(iconview)
        
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
