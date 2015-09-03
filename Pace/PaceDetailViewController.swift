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
    var items: [String] = ["Departing In", "Distance", "Pace"]
    var answers: [String] = ["10 minutes", "Distance", "Pace"]
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
    
    func getPace() {
        if let paceinfoid = paceInfo?.id {
            NetworkController().getAPace(paceinfoid.toInt()!, {paces in
            
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
        if AccountController.sharedInstance.currentuser != nil {
     
        
        
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
            var cell:CustomTableViewCellDetails = tableView.dequeueReusableCellWithIdentifier("detailsCell") as CustomTableViewCellDetails!

            cell.typeLabel.text = self.items[indexPath.row]
            cell.detailLabel.text = self.answers[indexPath.row]
             return cell
        } else {
            
            var cell:CustomTableViewCellInfo = tableView.dequeueReusableCellWithIdentifier("infoCell") as CustomTableViewCellInfo!
            
            if let userid = runners[indexPath.row].toInt() {
                NetworkController().getUser(userid, successHandler: {user in
                    
                    cell.nameText.text = user.firstname
                    if let image = user.imageurl {
                        if image != "" {
                            println(image)
                            
                            cell.profImageView.sd_setImageWithURL(NSURL(string: image))
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
            navigationController!.pushViewController(vc, animated: true)
        }
        
    }

}

class CustomTableViewCellInfo: UITableViewCell {
    
    var message: UILabel = UILabel()
    var nameText = UILabel()
    var profImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var image = UIImage(named:"profile")
        profImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        profImageView.image = image
        profImageView.clipsToBounds = true
        profImageView.layer.cornerRadius = 25
        contentView.addSubview(profImageView)
        
        nameText = UILabel(frame: CGRect(x: 130, y: 10, width: 100, height: 50))
    
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
