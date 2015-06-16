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
    
    let profileUpdate = ["Profile Picture","Full Name","University", "Faculty", "Program", "Year","Gender"]
    let textCellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self


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
        
        if(prefs.objectForKey("University") != nil){
            let universityName = prefs.valueForKey("University") as! String
            if(cell.textLabel?.text == "University"){
                cell.detailTextLabel?.text = universityName
                return cell
            }
        }
        
        if(prefs.objectForKey("Faculty") != nil){
            let facultyName = prefs.valueForKey("Faculty") as! String
            if(cell.textLabel?.text == "Faculty"){
                cell.detailTextLabel?.text = facultyName
                return cell
            }
        }
        
        if(prefs.objectForKey("Program") != nil){
            let facultyName = prefs.valueForKey("Program") as! String
            if(cell.textLabel?.text == "Program"){
                cell.detailTextLabel?.text = facultyName
                return cell
            }
        }
        
        if(prefs.objectForKey("Year_Selected") != nil){
            let yearOfStudy = prefs.valueForKey("Year_Selected") as! String
            if(cell.textLabel?.text == "Year"){
                cell.detailTextLabel?.text = yearOfStudy
                return cell
            }
        }
        
        if(prefs.objectForKey("Gender_Selected") != nil){
            let gender = prefs.valueForKey("Gender_Selected") as! String
            if(cell.textLabel?.text == "Gender"){
                cell.detailTextLabel?.text = gender
                return cell
            }
        }
        
        if(prefs.objectForKey("Full_Name_Selected") != nil){
            let fullName = prefs.valueForKey("Full_Name_Selected") as! String
            if(cell.textLabel?.text == "Full Name"){
                cell.detailTextLabel?.text = fullName
                return cell
            }
        }
        
        if(prefs.objectForKey("Upload") != nil){
            let uploadSuccess = prefs.valueForKey("Upload") as! String
            if(cell.textLabel?.text == "Profile Picture"){
                cell.detailTextLabel?.text = uploadSuccess
                return cell
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
        }
        
    }
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        let storedData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let imageURL = storedData.valueForKey("imageURL") as! String
        println(imageURL)
        var imageToSend = "http://mentormee.info/dbTestConnect/userprofilepic/uploads/2015/\(imageURL)"
        println(imageToSend)
//        storedData.setObject(imageToSend, forKey: "ProfilePicture")
        let fullName = storedData.valueForKey("Full_Name_Selected") as! String
        println(fullName)
        let universityName = storedData.valueForKey("university") as! String
        println(universityName)
        let facultyName = storedData.valueForKey("Faculty") as! String
        println(facultyName)
        let programName = storedData.valueForKey("Program") as! String
        println(programName)
        let yearOfStudy = storedData.valueForKey("Year_Selected") as! String
        println(yearOfStudy)
        let genderSelected = storedData.valueForKey("Gender_Selected") as! String
        println(genderSelected)
        let emailIdentifier = storedData.valueForKey("email") as! String
        println(emailIdentifier)
        
        println("\(imageToSend)")
        
        var post: NSString = "email=\(emailIdentifier)&imageURL=\(imageToSend)&fullName=\(fullName)&universityName=\(universityName)&faculty=\(facultyName)&program=\(programName)&yearOfStudy=\(yearOfStudy)&genderSelect=\(genderSelected)"
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
                self.performSegueWithIdentifier("goto_homepage", sender: self)
                
                if(success == 1){
                    NSLog("Update SUCCESS!")
                    self.performSegueWithIdentifier("editto_home", sender: self)
                } else {
                    var error_msg: NSString
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Signup Failed"
                    alertView.message = error_msg as String
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
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
