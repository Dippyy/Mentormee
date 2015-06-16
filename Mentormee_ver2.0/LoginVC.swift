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
    @IBOutlet weak var mentormeeLogo: UIImageView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        emailField.alpha = 0
        passwordField.alpha = 0
        passwordConfirmField.alpha = 0
        
        signupButton.alpha = 0
        existingUserButton.alpha = 0
        loginButton.alpha = 0
        backButton.alpha = 0
        mentormeeLogo.alpha = 1.0
        
        let clearAllKeys: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        clearAllKeys.removeObjectForKey("Upload")
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
        self.mentormeeLogo.alpha = 0
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    func hideKeyboard() {
        emailField.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        passwordField.resignFirstResponder()
        passwordConfirmField.resignFirstResponder()
        mentormeeLogo.alpha = 1.0
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    @IBAction func mentorButtonTapped(sender: UIButton) {
        
        sender.highlighted = false
        UIView.animateWithDuration(0.75,
            delay: 0,
            options: .CurveLinear & .AllowUserInteraction & .BeginFromCurrentState,
            animations: {
                sender.alpha = 0
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, animations: {
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
        UIView.animateWithDuration(1.0, animations: {
            self.signupButton.alpha = 0
            self.passwordConfirmField.alpha = 0
            self.existingUserButton.alpha = 0
            self.loginButton.alpha = 1.0
            self.backButton.alpha = 1.0
        })
    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        UIView.animateWithDuration(1.0, animations: {
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
            
            var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/loginScript.php")!
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
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(email, forKey: "email")
                        
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
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
            
        } else {
            
            var post:NSString = "email=\(email)&password=\(password)&password_c=\(passwordConfirm)"
            NSLog("PostData: %@", post)
            
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/signupScript2.php")!
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
                        NSLog("Sign up SUCCESS")
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(email, forKey: "email")
                        self.dismissViewControllerAnimated(true, completion: nil)
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
