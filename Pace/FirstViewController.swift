//
//  FirstViewController.swift
//  Pace
//
//  Created by Tara Wilson on 7/8/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

let darkBlueColor = UIColor(red: 27/255, green: 78/255, blue: 93/255, alpha: 1)
let tealColor = UIColor(red: 54/255, green: 179/255, blue: 168/255, alpha: 1)


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var marker = GMSMarker(position: CLLocationCoordinate2DMake(-33.86, 151.20))
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
        tabBarController?.tabBar.backgroundColor = UIColor.clearColor()
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true

        tabBarController?.tabBar.tintColor = tealColor
        
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 60))
        headerView.backgroundColor = darkBlueColor
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "CLICK DROP PIN TO JOIN A PACE"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: titleButton.font.fontName, size: 14)
        
        headerView.addSubview(titleButton)
        
        view.addSubview(headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }


}

