//
//  staticTableUpdateVC.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-07-01.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class staticTableUpdateVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    // static table view that allows the user to update their graduation year
    
    let yearOfStudy = ["Grade 9","Grade 10","Grade 11", "Grade 12"]
    let contactInfo = ["Facebook","Skype","Email"]
    let textCellIdentifier = "cell5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_profileupdate2", sender: self)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(prefs.valueForKey("Selection")!.isEqualToString("Grade")){
            return yearOfStudy.count
        }
        else if(prefs.valueForKey("Selection")!.isEqualToString("Contact Info")){
            return contactInfo.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // populates the tableview with the contents of the array yearOfStudy
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Grade")){
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //takes in the year that the user selected and calculates the grad year and sends the result to the db
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Grade")){
        
        var gradYear: Int = 2018 - row
        
        var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var userID = prefs.valueForKey("userID") as! String
        println(userID)
        
        var post: NSString = "userID=\(userID)&yearOfStudy=\(gradYear)"
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/MenteeGradYear.php")!
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
                    self.performSegueWithIdentifier("goto_profileupdate2", sender: self)
                }
            }
        }
    }
        if(prefs.valueForKey("Selection")!.isEqualToString("Contact Info")){
            
            let selectedContactDevice = contactInfo[row] as String
            prefs.setObject(selectedContactDevice, forKey: "Selection")
            self.performSegueWithIdentifier("goto_singleFieldSelect", sender: self)
        }
    }
}
