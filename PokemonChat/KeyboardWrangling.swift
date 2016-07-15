//
//  KeyboardWrangling.swift
//  PokemonChat
//
//  Created by ----- --- on 7/15/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

extension NSObject
{
    func listenForKeyboardNotifications(shouldListen: Bool)
    {
        if shouldListen
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NSObject.keyboardMoved(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        }
        else
        {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    func keyboardMoved(notification:NSNotification)
    {
        // inherit this and do something
    }
}

extension UIView
{
    class func animateWithKeyboardNotification(notification:NSNotification, animations:UIKeyboardAnimationBlock)
    {
        // Coordinate the time and curve of the keyboard, as indicated by the notification options
        UIView.beginAnimations("MoveKeyboard", context:nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!)
        UIView.setAnimationBeginsFromCurrentState(true);
        
        // find the keyboards height and Y position on the main window
        let windowHeight = UIApplication.sharedApplication().keyWindow!.bounds.size.height
        let keyboardRectValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        let keyboardFrame = keyboardRectValue!.CGRectValue
        let keyboardOriginY = keyboardFrame.origin.y
        var keyboardHeight = keyboardFrame.size.height
        
        // if the keyboard is at some stupid number, its offscreen
        if (keyboardOriginY >= windowHeight) {
            keyboardHeight = 0;
        }
        
        // actually run the changes
        animations(keyboardHeight: keyboardHeight, keyboardWindowY: keyboardOriginY);
        
        UIView.commitAnimations()
    }
}