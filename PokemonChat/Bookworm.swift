//
//  Bookworm.swift
//  PokemonChat
//
//  Created by ----- --- on 7/19/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import Foundation

// reader of dictionaries

protocol OptionalType
{
    associatedtype Wrapped
    var asOptional : Wrapped? { get }
}

extension Optional : OptionalType
{
    var asOptional : Wrapped? {
        return self
    }
}

extension Dictionary where Key : StringLiteralConvertible, Value : OptionalType
{
    func safeFromNil() -> [String : AnyObject]
    {
        var safe = [String : AnyObject]()
        
        for (key, value) in self where key is String
        {
            if let key = key as? String, unwrappedValue = value.asOptional as? AnyObject
            {
                safe[key] = unwrappedValue
            }
        }
        
        return safe
    }
}