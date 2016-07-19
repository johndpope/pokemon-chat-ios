//
//  PasswordViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/18/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

private let SEGUE_TO_LOCATION = "PasswordToLocation"
private let MAX_CHARACTER_PASSWORD = 30

class PasswordViewController: UIViewController, UITextFieldDelegate
{
    var user : User?
    var completionClosure : SignupResultClosure?
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet weak var calloutLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = self.user?.team?.color()
        self.calloutLabel.hidden = true
        self.passwordField.delegate = self
        self.passwordField.text = nil
        self.view.layoutIfNeeded()
        self.passwordField.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.passwordField.resignFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        // wait for view to adjust, then listen for changes (to avoid jump on initial show)
        self.listenForKeyboardNotifications(true)
        
    }
    
    deinit
    {
        self.listenForKeyboardNotifications(false)
    }
    
    override func keyboardMoved(notification: NSNotification)
    {
        UIView.animateWithKeyboardNotification(notification) { (keyboardHeight, keyboardWindowY) in
            self.containerBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SEGUE_TO_LOCATION
        {
            let locationController = segue.destinationViewController as! LocationPermissionViewController
            locationController.user = self.user
            locationController.completionClosure = self.completionClosure
        }
    }
    
    
//MARK: Actions
    
    @IBAction func nextButtonPressed(sender: AnyObject)
    {
        self.user?.password = self.passwordField.text
        
        self.signup()
    }
    
    
//MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // 20 max characters
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        
        // enable/diable next button by text presence
        self.nextButton.enabled = newString.length > 2
        
        let withinCharLimits = newString.length <= MAX_CHARACTER_PASSWORD
        
        return withinCharLimits
    }
    
    
//MARK: Utilities
    
    private func signup()
    {
        self.calloutLabel.hidden = true
        self.showLoading(true)
        
        // signup, return
        self.user?.signUp({ (user, error) in
            
            self.showLoading(false)
            
            if error != nil
            {
                // handle error
                self.calloutLabel.text = "Something went wrong. Try again?"
                self.calloutLabel.hidden = false
            }
            else // signed up! FUCKYEAH
            {
                self.performSegueWithIdentifier(SEGUE_TO_LOCATION, sender: self)
            }
        })
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
