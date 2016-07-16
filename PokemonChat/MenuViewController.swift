
//
//  MenuViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/16/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController
{
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var menuButton: BouncingButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }

    @IBAction func menuButtonPressed(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
