//
//  HistoryService.swift
//  excgrate
//
//  Created by Dan Durbaca on 09/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift

protocol HistoryServiceProtocol : class {
    func fetchConverter(_ completion: @escaping ((Result<HistConverter, ErrorResult>) -> Void))
}

protocol HistoryServiceObservable : class {
    func fetchConverter() -> Observable<HistConverter>
}

final class HistoryService : RequestHandler, HistoryServiceProtocol {
        
    private let disposeBag = DisposeBag()
    static let shared = HistoryService()
    
    let endpoint = "https://api.exchangeratesapi.io/history?start_at={sdate}&end_at={edate}&symbols=RON,USD,BGN&base="
    var task : URLSessionTask?
    
    func fetchConverter(_ completion: @escaping ((Result<HistConverter, ErrorResult>) -> Void)) {
        
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

extension HistoryService : HistoryServiceObservable {
    
    func fetchConverter() -> Observable<HistConverter> {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        var date = Date()
        let end_date = dateFormatterGet.string(from: date)
        date.addTimeInterval(-10*24*60*60)
        let start_date = dateFormatterGet.string(from: date)
        var gep = endpoint.replacingOccurrences(of: "{sdate}", with: start_date)
        gep = gep.replacingOccurrences(of: "{edate}", with: end_date)

        return RxAlamofire.requestJSON(.get, gep+CurrencyService.baseCurrency)
        .map {
            let data = $0.1 as! Dictionary<String, AnyObject>
            return HistConverter.parseObjectRaw(dictionary: data)
        }
    }

}
