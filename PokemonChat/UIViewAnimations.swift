//
//  UIViewAnimations.swift
//  Index
//
//  Created by ----- --- on 5/4/16.
//  Copyright © 2016 BrianCoxCompany. All rights reserved.
//

import UIKit

typealias UIKeyboardAnimationBlock = ( (keyboardHeight:CGFloat, keyboardWindowY:CGFloat) -> Void )

extension UIView
{
    func touchUp()
    {
        self.animateTouchDown(false, completion: nil)
    }
    
    func touchDown()
    {
        self.animateTouchDown(true, completion: nil)
    }
    
    func animateTouchDown(touchDown:Bool, completion:(()->Void)?)
    {
        let damping : CGFloat = (touchDown) ? 1 : 0.34
        let velocity : CGFloat = (touchDown) ? 0.5 : 0.8
        let duration : Double = (touchDown) ? 0.24 : 0.42
        let options : UIViewAnimationOptions = [.CurveEaseOut, .BeginFromCurrentState]
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            self.layer.transform = (touchDown) ? CATransform3DMakeScale(0.92, 0.92, 1) : CATransform3DIdentity
        }) { (done) in
            if done { completion?() }
        }
    }
}