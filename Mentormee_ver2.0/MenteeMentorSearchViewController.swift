//
//  MenteeMentorSearchViewController.swift
//  Mentormee_ver2.0
//
//  Created by Prerna Kaul on 2015-06-22.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class MenteeMentorSearchViewController: UIViewController{
    
    var ProgramData:Array< String > = Array < String >()
    var SpecData:Array< String > = Array < String >()
    var HometownData:Array< String > = Array < String >()
    var UnivData:Array< String > = Array < String >()
    
    var tempcomparisonField:Array< String > = Array < String >()
    var comparisonField:Array< String > = Array < String >()
    var mentorsWithSpace_array:Array< AnyObject > = Array < AnyObject >()
    var topThreeMentors:Array< AnyObject > = Array < AnyObject >()
    var mentorRating:Array< Int > = Array < Int >()
    
    
    @IBOutlet weak var specButton: UIButton!
    
    @IBOutlet weak var programButton: UIButton!
    
    @IBOutlet weak var univButton: UIButton!
    
    @IBOutlet weak var hometownButton: UIButton!
    
    //var mentorList
    let userdefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var userDataLabel: UILabel!
    
    @IBOutlet var userDataView: UITableView!
    
    var senderDetail:String!
    var userSelectionText:String!
    var userSelectionField:String!
    var URL = "http://mentormee.info/dbTestConnect/programUpdate.php"
    
    //get_data_from_url("http://mentormee.info/dbTestConnect/programUpdate.php")
    //program = faculty
    // specialization = program
    
    override func viewDidLoad() {
        if(userSelectionField != nil){
            switch(userSelectionField){
            case "Program":
                programButton.setTitle("Program: \(userSelectionText)", forState: UIControlState.Normal)
            case "Specialization":
                specButton.setTitle("Specialization: \(userSelectionText)", forState: UIControlState.Normal)
            case "University":
                univButton.setTitle("University: \(userSelectionText)", forState: UIControlState.Normal)
            case "Hometown":
                hometownButton.setTitle("Hometown: \(userSelectionText)", forState: UIControlState.Normal)
            default:
                userSelectionField = nil
                userSelectionText = nil
            }
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var field = userdefaults.valueForKey("buttonClicked") as! String
        
        if let vc = segue.destinationViewController as? MentorUserDataSearchController {
            vc.senderField = field
            println("Printing valuee!! \(vc.senderField)")
        }
    }
    
    // =========================================  //
    
    @IBAction func FindMentorButtonTapped(sender: AnyObject) {
        //"Find A Mentor Now" button clicked
        if ((self.userSelectionText) != nil) {
        tempcomparisonField.insert(userSelectionText, atIndex: 0)
        } else {
            tempcomparisonField.insert("nil", atIndex: 0)
        }
        
        tempcomparisonField.insert("Engineering", atIndex: 1)
        tempcomparisonField.insert("University of Toronto", atIndex: 2)
        comparisonField = tempcomparisonField
        tempcomparisonField = []
        
        lets_connect_you_with_a_mentor(userSelectionText)
    }
    
    
    func lets_connect_you_with_a_mentor(Program:String) -> NSArray{
        
        // uses allMentorList & comparisonField to identify the top three mentors in an NSArray
    
        let allMentorList:NSArray = (Algorithm_filterOnCapacity("http://mentormee.info/dbTestConnect/Algorithm_filterOnCapacity.php"))
        
        for (var i=0; i<allMentorList.count; i++) {
            
            mentorRating.insert((Algorithm_rating(allMentorList[i], comparisonField)), atIndex: i)
            
        }
        
        var topThreeMentorIndex:Array< Int > = Array < Int >()
        
        
        println(mentorRating)
        
        for (var i=0; i<mentorRating.count; i++) {
            if (mentorRating[i] == maxElement(mentorRating) && topThreeMentorIndex.count != 3) {
                topThreeMentorIndex.append(i)
                topThreeMentors.append(allMentorList[i])
                mentorRating[i] = 0
            }
        }
        
        for (var i=0; i<mentorRating.count; i++) {
            if (mentorRating[i] == maxElement(mentorRating) && topThreeMentorIndex.count != 3) {
                topThreeMentorIndex.append(i)
                topThreeMentors.append(allMentorList[i])
                mentorRating[i] = 0
            }
        }
        for (var i=0; i<mentorRating.count; i++) {
            if (mentorRating[i] == maxElement(mentorRating) && topThreeMentorIndex.count != 3) {
                topThreeMentorIndex.append(i)
                topThreeMentors.append(allMentorList[i])
                mentorRating[i] = 0
            }
        }
        println(comparisonField)
        println(topThreeMentors)
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(topThreeMentors, forKey: "topThreeMentors")
        
        
        return topThreeMentors
    }

    
    
    
    // =====================================  //
    
    
    //program button clicked
    @IBAction func programButtonTapped(sender: AnyObject) {
        
        let buttonClicked = "Program"
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        var buttonTest = userdefaults.valueForKey("buttonClicked") as! String
        userdefaults.synchronize()
        println("Printing valie!! \(buttonTest)")
        //        println("Printing value!! " \( userdefaults.valueForKey("buttonClicked") as! String?))
        
        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
        //programButton.setTitle("Program: /(userSelectionText)", forState: <#UIControlState#>)
    }
    
    
    //specialization button clicked
    @IBAction func specButtonTapped(sender: AnyObject) {
        let buttonClicked = "Specialization"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        userdefaults.synchronize()
        self.performSegueWithIdentifier("goto_programspec", sender: self)
    }
    
    //university button clicked
    @IBAction func univButtonTapped(sender: AnyObject) {
        let buttonClicked = "University"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        userdefaults.synchronize()
        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
        
    }
    
    //hometown
    @IBAction func homemadeButtonTapped(sender: AnyObject) {
        
        let buttonClicked = "Hometown"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        userdefaults.synchronize()
        
        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
    }
    
    
//    @IBAction func findMentorClicked(sender: AnyObject) {
//        
//        //generate mentors based on list of variables
//        useAlexAlgorithm("", b:"", c:"")
//        //get list of mentors and information in an array
//        //display list of mentors and info in table view
//    }
    
    
    
//    func useAlexAlgorithm(a: String, b: String, c: String){
//        
//    }
//    
//}

func Algorithm_filterOnCapacity(url:String) -> NSArray {
    //Returns an array with mentors who are currently available
    
    let urlToSend = NSURL(string:url)
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()  //NSUserDefault = Dictionary
    
    var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToSend!)
    
    request.HTTPMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    var responseError: NSError?
    var response: NSURLResponse?
    
    var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
    
    if(urlData != nil){
        
        let res = response as! NSHTTPURLResponse!
        //   NSLog("Response Code: %ld", res.statusCode)
        var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
        //  NSLog("Response ==> %@", responseData)
        var error: NSError?
        
        let jsonData: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
        
        
        for (var i=0; i<jsonData.count;i++) {
            if let jsonData_obj = jsonData[i].valueForKey("Account_ID") as? String
            {
                mentorsWithSpace_array.append(jsonData_obj)
                // this prints all the jsonData elements
            }
        }
        var unique = NSSet(array: mentorsWithSpace_array).allObjects
        // println(self.mentorsWithSpace_array)
      //  println(unique)
        return unique //unique is an array containing available mentor's account_id
        
        
        
        
    } else {
        println("url data is empty")
    }
    var empty:NSArray = []
    return empty
    
}



}



