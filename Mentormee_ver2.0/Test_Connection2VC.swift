//
//  Test_Connection2VC.swift
//  Mentormee_ver2.0
//
//  Created by Alex on 2015-06-24.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class Test_Connection2VC: UIViewController {

@IBOutlet weak var ConnectButton: UIButton!
@IBOutlet weak var BackButton: UIButton!
    
@IBAction func connectButtonTapped(sender: AnyObject) {
    
    
    
    }
    
    
@IBAction func backButtonTapped(sender: AnyObject) {
     self.performSegueWithIdentifier("goto_TestConnection", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
