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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.alpha = 0
        profilePictureImageView.alpha = 0
        selectPhotoButton.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(prefs.valueForKey("Selection")!.isEqualToString("Profile Picture")){
            UIView.animateWithDuration(1.0, animations: {
                self.selectPhotoButton.alpha = 1.0
                self.profilePictureImageView.alpha = 1.0
            })
        } else if (prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
            UIView.animateWithDuration(1.0, animations: {
                self.fullNameTextField.alpha = 1.0
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
       
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Full Name")){
            
            var fullName: NSString = fullNameTextField.text as String
            prefs.setObject(fullName, forKey: "Full_Name_Selected") 
            self.performSegueWithIdentifier("goto_overview3", sender: self)
            
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Profile Picture")){
            
            myImageUploadRequest()
            self.performSegueWithIdentifier("goto_overview3", sender: self)
        }
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let upload:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        upload.setObject("Uploaded", forKey: "Upload")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func myImageUploadRequest(){
        
        let myUrl = NSURL(string: "http://mentormee.info/dbTestConnect/imageUpload2.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let emailReceived = prefs.valueForKey("email") as! String
        
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
        fileName.setObject(filename, forKey: "imageURL")
        let fullImageUrl = "http://mentormee.info/dbTestConnect/userprofilepic/uploads/2015/\(filename)" as String
        fileName.setObject(fullImageUrl, forKey: "ProfileImage")
    
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

    extension NSMutableData {
        func appendString(string: String) {
            let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            appendData(data!)
        }

}










