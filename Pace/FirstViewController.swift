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
let tealColor = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)


class FirstViewController: GAITrackedViewController, UISearchBarDelegate, GMSMapViewDelegate {
    
    var firstLocationUpdate: Bool?
    let locationManager=CLLocationManager()
    var mapView: GMSMapView!
    var searchActive : Bool = false
    var searchBar : UISearchBar?
    var searchbutton: UIButton?
    var newPace : Pace?
    var togglebutton: UIButton!
    var pacetoggle = 2
    var once = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        var camera = GMSCameraPosition()
        mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50), camera: camera)
        mapView.settings.myLocationButton = true
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.myLocationEnabled = true
        })
        mapView.delegate = self
        
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
        
        tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true
        tabBarController?.tabBar.hidden = false
        tabBarController?.tabBar.tintColor = tealColor
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 70))
        headerView.backgroundColor = darkBlueColor
        var titleButton = UILabel(frame: CGRectMake(20, 28, view.frame.width - 40, 30))
        titleButton.text = "Join A Run"
        titleButton.textAlignment = .Center
        titleButton.textColor = UIColor.whiteColor()
        titleButton.font = UIFont(name: "Oswald-Regular", size: 20)
        headerView.addSubview(titleButton)
        mapView.addSubview(headerView)
        
        let items = ["2 Hours", "Today", "All"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.frame =  CGRect(x: 30, y: view.frame.height - 90, width: view.frame.width - 60, height: 30)
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.tintColor = tealColor
        segmentedControl.addTarget(self, action: "toggle:", forControlEvents: .ValueChanged)
        mapView.addSubview(segmentedControl)
        
        self.view = mapView
        
    }
    
    func toggle(control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            pacetoggle = 0
        } else if control.selectedSegmentIndex == 1 {
            pacetoggle = 1
        } else {
            pacetoggle = 2
        }
        mapView.clear()
        getPaces()
    }
    
    var page = 1
    var paginatedone = false
    
    func getPaces() {

   
            NetworkController().getPaces(page, successHandler: {paces in
                print(paces.count)
                for pace in paces {
                    var shoulddrop = false
                    
                    var isthishour = false
                    var istoday = false
                    if let timestring = pace.time as NSString? {
                        let arr = timestring.componentsSeparatedByString("T")
                        let date = arr[0].componentsSeparatedByString("-")
                        let time = arr[1].componentsSeparatedByString(":")
                        
                        var yeardifference = self.yearDiff(date[0] as? String)
                        var monthdifference = self.monthDiff(date[1] as? String)
                        var daydifference = self.dayDiff(date[2] as? String)
                        var hourdifference = self.hourDiff(time[0] as? String)
                        var mindifference = self.minDiff(time[1] as? String)
                        
                        if yeardifference < 0 {
                            shoulddrop = true
                        } else if yeardifference == 0 {
                            if monthdifference < 0 {
                                shoulddrop = true
                            } else if monthdifference == 0 {
                                if daydifference < 0 {
                                    shoulddrop = true
                                } else if daydifference == 0 {
                                    istoday = true
                                    if hourdifference < 2 && mindifference > 0 {
                                        isthishour = true
                                    }
                                    if hourdifference < 0 {
                                        
                                    } else if hourdifference == 0 {
                                        if mindifference < 0 {
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        if let runners = pace.participants {
                            for runner in runners {
                                if "\(runner)" == "18" {
                                    shoulddrop = true
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
                                    marker.icon = UIImage(named: "paceDropPin")
                                }
                            }
                            else if self.pacetoggle == 1 {
                                if istoday || isthishour {
                                    var marker = GMSMarker(position: pace.location!)
                                    marker.title = "Join Pace"
                                    marker.map = self.mapView
                                    marker.userData = pace
                                    marker.icon = UIImage(named: "paceDropPin")
                                }
                            } else if self.pacetoggle == 2 {
                                var marker = GMSMarker(position: pace.location!)
                                marker.title = "Join Pace"
                                marker.map = self.mapView
                                marker.userData = pace
                                marker.icon = UIImage(named: "paceDropPin")
                            }
                            
                        }
                        
                        
                    }
                }
                if paces.count == 10 {
                    self.page++
                    self.getPaces()
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
    
    func yearDiff(year: String?) -> Int {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
        return (year!.toInt()! - components.year)
    }
    
    func monthDiff(month: String?) -> Int {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
        return (month!.toInt()! - components.month)
    }
    
    func dayDiff(day: String?) -> Int {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
        return (day!.toInt()! - components.day)
    }
    
    func hourDiff(hour: String?) -> Int {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
        return (hour!.toInt()! - components.hour)
    }
    
    func minDiff(min: String?) -> Int {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate:  NSDate())
        return (min!.toInt()! - components.minute)
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.removeObserver(self, forKeyPath: "myLocation")
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
        self.screenName = "FirstMapView"
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
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
                if let geometry = results[0]["geometry"] as? NSDictionary {
                    if let location = geometry["location"] as? NSDictionary {
                        var latitude = location["lat"] as? Double
                        var longitude = location["lng"] as? Double
                        mapView.camera = GMSCameraPosition.cameraWithLatitude(CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!), zoom: 11)
                        var position = CLLocationCoordinate2DMake(latitude!, longitude!)
                        
                        getPaces()
                    }
                }
            }
        }
        
        
        
    }
    
    func startsearch() {
        searchbutton?.removeFromSuperview()
        searchBar?.becomeFirstResponder()
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let vc = PaceDetailViewController()
        vc.paceInfo = marker.userData as? Pace
        navigationController?.pushViewController(vc, animated: true)
        return true
    }
    
    
    
    
}

