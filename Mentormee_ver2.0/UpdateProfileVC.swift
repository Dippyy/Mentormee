//
//  UpdateProfileVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-11.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//  I am making a change to this file

import UIKit

class UpdateProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let profileUpdate = ["Profile Picture","Full Name","Contact Info","University", "Faculty", "Program","What's Up", "Year","Gender"]
    let textCellIdentifier = "cell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        
//------------------------ Updates the detail text fields of the user update screen ------------------------------------------
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
//        let emailToSend = prefs.valueForKey("email") as! String
        let userID = prefs.valueForKey("userID") as! String
        
//        var post: NSString = "email=\(emailToSend)"
        var post: NSString = "userID=\(userID)"

        NSLog("PostData: %@",post);
//        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/populateSelectionTable.php")!
        var url:NSURL = NSURL(string:populateSelectionTable)!

        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String( postData.length )
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
        
        if(urlData != nil){
            let res = response as! NSHTTPURLResponse!
            NSLog("Response code: %ld", res.statusCode)
            
            if(res.statusCode >= 200 && res.statusCode < 300){
                
                var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData)
                var error:NSError?
                
                let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                
                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                prefs.setObject(jsonData[0].valueForKey("FirstName"), forKey: "First Name")
                prefs.setObject(jsonData[0].valueForKey("LastName"), forKey: "Last Name")
                var firstName: String = prefs.valueForKey("First Name") as! String
                var lastName: String = prefs.valueForKey("Last Name") as! String
                var fullName: String = firstName + " " + lastName
                prefs.setObject(fullName, forKey: "Full Name")
                
                prefs.setObject(jsonData[0].valueForKey("Picture"), forKey: "Profile Picture")
                prefs.setObject(jsonData[0].valueForKey("Gender"), forKey: "Gender")
                prefs.setObject(jsonData[0].valueForKey("Mm_Status"), forKey: "Mentor_Status2")
                
                prefs.setObject(jsonData[1].valueForKey("WhatsUp"), forKey: "Whatsup")
                prefs.setObject(jsonData[1].valueForKey("GraduationYear"), forKey: "Graduation Year")
                
                prefs.setObject(jsonData[2].valueForKey("University_id"), forKey: "UniID")
                prefs.setObject(jsonData[2].valueForKey("Program_id"), forKey: "ProgID")
                
                // ERROR HANDLER FOR NO UNIVERSITY ID ON FIRST SIGNUP
                
                if(jsonData[2].valueForKey("University_id")!.isEqualToString("0")){
                    let universityID = 1
                    prefs.setObject(universityID, forKey: "uniID2")
                } else {
                    let universityID: String = jsonData[2].valueForKey("University_id") as! String
                    let uniID: Int? = universityID.toInt()
                    prefs.setObject(uniID, forKey: "uniID2")
                }
                
                if(jsonData[2].valueForKey("Program_id")!.isEqualToString("0")){
                    let programID = 1
                    prefs.setObject(programID, forKey: "progID2")
                } else {
                    let programID: String = jsonData[2].valueForKey("Program_id") as! String
                    let progID: Int? = programID.toInt()
                    prefs.setObject(progID, forKey: "progID2")
                }
                
                let uniID = prefs.valueForKey("uniID2") as! Int
                let progID = prefs.valueForKey("progID2") as! Int
                
                var post: NSString = "universityID=\(uniID)&programID=\(progID)"
                NSLog("PostData: %@",post);
//                var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/universityLookup.php")!
                var url:NSURL = NSURL(string:universityLookup)!

                var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                var postLength:NSString = String( postData.length )
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                var responseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
                
                if(urlData != nil){
                    let res = response as! NSHTTPURLResponse!
                    NSLog("Response code: %ld", res.statusCode)
                    
                    if(res.statusCode >= 200 && res.statusCode < 300){
                        
                        var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                        NSLog("Response ==> %@", responseData)
                        var error:NSError?
                        
                        let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                        
                        prefs.setObject(jsonData[0].valueForKey("University"), forKey: "University")
                        let universitySelection = jsonData[0].valueForKey("University") as! NSString
                        
                        if (universitySelection.isEqualToString("University")) {
                            println("shit no faculty")
                            prefs.setObject(jsonData[1].valueForKey("Faculty"), forKey: "Faculty")
                        } 
                        prefs.setObject(jsonData[1].valueForKey("Program"), forKey: "Program")

                    }
                    
                }

            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileUpdate.count
    }
    
