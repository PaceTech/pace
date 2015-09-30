//
//  SelectHostLocation.swift
//  Pace
//
//  Created by Tara Wilson on 7/21/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

let MapAPIKey = "AIzaSyB-gLLCMZgNJ736X2sgKYgULICXKanc23w"

class SelectHostLocation: GAITrackedViewController, UISearchBarDelegate {
    
    var firstLocationUpdate: Bool?
    let locationManager=CLLocationManager()
    var mapView: GMSMapView!
    var searchActive : Bool = false
    var searchBar : UISearchBar?
    var searchbutton: UIButton?
    var savedLocation : CLLocationCoordinate2D?
    var once = false
    var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var camera = GMSCameraPosition()
        mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50), camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        
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
        titleButton.text = "Select Run Location"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: "Oswald-Regular", size: 20)
        
        let backButton = UIButton(frame: CGRect(x: 15, y: 20, width: 20, height: 30))
        backButton.setTitleColor(tealColor, forState: .Normal)
        backButton.setTitle("<", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Oswald-Bold", size: 25)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        headerView.addSubview(backButton)
        
//        var okButton = UIButton(frame: CGRect(x: view.frame.width - 44, y: 20, width: 30, height: 40))
//        okButton.setTitle("OK", forState: .Normal)
//        okButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        okButton.addTarget(self, action: "select", forControlEvents: .TouchUpInside)
//        okButton.titleLabel!.font = UIFont(name: backButton.titleLabel!.font.fontName, size: 14)
//        headerView.addSubview(okButton)
        
        headerView.addSubview(titleButton)
        
        mapView.addSubview(headerView)
        
        searchBar = UISearchBar(frame: CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40))
        searchBar!.delegate = self
        mapView.addSubview(searchBar!)
        
        
        
        searchbutton = UIButton(frame: CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40))
        if let sb = searchbutton {
            sb.backgroundColor = UIColor.clearColor()
            sb.addTarget(self, action: "startsearch", forControlEvents: .TouchUpInside)
            mapView.addSubview(sb)
            mapView.bringSubviewToFront(sb)
        }
        
        
        joinButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 120, width: view.frame.width - 40, height: 50))
        joinButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        joinButton.backgroundColor = UIColor.grayColor()
        joinButton.setTitle("Select Location", forState: .Normal)
        joinButton.addTarget(self, action: "select", forControlEvents: .TouchUpInside)
        mapView.addSubview(joinButton)
        
        self.view = mapView
    }
    
    func startsearch() {
        searchbutton?.removeFromSuperview()
        searchBar?.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.screenName = "PaceHostLocationView"
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        firstLocationUpdate = true
        let location = change[NSKeyValueChangeNewKey] as? CLLocation
        if once == false {
            once = true
            mapView.camera = GMSCameraPosition.cameraWithTarget(location!.coordinate, zoom: 14)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    func goBack() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func select() {
        //send selected location to other view
        if let vc = navigationController?.viewControllers[0] as? SecondViewController {
            vc.location = savedLocation
            if savedLocation != nil {
                navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        searchbutton = UIButton(frame: CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40))
        if let sb = searchbutton {
            sb.backgroundColor = UIColor.clearColor()
            sb.addTarget(self, action: "startsearch", forControlEvents: .TouchUpInside)
            mapView.addSubview(sb)
            mapView.bringSubviewToFront(sb)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        mapView.clear()
        searchCoordinatesForAddress(searchBar.text)
        searchBar.text = nil
        searchbutton = UIButton(frame: CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40))
        if let sb = searchbutton {
            sb.backgroundColor = UIColor.clearColor()
            sb.addTarget(self, action: "startsearch", forControlEvents: .TouchUpInside)
            mapView.addSubview(sb)
            mapView.bringSubviewToFront(sb)
        }
        searchBar.resignFirstResponder()
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
            
            self.joinButton.backgroundColor = tealColor
            
            if let geometry = results[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    var latitude = location["lat"] as? Double
                    var longitude = location["lng"] as? Double
                    mapView.camera = GMSCameraPosition.cameraWithLatitude(CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!), zoom: 12)
                    var position = CLLocationCoordinate2DMake(latitude!, longitude!)
                    savedLocation = position
                    var marker = GMSMarker(position: position)
                    marker.title = "Start A Pace"
                    marker.icon = UIImage(named: "paceDropPin")
                    marker.map = mapView
                }
            }
        }
        }



    }
    

}
