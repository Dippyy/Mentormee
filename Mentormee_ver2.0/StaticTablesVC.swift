//
//  StaticTablesVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-12.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class StaticTablesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    let genderTable = ["Male","Female"]
    let yearOfStudy = ["First Year","Second Year","Third Year", "Fourth Year", "Graduate"]
    let contactInfo = ["Skype","Facebook","Email"]
    let textCellIdentifier = "cell3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0, animations: {
            self.myTableView.alpha = 1.0
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Depending on what the user selected (Gender/Year) the number of cells is equal to the count of each array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(prefs.valueForKey("Selection")!.isEqualToString("Gender")){
            return genderTable.count
        }
        else if(prefs.valueForKey("Selection")!.isEqualToString("Year")){
            return yearOfStudy.count
        }
        else if(prefs.valueForKey("Selection")!.isEqualToString("Contact Info")){
            return contactInfo.count
        }
        return 0
    }
    
    // The values of these cells are based on the contents of the arrays (genderTable/yearOfStudy) -> see top for declaration
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        if(prefs.valueForKey("Selection")!.isEqualToString("Gender")){
            cell.textLabel?.text = genderTable[row]
            return cell
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Year")){
            cell.textLabel?.text = yearOfStudy[row]
            return cell
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Contact Info")){
            cell.textLabel?.text = contactInfo[row]
            
            let userID = prefs.valueForKey("userID") as! String
            let userIDToSend = userID.toInt()
            
            var post: NSString = "userID=\(userIDToSend!)"
            
            NSLog("PostData: %@",post);
            var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/populateContractInfo.php")!
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
                    prefs.setObject(jsonData[0].valueForKey("Facebook"), forKey: "Facebook")
                    prefs.setObject(jsonData[0].valueForKey("Skype"), forKey: "Skype")
                    
                    
                    if let facebookID = prefs.valueForKey("Facebook") as? String {
                        if(cell.textLabel?.text == "Facebook"){
                            cell.detailTextLabel?.text = facebookID
                        }
                    }
                    if let skypeID = prefs.valueForKey("Skype") as? String {
                        if(cell.textLabel?.text == "Skype"){
                            cell.detailTextLabel?.text = skypeID
                        }
                    }
                    if let emailID = prefs.valueForKey("email") as? String {
                        if(cell.textLabel?.text == "Email"){
                            cell.detailTextLabel?.text = emailID
                        }
                    }
                }
            }
            
            return cell
        }
        return cell
    }
    
    // Whatever is selected from the table is pushed to the DB under the Gender and GraduationYear columns
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Gender")){
                
                var genderSelected = genderTable[row]
                println("WE ARE GETTING INTO THIS PART OF THE CODE")
                var userID = prefs.valueForKey("userID") as! String
                
                var post: NSString = "userID=\(userID)&genderSelect=\(genderSelected)"
                println(post)
                var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/genderNameUpdate2.php")!
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
                            NSLog("Update SUCCESS!")
                            self.performSegueWithIdentifier("goto_overview2", sender: self)
                    }
                }
            }

        }
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Year")){
            
            var gradYear: Int = 2018 - row
            
            var userID = prefs.valueForKey("userID") as! String
            
            var post: NSString = "userID=\(userID)&yearOfStudy=\(gradYear)"
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/yearOfStudyUpdate2.php")!
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
                        NSLog("Update SUCCESS!")
                        self.performSegueWithIdentifier("goto_overview2", sender: self)
                    }
                }
            }
        }
        if(prefs.valueForKey("Selection")!.isEqualToString("Contact Info")){
            
            let selectedContactDevice = contactInfo[row] as String
            prefs.setObject(selectedContactDevice, forKey: "Selection")
            self.performSegueWithIdentifier("goto_singleFieldSelect2", sender: self)
            
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
