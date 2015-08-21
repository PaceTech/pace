//
//  NetworkController.swift
//  Pace
//
//  Created by Tara Wilson on 8/10/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

let ngrok = "http://b6bb48b.ngrok.com"
let apitoken = "7ae8038ed74b3edcab26eed7943a77e38167e2a6"

class NetworkController: NSObject {
    
    let token = "Token " + apitoken
   
    func getPaces(successHandler:([Pace]) -> (), failureHandler:NSError -> ()){
        if let url = NSURL(string: ngrok + "/api/v1/runs/"){
            var request = NSMutableURLRequest(URL: url)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.HTTPMethod = "GET"
            NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                URLResponse, responsedata, error in
                if (error == nil) {
                    if ((URLResponse as! NSHTTPURLResponse).statusCode == 200){
                        var jsonerror: NSError?
                        if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                            var paces = [Pace]()
                            if let jsonDict = json as? NSDictionary {
                                if let resultArray = jsonDict["results"] as? NSArray {
                                    for pace in resultArray {
                                        var newPace = Pace()
                                        var dist = pace["distance"] as? String
                                        newPace.distance = dist
                                        var paceval = pace["pace"] as? String
                                        newPace.pace = paceval
                                        var lat = pace["latitute"] as? NSString
                                        var long = pace["longitude"] as? NSString
                                        let loclat = lat?.doubleValue, loclon = long?.doubleValue
                                            newPace.location = CLLocationCoordinate2DMake(loclat!, loclon!)
                                        newPace.owner = pace["owner"] as? String
                                        newPace.participants = pace["participants"] as? [AnyObject]
                                        var paceint = pace["id"] as? Int
                                        newPace.id = String(stringInterpolationSegment: paceint)
                                        paces.append(newPace)
                                    }
                                }
                            }
                         successHandler(paces)
                        }
                    }else{
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse).statusCode, userInfo: [:]))
                    }
                }else{
                    failureHandler(error!)
                }
                
            }
        }
    }

    func createPace(pace: String, successHandler:(Bool) -> (), failureHandler:NSError -> ()){
        if let url = NSURL(string: ngrok + "/api/v1/runs/"){
            var request = NSMutableURLRequest(URL: url)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            let requestBodyData = (pace as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = requestBodyData
            request.HTTPMethod = "POST"
            
            let boundaryConstant = "----WebKitFormBoundaryE19zNvXGzXaLvS5C";
            let contentType = "multipart/form-data; boundary=" + boundaryConstant
            NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
            
            NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                URLResponse, responsedata, error in
                if (error == nil) {
                    if ((URLResponse as! NSHTTPURLResponse).statusCode == 200){
                        var jsonerror: NSError?
                        if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                            successHandler(true)
                        }
                    }else{
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse).statusCode, userInfo: [:]))
                    }
                }else{
                    failureHandler(error!)
                }
                
            }
        }
    }

    func updatePace(pace: Pace, successHandler:(Bool) -> (), failureHandler:NSError -> ()){
        var paceString = ""
        if let lat = pace.location?.latitude, lon = pace.location?.longitude, distance = pace.distance, pacespeed = pace.pace, participants = pace.participants, id = pace.id, paceowner = pace.owner {
            
            var dataString = "id=\(id)latitute=\(lat)&longitude=\(lon)&distance=\(distance)&pace=\(pacespeed)&runtime=2015-08-11T01:57:57.579870Z&owner=\(paceowner)&participants=\(AccountController.sharedInstance.userID)"
            for participant in participants {
                if let participantstring = "&participants=" + String(stringInterpolationSegment: participant) as String? {
                    dataString = dataString + participantstring
                }
            }
            paceString = dataString
            println(paceString)
            if let url = NSURL(string: ngrok + "/api/v1/runs/\(id)"){
                var request = NSMutableURLRequest(URL: url)
                request.addValue(token, forHTTPHeaderField: "Authorization")
                let requestBodyData = (paceString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                request.HTTPBody = requestBodyData
                request.HTTPMethod = "PUT"
                
                let boundaryConstant = "----WebKitFormBoundaryE19zNvXGzXaLvS5C";
                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
                
                NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                    URLResponse, responsedata, error in
                    if (error == nil) {
                        if ((URLResponse as! NSHTTPURLResponse).statusCode == 200){
                            var jsonerror: NSError?
                            if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                                successHandler(true)
                            }
                        }else{
                            failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse).statusCode, userInfo: [:]))
                        }
                    }else{
                        failureHandler(error!)
                    }
                    
                }
            }
        }
        

    }
    
        

    
}
