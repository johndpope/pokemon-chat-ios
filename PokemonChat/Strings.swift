//
//  Strings.swift
//  Index
//
//  Created by ----- --- on 6/21/16.
//  Copyright © 2016 BrianCoxCompany. All rights reserved.
//

import Foundation

extension String {
    
    /**
    *   Character access by subscripting
    */
    subscript (i: Int) -> Character
    {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String
    {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String
    {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
    
    /// whitespace newline trimming
    func trimmed() -> String
    {
        let spaces = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let trimmed =  self.stringByTrimmingCharactersInSet(spaces)
        return trimmed
    }
    
    /// check if string has no text content
    func isEmpty() -> Bool
    {
        let empty = self.trimmed() == ""
        return empty
    }
    
    /// check if string has text content
    func hasText() -> Bool
    {
        let empty = self.isEmpty()
        return !empty
    }
    
    /// returns an NSURL if possible
    func toURL() -> NSURL?
    {
        let url = NSURL(string:self)
        return url
    }
}