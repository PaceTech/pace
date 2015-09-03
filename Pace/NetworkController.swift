//
//  NetworkController.swift
//  Pace
//
//  Created by Tara Wilson on 8/10/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps
//
let ngrok = "http://pace-api.elasticbeanstalk.com"
let apitoken = "4c6ca03a842670fcb6fdc3712cf582934499a0eb"

//let ngrok = "http://localhost:8000"
//let apitoken = "47fc6bd1421bc8c52fb73d3dc1c5c67957d62e23"

class NetworkController: NSObject {
    
    let token = "Token " + apitoken
   
    func getUser(id: Int, successHandler:(User) -> (), failureHandler:NSError -> ()){
        let urlstring = "http://pace-api.elasticbeanstalk.com/api/v1/accounts/\(id)/"
        if let url = NSURL(string: urlstring){
            var request = NSMutableURLRequest(URL: url)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.HTTPMethod = "GET"
            NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                URLResponse, responsedata, error in
                if (error == nil) {
                    if ((URLResponse as! NSHTTPURLResponse!).statusCode == 200){
                        var jsonerror: NSError?
                        if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                            let myUser = User()
                            if let jsonDict = json as? NSDictionary {
                                myUser.firstname = jsonDict["first_name"] as? String
                                myUser.imageurl = jsonDict["image_url"] as? String
                                myUser.facebook_id = jsonDict["facebook_id"] as? String
                                myUser.username = jsonDict["email"] as? String
                                myUser.lastname = jsonDict["last_name"] as? String
                                myUser.id = jsonDict["id"] as? Int
                                successHandler(myUser)
                            }
                        }
                    }else{
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse!).statusCode, userInfo: [:]))
                    }
                }else{
                    failureHandler(error!)
                }
                
            }
        }
    }
    
    func getPaces(successHandler:([Pace]) -> (), failureHandler:NSError -> ()){
        if let url = NSURL(string: ngrok + "/api/v1/runs/"){
            var request = NSMutableURLRequest(URL: url)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.HTTPMethod = "GET"
            NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                URLResponse, responsedata, error in
                if (error == nil) {
                    if ((URLResponse as! NSHTTPURLResponse!).statusCode == 200){
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
                                        if let own = pace["owner"] as? Int {
                                            newPace.owner = String(own)
                                        }
                                        if let time = pace["runtime"] as? String {
                                            newPace.time = time
                                        }
                                        if let runners = pace["participants"] as? [AnyObject] {
                                            newPace.participants = runners
                                        }
                                        if let id = pace["id"] as? Int{
                                            newPace.id = String(id)
                                        }
                                        paces.append(newPace)
                                    }
                                }
                            }
                            successHandler(paces)
                        }
                    }else{
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse!).statusCode, userInfo: [:]))
                    }
                }else{
                    failureHandler(error!)
                }
                
            }
        }
    }

    
    func getAPace(currentpaceid: Int, successHandler:([Pace]) -> (), failureHandler:NSError -> ()){
        if let url = NSURL(string: ngrok + "/api/v1/runs/\(currentpaceid)/"){
            var request = NSMutableURLRequest(URL: url)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.HTTPMethod = "GET"
            NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                URLResponse, responsedata, error in
                if (error == nil) {
                    if ((URLResponse as! NSHTTPURLResponse!).statusCode == 200){
                        var jsonerror: NSError?
                        if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                            var paces = [Pace]()
                            if let pace = json as? NSDictionary {

                                
                                        var newPace = Pace()
                                        var dist = pace["distance"] as? String
                                        newPace.distance = dist
                                        var paceval = pace["pace"] as? String
                                        newPace.pace = paceval
                                        var lat = pace["latitute"] as? NSString
                                        var long = pace["longitude"] as? NSString
                                        let loclat = lat?.doubleValue, loclon = long?.doubleValue
                                            newPace.location = CLLocationCoordinate2DMake(loclat!, loclon!)
                                        if let own = pace["owner"] as? Int {
                                            newPace.owner = String(own)
                                        }
                                        if let time = pace["runtime"] as? String {
                                            newPace.time = time
                                        }
                                        if let runners = pace["participants"] as? [AnyObject] {
                                                newPace.participants = runners
                                        }
                                        if let id = pace["id"] as? Int{
                                           newPace.id = String(id)
                                        }
                                        paces.append(newPace)
                                    
                                }

                         successHandler(paces)
                        }
                    }else{
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse!).statusCode, userInfo: [:]))
                    }
                }else{
                    failureHandler(error!)
                }
                
            }
        }
    }

    func getMyRuns(successHandler:([Pace]) -> (), failureHandler:NSError -> ()){
        if let userid = AccountController.sharedInstance.getUser()!.id {
            if let url = NSURL(string: ngrok + "/api/v1/accounts/\(userid)/runs"){
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
                                            if let own = pace["owner"] as? Int {
                                                newPace.owner = String(own)
                                            }
                                            if let time = pace["runtime"] as? String {
                                                newPace.time = time
                                            }
                                            if let runners = pace["participants"] as? [AnyObject] {
                                                newPace.participants = runners
                                            }
                                            if let id = pace["id"] as? Int{
                                                newPace.id = String(id)
                                            }
                                            paces.append(newPace)
                                        }
                                    }
                                }
                                successHandler(paces)
                            }
                        }else{
                            failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse!).statusCode, userInfo: [:]))
                        }
                    }else{
                        failureHandler(error!)
                    }
                    
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
                    if ((URLResponse as! NSHTTPURLResponse!).statusCode == 200 || (URLResponse as! NSHTTPURLResponse!).statusCode == 201){
                        var jsonerror: NSError?
                        if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                          
                        
                            successHandler(true)
                        }
                        
                    }else{
                        println((URLResponse as! NSHTTPURLResponse!).statusCode)
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse!).statusCode, userInfo: [:]))
                    }
                } else{
                    failureHandler(error!)
                }
                
                }
            }
        }
    

    func createAccount(pace: String, successHandler:(User) -> (), failureHandler:NSError -> ()){
        if let url = NSURL(string: ngrok + "/api/v1/accounts/create/"){
            var request = NSMutableURLRequest(URL: url)
            let requestBodyData = (pace as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = requestBodyData
            request.HTTPMethod = "POST"
            
            let boundaryConstant = "----WebKitFormBoundaryE19zNvXGzXaLvS5C";
            let contentType = "multipart/form-data; boundary=" + boundaryConstant
            NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
            var jsonerror: NSError?
            
            NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()){
                URLResponse, responsedata, error in
                if (error == nil) {
                    if ((URLResponse as! NSHTTPURLResponse!).statusCode == 200 || (URLResponse as! NSHTTPURLResponse!).statusCode == 201){
                        if let jsondict: AnyObject! = NSJSONSerialization.JSONObjectWithData(responsedata, options: NSJSONReadingOptions.MutableContainers, error : &jsonerror) {
                            if let json = jsondict as? NSDictionary {
                                let user = User()
                                user.username = json["email"] as? String
                                user.firstname = json["first_name"] as? String
                                user.lastname = json["last_name"] as? String
                                user.id = json["id"] as? Int
                                user.imageurl = json["image_url"] as? String
                                user.facebook_id = json["facebook_id"] as? String
                                successHandler(user)
                            }
                            
                        }
                    }else{
                        println(URLResponse as? NSHTTPURLResponse)
                        failureHandler(NSError(domain: "HTTP response not 200", code: (URLResponse as! NSHTTPURLResponse!).statusCode, userInfo: [:]))
                    }
                }else{
                    println("error 2")
                    println(error)
                    failureHandler(error!)
                }
                
            }
        }
    }

    
    func updatePace(pace: Pace, successHandler:(Bool) -> (), failureHandler:NSError -> ()){

        
        if let id = pace.id {
    
        if let participants = pace.participants {
            
            if let accountid = AccountController.sharedInstance.getUser()?.id {
                var participantArray  = ["\(accountid)"]
            
            
            
            for participant in participants {
                    participantArray.append("\(participant)")
            }
            
            var session = NSURLSession.sharedSession()
            if let url = NSURL(string: ngrok + "/api/v1/runs/\(id)/"){
            var request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "PUT"
            
            var params = ["participants":[1,2]] as Dictionary<String, NSArray>
            
            var err: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue(token, forHTTPHeaderField: "Authorization")
            
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                println("Response: \(response)")
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                if(err != nil) {
                   
                }
                successHandler(true)

            })
            
            task.resume()
            }
            }
        }
        }
    }
    
        

    
}
