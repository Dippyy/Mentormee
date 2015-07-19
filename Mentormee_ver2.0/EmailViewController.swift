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
    
    
    
    var emailAddress = "info@mentormee.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        let image = UIImage(named: "NavbarImage")
        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject) {
        if(MFMailComposeViewController.canSendMail()){
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        } else{
            println("no email account found!")
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([emailAddress])
       
        mailComposerVC.setSubject("Coffee Chat Request")
        mailComposerVC.setMessageBody(textField.text, isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value{
        case MFMailComposeResultCancelled.value:
            println("cancelled!")
        case MFMailComposeResultFailed.value:
            println("failed!")
        case MFMailComposeResultSaved.value:
            println("saved!")
        case MFMailComposeResultSent.value:
            println("sent!")
        default:
            println("default!")
        }
        controller.dismissViewControllerAnimated(false, completion: nil)

    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
