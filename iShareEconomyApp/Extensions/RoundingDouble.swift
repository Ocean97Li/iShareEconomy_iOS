//
//  RoundingDouble.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 28/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