//--------------- Sets the value of the detailed text fields based on variables that are stored locally -------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = profileUpdate[row]
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(cell.textLabel?.text == "University"){
            cell.detailTextLabel?.text = prefs.valueForKey("University") as? String
            if(cell.detailTextLabel?.text == "University"){
                cell.detailTextLabel?.textColor = UIColor.redColor()
            }
        } else if(cell.textLabel?.text == "Faculty"){
            cell.detailTextLabel?.text = prefs.valueForKey("Faculty") as? String
            if(cell.detailTextLabel?.text == "Faculty"){
                cell.detailTextLabel?.textColor = UIColor.redColor()
            }
        } else if(cell.textLabel?.text == "Program"){
            cell.detailTextLabel?.text = prefs.valueForKey("Program") as? String
            if(cell.detailTextLabel?.text == "Program"){
                cell.detailTextLabel?.textColor = UIColor.redColor()
            }
        }  else if(cell.textLabel?.text == "Gender"){
            cell.detailTextLabel?.text = prefs.valueForKey("Gender") as? String
        } else if(cell.textLabel?.text == "Year"){
            
            if(prefs.valueForKey("Graduation Year") as! String == "0"){
                cell.detailTextLabel?.text = "Grad year"
            } else {
            cell.detailTextLabel?.text = prefs.valueForKey("Graduation Year") as? String
            }
            
        } else if(cell.textLabel?.text == "Full Name"){
            cell.detailTextLabel?.text = prefs.valueForKey("Full Name") as? String
        }
        
        
        else if(cell.textLabel?.text == "Profile Picture"){
            if(prefs.valueForKey("Profile Picture") as? String != ""){
                cell.detailTextLabel?.text = "Uploaded"
            } else {
                cell.detailTextLabel?.text = "Upload a Picture"
            }
        } else if(cell.textLabel?.text == "Contact Info"){
            if(prefs.valueForKey("Contact Info") as? String != ""){
                cell.detailTextLabel?.text = "Contact Info Set"
            } else {
                cell.detailTextLabel?.text = "Set Contact Info"
            }
        } else if(cell.textLabel?.text == "What's Up"){
            if(prefs.valueForKey("Whatsup") as? String != ""){
                cell.detailTextLabel?.text = "Set"
            } else {
                cell.detailTextLabel?.text = "Whats on your mind?"
            }
        }
        
        return cell
    }
    
