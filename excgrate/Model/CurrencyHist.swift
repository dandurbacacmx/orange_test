//
//  CurrencyHist.swift
//  excgrate
//
//  Created by Dan Durbaca on 09/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation

struct CurrencyHist: Equatable {
    
    let histDate : String
    let rateRon : Double
    let rateUsd : Double
    let rateBgn : Double
    
    public static func == (lhs: CurrencyHist, rhs: CurrencyHist) -> Bool {
        return lhs.rateRon == rhs.rateRon && lhs.rateUsd == rhs.rateUsd && lhs.rateBgn == rhs.rateBgn &&
            lhs.histDate == rhs.histDate
    }
}
