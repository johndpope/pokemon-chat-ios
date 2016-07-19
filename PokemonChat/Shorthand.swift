//
//  Shorthand.swift
//  Index
//
//  Created by ----- --- on 5/30/16.
//  Copyright © 2016 BrianCoxCompany. All rights reserved.
//

import Foundation


/**
    A completion handler for a boolean operation
 */
typealias BooleanResponseClosure = (Bool, NSError?) -> (Void)

/**
    Async wait helper. GCD abstraction.
 */
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}