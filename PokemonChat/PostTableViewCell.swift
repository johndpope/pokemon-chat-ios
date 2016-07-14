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
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.containerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.containerView.layer.shadowRadius = 1.5
        self.containerView.layer.shadowOpacity = 0.40
        self.containerView.layer.shouldRasterize = true
        self.containerView.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        //update the shadow path for performance when scrolling
        self.containerView.layer.shadowPath = UIBezierPath(rect: self.containerView.layer.bounds).CGPath
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
