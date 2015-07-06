//
//  menteeProfileView.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-06-30.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class menteeProfileView: UIViewController {

    @IBOutlet weak var menteeProfileImageView: UIImageView!
    @IBOutlet weak var menteeFullNameLabel: UILabel!
    @IBOutlet weak var highschoolLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This setups the imageview so it appears circular
        
        menteeProfileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        menteeProfileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        menteeProfileImageView.layer.borderWidth = 1.5
        menteeProfileImageView.layer.masksToBounds = false
        menteeProfileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        menteeProfileImageView.layer.cornerRadius = menteeProfileImageView.frame.height/2
        menteeProfileImageView.clipsToBounds = true
        
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        menteeFullNameLabel.text = prefs.valueForKey("fullNameMentee") as? String
//        highschoolLabel.text = prefs.valueForKey("highSchool") as? String
//        gradeLabel.text = prefs.valueForKey("gradeOfStudy") as? String
//        menteeProfileImageView.image = UIImage(named: prefs.valueForKey("menteeProfilePicture") as! String)
        
        let mentorID = prefs.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(mentorID)"
        println(post)
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updatePublicProfileMentee.php")!
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
                
                let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                
                if let firstName: String = jsonData[0].valueForKey("FirstName") as? String {
                    let lastName: String = jsonData[0].valueForKey("LastName") as! String
                    var fullName: String = firstName + " " + lastName
                    menteeFullNameLabel.text = fullName
                }
                if let highSchool: String = jsonData[0].valueForKey("HighSchool") as? String {
                    highschoolLabel.text = highSchool
                }
                if let profilePicture: String = jsonData[0].valueForKey("Picture") as? String {
                    if (profilePicture != ""){
                    let url2 = NSURL(string: profilePicture)
                    let data = NSData(contentsOfURL: url2!)
                    menteeProfileImageView.image = UIImage(data: data!)
                    } else {
                        menteeProfileImageView.image = UIImage(named: "profile_default.jpg")
                    }
                }
                if let gradYear: String = jsonData[1].valueForKey("GraduationYear") as? String {
                    gradeLabel.text = gradYear
                }
            }
        }
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func publicProfileTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_menteepublicprofile", sender: self)
    }
    @IBAction func setupProfileTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_menteeprofileupdate", sender: self)
    }
    @IBAction func logoutTapped(sender: AnyObject) {
        
    }
    @IBAction func findNewMentorTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_newmatch", sender: self)
    }
    
}
