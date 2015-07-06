//
//  Test_Connection2VC.swift
//  Mentormee_ver2.0
//
//  Created by Alex on 2015-06-24.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class Test_Connection2VC: UIViewController {
    

    @IBOutlet weak var textBoxOne1: UILabel!
    @IBOutlet weak var textBoxOne2: UILabel!
    @IBOutlet weak var textBoxOne3: UILabel!
    
    
    @IBOutlet weak var textBoxTwo1: UILabel!
    @IBOutlet weak var textBoxTwo2: UILabel!
    @IBOutlet weak var textBoxTwo3: UILabel!

    @IBOutlet weak var textBoxThree1: UILabel!
    @IBOutlet weak var textBoxThree2: UILabel!
    @IBOutlet weak var textBoxThree3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pref: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let topThreeMentors:NSArray = pref.valueForKey("topThreeMentors")! as! NSArray
        
        let mentorOneArray:NSArray = populateMentorInfo(topThreeMentors[0].integerValue)
        
        let mentorTwoArray:NSArray = populateMentorInfo(topThreeMentors[1].integerValue)
        
        let mentorThreeArray:NSArray = populateMentorInfo(topThreeMentors[2].integerValue)
        
        textBoxOne1.text = mentorOneArray[0] as? String
        textBoxOne2.text = mentorOneArray[1] as? String
        textBoxOne3.text = mentorOneArray[2] as? String
        
        textBoxTwo1.text = mentorTwoArray[0] as? String
        textBoxTwo2.text = mentorTwoArray[1] as? String
        textBoxTwo3.text = mentorTwoArray[2] as? String
        
        textBoxThree1.text = mentorThreeArray[0] as? String
        textBoxThree2.text = mentorThreeArray[1] as? String
        textBoxThree3.text = mentorThreeArray[2] as? String
        

        
        
        
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func populateMentorInfo (mentor_id: Int) -> NSArray {
        
        /*------- Extracting PrimaryCapacity --------------*/
        
        var Rating:Int = 0
        var mentorID:Int = mentor_id
        var PrimaryCapability_id:NSString = ""
        var mentor_Program:NSString = ""
        var mentor_Faculty:NSString = ""
        var mentor_Univeristy:NSString = ""
        
        var mentor_Program_ID:NSString = ""
        var mentor_Univeristy_ID:NSString = ""
        
        var post:NSString = "mentorID=\(mentorID)"
        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/Algorithm_rating_PrimaryCapability.php")!
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
            
            let res = response as! NSHTTPURLResponse!
            if (res.statusCode >= 200 && res.statusCode < 300) {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);
                var error: NSError?
                let jsonData: NSDictionary = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary)!
                PrimaryCapability_id = jsonData.valueForKey("PrimaryCapability_id") as! NSString
                println(PrimaryCapability_id)
            }
        }
        
        /*------- Use PrimaryCapability to get Mentor's [Program, Faculty, University] -----------*/
        
        
        
        post = "PrimaryCapability_id=\(PrimaryCapability_id)"
        url = NSURL(string:"http://mentormee.info/dbTestConnect/Algorithm_rating_dataExtract.php")!
        postData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        postLength = String( postData.length )
        request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError2: NSError?
        var response2: NSURLResponse?
        
        urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response2, error:&reponseError2)
        
        
        
        if ( urlData != nil ) {
            
            let res = response as! NSHTTPURLResponse!
            NSLog("Response code: %ld", res.statusCode);
            if (res.statusCode >= 200 && res.statusCode < 300) {
                
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);
                var error: NSError?
                let jsonData2: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                mentor_Program_ID  = jsonData2[0].valueForKey("Program_id") as! NSString
                //            mentor_Faculty = jsonData.valueForKey("Faculty") as! NSString
                mentor_Univeristy_ID = jsonData2[1].valueForKey("University_id") as! NSString
                
            } else {
                println("...")  }
        }
        else { println("...") }
        
        /*------- Get Mentor's [Program, Faculty] from the above ID -----------*/
        
        
        post = "mentor_Program_ID=\(mentor_Program_ID)"
        url = NSURL(string:"http://mentormee.info/dbTestConnect/Algorithm_rating_dataExtract2.php")!
        postData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        postLength = String( postData.length )
        request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError3: NSError?
        var response3: NSURLResponse?
        
        urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response3, error:&reponseError3)
        
        
        
        if ( urlData != nil ) {
            
            let res = response as! NSHTTPURLResponse!
            NSLog("Response code: %ld", res.statusCode);
            if (res.statusCode >= 200 && res.statusCode < 300) {
                
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);
                var error: NSError?
                let jsonData3: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                mentor_Program  = jsonData3[0].valueForKey("Program") as! NSString
                mentor_Faculty = jsonData3[1].valueForKey("Faculty") as! NSString
                //            var mentor_Univeristy_ID:NSString = jsonData2[1].valueForKey("University_id") as! NSString
                
                
            } else {
                println("...")  }
        }
        else { println("...") }
        
        
        
        /*------- Get Mentor's [University] from the above ID -----------*/
        
        
        post = "mentor_University_ID=\(mentor_Univeristy_ID)"
        url = NSURL(string:"http://mentormee.info/dbTestConnect/Algorithm_rating_dataExtract3.php")!
        postData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        postLength = String( postData.length )
        request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError4: NSError?
        var response4: NSURLResponse?
        
        urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response4, error:&reponseError4)
        
        
        
        if ( urlData != nil ) {
            
            let res = response as! NSHTTPURLResponse!
            NSLog("Response code: %ld", res.statusCode);
            if (res.statusCode >= 200 && res.statusCode < 300) {
                
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);
                var error: NSError?
                let jsonData4: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                mentor_Univeristy = jsonData4[0].valueForKey("University") as! NSString
                
            } else {
                println("...")  }
        }
        else { println("...") }
        
            
        return [mentor_Program, mentor_Faculty, mentor_Univeristy]
            
        }

    @IBAction func connectButtonTappedTemporary(sender: AnyObject) {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("matchCheck") as! String == "NeverMatched"){
            self.performSegueWithIdentifier("goto_menteesignup", sender: self)
        } else if (prefs.valueForKey("matchCheck") as! String == "MatchedPreviously"){
            self.performSegueWithIdentifier("goto_loginhome2", sender: self)
        }
        
    }
    
    
    
    
}
