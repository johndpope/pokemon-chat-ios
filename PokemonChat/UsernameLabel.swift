//
//  UsernameLabel.swift
//  PokemonChat
//
//  Created by ----- --- on 7/15/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class UsernameLabel: UILabel
{

    override func awakeFromNib()
    {
        self.initialize()
    }
    
    func initialize()
    {
        self.font = UIFont(name: "Avenir-Heavy", size: 14)
        self.textColor = UIColor.blackColor()
    }

}
