//
//  StyledLabel.swift
//  PokemonChat
//
//  Created by ----- --- on 7/15/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class ContentLabel: UILabel
{
    override func awakeFromNib()
    {
        self.initialize()
    }
    
    func initialize()
    {
        self.font = UIFont(name: "Avenir-Book", size: 15)
        self.textColor = UIColor.blackColor()
    }
}
