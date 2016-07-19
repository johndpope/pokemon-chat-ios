//
//  SettingsViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/19/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

private enum Section : Int
{
    case MyStuff = 0
    case Feedback = 1
    case Logout = 2
}

class SettingsViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == Section.Logout.rawValue
        {
            self.logOutCurrentUser()
        }
    }
    
    func logOutCurrentUser()
    {
        User.currentUser()?.logOut({ (itWorked, error) in
            
            // a notification will be fired for teardown
            
            if (error != nil)
            {
                // handle location error with alert
                let controller = UIAlertController(title: "Drat", message: "That didn't work. Try again, or restart the app if the problem continues.", preferredStyle: UIAlertControllerStyle.Alert)
                // dismiss the controller option
                let okayButton = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: { (_) in
                    controller.dismissViewControllerAnimated(true, completion: nil)
                })
                
                controller.addAction(okayButton)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        })
    }

}
