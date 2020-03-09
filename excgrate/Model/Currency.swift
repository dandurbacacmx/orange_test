//
//  Currency.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation

enum Currency : String {
    case EUR
    case GBP
    case USD
}

enum CurrencyLocale : String {
    case EUR = "fr_FR"
    case GBP = "en_UK"
}

struct CurrencyRate: Equatable {
    
    let currencyIso : String
    let rate : Double
    
    public static func == (lhs: CurrencyRate, rhs: CurrencyRate) -> Bool {
        return lhs.rate == rhs.rate &&
            lhs.currencyIso == rhs.currencyIso
    }
}
