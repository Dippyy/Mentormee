//
//  MenteeSignUpTableViewController.swift
//  Mentee
//
//  Created by Prerna Kaul on 2015-06-17.
//  Copyright (c) 2015 Jadoo. All rights reserved.
//

import UIKit


class MenteeSignUpTableViewController: UIViewController{
    
    @IBOutlet weak var SignUp: UIBarButtonItem!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
   
    @IBOutlet weak var retypePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        //send code to the database
        //validate sign up form
        var validated = validateSignUpForm()
        if(validated){
            //sendFieldsToDatabase(emailField.text,passwordTxt: passwordField.text)
        }
    }
    
    func validateSignUpForm() -> Bool{
        
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
            return false;
        }
        return true
    }
    
    func sendFieldsToDatabase( emailTxt: NSString,  passwordTxt: NSString){
        // send to database
        //check if email exists
        // if does not exist, add to account
        var post:NSString = "email=\(emailTxt)&password=\(passwordTxt)"
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
                    prefs.setObject(emailTxt, forKey: "email")
                    
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