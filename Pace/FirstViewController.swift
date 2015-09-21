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


class FirstViewController: GAITrackedViewController, UISearchBarDelegate, GMSMapViewDelegate {
    
    var firstLocationUpdate: Bool?
    let locationManager=CLLocationManager()
    var mapView: GMSMapView!
    var searchActive : Bool = false
    var searchBar : UISearchBar?
    var newPace : Pace?
    var togglebutton: UIButton!
    var pacetoggle = 2
    var once = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.locationManager.requestWhenInUseAuthorization()
        var camera = GMSCameraPosition()
        mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50), camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        
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
    
        
        headerView.addSubview(titleButton)
        
        mapView.addSubview(headerView)
        
        
        let items = ["2 Hours", "Today", "All"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.frame =  CGRect(x: 30, y: 90, width: view.frame.width - 60, height: 30)
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.tintColor = darkBlueColor
        segmentedControl.addTarget(self, action: "toggle:", forControlEvents: .ValueChanged)
        mapView.addSubview(segmentedControl)
        
        self.view = mapView
        
        
    }
    
    func toggle(control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            pacetoggle = 0
            mapView.clear()
            getPaces()
        } else if control.selectedSegmentIndex == 1 {
            pacetoggle = 1
            mapView.clear()
            getPaces()
        } else {
            pacetoggle = 2
            mapView.clear()
            getPaces()
        }
       
    }
    
    func getPaces() {
        let activityind = UIActivityIndicatorView(frame: CGRect(x: view.frame.width/2 - 20, y: view.frame.height/2 - 20, width: 40, height: 40))
        activityind.tintColor = darkBlueColor
        mapView.addSubview(activityind)
        NetworkController().getPaces({paces in
            for pace in paces {
                var shoulddrop = false
                let currentDate = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
                
                var isthishour = false
                var istoday = false
                activityind.stopAnimating()
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
                                                if (components.hour - val!) < 2 {
                                                    isthishour = true
                                                } else if (components.hour - val!) < 12 {
                                                    istoday = true
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
                        if self.pacetoggle == 0 {
                            if isthishour {
                                var marker = GMSMarker(position: pace.location!)
                                marker.title = "Join Pace"
                                marker.map = self.mapView
                                marker.userData = pace
                                marker.icon = UIImage(named: "blue-run-small")
                            }
                        }
                        else if self.pacetoggle == 1 {
                            if istoday || isthishour {
                                var marker = GMSMarker(position: pace.location!)
                                marker.title = "Join Pace"
                                marker.map = self.mapView
                                marker.userData = pace
                                marker.icon = UIImage(named: "blue-run-small")
                            }
                        } else if self.pacetoggle == 2 {
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
                
                let alertController = UIAlertController(title: NSLocalizedString("Uh oh!", comment: ""), message: NSLocalizedString("Something went wrong loading the paces.", comment: ""), preferredStyle: .Alert)
                let okAction = UIAlertAction(title: NSLocalizedString("I'll check back later.", comment: ""), style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
//            mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        firstLocationUpdate = true
        let location = change[NSKeyValueChangeNewKey] as? CLLocation
        if once == false {
            once = true
            mapView.camera = GMSCameraPosition.cameraWithTarget(location!.coordinate, zoom: 14)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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
            marker.userData = pace
        }
        self.screenName = "FirstMapView"
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

