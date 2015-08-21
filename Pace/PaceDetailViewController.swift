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
    var items: [String] = ["Departing In", "Departing From", "Distance", "Pace"]
    var runners: [String] = ["Steven", "Nick"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
//        distance.text = String(stringInterpolationSegment: paceInfo?.distance)
//        pace.text = String(stringInterpolationSegment: paceInfo?.pace)
//        runners.text = String(stringInterpolationSegment: paceInfo?.participants?.first)
//        runnerslast.text = String(stringInterpolationSegment: paceInfo?.participants?.last)

        
        let joinButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 120, width: view.frame.width - 40, height: 50))
        joinButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        joinButton.backgroundColor = tealColor
        joinButton.setTitle("JOIN", forState: .Normal)
        joinButton.addTarget(self, action: "join", forControlEvents: .TouchUpInside)
        view.addSubview(joinButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func join() {
        NetworkController().updatePace(paceInfo!, successHandler: {
            boolval in
            
            }, failureHandler: {
                error in
                println(error)
        })
        navigationController?.popToRootViewControllerAnimated(true)
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
            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell

            cell.textLabel?.text = self.items[indexPath.row]
             return cell
        } else {
            var cell:CustomTableViewCellInfo = tableView.dequeueReusableCellWithIdentifier("infoCell") as! CustomTableViewCellInfo

            cell.nameText.text = self.runners[indexPath.row]
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
        println("did select")
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var image = UIImage(named:"profile.jpg")
        let profImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
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
