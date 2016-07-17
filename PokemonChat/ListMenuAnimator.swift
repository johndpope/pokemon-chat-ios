//
//  ListMenuAnimator.swift
//  PokemonChat
//
//  Created by ----- --- on 7/16/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class ListMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    var isPushAnimation = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.2
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if self.isPushAnimation
        {
            self.animateListToMenu(transitionContext)
        }
        else
        {
            self.animateMenuToList(transitionContext)
        }
    }
    
    private func animateListToMenu(context: UIViewControllerContextTransitioning)
    {
        let listViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! PostsViewController
        let menuViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! MenuViewController
        let containerView = context.containerView()!
        
        // get an image of the current posts controller with no content
        listViewController.tableView.alpha = 0
        let backgroundSnapshot = listViewController.backgroundContainer.rasterizedImage()
        listViewController.tableView.alpha = 1 // <- cleanup

        menuViewController.backgroundImageView.image = backgroundSnapshot
        menuViewController.view.sendSubviewToBack(menuViewController.backgroundImageView)
        
        let centerFrame = context.finalFrameForViewController(menuViewController)
        
        // add the detail's view to the context in its final position (for correct rect conversions...)
        menuViewController.view.setNeedsLayout()
        menuViewController.view.layoutIfNeeded()
        menuViewController.view.frame = centerFrame
        containerView.addSubview(menuViewController.view)
        
        let addButtonSnapshot = UIImageView(image: menuViewController.addButton.imageForState(UIControlState.Normal)!)
        
        let initialAddButtonFrame = menuViewController.view.convertRect(menuViewController.menuButton.frame, fromView: menuViewController.menuButton.superview)
        let finalAddButtonFrame = menuViewController.view.convertRect(menuViewController.addButton.frame, fromView: menuViewController.addButton.superview)
        
        containerView.insertSubview(addButtonSnapshot, atIndex: containerView.subviews.count)
        addButtonSnapshot.frame = initialAddButtonFrame
        
        // teh transicion
        menuViewController.addButton.hidden = true
        menuViewController.view.alpha = 0
        
        UIView.animateWithDuration(self.transitionDuration(context), animations: { () -> Void in
            
            menuViewController.view.alpha = 1
            
        }) { (finished:Bool) -> Void in
            
            let cancelled = context.transitionWasCancelled()
            context.completeTransition(!cancelled)
            //cleanup
        }
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            addButtonSnapshot.frame = finalAddButtonFrame
            
        }) { (done) in
            // cleanup
            addButtonSnapshot.removeFromSuperview()
            menuViewController.addButton.hidden = false
        }
        
    }
    
    private func animateMenuToList(context: UIViewControllerContextTransitioning)
    {
        let listViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! PostsViewController
        let menuViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MenuViewController
        let containerView = context.containerView()!
        
        containerView.insertSubview(listViewController.view, atIndex: 0)

        // teh transicion
        let addButtonSnapshot = UIImageView(image: menuViewController.addButton.imageForState(UIControlState.Normal)!)
        let addButtonFrame = containerView.convertRect(menuViewController.addButton.frame, fromView: menuViewController.addButton.superview)
        var menuButtonFrame = containerView.convertRect(menuViewController.menuButton.frame, fromView: menuViewController.menuButton.superview)
        menuButtonFrame.origin = CGPoint(x: menuButtonFrame.origin.x + menuButtonFrame.size.width/2, y:menuButtonFrame.origin.y + menuButtonFrame.size.height/2)
        menuButtonFrame.size = CGSize(width: 0, height: 0)
        
        addButtonSnapshot.frame = addButtonFrame
        containerView.addSubview(addButtonSnapshot)
        menuViewController.addButton.hidden = true
        
        UIView.animateWithDuration(self.transitionDuration(context), animations: { () -> Void in
            
            menuViewController.view.alpha = 0
            addButtonSnapshot.frame = menuButtonFrame
            
        }) { (finished:Bool) -> Void in
            
            let cancelled = context.transitionWasCancelled()
            context.completeTransition(!cancelled)
            //cleanup
            addButtonSnapshot.removeFromSuperview()
        }
    }
}
