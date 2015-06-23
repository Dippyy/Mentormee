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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        profileImageView.alpha = 0
        fullNameLabel.alpha = 0
        universityNameLabel.alpha = 0
        programNameLabel.alpha = 0
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible=false
        
        UIView.animateWithDuration(0, animations: {
            self.profileImageView.alpha = 1.0
            self.fullNameLabel.alpha = 1.0
            self.universityNameLabel.alpha = 1.0
            self.programNameLabel.alpha = 1.0
        })
        
        
        let prefs1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs1.valueForKey("userID") == nil){
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
        
//        let emailToSend = prefs1.valueForKey("email") as! String
        let userID = prefs1.valueForKey("userID") as! String
        
//        var post: NSString = "email=\(emailToSend)"
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
                
                var firstName: String = jsonData[0].valueForKey("FirstName") as! String
                var lastName: String = jsonData[0].valueForKey("LastName") as! String
                var fullName: String = firstName + " " + lastName
                
                if(fullName != ""){
                    var fullName: String = fullName
                    fullNameLabel.text = fullName
                    println(fullName)
                } else {
                    fullNameLabel.text = "Full Name"
                }
                
                var universityID: String = jsonData[1].valueForKey("University_id") as! String // converts the strings to ints
                var programID: String = jsonData[1].valueForKey("Program_id") as! String
                let uniID: Int? = universityID.toInt()
                let progID: Int? = programID.toInt()
                
                var post: NSString = "universityID=\(uniID!)&programID=\(progID!)"
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
                            programNameLabel.text = program
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
        
        profileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true

        
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
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
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        fullNameLabel.text = ""
        universityNameLabel.text = ""
        programNameLabel.text = ""
        profileImageView.image = UIImage(named: "profile_default.jpg")
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