// ------------------------------ Performs the segues based on the selected label ------------------------------------------------

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)

        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = profileUpdate[row]
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(cell.textLabel?.text == "University"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_detailupdate", sender: self)
        } else if (cell.textLabel?.text == "Faculty"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_detailupdate", sender: self)
        } else if (cell.textLabel?.text == "Program"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_detailupdate", sender: self)
        } else if (cell.textLabel?.text == "Contact Info"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_statictable", sender: self)
        } else if (cell.textLabel?.text == "Gender"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_statictable", sender: self)
        } else if (cell.textLabel?.text == "Year"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_statictable", sender: self)
        } else if (cell.textLabel?.text == "Profile Picture"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_namepicture", sender: self)
        } else if (cell.textLabel?.text == "Full Name"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_namepicture", sender: self)
        } else if (cell.textLabel?.text == "What's Up"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_namepicture", sender: self)
        }
        
    }
    
    @IBAction func backToProfileTapped(sender: AnyObject) {
        
        let storedData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let universityName: String = storedData.valueForKey("University") as! String
        println(universityName)
        let programName: String = storedData.valueForKey("Program") as! String
        println(programName)
        let facultyName: String = storedData.valueForKey("Faculty") as! String
        println(facultyName)
        
        let fullName: String = storedData.valueForKey("Full Name") as! String
        println(facultyName)
        
        if(universityName == "University" || programName == "Program" || facultyName == "Faculty" || fullName == ""){
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Wait!"
            alertView.message = "We need you to fill out your educational information before you continue!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            
        }else {
            
            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let mentorStatusChecker = prefs.valueForKey("Mentor_Status2") as! NSString
            if(mentorStatusChecker.isEqualToString("Profile Set Mentor")){
                
                let mentorStatus = prefs.valueForKey("Mentor_Status2") as! String
                let userID = prefs.valueForKey("userID") as! String
                
                updateMentorStatus(mentorStatus, userID: userID)
                self.performSegueWithIdentifier("goto_homepage", sender: self)
                
            } else {
                self.performSegueWithIdentifier("goto_homepage", sender: self)
            }
        }
    }
    
    
    
//----------------------------- saves the image url to the database under Picture -----------------------------------------
//---------------- Note: MOVE THIS LOGIC TO THE NamePictureVC WHEN THE 'SAVE' BUTTON IS PRESSED -----------------------
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        let storedData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let universityName: String = storedData.valueForKey("University") as! String
        let programName: String = storedData.valueForKey("Program") as! String
        let facultyName: String = storedData.valueForKey("Faculty") as! String
        
        if(universityName == "University" || programName == "Program" || facultyName == "Faculty"){
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Wait!"
            alertView.message = "We need you to fill out your educational information before you continue!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if let mentorStatusChecker = prefs.valueForKey("Mentor_Status2") as? NSString {
                
                if(mentorStatusChecker.isEqualToString("Profile Set Mentor")){
                
                    let mentorStatus = prefs.valueForKey("Mentor_Status2") as! String
                    let userID = prefs.valueForKey("userID") as! String
                
                    updateMentorStatus(mentorStatus, userID: userID)
                    self.performSegueWithIdentifier("goto_homepage", sender: self)
                
                } else if (mentorStatusChecker.isEqualToString("Inactive Mentor")){
                
                    let mentorStatus = "Profile Set Mentor"
                    let userID = prefs.valueForKey("userID") as! String
            
                    updateMentorStatus(mentorStatus, userID: userID)
                    self.performSegueWithIdentifier("goto_homepage", sender: self)
                }
            }
        
        if(storedData.valueForKey("ProfileImage") != nil) {
            let imageURL = storedData.valueForKey("ProfileImage") as! String
            println(imageURL)
            storedData.setObject(imageURL, forKey: "imageToSend")
        } else {
            let imageURL = storedData.valueForKey("Profile Picture") as! String
            storedData.setObject(imageURL, forKey: "imageToSend")
        }
        
        let imageURL = storedData.valueForKey("imageToSend") as! String
        var userID = storedData.valueForKey("userID") as! String
        
        println(userID)
        
        var post: NSString = "userID=\(userID)&imageURL=\(imageURL)"

//        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/saveUserInfo.php")!
        var url:NSURL = NSURL(string: saveUserInfo)!

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
                    self.performSegueWithIdentifier("goto_homepage", sender: self)
                } else {
                    var error_msg: NSString
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                        self.performSegueWithIdentifier("goto_homepage", sender: self)
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Update Failed!"
                alertView.message = "Connection Failed Here"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Connection Failure"
            if let error = responseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            }
        }
    }
    
    
    func updateMentorStatus(mentorStatus: String, userID: String) {
        
        var post: NSString = "mentorStatus=\(mentorStatus)&userID=\(userID)"
        println(post)
        var url:NSURL = NSURL(string: updateMentorStatusString)!
        
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
                    println("Status Updated")
                }
            }
        }
    }


}
