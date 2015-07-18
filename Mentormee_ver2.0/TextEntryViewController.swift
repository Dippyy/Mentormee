//
//  TextEntryViewController.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-06-30.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class TextEntryViewController: UIViewController {
    
    @IBOutlet weak var shortTextfield: UITextField!
    @IBOutlet weak var longTextField: UITextView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        // this sets the transparency of the textfields (i.e. short textfield should appear for name, highschool, contact info but the long textfield should appear when the user needs to write more then one line (whatsup, current situation, etc..))
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
            longTextField.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("High School")){
            longTextField.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Grade")){
            longTextField.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Contact Info")){
            shortTextfield.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Current Situation")){
            shortTextfield.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Future Options")){
            shortTextfield.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("What's Up")){
            shortTextfield.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Interests")){
            shortTextfield.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Facebook")){
            longTextField.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Skype")){
            longTextField.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Email")){
            longTextField.alpha = 0.0
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Phone")){
            longTextField.alpha = 0.0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let fullName: String = prefs.valueForKey("Selection") as? String {
            if (prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
                self.shortTextfield.text = prefs.valueForKey("Full Name Mentee") as! String
            }
        }
        
        if let highSchool: String = prefs.valueForKey("Selection") as? String {
            if (prefs.valueForKey("Selection")!.isEqualToString("High School")){
                self.shortTextfield.text = prefs.valueForKey("Highschool Mentee") as! String
                println(prefs.valueForKey("Highschool Mentee") as! String)
            }
        }
        
        if let currentSituation: String = prefs.valueForKey("Selection") as? String {
            if (prefs.valueForKey("Selection")!.isEqualToString("Current Situation")){
                self.longTextField.text = prefs.valueForKey("Current Situation") as! String
                println(prefs.valueForKey("Current Situation") as! String)
            }
        }
        
        if let futureOptions: String = prefs.valueForKey("Selection") as? String {
            if (prefs.valueForKey("Selection")!.isEqualToString("Future Options")){
                self.longTextField.text = prefs.valueForKey("Future Options") as! String
                println(prefs.valueForKey("Future Options") as! String)
            }
        }
        
        if let whatsUp: String = prefs.valueForKey("Selection") as? String {
            if (prefs.valueForKey("Selection")!.isEqualToString("What's Up")){
                self.longTextField.text = prefs.valueForKey("Whatsup Mentee") as! String
            }
        }
        
        if let whatsUp: String = prefs.valueForKey("Selection") as? String {
            if (prefs.valueForKey("Selection")!.isEqualToString("Interests")){
                self.longTextField.text = prefs.valueForKey("Interests Mentee") as! String
                println(prefs.valueForKey("Interests Mentee") as! String)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        // calls the DB and updates the corresponding field that has appeared
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
            
            var fullName: String = shortTextfield.text as String
            var userID = prefs.valueForKey("userID") as! String
            print(userID)
            
            // takes full name and splits it into first and last based on the location of the space

            var fullNameArr = split(fullName) {$0 == " "}
            var firstName: String = fullNameArr[0]
            println("THE FIRST NAME IS \(firstName)")
            var lastName: String! = fullNameArr.count > 1 ? fullNameArr[1] : ""
            println("THE LAST NAME IS \(lastName)")
            
            // sends the userID, first name and last name to the DB to update the record

            var post: NSString = "userID=\(userID)&firstName=\(firstName)&lastName=\(lastName)"
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateName.php")!
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
                    
                    if(success == 1){
                        NSLog("Update SUCCESS!")
                        self.performSegueWithIdentifier("goto_profileupdate", sender: self)
                    }
                }
            }
            
            // updates the highschool
        } else if(prefs.valueForKey("Selection")!.isEqualToString("High School")){
            
            var highSchool: String = shortTextfield.text as String
            var updateInfo: String = "highSchool"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateHighSchool.php"
            update_table_info(urlToSend, userID: userID, updateField: highSchool, updateVariable: updateInfo)

            // updates the contact info
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Current Situation")){
            
            var currentInfo: String = longTextField.text as String
            var updateInfo: String = "currentInfo"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateCurrentSituation.php"
            update_table_info(urlToSend, userID: userID, updateField: currentInfo, updateVariable: updateInfo)
            
            // updates the whatsup
        } else if(prefs.valueForKey("Selection")!.isEqualToString("What's Up")){
            
            var whatsupMentee: String = longTextField.text as String
            var updateInfo: String = "whatsUpMentee"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateWhatsupMentee.php"
            update_table_info(urlToSend, userID: userID, updateField: whatsupMentee, updateVariable: updateInfo)

            // updates the future options
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Future Options")){
            
            var futureOptions: String = longTextField.text as String
            var updateInfo: String = "updateFutureOptions"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateFutureOptions.php"
            update_table_info(urlToSend, userID: userID, updateField: futureOptions, updateVariable: updateInfo)
            
            // updates the interests
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Interests")){
            
            var interests: String = longTextField.text as String
            var updateInfo: String = "InterestsMentee"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateMenteeInterest.php"
            update_table_info(urlToSend, userID: userID, updateField: interests, updateVariable: updateInfo)
            
            // updates the Facebook
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Facebook")){
            
            var facebookID: String = shortTextfield.text as String
            var updateInfo: String = "FacebookID"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateFacebookID.php"
            update_table_info(urlToSend, userID: userID, updateField: facebookID, updateVariable: updateInfo)
            
            // updates the Skype
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Skype")){
            
            var skypeID: String = shortTextfield.text as String
            var updateInfo: String = "skypeID"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateSkypeID.php"
            update_table_info(urlToSend, userID: userID, updateField: skypeID, updateVariable: updateInfo)
            
            // updates the email
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Email")){
            
            var emailID: String = shortTextfield.text as String
            var updateInfo: String = "emailID"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateEmailID.php"
            update_table_info(urlToSend, userID: userID, updateField: emailID, updateVariable: updateInfo)
            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setObject(emailID, forKey: "email")
            
        } 
    }
    
    // this function takes the userID, updatefield (the content) and the updatevariable (what is being updated)
    func update_table_info(url: String, userID: String, updateField: String, updateVariable: String){
        
        var post: NSString = "userID=\(userID)&\(updateVariable)=\(updateField)"
        println(post)
        var url:NSURL = NSURL(string: url)!
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
                
                if(success == 1){
                    NSLog("Update SUCCESS!")
                    self.performSegueWithIdentifier("goto_profileupdate", sender: self)

                }
            }
        }
    }

}
