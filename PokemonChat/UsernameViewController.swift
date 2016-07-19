//
//  UsernameViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/18/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

let MAX_CHARACTER_USERNAME = 20
private let SEGUE_PASSWORD = "UserToPassword"

class UsernameViewController: UIViewController, UITextFieldDelegate
{
    var user : User?
    var completionClosure : SignupResultClosure?
    var shouldCheckUsernames = false
    
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet weak var nameTakenLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    
    private var hasShown = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = user?.team?.color()
        self.nextButton.enabled = false
        self.nameTakenLabel.hidden = true
        self.usernameField.delegate = self
        self.usernameField.text = nil
        self.listenForKeyboardNotifications(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if self.hasShown
        {
            self.usernameField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if !self.hasShown
        {
            self.usernameField.becomeFirstResponder()
            self.hasShown = true
        }
    }
    
    deinit
    {
        self.listenForKeyboardNotifications(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SEGUE_PASSWORD
        {
            let passwordController = segue.destinationViewController as! PasswordViewController
            passwordController.user = self.user
            passwordController.completionClosure = self.completionClosure
        }
    }
    
//MARK: Actions
    
    @IBAction func nextButtonPressed(sender: UIButton)
    {
        self.user?.username = self.usernameField.text?.trimmed()
        
        self.checkUsernameAndContinue()
    }
    
//MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // 20 max characters
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        
        // enable/diable next button by text presence
        self.nextButton.enabled = newString.length > 2
        
        let withinCharLimits = newString.length <= MAX_CHARACTER_USERNAME
        
        return withinCharLimits
    }
    
//MARK: Utilities
    
    private func checkUsernameAndContinue()
    {
        self.showLoading(true)
        
        self.nameTakenLabel.hidden = true
        
        if self.shouldCheckUsernames
        {
            if let username = self.usernameField.text?.trimmed()
            {
                Connector().checkUsername(username) { (available, error) in
                    
                    self.showLoading(false)
                    
                    if error != nil
                    {
                        print(error)
                        self.nameTakenLabel.hidden = false
                        self.nameTakenLabel.text = "something funny happened. try again."
                    }
                    else // success
                    {
                        if available
                        {
                            self.nameTakenLabel.hidden = true
                            self.performSegueWithIdentifier(SEGUE_PASSWORD, sender: self)
                        }
                        else
                        {
                            self.nameTakenLabel.hidden = false
                            self.nameTakenLabel.text = "🤔 that name is taken. try another"
                        }
                    }
                }
            }
        }
        else // this is a login, proceed
        {
            self.performSegueWithIdentifier(SEGUE_PASSWORD, sender: self)
            self.showLoading(false)
        }
    }

    override func keyboardMoved(notification: NSNotification)
    {
        UIView.animateWithKeyboardNotification(notification) { (keyboardHeight, keyboardWindowY) in
            self.containerBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func showLoading(shouldShow:Bool)
    {
        if shouldShow
        {
            self.navigationItem.showSpinner(onSide: .Right)
        }
        else
        {
            self.navigationItem.rightBarButtonItem = self.nextButton
        }
    }
    
}
