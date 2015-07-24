//
//  EmailViewController.swift
//  EmailMe
//
//  Created by Prerna Kaul on 2015-07-16.
//  Copyright (c) 2015 Jadoo. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var emailAddress = "info@mentormee.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func deregisterFromKeyboardNotifications() -> Void {
        println("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func keyboardWasShown(notification: NSNotification) {
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size)!
        var buttonOrigin: CGPoint = self.connectButton.frame.origin;
        var buttonHeight: CGFloat = self.connectButton.frame.size.height/2;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        instructionLabel.hidden = true
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    
    // functions to control how the keyboard behaves when the textfields are tapped
    
    func hideKeyboard() {
        connectButton.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        textField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject) {
        
        //SEND ALERT , ARE YOU SURE YOU WANT TO EMAIL THIS TO YOUR MENTOR?
        
        //Create a record in the database for message, mentee email, mentor email
        // -> Send mentee ID and mentor ID to database and retreive emails
        // -> Send emails and message to new table in DB
        
        //Package information into email format, textfield = BODY, static = subject, to = mentor, from = mentee
        //  -> Dynamic content: Body, From
        //  -> Static content: Subject, To

        
        
        
//        if(MFMailComposeViewController.canSendMail()){
//            let mailComposeViewController = configuredMailComposeViewController()
//            if MFMailComposeViewController.canSendMail() {
//                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//            } else {
//                self.showSendMailErrorAlert()
//            }
//        } else{
//            println("no email account found!")
//        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        
//        mailComposerVC.setToRecipients([emailAddress])
//       
//        mailComposerVC.setSubject("First Connection")
//        mailComposerVC.setMessageBody(textField.text, isHTML: true)
//        
//        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
//        switch result.value{
//        case MFMailComposeResultCancelled.value:
//            println("cancelled!")
//        case MFMailComposeResultFailed.value:
//            println("failed!")
//        case MFMailComposeResultSaved.value:
//            println("saved!")
//        case MFMailComposeResultSent.value:
//            println("sent!")
//        default:
//            println("default!")
//        }
//        controller.dismissViewControllerAnimated(false, completion: nil)

    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
