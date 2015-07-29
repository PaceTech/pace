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


class FirstViewController: UIViewController, UISearchBarDelegate {

    
    var firstLocationUpdate: Bool?
    let locationManager=CLLocationManager()
    var mapView: GMSMapView!
    var searchActive : Bool = false
    var searchBar : UISearchBar?
    var newPace : Pace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.locationManager.requestWhenInUseAuthorization()
        
        var camera = GMSCameraPosition.cameraWithLatitude(40.7903, longitude: -73.9597, zoom: 12)
        mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50), camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.myLocationEnabled = true
        })
        println(mapView.myLocation)
        
        tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true
        tabBarController?.tabBar.hidden = false
        tabBarController?.tabBar.tintColor = tealColor
        
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 60))
        headerView.backgroundColor = darkBlueColor
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "CLICK DROP PIN TO JOIN A PACE"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: titleButton.font.fontName, size: 14)
        
        headerView.addSubview(titleButton)
        
        searchBar = UISearchBar(frame: CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40))
        searchBar!.delegate = self
        mapView.addSubview(searchBar!)
        
        mapView.addSubview(headerView)
        
        self.view = mapView
        
    }

    func getPaces() {
        var urlString = "http://japace.com/pace/get"
        var url: NSURL = NSURL(string: urlString)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal, options: .MutableContainers, error: nil) as! NSDictionary
        
        
        if let results: AnyObject = jsonResult["data"] {
            if let paces = results["allPaces"] as? [AnyObject]{
                for pace in paces {
                    if let latmark = pace["lat"] as? NSString, lonmark = pace["long"] as? NSString {
                            var marker = GMSMarker(position: CLLocationCoordinate2DMake(latmark.doubleValue, lonmark.doubleValue))
                            marker.title = "Join Pace"
                            marker.map = mapView
                            mapView.camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 13)
                        
                    }
                }
            }
        }

    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        firstLocationUpdate = true
        let location = change[NSKeyValueChangeNewKey] as! CLLocation
        
//        mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 14)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidAppear(animated: Bool) {
        getPaces()
        if let pace = newPace {
            var marker = GMSMarker(position: pace.location!)
            marker.title = "Your new pace!"
            marker.map = mapView
            mapView.camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 13)
        }
//        searchBar?.becomeFirstResponder()
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        println(searchBar.text)
        searchBar.resignFirstResponder()
    }


}

