//
//  CommentTableViewCell.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell
{

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.containerView.drawDropShadow()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.rasterizeShadow() // for the millis
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
