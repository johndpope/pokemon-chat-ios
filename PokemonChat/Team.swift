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
}
