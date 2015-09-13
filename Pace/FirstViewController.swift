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


class FirstViewController: UIViewController, UISearchBarDelegate, GMSMapViewDelegate {
    
    var firstLocationUpdate: Bool?
    let locationManager=CLLocationManager()
    var mapView: GMSMapView!
    var searchActive : Bool = false
    var searchBar : UISearchBar?
    var newPace : Pace?
    var togglebutton: UIButton!
    var pacetoggle = false
    
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
        mapView.delegate = self
        
        tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true
        tabBarController?.tabBar.hidden = false
        tabBarController?.tabBar.tintColor = tealColor
        
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        
        var titleButton = UILabel(frame: CGRectMake(20, 24, view.frame.width - 40, 30))
        titleButton.text = "CLICK DROP PIN TO JOIN A PACE"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: titleButton.font.fontName, size: 14)
        
        togglebutton = UIButton(frame: CGRectMake(view.frame.width - 80, 24, 80, 30))
        togglebutton.setTitle("Soon", forState: .Normal)
        togglebutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        togglebutton.addTarget(self, action: "toggle", forControlEvents: .TouchUpInside)
        headerView.addSubview(togglebutton)
        
        headerView.addSubview(titleButton)
        
        //        searchBar = UISearchBar(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40))
        //        searchBar!.delegate = self
        //        mapView.addSubview(searchBar!)
        
        mapView.addSubview(headerView)
        
        self.view = mapView
        
    }
    
    func toggle() {
        if togglebutton.titleLabel?.text == "Soon" {
            pacetoggle = true
            togglebutton.setTitle("Always", forState: .Normal)
            mapView.clear()
            getPaces()
        } else {
            pacetoggle = false
            togglebutton.setTitle("Soon", forState: .Normal)
            mapView.clear()
            getPaces()
        }
    }
    
    func getPaces() {
        NetworkController().getPaces({paces in
            for pace in paces {
                var shoulddrop = false
                let currentDate = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
                
                var isgreen = false
                
                if let timestring = pace.time as NSString? {
                    let arr = timestring.componentsSeparatedByString("T")
                    let date = arr[0].componentsSeparatedByString("-")
                    let time = arr[1].componentsSeparatedByString(":")
                    if let year = date[0] as? String {
                        var val = year.toInt()
                        if val < components.year {
                            shoulddrop = true
                        } else if val == components.year {
                            if let month = date[1] as? String {
                                var val = month.toInt()
                                if val < components.month {
                                    shoulddrop = true
                                } else if val == components.month {
                                    if let day = date[2] as? String {
                                        var val = day.toInt()
                                        if val < components.day {
                                            shoulddrop = true
                                        } else if val == components.day {
                                            if let hour = time[0] as? String {
                                                if (components.hour - val!) < 12 {
                                                    isgreen = true
                                                }
                                                var val = hour.toInt()
                                                if val < components.hour {
                                                    shoulddrop = true
                                                } else if val == components.hour {
                                                    if let min = time[1] as? String {
                                                        var val = min.toInt()
                                                        if val < components.minute {
                                                            shoulddrop = true
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    if shoulddrop {
                    } else {
                        if self.pacetoggle {
                            if isgreen {
                                var marker = GMSMarker(position: pace.location!)
                                marker.title = "Join Pace"
                                marker.map = self.mapView
                                marker.userData = pace
                                marker.icon = UIImage(named: "blue-run-small")
                            }
                        } else {
                            var marker = GMSMarker(position: pace.location!)
                            marker.title = "Join Pace"
                            marker.map = self.mapView
                            marker.userData = pace
                            marker.icon = UIImage(named: "blue-run-small")
                        }
                        
                    }
                    
                    
                }
            }
            
            }, failureHandler: {
                error in
                println(error)
                
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        //        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        firstLocationUpdate = true
        let location = change[NSKeyValueChangeNewKey] as? CLLocation
        
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
            marker.icon = UIImage(named: "blue-run-small")
            mapView.camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 13)
            marker.userData = pace
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
        searchBar.resignFirstResponder()
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let vc = PaceDetailViewController()
        vc.paceInfo = marker.userData as? Pace
        navigationController?.pushViewController(vc, animated: true)
        return true
    }
    
    
    
    
}

