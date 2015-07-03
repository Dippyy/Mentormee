//
//  MentorUserDataSearchController.swift
//  Mentormee_ver2.0
//
//  Created by Prerna Kaul on 2015-06-29.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class MentorUserDataSearchController:UITableViewController{
    
    var senderField:String!
    var temp_array:Array< String > = Array < String >()
    var selectedItem:String!
    
    var cars = [String]()
    var url = "http://mentormee.info/dbTestConnect/programUpdate.php"
    
    @IBOutlet var userDataTableView: UITableView!{
        didSet{
            userDataTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cars=["BMW", "Audi", "Toyota"]
        println("Printing VAL!! \(senderField)")
        if(senderField == "Program"){
            println("sender field is Program")
            getDataFromURL(url, searchField: "Faculty")
        } else if (senderField == "Specialization"){
            getDataFromURL(url, searchField: "Program")
        }else if(senderField == "University"){
            getDataFromURL(url, searchField: "University")
        }else if (senderField == "Hometown"){
            getDataFromURL(url, searchField: "Hometown")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temp_array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = userDataTableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = temp_array[indexPath.row]
        
        return cell
    }
    
    func getDataFromURL(var url:String, var searchField:String){
        println("sender detail: ")
        let urlToSend = NSURL(string:url)
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()  //NSUserDefault = Dictionary
        var post: NSString = "selection=\(senderField)"
        println("post is: \(post)")
        var postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength : NSString = String(postData.length)
        
         var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToSend!)
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
            NSLog("Response Code: %ld", res.statusCode)
            var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData)
            var error: NSError?
            
            let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
            
            
            for (var i=0; i<jsonData.count;i++) {
                if let jsonData_obj = jsonData[i].valueForKey(searchField) as? String
                {
                    temp_array.append(jsonData_obj)
                    //                   println(jsonData_obj)         // this prints all the jsonData elements
                }
            }
        } else{
            println("url data is empty")
        }
        /**if(searchField == "Program"){
            
        } else if (searchField == "Faculty"){
            
        }else if(searchField == "University"){
            
        }else if(senderField == "Hometown"){
            
        }*/
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segue is underway, update destination ViewController with value set earlier
        
        if let vc = segue.destinationViewController as? MenteeMentorSearchViewController {
            vc.userSelectionField = senderField
            vc.userSelectionText = selectedItem
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = temp_array[indexPath.row] as String
        selectedItem = selected
        performSegueWithIdentifier("goto_searchcriteria", sender: self)
    }
    
    

    
    
}
