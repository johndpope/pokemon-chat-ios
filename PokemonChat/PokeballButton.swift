//
//  PokeballButton.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

private let IMAGE_YELLOW = "PokeBall-Yellow"
private let IMAGE_BLUE = "PokeBall-Blue"
private let IMAGE_RED = "PokeBall-Red"
private let IMAGE_GRAY = "PokeBall-Gray"

class PokeballButton: TeamColorButton
{

    override func imageForTeam(team: Team?) -> UIImage?
    {
        switch team
        {
            case .Some(.Yellow): return UIImage(named: IMAGE_YELLOW)
            case .Some(.Blue): return UIImage(named: IMAGE_BLUE)
            case .Some(.Red): return UIImage(named: IMAGE_RED)
            default: return UIImage(named: IMAGE_GRAY)
        }
    }

}
