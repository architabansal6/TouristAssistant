//
//  MapService.swift
//  Places
//
//  Created by Swasidhant Chowdhury on 04/02/16.
//  Copyright © 2016 Random. All rights reserved.
//

import Foundation
import Alamofire

class MapService {
    static var baseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
    static var firstAddressDictionary:[String:AnyObject]=[:]
    
    class func geocodeAddress(address:String!,completionHandler:((Double,Double)->Void)){
        let urlString = baseURL + "address=" + address
        
       /* Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON(completionHandler: {result in
            if result.result.error != nil{
                print("Some Error")
            }
            else{
                do{
                    let totalDictionary = result.result.value as! NSDictionary
                    let resultsArray = totalDictionary["results"] as! NSArray
                    
                    self.firstAddressDictionary = resultsArray[0] as! [String:AnyObject]//may be NSDictionary
                    
                    let formattedAddress = self.firstAddressDictionary["formatted_address"] as! String
                    let geometry = self.firstAddressDictionary["geometry"] as! Dictionary<NSObject, AnyObject>
                   let longitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
                   let latitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as!  NSNumber).doubleValue
                    completionHandler(latitude,longitude)
                }
                catch{
                    print("problem in parsing JSON")
                }
            }
        })*/
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {response,data,error in
            if error == nil{
                var result:AnyObject!
                do{
                    result = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                }
                catch{}
                let totalDictionary = result as! NSDictionary
                let resultsArray = totalDictionary["results"] as! NSArray
                
                self.firstAddressDictionary = resultsArray[0] as! [String:AnyObject]//may be NSDictionary
                
                let formattedAddress = self.firstAddressDictionary["formatted_address"] as! String
                let geometry = self.firstAddressDictionary["geometry"] as! Dictionary<NSObject, AnyObject>
                let longitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
                let latitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as!  NSNumber).doubleValue
                completionHandler(latitude,longitude)
            }
            else{
                print("error in getting polarity")
            }
        })

    }
}