//
//  CryptoListViewModelTests.swift
//  ankushBhatiaCryptoCoinsListTests
//
//  Created by ANKUSH BHATIA on 1/22/25.
//

import XCTest
@testable import ankushBhatiaCryptoCoinsList

final class CryptoListViewModelTests: XCTestCase {
    
    private var viewModel: CryptoListViewModel!
    private var mockRepository: MockCryptoListRepository!
    
    lazy private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    override func setUp() {
        super.setUp()
        mockRepository = MockCryptoListRepository()
        let getCoinsUseCase = CryptoListGetCoinsUseCase(repository: mockRepository)
        viewModel = CryptoListViewModel(getCryptoListCoinsUseCase: getCoinsUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testGetCryptoListSuccess() {
        // Arrange
        let cryptoListBundlePath = Bundle(for: CryptoListViewModelTests.self).path(forResource: "CryptoListJSON", ofType: "json")!
        do {
            let cryptoListJSONData = try String(contentsOfFile: cryptoListBundlePath).data(using: .utf8)
            let cryptoListResponse = try decoder.decode([CryptoItem].self, from: cryptoListJSONData!)
            mockRepository.saveCoins(cryptoCoins: cryptoListResponse)
            let expectation = XCTestExpectation(description: "State updated")
            
            viewModel.didUpdate = {
                expectation.fulfill()
            }
            
            // Act
            viewModel.getCoins()
            
            // Assert
            wait(for: [expectation], timeout: 5.0)
            XCTAssertEqual(viewModel.state, .loaded)
            XCTAssertEqual(viewModel.cryptoList.count, 26)
            XCTAssertEqual(viewModel.filteredCryptoList.count, 26)
        } catch {
            XCTFail("Failed to decode cryptoListJSONData")
        }
    }
    
    func testGetCryptoListFailure() {
        // Arrange
        let cryptoListBundlePath = Bundle(for: CryptoListViewModelTests.self).path(forResource: "CryptoListJSON", ofType: "json")!
        do {
            let cryptoListJSONData = try String(contentsOfFile: cryptoListBundlePath).data(using: .utf8)
            let cryptoListResponse = try decoder.decode([CryptoItem].self, from: cryptoListJSONData!)
            mockRepository.cryptoCoins = .failure(.parsingError)
            let expectation = XCTestExpectation(description: "State updated")
            
            viewModel.didUpdate = {
                expectation.fulfill()
            }
            
            // Act
            viewModel.getCoins()
            
            // Assert
            wait(for: [expectation], timeout: 5.0)
            XCTAssertEqual(viewModel.state, .error(error: APIError.parsingError))
            XCTAssertEqual(viewModel.cryptoList.count, 0)
            XCTAssertEqual(viewModel.filteredCryptoList.count, 0)
        } catch {
            XCTFail("Failed to decode cryptoListJSONData")
        }
    }
    
    func testRestFilters() {
        // Arrange
        viewModel.udpateFilteredCoins(indexPath: IndexPath(row: 0, section: 0))
        
        // Act
        viewModel.resetFilters()
        
        // Assert
        let selectedFilterItems = viewModel.filterItems.filter { $0.isSelected }
        XCTAssertEqual(selectedFilterItems.count, 0)
    }
    
    func testUpdateFilteredCoins() {
        // Arrange
        let cryptoListBundlePath = Bundle(for: CryptoListViewModelTests.self).path(forResource: "CryptoListJSON", ofType: "json")!
        do {
            let cryptoListJSONData = try String(contentsOfFile: cryptoListBundlePath).data(using: .utf8)
            let cryptoListResponse = try decoder.decode([CryptoItem].self, from: cryptoListJSONData!)
            mockRepository.saveCoins(cryptoCoins: cryptoListResponse)
            
            let expectation = XCTestExpectation(description: "State updated")
            
            viewModel.didUpdate = {
                expectation.fulfill()
            }
            
            // Act
            viewModel.getCoins()
            
            
            // Assert
            wait(for: [expectation], timeout: 5.0)
            let activeCoinFilterIndex = viewModel.filterItems.firstIndex(where: { $0.type == .activeCoins })!
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: activeCoinFilterIndex, section: 0))
            let activeCoins = viewModel.filteredCryptoList.compactMap { $0.isActive }
            XCTAssertEqual(activeCoins.count, 23, "Active coins count should be 23")
            
            viewModel.resetFilters()
            let inActiveCoinFilterIndex = viewModel.filterItems.firstIndex(where: { $0.type == .inactiveCoins })!
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: inActiveCoinFilterIndex, section: 0))
            let inactiveCoins = viewModel.filteredCryptoList.compactMap { !$0.isActive }
            XCTAssertEqual(inactiveCoins.count, 3, "Active coins count should be 3")
            
            viewModel.resetFilters()
            let onlyTokensFilterIndex = viewModel.filterItems.firstIndex(where: { $0.type == .onlyTokens })!
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: onlyTokensFilterIndex, section: 0))
            let onlyTokens = viewModel.filteredCryptoList.compactMap { $0.type == .token }
            XCTAssertEqual(onlyTokens.count, 9, "Only tokens count should be 9")
            
            viewModel.resetFilters()
            let onlyCoinsFilterIndex = viewModel.filterItems.firstIndex(where: { $0.type == .onlyCoins })!
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: onlyCoinsFilterIndex, section: 0))
            let onlyCoins = viewModel.filteredCryptoList.compactMap { $0.type == .coin }
            XCTAssertEqual(onlyCoins.count, 17, "Only coins count should be 17")
            
            viewModel.resetFilters()
            let newCoinsFilterIndex = viewModel.filterItems.firstIndex(where: { $0.type == .newCoins })!
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: newCoinsFilterIndex, section: 0))
            let newCoins = viewModel.filteredCryptoList.compactMap { $0.isNew }
            XCTAssertEqual(newCoins.count, 8, "New coins count should be 8")
            
            viewModel.resetFilters()
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: activeCoinFilterIndex, section: 0))
            viewModel.udpateFilteredCoins(indexPath: IndexPath(row: activeCoinFilterIndex, section: 0))
            XCTAssertEqual(viewModel.filteredCryptoList.count, viewModel.cryptoList.count)
        } catch {
            XCTFail("Failed to decode cryptoListJSONData")
        }
    }
}
