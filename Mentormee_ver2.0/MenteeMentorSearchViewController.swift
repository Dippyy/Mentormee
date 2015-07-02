//
//  MenteeMentorSearchViewController.swift
//  Mentormee_ver2.0
//
//  Created by Prerna Kaul on 2015-06-22.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class MenteeMentorSearchViewController: UIViewController{
    
    var ProgramData:Array< String > = Array < String >()
    var SpecData:Array< String > = Array < String >()
    var HometownData:Array< String > = Array < String >()
    var UnivData:Array< String > = Array < String >()
    
    @IBOutlet weak var programButton: UIButton!
    
    @IBOutlet weak var specButton: UIButton!
    
    @IBOutlet weak var univButton: UIButton!
    
    @IBOutlet weak var hometownButton: UIButton!
    
    //var mentorList
    let userdefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var userDataLabel: UILabel!
    
    @IBOutlet var userDataView: UITableView!
    
    var senderDetail:String!
    var userSelectionText:String!
    var userSelectionField:String!
    var URL = "http://mentormee.info/dbTestConnect/programUpdate.php"
    
    //get_data_from_url("http://mentormee.info/dbTestConnect/programUpdate.php")
    //program = faculty
    // specialization = program
    
    override func viewDidLoad() {
        if(userSelectionField != nil){
            switch(userSelectionField){
            case "Program":
                programButton.setTitle("Program: \(userSelectionText)", forState: UIControlState.Normal)
            case "Specialization":
                specButton.setTitle("Specialization: \(userSelectionText)", forState: UIControlState.Normal)
            case "University":
                univButton.setTitle("University: \(userSelectionText)", forState: UIControlState.Normal)
            case "Hometown":
                hometownButton.setTitle("Hometown: \(userSelectionText)", forState: UIControlState.Normal)
            default:
                userSelectionField = nil
                userSelectionText = nil
            }
            
        }
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var field = userdefaults.valueForKey("buttonClicked") as! String
        
        if let vc = segue.destinationViewController as? MentorUserDataSearchController {
            vc.senderField = field
            println("Printing valuee!! \(vc.senderField)")
        }
    }

    //program button clicked
    @IBAction func programButtonTapped(sender: AnyObject) {
        
        let buttonClicked = "Program"
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        var buttonTest = userdefaults.valueForKey("buttonClicked") as! String
        userdefaults.synchronize()
        println("Printing valie!! \(buttonTest)")
//        println("Printing value!! " \( userdefaults.valueForKey("buttonClicked") as! String?))
        
        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
        //programButton.setTitle("Program: /(userSelectionText)", forState: <#UIControlState#>)
    }
    
    
    //specialization button clicked
    @IBAction func specButtonTapped(sender: AnyObject) {
        
        let buttonClicked = "Specialization"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        userdefaults.synchronize()
        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
     
        
    }
    
    //university button clicked
    @IBAction func univButtonTapped(sender: AnyObject) {
        let buttonClicked = "University"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        userdefaults.synchronize()
        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
        
    }
    
    //hometown
    @IBAction func homemadeButtonTapped(sender: AnyObject) {
        
        let buttonClicked = "Hometown"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setValue(buttonClicked, forKey:"buttonClicked")
        userdefaults.synchronize()

        self.performSegueWithIdentifier("goto_programspec", sender: self)
        
    }
    
    
    @IBAction func findMentorClicked(sender: AnyObject) {
        
        //generate mentors based on list of variables
        useAlexAlgorithm("", b:"", c:"")
        //get list of mentors and information in an array
        //display list of mentors and info in table view
    }
    
    
    
    func useAlexAlgorithm(a: String, b: String, c: String){
        
    }
    
}

