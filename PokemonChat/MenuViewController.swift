
//
//  MenuViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/16/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var menuButton: BouncingButton!
    @IBOutlet weak var addButton: UIButton!
    
    var composeDelegate : ComposeViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }

    @IBAction func menuButtonPressed(sender: UIButton)
    {
        self.navigationController?.delegate = self.navigationController?.viewControllers[0] as? PostsViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func addPostButtonPressed(sender: AnyObject)
    {
        // go to the compose screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigation = storyboard.instantiateViewControllerWithIdentifier("ComposeNavigation") as! UINavigationController
        let composeController = navigation.viewControllers.first as? ComposeViewController
        composeController?.delegate = self.composeDelegate
        self.navigationController!.presentViewController(navigation, animated: true) {
            self.navigationController?.popViewControllerAnimated(false)

        }
    }
}
