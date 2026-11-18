//
//  BaseParserClass.swift
//  ENT and Allergy
//
//  Created by a on 21/03/17.
//  Copyright © 2017 Shyam Future. All rights reserved.
//

import UIKit




let DashboardURL : String = "https://www.artistbabysitting.com/WebviewForceLogin/"
//let DashboardURL : String = "https://www.tailormadesitters.com/WebviewForceLogin/"

let DashboardURLLogout : String = "http://strong.tulieservices.org/wp-json/wp/v2/logout"
//let DashboardURLLogout : String = "https://www.tailormadesitters.com/WebviewForceLogout/"

let BaseUrl = "http://strong.tulieservices.org/wp-json/wp/v2/"

class BaseParserClass: NSObject {

    class func callWebService(serverUrl:String,postValues:NSDictionary,methodName:String, completionHandler:@escaping(_ finalRes:NSDictionary?)-> Void){
        
        let jsonBody =  try? JSONSerialization.data(withJSONObject: postValues, options: .prettyPrinted)
        let strToken : String = UserDefaults.standard.string(forKey: "token") ?? ""

       // let url = NSURL(string: serverUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)

       // let url1 = serverUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)

        
        let url = URL(string:serverUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)
        
        let request = NSMutableURLRequest(url: url! as URL)
        let session = URLSession.shared
        
        let string1 = "Bearer"

        let appendString = "\(string1) \(String(describing: strToken))"
        
       // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if strToken.count > 1 {
                   
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               request.addValue(appendString, forHTTPHeaderField: "Authorization")

                   
        }else{
                 
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")


        }
        
        
        request.httpMethod = methodName
        
        let validateJson = String(data: jsonBody!, encoding: .utf8)
        print(validateJson!)
        request.httpBody = validateJson?.data(using: .utf8)
        
        
    
        
        do {
            
            let task = session.dataTask(with: request as URLRequest){ data,response,error in
                
               // print("\(String(describing: data))")
              //  print("response:\(String(describing: response))")
                //print(response as Any)
                //  print(response!)
                if error != nil {
                    return
                    
                }else{
                    
                    let dataJson = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    // print(dataJson!)
                     print("response last:\(String(describing: dataJson))")
                    let responseData : NSDictionary? = dataJson as? NSDictionary ?? NSDictionary()
                    
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(responseData)
                        
                    })
                    
                }
                
            }
            
            task.resume()
            
     }
        
}
    
class func getDatafromServer (strUrl: String, method: String, completion: @escaping (_ success: Bool, _ response: NSDictionary) -> ()) {
    
        let url = URL(string:strUrl)
        
        let request = NSMutableURLRequest(url: url! as URL)
    
        request.httpMethod = method
    
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    
        let authStr: String = "enta:ec2017"
        let authData: Data? = authStr.data(using: String.Encoding.utf8)
        
        let strBase64Encoding : String = authData!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        let authValue = "Basic "+strBase64Encoding
        
        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = ["Authorization": authValue]
    
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode
                {
                    completion(true, json!)
                    
                } else {
                    
                    completion(false, json!)
             }
         }
     }.resume()
}
    
    class func callWebServiceArr(serverUrl:String,postValues:NSDictionary,methodName:String, completionHandler:@escaping(_ finalRes:NSArray)-> Void){
        
        let jsonBody =  try? JSONSerialization.data(withJSONObject: postValues, options: .prettyPrinted)
        
        let url = URL(string:serverUrl)
        
        let request = NSMutableURLRequest(url: url! as URL)
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = methodName
        
        let validateJson = String(data: jsonBody!, encoding: .utf8)
        
        request.httpBody = validateJson?.data(using: .utf8)
        
        
        
        
        do {
            
            let task = session.dataTask(with: request as URLRequest){ data,response,error in
                
                print("\(String(describing: data))")
                
                print(response as Any)
                
                if error != nil {
                    return
                    
                }else{
                    
                    let dataJson = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseData : NSArray? = dataJson as? NSArray ?? NSArray()
                    
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(responseData as? NSArray ?? NSArray())
                        
                    })
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    // MARK: GET Method
       
       
       class func getDatafromWebservice (strUrl: String, method: String, completion: @escaping ( _ success: Bool,  _ response: NSDictionary) -> ()) {
           
           
           let url = URL(string:strUrl)
           
           let request = NSMutableURLRequest(url: url! as URL)
           
           request.httpMethod = method
           
           request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
           
           let session = URLSession(configuration: URLSessionConfiguration.default)
           
           session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
               if let data = data {
                   
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                   
                   if let response = response as? HTTPURLResponse, 200...401 ~= response.statusCode {
                       
                    completion(true, json!)
                       
                   } else {
                       
                    completion(false, json!)
                   }
               }
               }.resume()
       }
       
       class func getDatafromWebserviceArr (strUrl: String, method: String, completion: @escaping ( _ success: Bool,  _ response: NSArray) -> ()) {
           
           
           let url = URL(string:strUrl)
           
           let request = NSMutableURLRequest(url: url! as URL)
           
           request.httpMethod = method
           
           request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
           
           let session = URLSession(configuration: URLSessionConfiguration.default)
           
           session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
               if let data = data {
                   
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                   
                   if let response = response as? HTTPURLResponse, 200...401 ~= response.statusCode {
                       
                       completion(true, json! )
                       
                   } else {
                       
                       completion(false, json!)
                   }
               }
               }.resume()
       }
       
    

}
