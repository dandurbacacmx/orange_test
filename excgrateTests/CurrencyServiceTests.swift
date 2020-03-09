//
//  CurrencyServiceTests.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import XCTest
@testable import TemplateProject

class CurrencyServiceTests: XCTestCase {
    
    func testCancelRequest() {
        
        // giving a "previous" session
        CurrencyService.shared.fetchConverter { (_) in
            // ignore call
        }
        
        // Expected to task nil after cancel
        CurrencyService.shared.cancelFetchCurrencies()
        XCTAssertNil(CurrencyService.shared.task, "Expected task nil")
    }
}
