//
//  MenteeViewVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-16.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class MenteeViewVC: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    
    @IBOutlet weak var myImageView2: UIImageView!
    @IBOutlet weak var fullNameLabel2: UILabel!
    @IBOutlet weak var universityLabel2: UILabel!
    @IBOutlet weak var programLabel2: UILabel!
    
    @IBOutlet weak var myImageView3: UIImageView!
    @IBOutlet weak var fullNameLabel3: UILabel!
    @IBOutlet weak var universityLabel3: UILabel!
    @IBOutlet weak var programLabel3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// MAKES IMAGEVIEW CIRCULAR
        
        myImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        myImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        myImageView.layer.borderWidth = 1.5
        myImageView.layer.masksToBounds = false
        myImageView.layer.borderColor = UIColor.orangeColor().CGColor
        myImageView.layer.cornerRadius = myImageView.frame.height/2
        myImageView.clipsToBounds = true
        
        myImageView.alpha = 0
        fullNameLabel.alpha = 0
        universityLabel.alpha = 0
        programLabel.alpha = 0
        
        myImageView2.alpha = 0
        fullNameLabel2.alpha = 0
        universityLabel2.alpha = 0
        programLabel2.alpha = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
// Pulls the mentee information from the DB and displays their information

        let storedData:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userID: String = storedData.valueForKey("userID") as! String
        
        var post: NSString = "mentorUserID=\(userID)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/pullMentee3.php")!
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String( postData.length )
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
                
                if(responseData == "[]"){
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "No Match"
                    alertView.message = "No Match yet! :("
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                } else {
                
                    let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                    
                    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    
                    println(jsonData.count)
                    
                    if(jsonData.count == 1) {
                
                        let menteeUserID1: String = jsonData[0].valueForKey("Mentee_id") as! String
                        prefs.setObject(menteeUserID1, forKey: "MenteeID1")
                        
                        UIView.animateWithDuration(0, animations: {
                            
                            self.myImageView.alpha =  1.0
                            self.fullNameLabel.alpha = 1.0
                            self.universityLabel.alpha = 1.0
                            self.programLabel.alpha = 0
                            
                            })
                        
                        var post: NSString = "menteeUserID1=\(menteeUserID1)"
                        NSLog("PostData: %@",post);
                        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/pullMenteeInformation.php")!
                        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                        var postLength:NSString = String( postData.length )
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
                            
                            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                            NSLog("Response ==> %@", responseData)
                            var error:NSError?
                            
                            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                            
                            if let firstName:String = jsonData[0].valueForKey("FirstName") as? String {
                                
                                var lastName: String = jsonData[0].valueForKey("LastName") as! String
                                var fullName: String = firstName + " " + lastName
                                
                                if(fullName != ""){
                                    var fullName: String = fullName
                                    fullNameLabel.text = fullName
                                } else {
                                    fullNameLabel.text = "Full Name"
                                }
                                
                                var highschoolName: String = jsonData[0].valueForKey("HighSchool") as! String
                                universityLabel.text = highschoolName
                                
                                if(jsonData[0].valueForKey("Picture") as! String != ""){
                                    var imgURL: String = jsonData[0].valueForKey("Picture") as! String
                                    var url = NSURL(string: imgURL)
                                    var imgData = NSData(contentsOfURL: url!)
                                    myImageView.image = UIImage(data: imgData!)
                                } else {
                                    myImageView.image = UIImage(named: "profile_default.jpg")
                                }
                            }
                        }
        
                    } else if(jsonData.count == 2) {
                    
                        let menteeUserID1: String = jsonData[0].valueForKey("Mentee_id") as! String
//                        prefs.setObject(menteeUserID1, forKey: "MenteeID1")
                        
                        myImageView.layer.borderWidth = 1.5
                        myImageView.layer.masksToBounds = false
                        myImageView.layer.borderColor = UIColor.orangeColor().CGColor
                        myImageView.layer.cornerRadius = myImageView.frame.height/2
                        myImageView.clipsToBounds = true
                        
                        UIView.animateWithDuration(0, animations: {
                            
                            self.myImageView.alpha =  1.0
                            self.fullNameLabel.alpha = 1.0
                            self.universityLabel.alpha = 1.0
                            self.programLabel.alpha = 0
                            
                        })

                        let menteeUserID2: String = jsonData[1].valueForKey("Mentee_id") as! String
//                        prefs.setObject(menteeUserID1, forKey: "MenteeID2")
                        
                        myImageView2.layer.borderWidth = 1.5
                        myImageView2.layer.masksToBounds = false
                        myImageView2.layer.borderColor = UIColor.orangeColor().CGColor
                        myImageView2.layer.cornerRadius = myImageView2.frame.height/2
                        myImageView2.clipsToBounds = true
                        
                        UIView.animateWithDuration(0, animations: {
                            
                            self.myImageView2.alpha =  1.0
                            self.fullNameLabel2.alpha = 1.0
                            self.universityLabel2.alpha = 1.0
                            self.programLabel2.alpha = 0
                            
                        })
                        
                        var post: NSString = "menteeUserID1=\(menteeUserID1)&menteeUserID2=\(menteeUserID2)"
                        NSLog("PostData: %@",post);
                        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/pullMenteeInformation.php")!
                        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                        var postLength:NSString = String( postData.length )
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
                            
                            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                            NSLog("Response ==> %@", responseData)
                            var error:NSError?
                            
                            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                            
                            if let firstName:String = jsonData[0].valueForKey("FirstName") as? String {
                                
                                var lastName: String = jsonData[0].valueForKey("LastName") as! String
                                var fullName: String = firstName + " " + lastName
                                
                                if(fullName != ""){
                                    var fullName: String = fullName
                                    fullNameLabel.text = fullName
                                } else {
                                    fullNameLabel.text = "Full Name"
                                }
                                
                                var highschoolName: String = jsonData[0].valueForKey("HighSchool") as! String
                                universityLabel.text = highschoolName
                                
                                if(jsonData[0].valueForKey("Picture") as! String != ""){
                                    var imgURL: String = jsonData[0].valueForKey("Picture") as! String
                                    var url = NSURL(string: imgURL)
                                    var imgData = NSData(contentsOfURL: url!)
                                    myImageView.image = UIImage(data: imgData!)
                                } else {
                                    myImageView.image = UIImage(named: "profile_default.jpg")
                                }
                            }
                        
                        if let firstName:String = jsonData[1].valueForKey("FirstName") as? String {
            
                            var lastName: String = jsonData[1].valueForKey("LastName") as! String
                            var fullName: String = firstName + " " + lastName
                            
                            if(fullName != ""){
                                var fullName: String = fullName
                                fullNameLabel2.text = fullName
                            } else {
                                fullNameLabel2.text = "Full Name"
                            }
                            
                            var highschoolName: String = jsonData[1].valueForKey("HighSchool") as! String
                            universityLabel2.text = highschoolName
                            
                            
                            if(jsonData[1].valueForKey("Picture") as! String != ""){
                                var imgURL: String = jsonData[1].valueForKey("Picture") as! String
                                var url = NSURL(string: imgURL)
                                var imgData = NSData(contentsOfURL: url!)
                                myImageView2.image = UIImage(data: imgData!)
                            } else {
                                myImageView2.image = UIImage(named: "profile_default.jpg")
                            }
                            }
                        }
                    } else if(jsonData.count == 3){
                        println("Three Mentors")
                        let menteeUserID1: String = jsonData[0].valueForKey("Mentee_id") as! String
                        //                        prefs.setObject(menteeUserID1, forKey: "MenteeID1")
                        
                        myImageView.layer.borderWidth = 1.5
                        myImageView.layer.masksToBounds = false
                        myImageView.layer.borderColor = UIColor.orangeColor().CGColor
                        myImageView.layer.cornerRadius = myImageView.frame.height/2
                        myImageView.clipsToBounds = true
                        
                        UIView.animateWithDuration(0, animations: {
                            
                            self.myImageView.alpha =  1.0
                            self.fullNameLabel.alpha = 1.0
                            self.universityLabel.alpha = 1.0
                            self.programLabel.alpha = 0
                            
                        })
                        
                        let menteeUserID2: String = jsonData[1].valueForKey("Mentee_id") as! String
                        
                        myImageView2.layer.borderWidth = 1.5
                        myImageView2.layer.masksToBounds = false
                        myImageView2.layer.borderColor = UIColor.orangeColor().CGColor
                        myImageView2.layer.cornerRadius = myImageView2.frame.height/2
                        myImageView2.clipsToBounds = true
                        
                        UIView.animateWithDuration(0, animations: {
                            
                            self.myImageView2.alpha =  1.0
                            self.fullNameLabel2.alpha = 1.0
                            self.universityLabel2.alpha = 1.0
                            self.programLabel2.alpha = 0
                            
                        })
                        
                        let menteeUserID3: String = jsonData[2].valueForKey("Mentee_id") as! String
                        
                        myImageView3.layer.borderWidth = 1.5
                        myImageView3.layer.masksToBounds = false
                        myImageView3.layer.borderColor = UIColor.orangeColor().CGColor
                        myImageView3.layer.cornerRadius = myImageView3.frame.height/2
                        myImageView3.clipsToBounds = true
                        
                        UIView.animateWithDuration(0, animations: {
                            
                            self.myImageView3.alpha =  1.0
                            self.fullNameLabel3.alpha = 1.0
                            self.universityLabel3.alpha = 1.0
                            self.programLabel3.alpha = 0
                            
                        })
                        
                        var post: NSString = "menteeUserID1=\(menteeUserID1)&menteeUserID2=\(menteeUserID2)&menteeUserID3=\(menteeUserID3)"
                        NSLog("PostData: %@",post);
                        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/pullMenteeInformation.php")!
                        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                        var postLength:NSString = String( postData.length )
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
                            
                            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                            NSLog("Response ==> %@", responseData)
                            var error:NSError?
                            
                            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                            
                            if let firstName:String = jsonData[0].valueForKey("FirstName") as? String {
                                
                                var lastName: String = jsonData[0].valueForKey("LastName") as! String
                                var fullName: String = firstName + " " + lastName
                                
                                if(fullName != ""){
                                    var fullName: String = fullName
                                    fullNameLabel.text = fullName
                                } else {
                                    fullNameLabel.text = "Full Name"
                                }
                                
                                var highschoolName: String = jsonData[0].valueForKey("HighSchool") as! String
                                universityLabel.text = highschoolName
                                
                                if(jsonData[0].valueForKey("Picture") as! String != ""){
                                    var imgURL: String = jsonData[0].valueForKey("Picture") as! String
                                    var url = NSURL(string: imgURL)
                                    var imgData = NSData(contentsOfURL: url!)
                                    myImageView.image = UIImage(data: imgData!)
                                } else {
                                    myImageView.image = UIImage(named: "profile_default.jpg")
                                }
                            }
                            
                            if let firstName:String = jsonData[1].valueForKey("FirstName") as? String {
                                
                                var lastName: String = jsonData[1].valueForKey("LastName") as! String
                                var fullName: String = firstName + " " + lastName
                                
                                if(fullName != ""){
                                    var fullName: String = fullName
                                    fullNameLabel2.text = fullName
                                } else {
                                    fullNameLabel2.text = "Full Name"
                                }
                                
                                var highschoolName: String = jsonData[1].valueForKey("HighSchool") as! String
                                universityLabel2.text = highschoolName
                                
                                
                                if(jsonData[1].valueForKey("Picture") as! String != ""){
                                    var imgURL: String = jsonData[1].valueForKey("Picture") as! String
                                    var url = NSURL(string: imgURL)
                                    var imgData = NSData(contentsOfURL: url!)
                                    myImageView2.image = UIImage(data: imgData!)
                                } else {
                                    myImageView2.image = UIImage(named: "profile_default.jpg")
                                }
                            }
                            
                            if let firstName:String = jsonData[2].valueForKey("FirstName") as? String {
                                
                                var lastName: String = jsonData[2].valueForKey("LastName") as! String
                                var fullName: String = firstName + " " + lastName
                                
                                if(fullName != ""){
                                    var fullName: String = fullName
                                    fullNameLabel.text = fullName
                                } else {
                                    fullNameLabel.text = "Full Name"
                                }
                                
                                var highschoolName: String = jsonData[2].valueForKey("HighSchool") as! String
                                universityLabel.text = highschoolName
                                
                                if(jsonData[0].valueForKey("Picture") as! String != ""){
                                    var imgURL: String = jsonData[2].valueForKey("Picture") as! String
                                    var url = NSURL(string: imgURL)
                                    var imgData = NSData(contentsOfURL: url!)
                                    myImageView.image = UIImage(data: imgData!)
                                } else {
                                    myImageView.image = UIImage(named: "profile_default.jpg")
                                }
                            }
                        }
                    }
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
