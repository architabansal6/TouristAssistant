//
//  TwitterPolarityHelper.swift
//  MapView
//
//  Created by Swasidhant Chowdhury on 06/02/16.
//  Copyright © 2016 Archita Bansal. All rights reserved.
//

import Foundation
import OAuthSwift

class TwitterPolarityHelper{
    
    class func getTwitterStatues(query:String,completionHandler:(([Int])->Void)){
        var polarityArray:[Int]=[]
        let searchQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let client = OAuthSwiftClient(consumerKey: "U4R5oqXAxsRXhqdEcHihi4Hq9", consumerSecret: "fLPuhRjo4oG03d0nP8WjNtW8nzspJ5E9bVhPgLDWfWYsnzd9wM", accessToken: "4724379698-cZilHLQPvqHWK9mqdKjsNCpeNv2JHRE7rtdPRRj", accessTokenSecret: "qlk36vWMWAtBUj3o7pZZwADb4I8iYBMI9Wm1f9bFG6rpq")
        let searchUrl = "https://api.twitter.com/1.1/search/tweets.json?q=" + searchQuery
        client.get(searchUrl, success: {(data,response) in
            do{
                var textArray:[NSDictionary]=[]
                let searchDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
                let searchArray = searchDictionary["statuses"] as! NSArray
                for dictionaryData in searchArray{
                    let jsonDictionary = dictionaryData
                    let name = jsonDictionary["text"] as! String
                    
                    let status = ["text":name]
                    textArray.append(status)
                }
                let finalDictionary = ["data":textArray]
                self.getPolaritiesForName(finalDictionary, completionHandler:completionHandler) //{//
            }
            catch{
                print("No use")
            }
            },failure: nil)
    }
   
    class func getPolaritiesForName(inputDictionary:[String:[NSDictionary]],completionHandler:([Int]->Void)){
        var polarities:[Int]=[]
        let queue: NSOperationQueue = NSOperationQueue()
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.sentiment140.com/api/bulkClassifyJson")!)
        request.HTTPMethod = "POST"
        var requestData:NSData!
        do{
            requestData = try NSJSONSerialization.dataWithJSONObject(inputDictionary, options: .PrettyPrinted)
        }
        catch{}
        request.HTTPBody=requestData
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {response,data,error in
            if error == nil{
                do{
                    let results = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    
                    let resultsArray = results["data"] as! NSArray
                    for resultElement in resultsArray{
                        let polarity = (resultElement as! NSDictionary)["polarity"] as! Int
                        polarities.append(polarity)
                    }
                    //print(polarities)
                    completionHandler(polarities)
                }
                catch{
                    print("error in parsing polarity results")
                    completionHandler([])
                }
            }
            else{
                print("error in getting polarity")
            }
        })
        
    }
    
}