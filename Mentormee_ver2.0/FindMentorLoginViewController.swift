//
//  FindMentorLoginViewController.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-07-10.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class FindMentorLoginViewController: UIViewController {

    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject("LoadMenteeLogin", forKey: "MenteeLogin")
        self.performSegueWithIdentifier("goto_menteeloginfromstartup", sender: self)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
//        nav?.tintColor = UIColor.yellowColor()
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
//        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "NavbarImage")

        self.navigationController!.navigationBar.setBackgroundImage(image,
            forBarMetrics: .Default)
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
