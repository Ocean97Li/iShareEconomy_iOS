//
//  DateFormatting.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 20/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

extension Date {
    static func fromUTCString(_ utcString: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return df.date(from: utcString)
    }
    
    func toShortString() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df.string(from: self)
    }
    
    func removeTime() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func toUTCString() -> String {
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return df.string(from: self)
    }
    
    func adding(_ component: Calendar.Component, _ value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
}
