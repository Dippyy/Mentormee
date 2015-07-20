//
//  NamePictureVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-13.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class NamePictureVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var whatsupTextField: UITextView!
    @IBOutlet weak var whatsupTextFieldBorder: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.alpha = 0
        profilePictureImageView.alpha = 0
        selectPhotoButton.alpha = 0
        whatsupTextField.alpha = 0
        whatsupTextFieldBorder.alpha = 0
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
    }
    
//--------- Based on the selection made from the previous view controller the corresponding ------------------
//---------                         fields will appear                                      ------------------
    
    override func viewDidAppear(animated: Bool) {
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(prefs.valueForKey("Selection")!.isEqualToString("Profile Picture")){
            UIView.animateWithDuration(0, animations: {
                self.selectPhotoButton.alpha = 1.0
                self.profilePictureImageView.alpha = 1.0
            })
        } else if (prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
            self.fullNameTextField.text = prefs.valueForKey("Full Name") as! String
            UIView.animateWithDuration(0, animations: {
                self.fullNameTextField.alpha = 1.0
            
            })
        } else if (prefs.valueForKey("Selection")!.isEqual("What's Up")){
            self.whatsupTextField.text = prefs.valueForKey("Whatsup") as! String
            UIView.animateWithDuration(0, animations: {
                self.whatsupTextField.alpha = 1.0
                self.whatsupTextFieldBorder.alpha = 1.0
            })
        } else if (prefs.valueForKey("Selection")!.isEqual("Skype")){
            self.fullNameTextField.text = prefs.valueForKey("Skype") as! String
            UIView.animateWithDuration(0, animations: {
                self.fullNameTextField.alpha = 1.0
            })
        } else if (prefs.valueForKey("Selection")!.isEqual("Facebook")){
            self.fullNameTextField.text = prefs.valueForKey("Facebook") as! String
            UIView.animateWithDuration(0, animations: {
                self.fullNameTextField.alpha = 1.0
            })
        } else if (prefs.valueForKey("Selection")!.isEqual("Email")){
            self.fullNameTextField.text = prefs.valueForKey("email") as! String
            UIView.animateWithDuration(0, animations: {
                self.fullNameTextField.alpha = 1.0
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// Selects and stores a picture from the users photo library, will prompt user to access their photos
    
    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
// Uploads the picture/name/whatsup text to the DB
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
       
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
            
            var fullName: String = fullNameTextField.text as String
            
            var userID = prefs.valueForKey("userID") as! String
                    
            var fullNameArr = split(fullName) {$0 == " "}
            
            if(fullNameTextField.text.isEmpty){
                
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Full Name"
                alertView.message = "Please fill out your full name!"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
            } else {
                
            var firstName: String = fullNameArr[0]
            println("THE FIRST NAME IS \(firstName)")
            var lastName: String! = fullNameArr.count > 1 ? fullNameArr[1] : ""
            println("THE LAST NAME IS \(lastName)")

            var post: NSString = "userID=\(userID)&firstName=\(firstName)&lastName=\(lastName)"
            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateName.php")!
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
                    
                    if(success == 0){
                        self.performSegueWithIdentifier("goto_overview3", sender: self)
                    }
                    
                    if(success == 1){
                        NSLog("Update SUCCESS!")
                        self.performSegueWithIdentifier("goto_overview3", sender: self)
                    }
                }
            }
        }
            
        } else if(prefs.valueForKey("Selection")!.isEqualToString("What's Up")){
            
            var whatsupMentor: String = whatsupTextField.text as String
            var updateInfo: String = "whatsUpMentor"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateWhatsup2.php"
            update_table_info(urlToSend, userID: userID, updateField: whatsupMentor, updateVariable: updateInfo)
            
//            var whatsUp = whatsupTextField.text as String
//            var userID = prefs.valueForKey("userID") as! String
//            
//            var post: NSString = "userID=\(userID)&whatsup=\(whatsUp)"
//            var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/updateWhatsup2.php")!
//            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            var postLength:NSString = String(postData.length)
//            var request: NSMutableURLRequest = NSMutableURLRequest(URL:url)
//            
//            request.HTTPMethod = "POST"
//            request.HTTPBody = postData
//            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            
//            var responseError: NSError?
//            var response: NSURLResponse?
//            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
//            
//            if(urlData != nil){
//                
//                let res = response as! NSHTTPURLResponse!
//                NSLog("Response code: %ld", res.statusCode)
//                
//                if(res.statusCode >= 200 && res.statusCode < 300){
//                    
//                    var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
//                    NSLog("Response ==> %@", responseData)
//                    var error:NSError?
//                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
//                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
//                    NSLog("Success %ld", success)
//                    
//                    if(success == 0){
//                        self.performSegueWithIdentifier("goto_overview3", sender: self)
//                    }
//                    
//                    if(success == 1){
//                        NSLog("Update SUCCESS!")
//                        self.performSegueWithIdentifier("goto_overview3", sender: self)
//                    }
//                }
//            }
            
            
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Facebook")){
            
            var facebookID: String = fullNameTextField.text as String
            var updateInfo: String = "FacebookID"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateFacebookID.php"
            update_table_info(urlToSend, userID: userID, updateField: facebookID, updateVariable: updateInfo)
            
            // updates the Skype
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Skype")){
            
            var skypeID: String = fullNameTextField.text as String
            var updateInfo: String = "skypeID"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateSkypeID.php"
            update_table_info(urlToSend, userID: userID, updateField: skypeID, updateVariable: updateInfo)
            
            // updates the email
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Email")){
            
            var emailID: String = fullNameTextField.text as String
            var updateInfo: String = "emailID"
            var userID = prefs.valueForKey("userID") as! String
            var urlToSend: String = "http://mentormee.info/dbTestConnect/updateEmailID.php"
            update_table_info(urlToSend, userID: userID, updateField: emailID, updateVariable: updateInfo)
            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setObject(emailID, forKey: "email")
            
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Profile Picture")){
            
            myImageUploadRequest()
            self.performSegueWithIdentifier("goto_overview3", sender: self)
        }
    
    }
    
