//
//  HomeScreenVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-10.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

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
        
        UIView.animateWithDuration(1.5, animations: {
            self.profileImageView.alpha = 1.0
            self.fullNameLabel.alpha = 1.0
            self.universityNameLabel.alpha = 1.0
            self.programNameLabel.alpha = 1.0
        })
        
        
        let prefs1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        let emailToSend: String = "robert.dippolito@email.com"
        
        if(prefs1.valueForKey("email") == nil){
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
        
        let emailToSend = prefs1.valueForKey("email") as! String
        
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
                
                var firstName: String = jsonData[0].valueForKey("full_name") as! String
                if(firstName != ""){
                    var fullName: String = firstName
                    fullNameLabel.text = fullName
                    println(fullName)
                } else {
                    fullNameLabel.text = "Full Name"
                }
                
                var program: String = jsonData[0].valueForKey("program") as! String
                if(program != ""){
                    programNameLabel.text = program
                    println(program)
                } else {
                    programNameLabel.text = "Program of Study"
                }
                
                var universityName: String = jsonData[0].valueForKey("university_name") as! String
                if(universityName != "") {
                universityNameLabel.text = universityName
                println(universityName)
                } else {
                    universityNameLabel.text = "University"
                }
                                
                if(jsonData[0].valueForKey("picture") as! String != "") {
                    let imageURL = jsonData[0].valueForKey("picture") as! String
                    var url = NSURL(string: imageURL)
                    var data = NSData(contentsOfURL: url!)
                    profileImageView.image = UIImage(data:data!)
                } else {
                    profileImageView.image = (UIImage(named: "profile_default.jpg"))
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
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
