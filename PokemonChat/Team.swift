//
//  Team.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

enum Team : String
{
    case Yellow = "yellow"
    case Blue = "blue"
    case Red = "red"
    
    func color() -> UIColor
    {
        let color = TeamColors.colorForTeam(self)
        return color
    }
    
    func teamName() -> String
    {
        switch self
        {
            case .Yellow: return "Instinct"
            case .Blue: return "Mystic"
            case .Red: return "Valor"
        }
    }
    
    static func alertTeamChanged()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_TEAM_SWITCH, object: User.currentUser())
    }
}
