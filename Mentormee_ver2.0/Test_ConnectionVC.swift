//
//  Test_ConnectionVC.swift
//  Mentormee_ver2.0
//
//  Created by Alex on 2015-06-24.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class Test_ConnectionVC: UIViewController, UIPickerViewDelegate {

    var temp_array:Array< String > = Array < String >()
    var tempcomparisonField:Array< String > = Array < String >()
    var comparisonField:Array< String > = Array < String >()

    //["Program", "Faculty", "University"]
    // This array contains mentee's selected: [Program, Faculty, University]
    
    var mentorsWithSpace_array:Array< AnyObject > = Array < AnyObject >()
    var topThreeMentors:Array< AnyObject > = Array < AnyObject >()
    var mentorRating:Array< Int > = Array < Int >()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       dataExtractor_onCritera("http://mentormee.info/dbTestConnect/Connection.php")
        ProgramSelectedLable.text = temp_array[0]
        
    }
    
   
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temp_array.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return temp_array[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedProgram = temp_array[row]
        ProgramSelectedLable.text = selectedProgram
    }



@IBOutlet weak var ConnectButton: UIButton!
@IBOutlet weak var BackButton: UIButton!
@IBOutlet weak var ProgramSelectedLable: UILabel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func BackButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_testconnection", sender: self)
        
    } 
    
    @IBAction func ConnectButtonTapped(sender: AnyObject) {
        
        NSLog("You selected")
        NSLog(ProgramSelectedLable.text!)
        
        tempcomparisonField.insert(ProgramSelectedLable.text!, atIndex: 0)
        tempcomparisonField.insert("Engineering", atIndex: 1)
        tempcomparisonField.insert("University of Toronto", atIndex: 2)
        comparisonField = tempcomparisonField
        tempcomparisonField = []
     
        
        
        lets_connect_you_with_a_mentor(ProgramSelectedLable.text!)

        
    }
    
    func dataExtractor_onCritera(url:String) {
        //Goes into data base, finds the Engineering programs and populates it into array called "program"
        
        let urlToSend = NSURL(string:url)
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()  //NSUserDefault = Dictionary
     //   let userInput = prefs.valueForKey("Alex_Key") as! String
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToSend!)
        
        request.HTTPMethod = "POST"
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
                if let jsonData_obj = jsonData[i].valueForKey("Program") as? String
                {
                    temp_array.append(jsonData_obj)
 //                   println(jsonData_obj)         // this prints all the jsonData elements
                }
            }
        } else{
            println("url data is empty")
        }
        
    }
   
    func lets_connect_you_with_a_mentor(Program:String) -> NSArray{
        
        // uses allMentorList & comparisonField to identify the top three mentors in an NSArray
        println("TESTING")
        test("1", comparisonField)
        println("TESTING")
        
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
            println(unique)
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



