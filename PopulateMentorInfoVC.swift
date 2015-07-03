//
//  PopulateMentorInfoVC.swift
//  
//
//  Created by Robert D'Ippolito on 2015-06-26.
//
//

import UIKit

class PopulateMentorInfoVC: UIViewController {

    @IBOutlet weak var mentorProfileImageView: UIImageView!
    @IBOutlet weak var mentorNameTextLabel: UILabel!
    @IBOutlet weak var universityTextLabel: UILabel!
    @IBOutlet weak var programTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //This is an array of values that I am assuming will already be populated
        
        var InputData:String = "57"
//        MenteeInfo = ["Bobby Smith","Cardinal Newman","Grade 11","Contact Info","Current Situation","Future Options","Whatsup","Interests","profile_default.jpg",2]
//        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        //This setups the imageview so it appears circular
        
        mentorProfileImageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        mentorProfileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        mentorProfileImageView.layer.borderWidth = 1.5
        mentorProfileImageView.layer.masksToBounds = false
        mentorProfileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        mentorProfileImageView.layer.cornerRadius = mentorProfileImageView.frame.height/2
        mentorProfileImageView.clipsToBounds = true
        
        //Make DB call to retrieve mentor information from mentor 57
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        var post: NSString = "userID=\(InputData)"
        println(post)
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updatePublicProfile3.php")!
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
                
                let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
                
                var firstName: String = jsonData[0].valueForKey("FirstName") as! String
                var lastName: String = jsonData[0].valueForKey("LastName") as! String
                var fullName: String = firstName + " " + lastName
                
                if(firstName.isEmpty && lastName.isEmpty){
                    mentorNameTextLabel.text = "Full Name"
                } else {
                    var fullName: String = fullName
                    mentorNameTextLabel.text = fullName
                    println(fullName)
                }
                
                let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                if(jsonData[1].valueForKey("University_id")!.isEqualToString("0")){
                    let universityID = 1
                    prefs.setObject(universityID, forKey: "uniID")
                } else {
                    let universityID: String = jsonData[1].valueForKey("University_id") as! String
                    let uniID: Int? = universityID.toInt()
                    prefs.setObject(uniID, forKey: "uniID")
                }
                
                if(jsonData[1].valueForKey("Program_id")!.isEqualToString("0")){
                    let programID = 1
                    prefs.setObject(programID, forKey: "progID")
                } else {
                    let programID: String = jsonData[1].valueForKey("Program_id") as! String
                    let progID: Int? = programID.toInt()
                    prefs.setObject(progID, forKey: "progID")
                }
                
                let uniID = prefs.valueForKey("uniID") as! Int
                let progID = prefs.valueForKey("progID") as! Int
                
                var post: NSString = "universityID=\(uniID)&programID=\(progID)"
                NSLog("PostData: %@",post);
                var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/universityLookup.php")!
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
                        
                        var program: String = jsonData[1].valueForKey("Program") as! String
                        println(program)
                        if(program != ""){
                            programTextLabel.text = program
                            println(program)
                        } else {
                            programTextLabel.text = "Program of Study"
                        }
                        
                        var universityName: String = jsonData[0].valueForKey("University") as! String
                        println(universityName)
                        if(universityName != "") {
                            universityTextLabel.text = universityName
                            println(universityName)
                        } else {
                            universityTextLabel.text = "University"
                        }
                    }
                }
                
                if(jsonData[0].valueForKey("Picture")!.isEqualToString("")){
                    
                    mentorProfileImageView.image = UIImage(named: "profile_default.jpg")
                    
                } else {
                    
                    let imageString: String = jsonData[0].valueForKey("Picture") as! String
                    let url2 = NSURL(string: imageString)
                    let data = NSData(contentsOfURL: url2!)
                    mentorProfileImageView.image = UIImage(data: data!)
                }
                
                
            }
        }
        
//        mentorNameTextLabel.text = InputData[0] as? String
//        universityTextLabel.text = InputData[1]as? String
//        programTextLabel.text = InputData[2] as? String
//        mentorProfileImageView.image = UIImage(named: InputData[3] as! String)
        
        //variables that are not being used in this view controller are saved locally to be used later
        
//        prefs.setObject(InputData[4], forKey: "mentorUserID")
//        
//        prefs.setObject(MenteeInfo[0], forKey: "fullNameMentee")
//        prefs.setObject(MenteeInfo[1], forKey: "highSchool")
//        prefs.setObject(MenteeInfo[2], forKey: "gradeOfStudy")
//        prefs.setObject(MenteeInfo[3], forKey: "contactInfo")
//        prefs.setObject(MenteeInfo[4], forKey: "currentSituation")
//        prefs.setObject(MenteeInfo[5], forKey: "futureOptions")
//        prefs.setObject(MenteeInfo[6], forKey: "whatsupMentee")
//        prefs.setObject(MenteeInfo[7], forKey: "interestsMentee")
//        prefs.setObject(MenteeInfo[8], forKey: "menteeProfilePicture")
//        prefs.setObject(MenteeInfo[9], forKey: "userID")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mentorProfileClicked(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goto_mentorprofile", sender: self)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
