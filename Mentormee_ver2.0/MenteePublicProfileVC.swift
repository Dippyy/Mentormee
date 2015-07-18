//
//  MenteePublicProfileVC.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-06-30.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class MenteePublicProfileVC: UIViewController {
    
    @IBOutlet weak var menteeProfileImageView: UIImageView!
    @IBOutlet weak var menteeFullNameLabel: UILabel!
    @IBOutlet weak var highschoolLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var whatsupTextField: UITextView!
    @IBOutlet weak var interestsTextField: UITextView!
    @IBOutlet weak var futureConsiderationsTextField: UITextView!
    @IBOutlet weak var currentSituationTextField: UITextView!

    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        myScrollView.contentSize.height = 750
        
        //This setups the imageview so it appears circular
        
        menteeProfileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        menteeProfileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        menteeProfileImageView.layer.borderWidth = 1.5
        menteeProfileImageView.layer.masksToBounds = false
        menteeProfileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        menteeProfileImageView.layer.cornerRadius = menteeProfileImageView.frame.height/2
        menteeProfileImageView.clipsToBounds = true
        
        // Call the DB to set up the profile 
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

        let menteeID: String = prefs.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(menteeID)"
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
                
                //setup fields
                
                var firstName: String = jsonData[0].valueForKey("FirstName") as! String
                var lastName: String = jsonData[0].valueForKey("LastName") as! String
                var fullName: String = firstName + " " + lastName
                
                if(firstName.isEmpty && lastName.isEmpty){
                    menteeFullNameLabel.text = "Full Name"
                } else {
                    var fullName: String = fullName
                    menteeFullNameLabel.text = fullName
                    println(fullName)
                }
                
                if let highSchoolMentee: String = jsonData[0].valueForKey("HighSchool") as? String {
                    highschoolLabel.text = highSchoolMentee
                }
                
                if let interests: String = jsonData[0].valueForKey("Interests") as? String {
                    interestsTextField.text = interests
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
                if let whatsUp: String = jsonData[1].valueForKey("WhatsUp") as? String {
                    whatsupTextField.text = whatsUp
                }
                
                if let gradeYear: String = jsonData[1].valueForKey("GraduationYear") as? String {
                   gradeLabel.text = gradeYear
                }
                
                if let currentSituation: String = jsonData[1].valueForKey("CurrentSituation") as? String {
                    currentSituationTextField.text = currentSituation
                }
                
                if let futureOptions: String = jsonData[1].valueForKey("FutureOptions") as? String {
                    futureConsiderationsTextField.text = futureOptions
                }
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
