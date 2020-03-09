//
//  HistConverter.swift
//  excgrate
//
//  Created by Dan Durbaca on 09/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation

struct HistConverter {
    
    let rates : [CurrencyHist]
}

extension HistConverter : Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Result<HistConverter, ErrorResult> {
        if let rates = dictionary["rates"] as? [String: [String:Double]] {
            let finalRates : [CurrencyHist] = rates.flatMap({ CurrencyHist(histDate: $0.key, rateRon: $0.value["RON"]!, rateUsd: $0.value["USD"]!, rateBgn: $0.value["BGN"]!) })
            let conversion = HistConverter(rates: finalRates)
            
            return Result.success(conversion)
        } else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse conversion rate"))
        }
    }
    
    static func parseObjectRaw(dictionary: [String : AnyObject]) -> HistConverter {
        let rates = dictionary["rates"] as! [String: [String:Double]]
            
        let finalRates : [CurrencyHist] = rates.flatMap({ CurrencyHist(histDate: $0.key, rateRon: $0.value["RON"]!, rateUsd: $0.value["USD"]!, rateBgn: $0.value["BGN"]!) })

        let conversion = HistConverter(rates: finalRates)
        
        return conversion
    }
}
