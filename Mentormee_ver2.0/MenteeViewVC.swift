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
    @IBOutlet weak var backgroundLabel: UILabel!
    //sample check in
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        backgroundLabel.alpha = 0

    }
    
    override func viewDidAppear(animated: Bool) {
        
        let storedData:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/pullMentee.php")!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        request.HTTPMethod = "POST"
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
                
                let matchCheck = jsonData[0].valueForKey("NoOfMentees") as! String
                
                if(matchCheck != "None"){
                    
                UIView.animateWithDuration(0, animations: {
                    
                    self.myImageView.alpha =  1.0
                    self.fullNameLabel.alpha = 1.0
                    self.universityLabel.alpha = 1.0
                    self.programLabel.alpha = 1.0
                    self.backgroundLabel.alpha = 0.3
                    
                    })
                    
                    var fullNameValue: String = jsonData[0].valueForKey("full_name") as! String
                    fullNameLabel.text = fullNameValue
                    
                    var highschoolName: String = jsonData[0].valueForKey("highschool") as! String
                    universityLabel.text = highschoolName
                    
                    var grade: String = jsonData[0].valueForKey("grade") as! String
                    programLabel.text = grade
                    
                    if(jsonData[0].valueForKey("picture") as! String != ""){
                    var imgURL: String = jsonData[0].valueForKey("picture") as! String
                    var url = NSURL(string: imgURL)
                    var imgData = NSData(contentsOfURL: url!)
                    myImageView.image = UIImage(data: imgData!)
                    } else {
                        myImageView.image = UIImage(named: "profile_default.jpg")
                    }
                    
                } else {
                    
                    println("No Match yet! :(")
                    fullNameLabel.hidden = true
                    universityLabel.hidden = true
                    programLabel.hidden = true
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "No Match"
                    alertView.message = "No Match yet! :("
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                    
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
