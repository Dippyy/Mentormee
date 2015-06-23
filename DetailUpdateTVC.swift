//
//  DetailUpdateTVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-12.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class DetailUpdateTVC: UITableViewController {
    
    var UserData:Array< String > = Array < String >()

    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        get_data_from_url("http://mentormee.info/dbTestConnect/universityProgramProgramSpecUpdate.php")

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = UserData[indexPath.row]
        return cell
    }
    
    func get_data_from_url(url:String){
        
        let urlToSend = NSURL(string:url)
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInput = prefs.valueForKey("Selection") as! String
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToSend!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
        
        if(urlData != nil){
            
            let res = response as! NSHTTPURLResponse!
            NSLog("Response Code: %ld", res.statusCode)
            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData)
            var error: NSError?
            
            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
            println("this array contains: \(jsonData.count)")
            println(jsonData[0].valueForKey("University") as! String)
            println(jsonData[1].valueForKey("Faculty") as! String)
            println(jsonData[1].valueForKey("Program") as! String)
            
            for (var i = 0; i < jsonData.count; i++){
                if let jsonData_obj = jsonData[i] as? NSDictionary
                {
                    if let userInformation = jsonData_obj[userInput] as? String
                    {
                        UserData.append(userInformation)
                        
                    }
                }
            }
            
        } else{
            println("url data is empty")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        let selection = UserData[row]
    
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("Selection") as! String == "University"){
            
//            var universityName = UserData[row]
            var uniID: Int = row + 1
            
            var userID = prefs.valueForKey("userID") as! String
            
            var post: NSString = "userID=\(userID)&universityID=\(uniID)"
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateUniversityName2.php")! //need to update university_id
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String(postData.length)
            var request: NSMutableURLRequest = NSMutableURLRequest(URL:url)
            
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            
            if(urlData != nil){
                
                let res = response as! NSHTTPURLResponse!
                NSLog("Response code: %ld", res.statusCode)
                
                if(res.statusCode >= 200 && res.statusCode < 300){
                    
                    var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData)
                    var error:NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    NSLog("Success %ld", success)
                    
                    if(success == 1){
                        NSLog("Update SUCCESS!")
                        self.performSegueWithIdentifier("goto_overview", sender: self)
                    }
                }
            }
        }
        
        if(prefs.valueForKey("Selection") as! String == "Faculty"){
            
//            var facultyName = UserData[row]
            var facultyID: Int = row + 1
            var email = prefs.valueForKey("email") as! String
            
            println(facultyID)
            
            var post: NSString = "email=\(email)&faculty=\(facultyID)"
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateFacultyName2.php")! //update program_id
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String(postData.length)
            var request: NSMutableURLRequest = NSMutableURLRequest(URL:url)
            
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            
            if(urlData != nil){
                
                let res = response as! NSHTTPURLResponse!
                NSLog("Response code: %ld", res.statusCode)
                
                if(res.statusCode >= 200 && res.statusCode < 300){
                    
                    var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData)
                    var error:NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    NSLog("Success %ld", success)
                    
                    if(success == 1){
                        NSLog("Update SUCCESS!")
                        self.performSegueWithIdentifier("goto_overview", sender: self)
                    }
                }
            }
        }
        
        if(prefs.valueForKey("Selection") as! String == "Program"){
            
//            var programName = UserData[row]
            var programID: Int = row + 1
            
            var userID = prefs.valueForKey("userID") as! String
            
            var post: NSString = "userID=\(userID)&program=\(programID)"
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateProgramName2.php")! //update program_id
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String(postData.length)
            var request: NSMutableURLRequest = NSMutableURLRequest(URL:url)
            
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            
            if(urlData != nil){
                
                let res = response as! NSHTTPURLResponse!
                NSLog("Response code: %ld", res.statusCode)
                
                if(res.statusCode >= 200 && res.statusCode < 300){
                    
                    var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData)
                    var error:NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    NSLog("Success %ld", success)
                    
                    if(success == 1){
                        NSLog("Update SUCCESS!")
                        self.performSegueWithIdentifier("goto_overview", sender: self)
                    }
                }
            }
        }
        
//        
//        let userInput = prefs.valueForKey("Selection") as! String
//                
//        var identifier:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        identifier.setObject(selection, forKey:userInput)
//        
//        self.performSegueWithIdentifier("goto_overview", sender: self)
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
