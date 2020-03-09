//
//  CurrencyService.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift

protocol CurrencyServiceProtocol : class {
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void))
}

protocol CurrencyServiceObservable : class {
    func fetchConverter() -> Observable<Converter>
}

final class CurrencyService : RequestHandler, CurrencyServiceProtocol {
    
    static var baseCurrency = "EUR"
    static var refreshInterval = 3.0
    static var lastCallData = Converter(base: "", date: "", rates: [])
    
    private let disposeBag = DisposeBag()
    static let shared = CurrencyService()
    
    let endpoint = "https://api.exchangeratesapi.io/latest?base="
    var task : URLSessionTask?
    
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        
        // cancel previous request if already in progress
        self.cancelFetchCurrencies()
        
        task = RequestService().loadData(urlString: endpoint+CurrencyService.baseCurrency, completion: self.networkResult(completion: completion))
    }
    
    func cancelFetchCurrencies() {
        
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

extension CurrencyService : CurrencyServiceObservable {
    
    func fetchConverter() -> Observable<Converter> {
        
        return RxAlamofire.requestJSON(.get, endpoint+CurrencyService.baseCurrency)
        .map {
            let data = $0.1 as! Dictionary<String, AnyObject>
            CurrencyService.lastCallData = Converter.parseObjectRaw(dictionary: data)
            return CurrencyService.lastCallData
        }
    }

}
