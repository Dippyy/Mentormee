//
//  FindMentorNavigationController.swift
//  Mentormee_ver2.0
//
//  Created by Prerna Kaul on 2015-07-08.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class FindMentorNavigationController: UINavigationController {
    
    var userSelectionTxt:String!
    var userSelectionFld:String!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(userSelectionFld != nil && userSelectionTxt != nil){
            performSegueWithIdentifier("goto_searchcriteria", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? MenteeMentorSearchViewController {
            println("nav field: \(userSelectionFld)")
            println("nav text: \(userSelectionTxt)")

            vc.userSelectionField = userSelectionFld
            vc.userSelectionText = userSelectionTxt
            vc.navigationItem.title = "MentorMee"
        }
    }
    
}
