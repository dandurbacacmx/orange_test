//
//  File.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation
import RxSwift

final class FileDataService : CurrencyServiceProtocol {
    
    static let shared = FileDataService()
    
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "sample") else {
            completion(Result.failure(ErrorResult.custom(string: "No file or data")))
            return
        }
        
        ParserHelper.parse(data: data, completion: completion)
    }
} 

extension FileDataService : CurrencyServiceObservable {
    
    func fetchConverter() -> Observable<Converter> {
        
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "sample") else {
            return Observable.error(ErrorResult.custom(string: "No file or data"))
        }
        
        return ParserHelper.parse(data: data)
    }
}

extension FileManager {
    
    static func readJson(forResource fileName: String ) -> Data? {
        
        let bundle = Bundle(for: FileDataService.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        
        return nil
    }
}
