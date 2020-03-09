//
//  Converter.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation

struct Converter {
    
    let base : String
    let date : String
    
    let rates : [CurrencyRate]
}

extension Converter : Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Result<Converter, ErrorResult> {
        if let base = dictionary["base"] as? String,
            let date = dictionary["date"] as? String,
            let rates = dictionary["rates"] as? [String: Double] {
            
            let finalRates : [CurrencyRate] = rates.flatMap({ CurrencyRate(currencyIso: $0.key, rate: $0.value) })
            let conversion = Converter(base: base, date: date, rates: finalRates)
            
            return Result.success(conversion)
        } else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse conversion rate"))
        }
    }
    
    static func parseObjectRaw(dictionary: [String : AnyObject]) -> Converter {
        let base = dictionary["base"] as! String
        let date = dictionary["date"] as! String
        let rates = dictionary["rates"] as! [String: Double]
            
        var finalRates : [CurrencyRate] = rates.flatMap({ CurrencyRate(currencyIso: $0.key, rate: $0.value) })
        if finalRates.firstIndex(where: { $0.currencyIso ==  base}) == nil {
            finalRates.append(CurrencyRate(currencyIso: base, rate: 1.0))
        }
        finalRates.sort(by: { (item1, item2) -> Bool in
            return item1.currencyIso < item2.currencyIso
        })

        let conversion = Converter(base: base, date: date, rates: finalRates)
        
        return conversion
    }
}