// Sets the imageview to whatever picture was selected by the user
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        let upload:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        upload.setObject("Uploaded", forKey: "Upload")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
// Uploads the image to the DB (format -> dbTestConnect/userprofilepic/uploads/2015/user-profile-(email).jpg)
    
    func myImageUploadRequest(){
        
        let myUrl = NSURL(string: "http://mentormee.info/dbTestConnect/imageUpload4.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let emailReceived = prefs.valueForKey("email") as! String
        println("THIS IS THE EMAIL ! \(emailReceived)")
        
        let param = ["email" : emailReceived]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePictureImageView.image, 1)
        
        if(imageData==nil) { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
        myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            // You can print out response object
            println("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("****** response data = \(responseString!)")
            
            dispatch_async(dispatch_get_main_queue(),{
                self.myActivityIndicator.stopAnimating()
                self.profilePictureImageView.image = nil;
            });
            
        }
        
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        
        var body = NSMutableData();
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let email = prefs.valueForKey("email") as! String
        let filename = "user-profile-\(email).jpg"
        let fileName = NSUserDefaults.standardUserDefaults()
        let fullImageUrl = "http://mentormee.info/dbTestConnect/userprofilepic/uploads/2015/\(filename)" as String
        fileName.setObject(fullImageUrl, forKey: "ProfileImage")
        
//        println("the image url should be \(fileName.valueForKey("ProfileImage"))")
    
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)–-\r\n")
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    // this function takes the userID, updatefield (the content) and the updatevariable (what is being updated)
    func update_table_info(url: String, userID: String, updateField: String, updateVariable: String){
        
        var post: NSString = "userID=\(userID)&\(updateVariable)=\(updateField)"
        println(post)
        var url:NSURL = NSURL(string: url)!
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
                
                if(success == 1){
                    NSLog("Update SUCCESS!")
                    self.performSegueWithIdentifier("goto_overview3", sender: self)
                    
                }
            }
        }
    }
    
    
}

    extension NSMutableData {
        func appendString(string: String) {
            let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            appendData(data!)
        }

}










