//
//  LocationPermissionViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/18/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class LocationPermissionViewController: UIViewController
{
    var user : User?
    var completionClosure : SignupResultClosure?
    
    lazy var locationManager = Magellan()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = self.user?.team?.color()
    }

    @IBAction func locationButtonPressed(sender: AnyObject)
    {
        self.locationManager.getLocation { (coordinate, error) in
            if let error = error
            {
                print(error)
                Magellan.alertForFailedLocationFrom(self, completion: { _ in
                    // They fucked up, proceed and hope they do something about it
                    self.completionClosure?(newUser: true)
                })
            }
            else // got the location, lets go!!!
            {
                self.completionClosure?(newUser:true)
            }
        }
    }
}
