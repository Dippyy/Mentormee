//
//  mentorProfileView.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-06-26.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class mentorProfileView: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var mentorProfileImageView: UIImageView!
    @IBOutlet weak var mentorNameTextField: UILabel!
    @IBOutlet weak var programTextField: UILabel!
    @IBOutlet weak var universityTextField: UILabel!
    @IBOutlet weak var whatsupTextField: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        myScrollView.contentSize.height = 750
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let mentorID = prefs.valueForKey("mentorUserID") as! Int
        
        mentorProfileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        mentorProfileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        mentorProfileImageView.layer.borderWidth = 1.5
        mentorProfileImageView.layer.masksToBounds = false
        mentorProfileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        mentorProfileImageView.layer.cornerRadius = mentorProfileImageView.frame.height/2
        mentorProfileImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        var post: NSString = "userID=\(mentorID)"
        println(post)
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updatePublicProfile3.php")!
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
                    mentorNameTextField.text = "Full Name"
                } else {
                    var fullName: String = fullName
                    mentorNameTextField.text = fullName
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
                            programTextField.text = program
                            println(program)
                        } else {
                            programTextField.text = "Program of Study"
                        }
                        
                        var universityName: String = jsonData[0].valueForKey("University") as! String
                        println(universityName)
                        if(universityName != "") {
                            universityTextField.text = universityName
                            println(universityName)
                        } else {
                            universityTextField.text = "University"
                        }
                    }
                }
                
                var extraText: String = jsonData[2].valueForKey("WhatsUp") as! String
                whatsupTextField.text = extraText
                
                
                
                if(jsonData[0].valueForKey("Picture")!.isEqualToString("")){
                    
                    mentorProfileImageView.image = UIImage(named: "profile_default.jpg")
                    
                } else {
                    
                    let imageString: String = jsonData[0].valueForKey("Picture") as! String
                    let url2 = NSURL(string: imageString)
                    let data = NSData(contentsOfURL: url2!)
                    mentorProfileImageView.image = UIImage(data: data!)
                }
                
                
            }
        }
        
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
