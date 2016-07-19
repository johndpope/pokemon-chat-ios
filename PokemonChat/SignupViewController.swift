//
//  SingupViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/18/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

typealias SignupResultClosure = (newUser:Bool) -> Void

private let SEGUE_USERNAME = "SignupToUsername"

class SignupViewController: UIViewController
{
    lazy var user = User()
    var completionClosure : SignupResultClosure?
    
    private var nextButton : UIBarButtonItem?
    @IBOutlet weak var teamLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.nextButton = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SEGUE_USERNAME
        {
            let usernameController = segue.destinationViewController as! UsernameViewController
            usernameController.shouldCheckUsernames = true
            usernameController.user = self.user
            usernameController.completionClosure = self.completionClosure
        }
    }
    
//MARK: Public
    
    func signupWithCompletion(completion: SignupResultClosure)
    {
        self.completionClosure = completion
    }
    
//MARK: Actions
    
    @IBAction func zapdosPressed(sender: UIButton)
    {
        self.selectTeam(.Yellow)
    }
    
    @IBAction func articunoPressed(sender: UIButton)
    {
        self.selectTeam(.Blue)
    }

    @IBAction func moltresPressed(sender: UIButton)
    {
        self.selectTeam(.Red)
    }
    
    @IBAction func checkmarkPressed(sender: UIButton)
    {
        // next
        self.performSegueWithIdentifier(SEGUE_USERNAME, sender: self)
    }
    
//MARK: Utilities
    
    private func selectTeam(team:Team)
    {
        // enable signup flow progression
        self.navigationItem.rightBarButtonItem = self.nextButton
        
        // style the background
        let color = TeamColors.colorForTeam(team)
        UIView.animateWithDuration(0.23) {
            self.navigationController?.navigationBar.barTintColor = color
            self.view.backgroundColor = color
        }
        
        // show the team name
        self.teamLabel.text = team.teamName().uppercaseString
        
        // update the user
        self.user.team = team
    }
    
}
