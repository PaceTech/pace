//
//  SelectHostLocation.swift
//  Pace
//
//  Created by Tara Wilson on 7/21/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps


class LocationDetailViewController: GAITrackedViewController {
    
    var firstLocationUpdate: Bool?
    let locationManager=CLLocationManager()
    var mapView: GMSMapView!

    var savedLocation : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var camera = GMSCameraPosition()
        mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50), camera: camera)
        mapView.settings.myLocationButton = true
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.myLocationEnabled = true
        })
        
        tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true
        
        tabBarController?.tabBar.tintColor = tealColor
        
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 60))
        headerView.backgroundColor = darkBlueColor
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "Run Location"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: "Oswald-Regular", size: 20)
        
        var backButton = UIButton(frame: CGRect(x: 14, y: 20, width: 50, height: 40))
        backButton.setTitleColor(tealColor, forState: .Normal)
        backButton.setTitle("<", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Oswald-Bold", size: 25)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        headerView.addSubview(backButton)
        

        
        headerView.addSubview(titleButton)
        
        mapView.addSubview(headerView)
        
        self.view = mapView
    }
    
    override func viewDidAppear(animated: Bool) {
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        var marker = GMSMarker(position: savedLocation!)
        marker.title = "Join Pace"
        marker.map = self.mapView
        marker.icon = UIImage(named: "paceDropPin")
        mapView.camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 15)
        self.screenName = "PaceDetailLocationView"
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    func goBack() {
        if let vc = navigationController?.viewControllers[1] as? PaceDetailViewController {
            navigationController?.popToViewController(vc, animated: true)
        }
        
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        firstLocationUpdate = true
        let location = change[NSKeyValueChangeNewKey] as? CLLocation

        
    }

    
    func searchCoordinatesForAddress(address: String) {
        var urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)"
        var newUrlString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        let urlPath: String = newUrlString
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        if let  jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal, options: .MutableContainers, error: nil) as? NSDictionary {
            
            
            if let results: AnyObject = jsonResult["results"] {
                if let geometry = results[0]["geometry"] as? NSDictionary {
                    if let location = geometry["location"] as? NSDictionary {
                        var latitude = location["lat"] as? Double
                        var longitude = location["lng"] as? Double
                        mapView.camera = GMSCameraPosition.cameraWithLatitude(CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!), zoom: 15)
                        var position = CLLocationCoordinate2DMake(latitude!, longitude!)
                        savedLocation = position
                        var marker = GMSMarker(position: position)
                        marker.title = "Start A Pace"
                        marker.map = mapView
                    }
                }
            }
        }
        
        
        
    }
    
    
}
