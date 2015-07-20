//
//  LoginVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-10.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

extension NSString {
    var isEmail: Bool {
        let emailStr = self as? String
        let range = NSMakeRange(0, self.length)
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailBool = NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(self)
        return emailBool
    }
}

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var existingUserButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!


    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        emailField.alpha = 1.0
        passwordField.alpha = 1.0
        passwordConfirmField.alpha = 1.0
        
        signupButton.alpha = 1.0
        existingUserButton.alpha = 1.0
        loginButton.alpha = 0
        backButton.alpha = 0
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(tapGesture)

    }
    
    @IBAction func backButtonPressed2(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped

    func deregisterFromKeyboardNotifications() -> Void {
        println("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped

    func keyboardWasShown(notification: NSNotification) {
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size)!
        var buttonOrigin: CGPoint = self.existingUserButton.frame.origin;
        var buttonHeight: CGFloat = self.existingUserButton.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped

    func hideKeyboard() {
        emailField.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        passwordField.resignFirstResponder()
        passwordConfirmField.resignFirstResponder()
//        mentormeeLogo.alpha = 1.0
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    
    // toggles transparency
    
    @IBAction func ExistingUserTapped(sender: AnyObject) {
        UIView.animateWithDuration(0, animations: {
            self.signupButton.alpha = 0
            self.passwordConfirmField.alpha = 0
            self.existingUserButton.alpha = 0
            self.loginButton.alpha = 1.0
            self.backButton.alpha = 1.0
        })
    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        UIView.animateWithDuration(0, animations: {
            self.signupButton.alpha = 1.0
            self.passwordConfirmField.alpha = 1.0
            self.existingUserButton.alpha = 1.0
            self.loginButton.alpha = 0
            self.backButton.alpha = 0
        })
    }
    
    // login button to sign in user and check to see if their email and password match what is in the database
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        myActivityIndicator.startAnimating()
        
        var email:NSString = emailField.text
        var password:NSString = passwordField.text
        
        if ( email.isEmail != true || email.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Email and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            myActivityIndicator.stopAnimating()

        } else {
            
            var post:NSString = "email=\(email)&password=\(password)"
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/loginTest.php")!
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String( postData.length )
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
        
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData);
                    var error: NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary

                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    NSLog("Success: %ld", success);
                    
                    if(success == 1){
                        
                        NSLog("LOGIN SUCCESS time to FETCH USERID")
                        
                        let emailToSend = email
                        
                        var post: NSString = "email=\(emailToSend)"
                        NSLog("PostData: %@",post);
                        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/fetchUserID.php")!
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
                                
                                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                
                                //SET MENTOR USERID AND EMAIL TO THE CACHE
                                
                                prefs.setObject(jsonData[0].valueForKey("ID"), forKey: "userID")
                                prefs.setObject(email, forKey: "email")

                                prefs.setObject("MentorLoggedIn", forKey: "Status")
                                self.performSegueWithIdentifier("goto_mentorhome", sender: self)
                            }
                        }

                        
                    } else {
                        var error_msg:NSString
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        myActivityIndicator.stopAnimating()

                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    myActivityIndicator.stopAnimating()

                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                myActivityIndicator.stopAnimating()

            }
        }
        
    }
    
    
    // signup -> gives the DB email/password/password and mentor status
    // fetches the userID of the mentor based on the email
    // creates a row in Capabilities/Mentor/Mentee and inputs the userID into the row in the corresponding column
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        var email:NSString = emailField.text as NSString
        var password:NSString = passwordField.text as NSString
        var passwordConfirm: NSString = passwordConfirmField.text as NSString
        var mentorStatus:NSString = "Mentor"
        
        if (email.isEmail != true || password.isEqualToString("") || passwordConfirm.isEqualToString("")) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please Fill the Required Fields With Valid Information."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if ( !password.isEqual(passwordConfirm) ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if(password.length <= 6){
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords is no long enough!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            
        }else {
            
            var post:NSString = "email=\(email)&password=\(password)&password_c=\(passwordConfirm)&mentorStatus=\(mentorStatus)"
            NSLog("PostData: %@", post)
            
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/signupScript4.php")!
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
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    NSLog("Success %ld", success)
                    
                    if(success == 1){
                        
                        NSLog("Sign up SUCCESS time to FETCH USERID")
                        
                        let emailToSend = email
                        
                        var post: NSString = "email=\(emailToSend)"
                        NSLog("PostData: %@",post);
                        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/fetchUserID2.php")!
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
                                
                                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                
                                prefs.setObject(jsonData[0].valueForKey("ID"), forKey: "userID")
                                prefs.setObject(email, forKey: "email")
                                println(prefs.valueForKey("userID") as! String)
                                
                            }
                        }
                        
                        NSLog("Sign up ID RECEIVED TIME TO INPUT DATA INTO TABLES")
                        
                        
                        let prefs = NSUserDefaults.standardUserDefaults()
                        let userID = prefs.valueForKey("userID") as! String
                        
                        var postID: NSString = "userID=\(userID)"
                        NSLog("PostData: %@",postID);
                        var urlID:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/createNewAccount.php")!
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
                                
                                let primaryID = jsonDataID[0].valueForKey("Capability_id") as! String
                                prefs.setObject(primaryID, forKey: "Capability ID")

                            }
                        }
                        
                        NSLog("TIME TO UPDATE PRIMARY CAPABILITY")
                
                        let primaryCapability: String = prefs.valueForKey("Capability ID") as! String
                        
                        var postID2: NSString = "primaryCapabilityID=\(primaryCapability)&userID=\(userID)"
                        NSLog("PostData: %@",postID2);
                        var urlID2:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/createPrimaryCapabilityEntry.php")!
                        var postDataID2:NSData = postID2.dataUsingEncoding(NSASCIIStringEncoding)!
                        var postLengthID2:NSString = String( postDataID2.length )
                        var requestID2:NSMutableURLRequest = NSMutableURLRequest(URL: urlID2)
                        
                        requestID2.HTTPMethod = "POST"
                        requestID2.HTTPBody = postDataID2
                        requestID2.setValue(postLengthID2 as String, forHTTPHeaderField: "Content-Length")
                        requestID2.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        requestID2.setValue("application/json", forHTTPHeaderField: "Accept")
                        
                        var responseErrorID2: NSError?
                        var responseID2: NSURLResponse?
                        
                        var urlDataID2: NSData? = NSURLConnection.sendSynchronousRequest(requestID2, returningResponse:&responseID2, error:&responseErrorID2)
                        
                        if(urlDataID2 != nil){
                            let res = responseID2 as! NSHTTPURLResponse!
                            NSLog("Response code: %ld", res.statusCode)
                            
                            if(res.statusCode >= 200 && res.statusCode < 300){
                                
                                var responseData: NSString = NSString(data: urlDataID2!, encoding: NSUTF8StringEncoding)!
                                NSLog("Response ==> %@", responseData)
                                var error:NSError?
                                
                                let jsonDataID: NSDictionary = NSJSONSerialization.JSONObjectWithData(urlDataID2!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                                
                                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                
                                prefs.setObject("MentorLoggedIn", forKey: "Status")
//                                self.performSegueWithIdentifier("goto_mentorhome", sender: self)
                                self.performSegueWithIdentifier("goto_signupDetail", sender: self)

                            }
                        }

                    }else {
                        var error_msg: NSString
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Signup Failed"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = responseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
        }
        
    }

}
