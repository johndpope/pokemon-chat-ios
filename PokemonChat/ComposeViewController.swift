//
//  ComposeViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/16/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate
{
    func composeViewControllerCancelled(controller: ComposeViewController)
    func composeViewControllerWillSave(controller: ComposeViewController, post: Post)
    func composeViewControllerSubmitted(controller: ComposeViewController, post: Post)
}

class ComposeViewController: UIViewController
{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    
    var delegate : ComposeViewControllerDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.textView.text = nil
        self.textView.contentInset.bottom = 8
        self.listenForKeyboardNotifications(true)
        self.textView.becomeFirstResponder()
    }
    
    deinit
    {
        self.listenForKeyboardNotifications(false)
    }
    
    override func keyboardMoved(notification: NSNotification) {
        UIView.animateWithKeyboardNotification(notification) { (keyboardHeight, keyboardWindowY) in
            self.textViewBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.textView.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendButtonPressed(sender: UIButton)
    {
        if let text = self.textView.text where text.hasText() {
            sender.enabled = false
            let post = Post()
            post.content = text
            post.latitude = 34
            post.longitude = -84
            post.isPrivate = false
            
            // go refresh shit
            self.delegate?.composeViewControllerWillSave(self, post: post)
            
            post.save({ (post, error) in
                if error != nil
                {
                    // indicate error
                }
                else // success
                {
                    // add the post to the top
                    self.view.endEditing(true)
                    self.delegate?.composeViewControllerSubmitted(self, post: post)
                }
            })
            
            
        }
    }
}
