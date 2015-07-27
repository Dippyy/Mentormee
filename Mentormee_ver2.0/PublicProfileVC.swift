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
//        myScrollView.contentSize.height = 750
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)

        
// MAKES IMAGEVIEW CIRCULAR
        
        profileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        profileImageView.layer.borderWidth = 2.5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
//----------- Checks the DB for First Name/Last Name/University/Program/Whatsup ------------------------
        
        let storedData:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userID = storedData.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(userID)"
        println(post)
//        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updatePublicProfile3.php")!
        
        var url:NSURL = NSURL(string: updatePublicProfile3)!

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
                
                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                if(jsonData[1].valueForKey("University_id")!.isEqualToString("0")){
                    let universityID = 1
                    prefs.setObject(universityID, forKey: "uniID")
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
                        
                        var program: String = jsonData[1].valueForKey("Program") as! String
                        println(program)
                        if(program != ""){
                            programLabel.text = program + " Engineering"
                            println(program)
                        } else {
                            programLabel.text = "Program of Study"
                        }
                        
                        var universityName: String = jsonData[0].valueForKey("University") as! String
                        println(universityName)
                        if(universityName != "") {
                            universityLabel.text = universityName
                            println(universityName)
                        } else {
                            universityLabel.text = "University"
                        }
                    }
                }
                
                var extraText: String = jsonData[2].valueForKey("WhatsUp") as! String
                whatsupText.text = extraText
                
                
                
                if(jsonData[0].valueForKey("Picture")!.isEqualToString("")){
                    
                    var email: String = jsonData[0].valueForKey("Email") as! String
                    var emailLower: String = email.lowercaseString
                    var firstChar = Array(emailLower)[0]
                    println(firstChar)
                    profileImageView.image = UIImage(named: "\(firstChar)DefaultLetter")
                    
                } else {
                    
                    let imageString: String = jsonData[0].valueForKey("Picture") as! String
                    let url2 = NSURL(string: imageString)
                    let data = NSData(contentsOfURL: url2!)
                    profileImageView.image = UIImage(data: data!)
                }
                
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
