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
        
        // NAV BAR PROPERTIES
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        nav?.barTintColor = UIColor.whiteColor()
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        // POPULATE TABLE VIEW
        

        let selection = prefs.valueForKey("Selection") as! String
        
        if(selection == "University"){
            get_data_from_university(universityUpdate)
        } else if(selection == "Program" || selection == "Faculty"){
            
            
            //        get_data_from_url("http://mentormee.info/dbTestConnect/programUpdate.php")
            get_data_from_url(programUpdate)
            
        }


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

// -------------- Reads through Program_Data/University_Data tables and puts the contents into an array ----------------------
    
    func get_data_from_url(url:String){
        
        let urlToSend = NSURL(string:url)
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInput = prefs.valueForKey("Selection") as! String
        let universityName = prefs.valueForKey("UniID") as! String
        
        if let facultyText = prefs.valueForKey("Faculty") as? String {
            prefs.setObject(facultyText, forKey: "Faculty")
//            let facultyText = prefs.valueForKey("Faculty") as! String
        } else {
            prefs.setObject("Faculty", forKey: "Faculty")
//            let facultyText = "Faculty"
        }
        
        let facultyText = prefs.valueForKey("Faculty") as! String
        
        var post: NSString = "selection=\(userInput)&universityID=\(universityName)&facultyText=\(facultyText)"
        NSLog("PostData: %@",post);
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String( postData.length )
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToSend!)
        
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
            NSLog("Response Code: %ld", res.statusCode)
            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData)
            var error: NSError?
            
            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
    
            for (var i = 0; i < jsonData.count; i++){
                if let jsonData_obj = jsonData[i] as? NSDictionary
                {
                    if let userInformation = jsonData_obj[userInput] as? String
                    {
                        UserData.append(userInformation)
                        
                    }
                }
            }
        }
    }
    
    func get_data_from_university(url: String) {
        
        let urlToSend = NSURL(string:url)
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInput = prefs.valueForKey("Selection") as! String
        var post: NSString = "selection=\(userInput)"
        NSLog("PostData: %@",post);
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String( postData.length )
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToSend!)
        
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
            NSLog("Response Code: %ld", res.statusCode)
            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData)
            var error: NSError?
            
            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
            
            for (var i = 0; i < jsonData.count; i++){
                if let jsonData_obj = jsonData[i] as? NSDictionary
                {
                    if let userInformation = jsonData_obj[userInput] as? String
                    {
                        UserData.append(userInformation)
                        
                    }
                }
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        let selection = UserData[row]
        let count = UserData.count
    
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        
// If the user selects University the selected university_id will be saved in the mentors capabilities table
        if(prefs.valueForKey("Selection") as! String == "University"){
            
//            var universityName = UserData[row]
            
            //THIS IS THE PROBLEM
            var uniID: Int = row + 1
            
            var userID = prefs.valueForKey("userID") as! String
            var post: NSString = "userID=\(userID)&universityID=\(uniID)"
            
            println(post)
            
//            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateUniversityName2.php")! //need to update university_id
            
            var url:NSURL = NSURL(string: updateUniversityName2)! //need to update university_id

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
        
// If the user selects Faculty the selected program_id will be saved in the mentors capabilities table
        
        if(prefs.valueForKey("Selection") as! String == "Faculty"){
            
//            var facultyID: Int = row + 1
            var facultyText: String = UserData[row]
            println("THIS IS THE TEXT \(facultyText)")
            prefs.setObject(facultyText, forKey: "Faculty")
            
            self.performSegueWithIdentifier("goto_overview", sender: self)


        }
        
// If the user selects Program the selected program_id will be saved in the mentors capabilities table
        
        if(prefs.valueForKey("Selection") as! String == "Program"){
            
          var programName = UserData[row]
//            var programID: Int = row + 1
            
            let programID = retrieve_program_id(programName)
            
            println("WE ARE HERERERERERER \(programID)")
            
            var userID = prefs.valueForKey("userID") as! String
            
            var post: NSString = "userID=\(userID)&program=\(programID)"
//            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateProgramName2.php")! //update program_id
            
            var url:NSURL = NSURL(string: updateProgramName2)! //update program_id

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
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func retrieve_program_id(programName: String) -> String {
        
        var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userID = prefs.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(userID)&program=\(programName)"
        println(post)
        
        var url:NSURL = NSURL(string: grabProgramID)! //update program_id
        
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
                let jsonData:NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
                
                NSLog("Update SUCCESS!")
                return jsonData[0].valueForKey("Program_id") as! String
            }
            
        }
        return "oops"
    }

    
//    func updateFaculty(userSelection: String){
//        
//        var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        var userID = prefs.valueForKey("userID") as! String
//        
//        var post: NSString = "userID=\(userID)&faculty=\(userSelection)"
//        println(post)
//        
//        var url:NSURL = NSURL(string: updateFacultyScript)!
//        
//        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//        var postLength:NSString = String(postData.length)
//        var request: NSMutableURLRequest = NSMutableURLRequest(URL:url)
//        
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postData
//        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        var responseError: NSError?
//        var response: NSURLResponse?
//        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
//        
//        if(urlData != nil){
//            
//            let res = response as! NSHTTPURLResponse!
//            NSLog("Response code: %ld", res.statusCode)
//            
//            if(res.statusCode >= 200 && res.statusCode < 300){
//                
//                var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
//                NSLog("Response ==> %@", responseData)
//                var error:NSError?
//                let jsonData:NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
//                
//                    NSLog("Update SUCCESS!")
//            }
//        }
//    }

}
