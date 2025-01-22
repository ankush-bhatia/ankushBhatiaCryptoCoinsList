//
//  CoinSearchViewModelTests.swift
//  ankushBhatiaCryptoCoinsListTests
//
//  Created by ANKUSH BHATIA on 1/22/25.
//

import XCTest
@testable import ankushBhatiaCryptoCoinsList

final class CoinSearchViewModelTests: XCTestCase {
    
    private var viewModel: CryptoSearchViewModel!
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    override func setUp() {
        super.setUp()
        let cryptoListBundlePath = Bundle(for: CryptoListViewModelTests.self).path(forResource: "CryptoListJSON", ofType: "json")!
        do {
            let cryptoListJSONData = try String(contentsOfFile: cryptoListBundlePath).data(using: .utf8)
            let cryptoListResponse = try decoder.decode([CryptoItem].self, from: cryptoListJSONData!)
            viewModel = CryptoSearchViewModel(coinItems: cryptoListResponse)
        } catch {
            XCTFail("Failed to decode cryptoListJSONData")
        }
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testIntialState() {
        XCTAssertEqual(viewModel.filteredCoinItems.count,
                       viewModel.coinItems.count)
    }
    
    func testUpdateSearchResults() {
        // Arrange
        let searchText = "Bit"
        let expectation = XCTestExpectation(description: "Filtered coin list updated")
        
        viewModel.didUpdate = {
            expectation.fulfill()
        }
        
        // Act
        viewModel.updateSearchResults(searchText: searchText)
        
        // Assert
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(viewModel.filteredCoinItems.count, 2)
    }
    
    func testUpdateSearchResultsEmptyText() {
        // Arrange
        let searchText = ""
        let expectation = XCTestExpectation(description: "Filtered coin list updated")
        
        viewModel.didUpdate = {
            expectation.fulfill()
        }
        
        // Act
        viewModel.updateSearchResults(searchText: searchText)
        
        // Assert
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(viewModel.filteredCoinItems.count,
                       viewModel.coinItems.count)
    }
}
