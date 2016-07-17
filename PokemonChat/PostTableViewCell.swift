//
//  PostTableViewCell.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

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
        
        //update the shadow path for performance when scrolling
        self.containerView.rasterizeShadow()
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        selected ? self.touchDown() : self.touchUp()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool)
    {
        super.setHighlighted(highlighted, animated: animated)
        highlighted ? self.touchDown() : self.touchUp()
    }

}
