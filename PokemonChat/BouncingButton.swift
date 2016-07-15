//
//  BouncingButton.swift
//  Index
//
//  Created by ----- --- on 5/4/16.
//  Copyright © 2016 BrianCoxCompany. All rights reserved.
//

import UIKit

class BouncingButton: UIButton
{
    override var highlighted : Bool
    {
        didSet
        {
            (highlighted) ? self.touchDown() : self.touchUp()
        }
    }
}
