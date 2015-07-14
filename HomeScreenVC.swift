//
//  HomeScreenVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-10.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//  Alex test merge

import UIKit

class HomeScreenVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var ViewProfileButton: UIButton!
    @IBOutlet weak var SetUpProfileButton: UIButton!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var signUpLabelToSignup: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        profileImageView.alpha = 0
        fullNameLabel.alpha = 0
        universityNameLabel.alpha = 0
        programNameLabel.alpha = 0
        ViewProfileButton.alpha = 0
        SetUpProfileButton.alpha = 0
        LogoutButton.alpha = 0
        signUpLabelToSignup.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible=false
    
        UIView.animateWithDuration(1, animations: {
            self.profileImageView.alpha = 1.0
            self.fullNameLabel.alpha = 1.0
            self.universityNameLabel.alpha = 1.0
            self.programNameLabel.alpha = 1.0
            self.ViewProfileButton.alpha = 1.0
            self.SetUpProfileButton.alpha = 1.0
            self.LogoutButton.alpha = 1.0
        })
        
        let prefs1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs1.valueForKey("userID") == nil){
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
        
        let userID = prefs1.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(userID)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/homeScreenUpdate2.php")!
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
                
                // ERROR HANDLER FOR FULL NAME

                    var firstName: String = jsonData[0].valueForKey("FirstName") as! String
                    var lastName: String = jsonData[0].valueForKey("LastName") as! String
                    var fullName: String = firstName + " " + lastName
                
                    if(firstName.isEmpty && lastName.isEmpty){
                        fullNameLabel.text = "Full Name"
                    } else {
                        var fullName: String = fullName
                        fullNameLabel.text = fullName
                        println(fullName)
                    }
                
                // ERROR HANDLER FOR PROFILE PICTURE
                    if(jsonData[0].valueForKey("Picture")!.isEqualToString("")){
                
                        profileImageView.image = UIImage(named: "profile_default.jpg")

                    }   else {
                
                            let imageString: String = jsonData[0].valueForKey("Picture") as! String
                            let url2 = NSURL(string: imageString)
                            let data = NSData(contentsOfURL: url2!)
                            profileImageView.image = UIImage(data: data!)
                    }
                
                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                  // ERROR HANDLER FOR NO UNIVERSITY ID & PROGRAM ID ON FIRST SIGNUP
                
                if(jsonData[1].valueForKey("University_id")!.isEqualToString("0")){
                    let universityID = 1
                    prefs.setObject(universityID, forKey: "uniID")
                    
                    signUpLabelToSignup.hidden = false
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "First Login Mentor"
                    alertView.message = "We noticed you have not set your University / Program yet! To help us match you with a mentee please set these fields!"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                } else {
                                    
                    let universityID: String = jsonData[1].valueForKey("University_id") as! String
                    let uniID: Int? = universityID.toInt()
                    prefs.setObject(uniID, forKey: "uniID")
                }
                
                if(jsonData[1].valueForKey("Program_id")!.isEqualToString("0")){
                    let programID = 1
                    prefs.setObject(programID, forKey: "progID")
                } else {
                    let programID: String = jsonData[1].valueForKey("Program_id") as! String
                    let progID: Int? = programID.toInt()
                    prefs.setObject(progID, forKey: "progID")
                }
        
                
                let uniID = prefs.valueForKey("uniID") as! Int
                let progID = prefs.valueForKey("progID") as! Int
                
                var post: NSString = "universityID=\(uniID)&programID=\(progID)"
                NSLog("PostData: %@",post);
                var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/universityLookup.php")!
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
                        
                        var program: String = jsonData[1].valueForKey("Program") as! String
                        println(program)
                        if(program != ""){
                            programNameLabel.text = program + " Engineering"
                            println(program)
                        } else {
                            programNameLabel.text = "Program of Study"
                        }

                        var universityName: String = jsonData[0].valueForKey("University") as! String
                        println(universityName)
                        if(universityName != "") {
                            universityNameLabel.text = universityName
                            println(universityName)
                        } else {
                            universityNameLabel.text = "University"
                        }
                        
                    }
                }
            }
        }
        
        //MAKES THE IMAGEVIEW CIRCULAR
        profileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true

        
        //Checks to see if the user has logged in before, if not it will take the user to the login screen
//        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        var isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
//        if (isLoggedIn != 1) {
//            self.performSegueWithIdentifier("goto_login", sender: self)
//        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func viewPublicProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_reviews", sender: self)
    }
    @IBAction func setupProfileTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_profileupdate", sender: self)
    }
    @IBAction func viewActiveMenteesTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_mentee", sender: self)
    }
    
    // clears the fields in the mentor home screen and all variables stored locally
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        fullNameLabel.text = ""
        universityNameLabel.text = ""
        programNameLabel.text = ""
        profileImageView.image = UIImage(named: "profile_default.jpg")
        
        let clearAllKeys: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        clearAllKeys.removeObjectForKey("Status")
        clearAllKeys.removeObjectForKey("ProfileImage")

        
        //        clearAllKeys.removeObjectForKey("picture")
        //        clearAllKeys.removeObjectForKey("ProfileImage")
        //        clearAllKeys.removeObjectForKey("Full_Name_Selected")
        //        clearAllKeys.removeObjectForKey("University")
        //        clearAllKeys.removeObjectForKey("Faculty")
        //        clearAllKeys.removeObjectForKey("Program")
        //        clearAllKeys.removeObjectForKey("Year_Selected")
        //        clearAllKeys.removeObjectForKey("Gender_Selected")
        
//        self.performSegueWithIdentifier("goto_login", sender: self)
        self.performSegueWithIdentifier("goto_TEMPSEGUE", sender: self)

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
