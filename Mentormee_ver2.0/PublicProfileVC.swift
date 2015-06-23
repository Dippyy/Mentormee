//
//  PublicProfileVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-16.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class PublicProfileVC: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var whatsupLabel: UILabel!
    @IBOutlet weak var whatsupText: UITextView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var menteeReviewLabel: UILabel!
    @IBOutlet weak var menteeReviewText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.contentSize.height = 750
        
        profileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        let storedData:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let emailIdentifier = storedData.valueForKey("email") as! String
        
        var post: NSString = "email=\(emailIdentifier)"
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updatePublicProfile.php")!
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
                
                
                if(jsonData[0].valueForKey("full_name") as! String != ""){
                var fullNameValue: String = jsonData[0].valueForKey("full_name") as! String
                fullNameLabel.text = fullNameValue
                } else {
                    fullNameLabel.text = "Full Name"
                }
                
                if(jsonData[0].valueForKey("program") as! String != ""){
                var program: String = jsonData[0].valueForKey("program") as! String
                programLabel.text = program
                } else {
                    programLabel.text = "Program of Study"
                }
                
                if(jsonData[0].valueForKey("university_name") as! String != ""){
                var universityName: String = jsonData[0].valueForKey("university_name") as! String
                universityLabel.text = universityName
                } else {
                    universityLabel.text = "University"
                }
                
                if(jsonData[0].valueForKey("picture") as! String != ""){
                let imageURL = jsonData[0].valueForKey("picture") as! String
                var url = NSURL(string: imageURL)
//                var url = NSURL(string: fullURL)
                var data = NSData(contentsOfURL: url!)
                profileImageView.image = UIImage(data: data!)
                } else {
                    profileImageView.image = UIImage(named: "profile_default.jpg")
                }
                
                var extraText: String = jsonData[0].valueForKey("extra") as! String
                whatsupText.text = extraText
                
                
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
