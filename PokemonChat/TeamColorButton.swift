//
//  TeamColorButton.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class TeamColorButton: BouncingButton
{
    override init(frame: CGRect)
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
        self.updateImage()
        self.listenForColorChanges(true)
    }
    
    deinit
    {
        self.listenForColorChanges(false)
    }
    
    /// override this in subclasses
    func imageForTeam(team: Team?) -> UIImage?
    {
        return nil
    }

    
    func colorsChanged(notification:NSNotification)
    {
        self.updateImage()
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
    
    
    private func updateImage()
    {
        let team = User.currentUser()?.teamMode == .Team ? User.currentUser().team : nil
        self.setImage(self.imageForTeam(team), forState: UIControlState.Normal)
    }

}