func test (mentor_id:AnyObject, comparisonField:NSArray) -> Int {
    //Takes in an available mentors from Algorithm_filterOnCapacity + Comparison Fields and spits out the top three rated mentors' Account_ID
    
    
    /*------- comparisonField ----[Program, Faculty, university] -----------*/
    
    var mentorID:NSString = mentor_id as! NSString
    var Program:NSString = comparisonField[0] as! NSString
    var Faculty:NSString = comparisonField[1] as! NSString
    var University:NSString = comparisonField[2] as! NSString
    
    var post:NSString = "mentorID=\(mentorID)&Program=\(Program)&Faculty=\(Faculty)&University=\(University)"
    //  NSLog("PostData: %@",post);
    
    var url:NSURL = NSURL(string:"http://mentormee.info/dbTestConnect/Algorithm_rating.php")!
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
        //    NSLog("Response code: %ld", res.statusCode);
        
        if (res.statusCode >= 200 && res.statusCode < 300) {
            var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
            //         NSLog("Response ==> %@", responseData);
            let Rating:NSInteger = responseData.integerValue
            //        println(Rating)
            return Rating
            //                var error: NSError?
            //                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
            ////                let Rating:NSInteger = jsonData.valueForKey("Rating") as! NSInteger
            ////                NSLog("Rating: %ld", Rating);
            ////                return Rating
            
        } else {
            println("omg...")  }
        
    }
    else { println("url data is empty") }
    println("PROBLEM!! :( ")
    return -1
}




func Algorithm_rating(mentor_id:AnyObject, comparisonField:NSArray) -> Int{
    //Takes in an available mentor from Algorithm_filterOnCapacity + Comparison Fields and spits out the top three rated mentors' Account_ID
    
    
    /*------- Extracting PrimaryCapacity --------------*/
    
    var Rating:Int = 0
    var mentorID:NSString = mentor_id as! NSString
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
      //      NSLog("Response ==> %@", responseData);
            var error: NSError?
            let jsonData: NSDictionary = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary)!
            PrimaryCapability_id = jsonData.valueForKey("PrimaryCapability_id") as! NSString
      //      println(PrimaryCapability_id)
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
    //        NSLog("Response ==> %@", responseData);
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
   //     NSLog("Response code: %ld", res.statusCode);
        if (res.statusCode >= 200 && res.statusCode < 300) {
            
            var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
   //         NSLog("Response ==> %@", responseData);
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
   //     NSLog("Response code: %ld", res.statusCode);
        if (res.statusCode >= 200 && res.statusCode < 300) {
            
            var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
   //         NSLog("Response ==> %@", responseData);
            var error: NSError?
            let jsonData4: NSArray = (NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray)!
            mentor_Univeristy = jsonData4[0].valueForKey("University") as! NSString
            
        } else {
            println("...")  }
    }
    else { println("...") }
    
    
    if (comparisonField[0] as! NSString == mentor_Program) {
        Rating += 33
    }
    
    if (comparisonField[1] as! NSString == mentor_Faculty) {
        Rating += 33
    }
    
    if (comparisonField[2] as! NSString == mentor_Univeristy) {
        Rating += 33
    }
    
    return Rating
}


