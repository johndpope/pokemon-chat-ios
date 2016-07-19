//
//  TeamNavigationBar.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

enum NavigationBarSide
{
    case Left
    case Right
}

class TeamNavigationBar: UINavigationBar
{
    var teamSwitch : UISwitch? {
        get {
            if let slider = self.topItem?.leftBarButtonItem?.customView as? UISwitch {
                return slider
            }
            return nil
        }
    }
    
//
    
    required override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize()
    {
        self.barTintColor = COLOR_GRAY
        self.teamSwitch?.tintColor = COLOR_GRAY
        self.updateBarBasedOnTeamState()
        self.listenForColorChanges(true)
    }
    
    deinit
    {
        self.listenForColorChanges(false)
    }
    
    
//MARK: Public
    

    
    
//MARK: Utilities
    
    private func listenForColorChanges(shouldListen:Bool)
    {
        if shouldListen
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(colorsChanged), name: NOTIFICATION_TEAM_SWITCH, object: nil)
        }
        else
        {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_TEAM_SWITCH, object: nil)
        }
    }

    
    func colorsChanged(notification:NSNotification)
    {
        self.updateBarBasedOnTeamState()
    }
    
    private func updateBarBasedOnTeamState()
    {
        self.translucent = false
        self.opaque = true
        
        if let user = User.currentUser() {
            let color = user.currentColor()
            let otherColor = color == COLOR_GRAY ? user.team?.color() : COLOR_GRAY
            
            UIView.animateWithDuration(0.23) {
                self.barTintColor = color
                self.teamSwitch?.onTintColor = otherColor
                self.teamSwitch?.backgroundColor = otherColor
            }
        }
    }
}


/* * * * * * * * */

/**
    UINavigationBar Extension
 */
extension UINavigationItem
{
    func showSpinner(onSide side:NavigationBarSide)
    {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        let barButtonSpinner = UIBarButtonItem(customView: spinner)
        if side == .Right { self.rightBarButtonItem = barButtonSpinner }
        else if side == .Left { self.leftBarButtonItem = barButtonSpinner }
    }
}



