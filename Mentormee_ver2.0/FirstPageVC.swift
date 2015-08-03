//
//  FirstPageVC.swift
//  Mentormee_ver2.0
//
//  Created by Alex on 2015-07-03.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class FirstPageVC: UIViewController {

    @IBAction func MentorButton(sender: AnyObject) {
    }
    @IBAction func menteeButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_menteelogin", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
        //THIS IS FOR TESTING PURPOSES! 
        prefs.setObject("new", forKey: "Status")
        
        if let status = prefs.valueForKey("Status") as? String {
        
         println(status)
            
        if(status == "MentorLoggedIn"){
            self.performSegueWithIdentifier("goto_mentorhome2", sender: self)
        } else if(status == "MentorLoggedOut"){
            self.performSegueWithIdentifier("goto_loginpage", sender: self)
        } else if(status == "MenteeLoggedIn"){
            println("Go to mentee profile page")
        } else if(status == "MenteeLoggedOut"){
            self.performSegueWithIdentifier("goto_menteelogin", sender: self)
        }
    } else {
        println("NEW USER")
    }
}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationSetting = UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject("NeverMatched", forKey: "matchCheck")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForStatusChange() -> String {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let userID = prefs.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(userID)"
        NSLog("PostData: %@",post);
//        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/checkMentorMatchField.php")!
        
        var url:NSURL = NSURL(string:checkMentorMatchField)!

        
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
                
                let mentorMatchFieldCheck = jsonData[0].valueForKey("MentorStatusCheck") as! String
                return mentorMatchFieldCheck
            }
        }
        
        return "False"
    }
    
    func updateNotification() {
        
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if(settings.types == .None) {
            let ac = UIAlertController(title: "Can't Send", message: "We can't send! or you haven't let us", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        //        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        notification.alertTitle = "Mentormee"
        notification.alertBody = "You Have Been Matched!"
        notification.alertAction = "Lets Check It Out"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["MentorStatusCheck":"0"]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func updateMmStatusPostSwipe() {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let userID = prefs.valueForKey("userID") as! String
        
        var post: NSString = "userID=\(userID)"
        NSLog("PostData: %@",post);
//        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/updateMmStatusPostNotification.php")!
        var url:NSURL = NSURL(string: updateMmStatusPostNotification)!

        
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
                
                let jsonData: NSDictionary = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary)!
                let success = jsonData.valueForKey("success") as! Int
                if (success == 1) {
                    println("notification sent and status back to zero")
                }
                
            }
        }
    }
    

}
