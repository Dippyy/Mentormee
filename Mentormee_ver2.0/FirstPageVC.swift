//
//  FirstPageVC.swift
//  Mentormee_ver2.0
//
//  Created by Alex on 2015-07-03.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class FirstPageVC: UIViewController {

    @IBAction func MentorButton(sender: AnyObject) {
    }
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn = prefs.valueForKey("ISLOGGEDIN") as! Int
        if let status = prefs.valueForKey("Status") as? String {
        
        if(isLoggedIn == 1 && status == "Mentor") {
            self.performSegueWithIdentifier("goto_mentorhome2", sender: self)
        } else if (isLoggedIn == 1 && status == "Mentee") {
            self.performSegueWithIdentifier("", sender: self)
        } else if (isLoggedIn == 0 && status == "Mentor"){
            self.performSegueWithIdentifier("goto_mentorhome", sender: self)
        } else if (isLoggedIn == 0 && status == "Mentee"){
            self.performSegueWithIdentifier("", sender: self)
        }
            
        } else {
            println("no account!")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
