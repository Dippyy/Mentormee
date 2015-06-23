//
//  UpdateProfileVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-11.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class UpdateProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let profileUpdate = ["Profile Picture","Full Name","University", "Faculty", "Program","Whatsup", "Year","Gender"]
    let textCellIdentifier = "cell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let emailToSend = prefs.valueForKey("email") as! String
        
        var post: NSString = "email=\(emailToSend)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/profilePopulateScript2.php")!
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
                
                prefs.setObject(jsonData[0].valueForKey("university_name"), forKey: "University")
                prefs.setObject(jsonData[0].valueForKey("program"), forKey: "Faculty")
                prefs.setObject(jsonData[0].valueForKey("program_detailed"), forKey: "Program")
                prefs.setObject(jsonData[0].valueForKey("year"), forKey: "Year_Selected")
                prefs.setObject(jsonData[0].valueForKey("gender"), forKey: "Gender_Selected")
                
                prefs.setObject(jsonData[0].valueForKey("full_name"), forKey: "Full_Name_Selected")
                prefs.setObject(jsonData[0].valueForKey("extra"), forKey: "Whatsup")
                prefs.setObject(jsonData[0].valueForKey("picture"), forKey: "Profile Picture")
//                println(prefs.valueForKey("Profile Picture") as! String)

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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = profileUpdate[row]
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(cell.textLabel?.text == "University"){
            cell.detailTextLabel?.text = prefs.valueForKey("University") as? String
        } else if(cell.textLabel?.text == "Faculty"){
            cell.detailTextLabel?.text = prefs.valueForKey("Faculty") as? String
        } else if(cell.textLabel?.text == "Program"){
            cell.detailTextLabel?.text = prefs.valueForKey("Program") as? String
        }  else if(cell.textLabel?.text == "Gender"){
            cell.detailTextLabel?.text = prefs.valueForKey("Gender_Selected") as? String
        } else if(cell.textLabel?.text == "Year"){
            cell.detailTextLabel?.text = prefs.valueForKey("Year_Selected") as? String
        } else if(cell.textLabel?.text == "Full Name"){
            cell.detailTextLabel?.text = prefs.valueForKey("Full_Name_Selected") as? String
        }
        
        
        else if(cell.textLabel?.text == "Profile Picture"){
            if(prefs.valueForKey("Profile Picture") as? String != ""){
                cell.detailTextLabel?.text = "Uploaded"
            } else {
                cell.detailTextLabel?.text = "Upload a Picture"
            }
        } else if(cell.textLabel?.text == "Whatsup"){
            if(prefs.valueForKey("Whatsup") != nil){
                cell.detailTextLabel?.text = "Set"
            } else {
                cell.detailTextLabel?.text = "Whats on your mind?"
            }
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)

        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = profileUpdate[row]
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(cell.textLabel?.text == "University"){
            cell.textLabel?.text = profileUpdate[row]
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_detailupdate", sender: self)
        } else if (cell.textLabel?.text == "Faculty"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_detailupdate", sender: self)
        } else if (cell.textLabel?.text == "Program"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_detailupdate", sender: self)
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
        } else if (cell.textLabel?.text == "Whatsup"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_namepicture", sender: self)
        }
        
    }
    @IBAction func backToProfileTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        let storedData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(storedData.valueForKey("ProfileImage") != nil) {
            let imageURL = storedData.valueForKey("ProfileImage") as! String
            println(imageURL)
            storedData.setObject(imageURL, forKey: "imageToSend")
//        var imageToSend = "http://mentormee.info/dbTestConnect/userprofilepic/uploads/2015/\(imageURL)"
        } else {
            let imageURL = storedData.valueForKey("Profile Picture") as! String
            storedData.setObject(imageURL, forKey: "imageToSend")
        }
        
        let imageURL = storedData.valueForKey("imageToSend") as! String
        
        var fullName = storedData.valueForKey("Full_Name_Selected") as! String
        var universityName = storedData.valueForKey("University") as! String
        var facultyName = storedData.valueForKey("Faculty") as! String
        var programName = storedData.valueForKey("Program") as! String
        var yearOfStudy = storedData.valueForKey("Year_Selected") as! String
        var genderSelected = storedData.valueForKey("Gender_Selected") as! String
        var whatsup = storedData.valueForKey("Whatsup") as! String
        var emailIdentifier = storedData.valueForKey("email") as! String
        
        var post: NSString = "email=\(emailIdentifier)&imageURL=\(imageURL)&fullName=\(fullName)&universityName=\(universityName)&faculty=\(facultyName)&program=\(programName)&yearOfStudy=\(yearOfStudy)&genderSelect=\(genderSelected)&whatsup=\(whatsup)"

        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateProfile2.php")!
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
//                    var alertView:UIAlertView = UIAlertView()
//                    alertView.title = "Signup Failed"
//                    alertView.message = error_msg as String
//                    alertView.delegate = self
//                    alertView.addButtonWithTitle("OK")
//                    alertView.show()
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
