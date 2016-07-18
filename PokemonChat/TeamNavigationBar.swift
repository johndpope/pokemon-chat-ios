//
//  TeamNavigationBar.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

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
        self.teamSwitch?.tintColor = COLOR_GRAY
        self.updateBarBasedOnTeamState()
        self.listenForColorChanges(true)
    }
    
    deinit
    {
        self.listenForColorChanges(false)
    }
    
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
    
    func updateBarBasedOnTeamState()
    {
        let color = User.currentUser().currentColor()
        let otherColor = color == COLOR_GRAY ? User.currentUser().team.color() : COLOR_GRAY
        
        UIView.animateWithDuration(0.23) {
            self.barTintColor = color
            self.teamSwitch?.onTintColor = otherColor
            self.teamSwitch?.backgroundColor = otherColor
        }
    }
}
