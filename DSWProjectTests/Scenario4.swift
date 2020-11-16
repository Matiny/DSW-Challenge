//
//  DSWProjectTests.swift
//  DSWProjectTests
//
//  Created by Matiny L on 11/15/20.
//  Copyright © 2020 Matiny L. All rights reserved.
//

import XCTest
@testable import DSWProject

class DSWProjectTests: XCTestCase {

    func testViewModel() {
        
        let product = OneProduct(sku: "12345", displayName: "Winter Boot", price: "54.99", quantity: 4)
        let promo = OnePromo(code: "code", description: "description", value: "5")
        let summary = TheSummary(subtotal: "subtotal", tax: "tax", discounts: "Discounts", total: "total")
        
        let data = DSWData(products: [product], promos: [promo], summary: summary)
        let viewModel = ViewModel(model: data)
        
        XCTAssertEqual(data.products[0].displayName,
                       viewModel.model.products[0].displayName)
        
        XCTAssertEqual(data.promos[0].code,
                       viewModel.model.promos[0].code)
        
        XCTAssertEqual(data.summary.subtotal,
                       viewModel.model.summary.subtotal)
    }
    

}

class API: XCTestCase {
    
    var sut: DSW?
    
    override func setUp() {
        super.setUp()
        sut = DSW()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_404StatusCodeDatatask() {
        guard let url =
            URL(string: "https://www.dsw.com/api/v1/bag") else {
            return
        }
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 404)
    }
    
}
