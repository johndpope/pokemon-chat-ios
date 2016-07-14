//
//  Dating.swift
//  Index
//
//  Created by ----- --- on 7/2/16.
//  Copyright © 2016 BrianCoxCompany. All rights reserved.
//

import Foundation

private let FORMAT_ISO_8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

extension NSDate
{
    /**
        Returns an integer timestamp in milliseconds
     */
    func timestamp() -> Int
    {
        let timeInterval = self.timeIntervalSince1970
        let timestamp = Int(timeInterval * 1000) // for milliseconds
        return timestamp
    }
    
    func iso8601Date() -> String
    {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = FORMAT_ISO_8601
        
        let iso8601String = dateFormatter.stringFromDate(NSDate())
        return iso8601String
    }
    
    convenience init?(iso8601:String)
    {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = FORMAT_ISO_8601
        if let date = dateFormatter.dateFromString(iso8601) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
}