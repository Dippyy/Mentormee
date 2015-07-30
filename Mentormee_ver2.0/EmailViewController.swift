//
//  EmailViewController.swift
//  EmailMe
//
//  Created by Prerna Kaul on 2015-07-16.
//  Copyright (c) 2015 Jadoo. All rights reserved.
//

import UIKit
//import MessageUI

class EmailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var sendMessageLabel: UILabel!
    
    var emailAddress = "info@mentormee.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMessageLabel.alpha = 0
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        
        // prevents the scroll view from swallowing up the touch event of child buttons
//        tapGesture.cancelsTouchesInView = false
        
//        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        self.registerForKeyboardNotifications()
        
    }
    override func viewWillDisappear(animated: Bool) {
//        self.deregisterFromKeyboardNotifications()
//        super.viewWillDisappear(true)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func registerForKeyboardNotifications() -> Void {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func deregisterFromKeyboardNotifications() -> Void {
//        println("Deregistering!")
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func keyboardWasShown(notification: NSNotification) {
        
//        var info: Dictionary = notification.userInfo!
//        var keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size)!
//        var buttonOrigin: CGPoint = self.emailButton.frame.origin;
//        var buttonHeight: CGFloat = self.emailButton.frame.size.height/2;
//        var visibleRect: CGRect = self.view.frame
//        visibleRect.size.height -= keyboardSize.height
//        instructionLabel.hidden = true
//        
//        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
//            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
//            self.scrollView.setContentOffset(scrollPoint, animated: true)
//            
//        }
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func hideKeyboard() {
        
//        emailButton.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
//        textField.resignFirstResponder()
//        self.scrollView.setContentOffset(CGPointZero, animated: true)
        
    }
    
    
    
    @IBAction func sendMessageButtonTapped(sender: AnyObject) {
        
        //SEND ALERT , ARE YOU SURE YOU WANT TO EMAIL THIS TO YOUR MENTOR?
                
        var refreshAlert = UIAlertController(title: "Confirm Message", message: "Are you sure you want to send this message to your mentor?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        
        //Create a record in the database for message, mentee email, mentor email
        
        // -> Send mentee ID and mentor ID to database and retreive emails
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let mentee: String = prefs.valueForKey("userID") as! String
        
        let mentor: String = prefs.valueForKey("MentorMatched") as! String
        
        let menteeEmail = self.grabEmail(mentee)
        let mentorEmail = self.grabEmail(mentor)
        
        // -> Send emails and message to new table in DB
        
        let menteeMessage: String = self.textField.text
        
        self.create_message_record(menteeEmail, mentorEmail: mentorEmail, menteeMessage: menteeMessage)
            
        UIView.animateWithDuration(1, animations: {
            self.textField.alpha = 0
            self.instructionLabel.alpha = 0
            self.emailButton.alpha = 0
            self.sendMessageLabel.alpha = 1.0
                })
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)

        
    }
    
    func create_message_record(menteeEmail: String, mentorEmail: String, menteeMessage: String){
        
    // Takes the mentor/mentee email and the mentee message and puts it into the database under MentormeeMessage
        
        var postID: NSString = "menteeEmail=\(menteeEmail)&mentorEmail=\(mentorEmail)&menteeMessage=\(menteeMessage)"
        NSLog("PostData: %@",postID);
//        var urlID:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/createMessageRecord.php")!
        
        var urlID:NSURL = NSURL(string: createMessageRecord)!

        var postDataID:NSData = postID.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLengthID:NSString = String( postDataID.length )
        var requestID:NSMutableURLRequest = NSMutableURLRequest(URL: urlID)
        
        requestID.HTTPMethod = "POST"
        requestID.HTTPBody = postDataID
        requestID.setValue(postLengthID as String, forHTTPHeaderField: "Content-Length")
        requestID.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestID.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var responseErrorID: NSError?
        var responseID: NSURLResponse?
        
        var urlDataID: NSData? = NSURLConnection.sendSynchronousRequest(requestID, returningResponse:&responseID, error:&responseErrorID)
        
        if(urlDataID != nil){
            let res = responseID as! NSHTTPURLResponse!
            NSLog("Response code: %ld", res.statusCode)
            
            if(res.statusCode >= 200 && res.statusCode < 300){
                
                var responseData: NSString = NSString(data: urlDataID!, encoding: NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData)
                var error:NSError?
                                
                }
            }
    }
    
    func grabEmail(userID: String) -> String {
        
        // A userID is sent into this function, the email of the corresponding userID is returned
        
        var postID: NSString = "userID=\(userID)"
        NSLog("PostData: %@",postID);
//        var urlID:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/grabEmailFromID.php")!
        
        var urlID:NSURL = NSURL(string:grabEmailFromID)!

        var postDataID:NSData = postID.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLengthID:NSString = String( postDataID.length )
        var requestID:NSMutableURLRequest = NSMutableURLRequest(URL: urlID)
        
        requestID.HTTPMethod = "POST"
        requestID.HTTPBody = postDataID
        requestID.setValue(postLengthID as String, forHTTPHeaderField: "Content-Length")
        requestID.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestID.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var responseErrorID: NSError?
        var responseID: NSURLResponse?
        
        var urlDataID: NSData? = NSURLConnection.sendSynchronousRequest(requestID, returningResponse:&responseID, error:&responseErrorID)
        
        if(urlDataID != nil){
            let res = responseID as! NSHTTPURLResponse!
            NSLog("Response code: %ld", res.statusCode)
            
            if(res.statusCode >= 200 && res.statusCode < 300){
                
                var responseData: NSString = NSString(data: urlDataID!, encoding: NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData)
                var error:NSError?
                
                let jsonDataID: NSArray = (NSJSONSerialization.JSONObjectWithData(urlDataID!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                
                let emailReturned = jsonDataID[0].valueForKey("Email") as! String
                return emailReturned
            }
        }
        
        return "did not find"
    }
    
    func sendAlert(alertMessage: String) -> UIAlertView {
        
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Confirm"
        alertView.message = alertMessage
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
        
        return alertView
    }
    
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
