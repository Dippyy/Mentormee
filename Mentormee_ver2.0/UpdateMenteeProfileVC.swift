//
//  UpdateMenteeProfileVC.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-06-30.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit


class UpdateMenteeProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var updateCategories = ["Profile Picture","Full Name","High School","Grade","Contact Info","Current Situation","Future Options","What's Up","Interests"]
    let textCellIdentifier = "cell4"
    
    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("ISLOGGEDIN")!.isEqualToNumber(1)){
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Additional Information"
            alertView.message = "Hi! To help us provide a better match please feel free to add any of the following additional information! To be matched you will need to have set up your contact info! :)"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        }
        
        let userID = prefs.valueForKey("userID") as! String
        let userIDToSend = userID.toInt()
        
        var post: NSString = "userID=\(userIDToSend!)"
        
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/populateSelectionTableMentee.php")!
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
                
                prefs.setInteger(0, forKey: "ISLOGGEDIN")
                
                if let firstName: String = jsonData[0].valueForKey("FirstName") as? String{
                    prefs.setObject(jsonData[0].valueForKey("FirstName"), forKey: "First Name Mentee")
                    prefs.setObject(jsonData[0].valueForKey("LastName"), forKey: "Last Name Mentee")
                    var firstName: String = prefs.valueForKey("First Name Mentee") as! String
                    var lastName: String = prefs.valueForKey("Last Name Mentee") as! String
                    var fullName: String = firstName + " " + lastName
                    prefs.setObject(fullName, forKey: "Full Name Mentee")

                }
                
                if let highSchool: String = jsonData[0].valueForKey("HighSchool") as? String {
                    prefs.setObject(jsonData[0].valueForKey("HighSchool"), forKey: "Highschool Mentee")
                }
                
                if let skype: String = jsonData[0].valueForKey("Skype") as? String {
                    prefs.setObject(jsonData[0].valueForKey("Skype"), forKey: "Contact Info Mentee")
                }
                
                if let interests: String = jsonData[0].valueForKey("Interests") as? String {
                    prefs.setObject(interests, forKey: "Interests Mentee")
                }
                
                if let profilePic: String = jsonData[0].valueForKey("Picture") as? String {
                    prefs.setObject(profilePic, forKey: "Profile Picture Mentee")
                }
                
                if let whatsUp: String = jsonData[1].valueForKey("What's Up") as? String {
                    prefs.setObject(jsonData[1].valueForKey("WhatsUp"), forKey: "Whatsup Mentee")
                }
                
                if let whatsUp: String = jsonData[1].valueForKey("CurrentSituation") as? String {
                    prefs.setObject(jsonData[1].valueForKey("CurrentSituation"), forKey: "Current Situation")
                }
                
                if let whatsUp: String = jsonData[1].valueForKey("FutureOptions") as? String {
                    prefs.setObject(jsonData[1].valueForKey("FutureOptions"), forKey: "Future Options")
                }
                
                if let whatsUp: String = jsonData[1].valueForKey("GraduationYear") as? String {
                    prefs.setObject(jsonData[1].valueForKey("GraduationYear"), forKey: "Graduation Year Mentee")
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updateCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = updateCategories[row]
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(cell.textLabel?.text == "Full Name"){
            cell.detailTextLabel?.text = prefs.valueForKey("Full Name Mentee") as? String
        } else if(cell.textLabel?.text == "High School"){
            if(prefs.valueForKey("Highschool Mentee") as? String != ""){
                cell.detailTextLabel?.text = prefs.valueForKey("Highschool Mentee") as? String
            } else {
                cell.detailTextLabel?.text = "Where did you go to HS?"
            }
        } else if(cell.textLabel?.text == "What's Up"){
            if(prefs.valueForKey("Whatsup Mentee") as? String != ""){
                cell.detailTextLabel?.text = "Whatsup Set"
            } else {
                cell.detailTextLabel?.text = "Whats on your mind?"
            }
        } else if(cell.textLabel?.text == "Grade"){
            if(prefs.valueForKey("Graduation Year Mentee") as? String != "0"){
                cell.detailTextLabel?.text = prefs.valueForKey("Graduation Year Mentee") as? String
            } else {
                cell.detailTextLabel?.text = "What year do you finish HS?"
            }
        }else if(cell.textLabel?.text == "Current Situation"){
            if(prefs.valueForKey("Current Situation") as? String != ""){
                cell.detailTextLabel?.text = "Current Situation Set"
            } else {
                cell.detailTextLabel?.text = "What are your goals?"
            } 
        } else if(cell.textLabel?.text == "Future Options"){
            if(prefs.valueForKey("Future Options") as? String != ""){
                cell.detailTextLabel?.text = "Future Options Set"
            } else {
                cell.detailTextLabel?.text = "What is your future?"
            }
        } else if(cell.textLabel?.text == "Contact Info"){
            if(prefs.valueForKey("Contact Info") as? String != nil){
                cell.detailTextLabel?.text = "Contact Info Set"
            } else {
                cell.detailTextLabel?.text = "Set up Contact Info"
            }
        } else if(cell.textLabel?.text == "Interests"){
            if(prefs.valueForKey("Interests Mentee") as? String != ""){
                cell.detailTextLabel?.text = "Interests Set"
            } else {
                cell.detailTextLabel?.text = "What are you interested in?"
            }
        } else if(cell.textLabel?.text == "Profile Picture"){
            if(prefs.valueForKey("Profile Picture Mentee") as? String != ""){
                cell.detailTextLabel?.text = "Uploaded"
            } else {
                cell.detailTextLabel?.text = "Upload a Picture"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = updateCategories[row]
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(cell.textLabel?.text == "Full Name"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_textUpdate", sender: self)
        }  else if (cell.textLabel?.text == "Profile Picture"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_profilepicture", sender: self)
        } else if (cell.textLabel?.text == "High School"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_textUpdate", sender: self)
        } else if (cell.textLabel?.text == "Grade"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_staticTable", sender: self)
        } else if (cell.textLabel?.text == "Contact Info"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_staticTable", sender: self)
        } else if (cell.textLabel?.text == "Current Situation"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_textUpdate", sender: self)
        } else if (cell.textLabel?.text == "Future Options"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_textUpdate", sender: self)
        } else if (cell.textLabel?.text == "What's Up"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_textUpdate", sender: self)
        } else if (cell.textLabel?.text == "Interests"){
            prefs.setObject(cell.textLabel?.text, forKey: "Selection")
            self.performSegueWithIdentifier("goto_textUpdate", sender: self)
        }
    }
        
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_menteehome", sender: self)
    }


}
