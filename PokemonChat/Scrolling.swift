//
//  Scrolling.swift
//  PokemonChat
//
//  Created by ----- --- on 7/15/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

extension UIScrollView
{
    func scrollToBottom(animated animated:Bool)
    {
        let delta = max(-self.contentInset.top, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom)
        let bottomOffset = CGPoint(x: 0, y: delta);
        self.setContentOffset(bottomOffset, animated:animated)
    }
}