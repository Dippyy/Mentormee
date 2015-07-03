//
//  MenteeSignupPage.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-07-02.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class MenteeSignupPage: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var buttonToLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        myScrollView.addGestureRecognizer(tapGesture)
        buttonToLogin.alpha = 0

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
        var buttonOrigin: CGPoint = self.loginButton.frame.origin;
        var buttonHeight: CGFloat = self.loginButton.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.myScrollView.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    func hideKeyboard() {
        fullNameTextField.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.resignFirstResponder()
        //        mentormeeLogo.alpha = 1.0
        self.myScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    //  This function does NOT log-in it simply hides the neccessary fields so the user can login
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        buttonToLogin.alpha = 1.0
        signupButton.alpha = 0
        fullNameTextField.alpha = 0
        passwordConfirmTextField.alpha = 0
        loginButton.alpha = 0
        
    }
    
    // This is the function that performs the login
    
    @IBAction func loginButtonToLoginTapped(sender: AnyObject) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        var email:NSString = emailTextField.text
        var password:NSString = passwordTextField.text
        
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
                                self.performSegueWithIdentifier("goto_loginhome", sender: self)
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
        
        var fullName: String = fullNameTextField.text as String
        
        var fullNameArr = split(fullName) {$0 == " "}
        var firstName: String = fullNameArr[0]
        println("THE FIRST NAME IS \(firstName)")
        var lastName: String! = fullNameArr.count > 1 ? fullNameArr[1] : ""
        println("THE LAST NAME IS \(lastName)")
        var email:String = emailTextField.text as String
        var password:String = passwordTextField.text as String
        var passwordConfirm: String = passwordConfirmTextField.text as String
        var mentorStatus:String = "Mentee"
        
        if (email == "" || password == "" || passwordConfirm == "") {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please Fill the Required Fields"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if (password != passwordConfirm) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if(count(password) <= 8){
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords is no long enough!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            
        }else {
            
            var post:NSString = "email=\(email)&password=\(password)&password_c=\(passwordConfirm)&mentorStatus=\(mentorStatus)&firstName=\(firstName)&lastName=\(lastName)"
            NSLog("PostData: %@", post)
            
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/signupScriptMentee.php")!
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
                                
                                println("Performing this SEGUE")
                                self.performSegueWithIdentifier("goto_detailsignup", sender: self)
                                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                                prefs.synchronize()
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
