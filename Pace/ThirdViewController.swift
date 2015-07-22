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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBlueColor
        
        tableView.frame = CGRectMake(0, 60, view.frame.width, view.frame.height - 60)
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let vc = DetailViewController()
        vc.titleText = items[indexPath.row]
        navigationController!.pushViewController(vc, animated: true)
    }
    
    
    
}