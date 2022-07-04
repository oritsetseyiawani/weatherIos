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

    func testGetWeatherData() {
    
        guard   let url = Bundle(for: MockNetworkManager.self).url(forResource: "weather", withExtension: ".json"),
        let data = try? Data(contentsOf: url) else {
            assertionFailure("Failed to read data ")
            return
        }
        
        
        do {
            let weatherList = try JSONDecoder().decode([Weather].self, from: data)
            
            XCTAssertNotNil(weatherList)
            XCTAssertEqual(weatherList.count, 1 )
        } catch {
//            XCTAssertFail("Failed to parse weather data ")

        }
       
    }


}
