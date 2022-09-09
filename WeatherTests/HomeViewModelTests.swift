//
//  HomeViewModelTests.swift
//  WeatherTests
//
//  Created by Melvyn Awani on 13/04/2022.
//

import XCTest
@testable import Weather


class HomeViewModelTests: XCTestCase {

    var homeViewModel: HomeViewModel!
    var mockNetworkManager = MockNetworkManager()
    var homeViewController = HomeViewController()
    
    override func setUpWithError() throws {
        homeViewModel = HomeViewModel(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
       
    }

    func testGetWeatherDataFail() {
        let textEntered = "lodon"
        homeViewModel.informNetworkManagerToPerformRequest(textEntered: textEntered) { response in
            XCTAssertFalse(response)
        }
    }
    
    func testGetWeatherDataPass() {
        let textEntered = "london"
        homeViewModel.informNetworkManagerToPerformRequest(textEntered: textEntered) { response in
            XCTAssertTrue(response)
            
        }
    }

}
