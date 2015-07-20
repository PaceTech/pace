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
        
        
        
        var camera = GMSCameraPosition.cameraWithLatitude(40.7903, longitude: -73.9597, zoom: 12)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
//        view.addSubview(mapView)
        
        
        var marker = GMSMarker(position: CLLocationCoordinate2DMake(40.7903, -73.9597))
        marker.title = "New York City"
        marker.snippet = "NY"
        marker.map = mapView
        
        if let mylocation = mapView.myLocation {
            NSLog("User's location: %@", mylocation)
        } else {
            NSLog("User's location is unknown")
        }
        
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
        
        mapView.addSubview(headerView)
        
        self.view = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }


}

