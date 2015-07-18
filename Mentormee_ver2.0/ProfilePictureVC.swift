//
//  ProfilePictureVC.swift
//  MenteeProfilePage
//
//  Created by Robert D'Ippolito on 2015-07-02.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class ProfilePictureVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectAPhotoButton: UIButton!
    @IBOutlet weak var uploadAPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func selectPhotoTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    @IBAction func uploadPhotoTapped(sender: AnyObject) {
        
        myImageUploadRequest()
        
        let storedData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(storedData.valueForKey("ProfileImage") != nil) {
            let imageURL = storedData.valueForKey("ProfileImage") as! String
            println(imageURL)
            storedData.setObject(imageURL, forKey: "imageToSend")
        } else {
            let imageURL = storedData.valueForKey("Profile Picture") as! String
            storedData.setObject(imageURL, forKey: "imageToSend")
        }
        
        let imageURL = storedData.valueForKey("imageToSend") as! String
        
        var userID = storedData.valueForKey("userID") as! String
                
        var post: NSString = "userID=\(userID)&imageURL=\(imageURL)"
        
        var url:NSURL = NSURL(string: "http://mentormee.info/dbTestConnect/saveUserInfo.php")!
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
                    self.performSegueWithIdentifier("goto_profileupdate3", sender: self)
                } else {
                    var error_msg: NSString
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    self.performSegueWithIdentifier("goto_profileupdate3", sender: self)

                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Update Failed!"
                alertView.message = "Connection Failed Here"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Connection Failure"
            if let error = responseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    
        
    
    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_profileupdate3", sender: self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func myImageUploadRequest(){
        
        let myUrl = NSURL(string: "http://mentormee.info/dbTestConnect/imageUpload4.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let emailReceived = prefs.valueForKey("email") as! String
        
        let param = ["email" : emailReceived]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profileImageView.image, 1)
        
        if(imageData==nil) { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
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
                self.profileImageView.image = nil;
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
        //        fileName.setObject(filename, forKey: "imageURL")
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

}

