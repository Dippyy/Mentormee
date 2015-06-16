//
//  StaticTablesVC.swift
//  Mentormee_ver2.0
//
//  Created by Robert D'Ippolito on 2015-06-12.
//  Copyright (c) 2015 Robert D'Ippolito. All rights reserved.
//

import UIKit

class StaticTablesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    let genderTable = ["Male","Female"]
    let yearOfStudy = ["First Year","Second Year","Third Year", "Fourth Year", "Graduate"]
    let textCellIdentifier = "cell3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.0, animations: {
            self.myTableView.alpha = 1.0
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(prefs.valueForKey("Selection")!.isEqualToString("Gender")){
            return genderTable.count
        }
        else if(prefs.valueForKey("Selection")!.isEqualToString("Year")){
            return yearOfStudy.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        if(prefs.valueForKey("Selection")!.isEqualToString("Gender")){
            cell.textLabel?.text = genderTable[row]
            return cell
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Year")){
            cell.textLabel?.text = yearOfStudy[row]
            return cell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = myTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(prefs.valueForKey("Selection")!.isEqualToString("Gender")){
            cell.textLabel?.text = genderTable[row]
            prefs.setObject(genderTable[row], forKey: "Gender_Selected")
            self.performSegueWithIdentifier("goto_overview2", sender: self)
        } else if(prefs.valueForKey("Selection")!.isEqualToString("Year")){
            cell.textLabel?.text = yearOfStudy[row]
            prefs.setObject(yearOfStudy[row], forKey: "Year_Selected")
            self.performSegueWithIdentifier("goto_overview2", sender: self)
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
