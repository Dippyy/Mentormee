//
//  LoginVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-10.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var existingUserButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mentorButton: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        emailField.alpha = 0
        passwordField.alpha = 0
        passwordConfirmField.alpha = 0
        
        signupButton.alpha = 0
        existingUserButton.alpha = 0
        loginButton.alpha = 0
        backButton.alpha = 0
//        mentormeeLogo.alpha = 1.0
        
        let clearAllKeys: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        clearAllKeys.removeObjectForKey("picture")
        clearAllKeys.removeObjectForKey("ProfileImage")
        clearAllKeys.removeObjectForKey("Full_Name_Selected")
        clearAllKeys.removeObjectForKey("University")
        clearAllKeys.removeObjectForKey("Faculty")
        clearAllKeys.removeObjectForKey("Program")
        clearAllKeys.removeObjectForKey("Year_Selected")
        clearAllKeys.removeObjectForKey("Gender_Selected")
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(tapGesture)

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
    
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    func deregisterFromKeyboardNotifications() -> Void {
        println("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
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
    func hideKeyboard() {
        emailField.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        passwordField.resignFirstResponder()
        passwordConfirmField.resignFirstResponder()
//        mentormeeLogo.alpha = 1.0
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    @IBAction func mentorButtonTapped(sender: UIButton) {
        
        sender.highlighted = false
        UIView.animateWithDuration(0,
            delay: 0,
            options: .CurveLinear & .AllowUserInteraction & .BeginFromCurrentState,
            animations: {
                sender.alpha = 0
            }, completion: nil)
        
        UIView.animateWithDuration(0, animations: {
            self.emailField.alpha = 1.0
            self.passwordField.alpha = 1.0
            self.passwordConfirmField.alpha = 1.0
            self.signupButton.alpha = 1.0
            self.existingUserButton.alpha = 1.0
        })
 
        
        passwordField.alpha = 1
        passwordConfirmField.alpha = 1
        
        signupButton.alpha = 1
        existingUserButton.alpha = 1
        
    }
    
    
    
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
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        var email:NSString = emailField.text
        var password:NSString = passwordField.text
        
        if ( email.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Email and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
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
                        
                        NSLog("Login SUCCESS");
                        
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
                                
                                prefs.setObject(jsonData[0].valueForKey("ID"), forKey: "userID")
                                prefs.setObject(email, forKey: "email")
                                println(prefs.valueForKey("userID") as! String)
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
//                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//                        prefs.setObject(email, forKey: "email")
//                        
//                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
//                        prefs.synchronize()
//                        self.dismissViewControllerAnimated(true, completion: nil)
                        
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
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
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
            }
        }
        
    }
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        var email:NSString = emailField.text as NSString
        var password:NSString = passwordField.text as NSString
        var passwordConfirm: NSString = passwordConfirmField.text as NSString
        var mentorStatus:NSString = "Mentor"
        
        if (email.isEqualToString("") || password.isEqualToString("") || passwordConfirm.isEqualToString("")) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please Fill the Required Fields"
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
            
        } else if(password.length <= 8){
            
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
//                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                        
                        NSLog("Sign up ID RECEIVED TIME TO INPUT DATA INTO TABLES")
                        
                        
                        let prefs = NSUserDefaults.standardUserDefaults()
                        let userID = prefs.valueForKey("userID") as! String
//                        let userID = jsonData[0]?.valueForKey("userID") as! String
//                        let IDToSend = userID.toInt()
                        
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
                                
                                var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                                NSLog("Response ==> %@", responseData)
                                var error:NSError?
                                
                                let jsonDataID: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                                
                                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                
//                                prefs.setObject(jsonDataID[0].valueForKey("ID"), forKey: "userID")
//                                println(prefs.valueForKey("userID") as! String)
                                self.dismissViewControllerAnimated(true, completion: nil)
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
