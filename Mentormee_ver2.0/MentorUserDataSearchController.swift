//
//  MentorUserDataSearchController.swift
//  Mentormee_ver2.0
//
//  Created by Prerna Kaul on 2015-06-29.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit
import iAd
import QuartzCore

class MentorUserDataSearchController:UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var senderField:String!
    var temp_array:Array< String > = Array < String >()
    var selectedItem:String!
    
    var cars = [String]()
    var url = "http://mentormee.info/dbTestConnect/programUpdate.php"
    
    @IBOutlet weak var userDataPickerView: UIPickerView!
    
    @IBOutlet weak var pickerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
            

        userDataPickerView.dataSource = self
        userDataPickerView.delegate = self
        
        cars=["BMW", "Audi", "Toyota"]
        println("Printing VAL!! \(senderField)")
        if (senderField == "Specialization"){
            getDataFromURL(url, searchField: "Program")
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int{
        return temp_array.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return temp_array[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLabel.text = temp_array[row]
        let selected = temp_array[row] as String
        selectedItem = selected
        performSegueWithIdentifier("goto_searchcriteria", sender: self)
    }
    
    
    func getDataFromURL(var url:String, var searchField:String){
        println("sender detail: ")
        let urlToSend = NSURL(string:url)
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()  //NSUserDefault = Dictionary
        var post: NSString = "selection=\(searchField)"
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
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(senderField, forKey: "fieldToSend")
        prefs.setObject(selectedItem, forKey: "specToSend")
        
        
        if let vc = segue.destinationViewController as? MenteeMentorSearchViewController {
            vc.userSelectionField = senderField
            vc.userSelectionText = selectedItem
            
            
        }
    }
    
    
}
