//
//  AddPostButton.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

private let IMAGE_YELLOW = "AddButton-Yellow"
private let IMAGE_BLUE = "AddButton-Blue"
private let IMAGE_RED = "AddButton-Red"
private let IMAGE_GRAY = "AddButton-Gray"

class AddPostButton: TeamColorButton
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
