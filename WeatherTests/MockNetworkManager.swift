//
//  MockNetworkManager.swift
//  WeatherTests
//
//  Created by Melvyn Awani on 13/04/2022.
//

import Combine
import Foundation
@testable import Weather

class MockNetworkManager: Networkable {
    func performRequest(baseUrl: String, path: String, params: [String: String]) -> Future<WeatherData, Error> {
        return Future { promise in

            var urlComponents = URLComponents(string: baseUrl.appending(path))
            let queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            urlComponents?.queryItems = queryItems
            guard let url = urlComponents?.url
            else {
                return
            }

            if url.valueOf("q") == "london" {
                print("URL MATCHESSSSS")
                let weatherJsonString = """

                {"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":13.34,"feels_like":12.9,"temp_min":11.88,"temp_max":14.64,"pressure":1016,"humidity":83},"visibility":10000,"wind":{"speed":3.09,"deg":230},"clouds":{"all":77},"dt":1649838700,"sys":{"type":2,"id":2019646,"country":"GB","sunrise":1649826553,"sunset":1649875948},"timezone":3600,"id":2643743,"name":"London","cod":200}
                """
                let weatherJsonData = Data(weatherJsonString.utf8)
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(WeatherData.self, from: weatherJsonData)
                    promise(.success(decodedData))

                } catch {
                    promise(.failure(error))
                }
            } else {
                let weatherJsonString = ""
                let weatherJsonData = Data(weatherJsonString.utf8)
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(WeatherData.self, from: weatherJsonData)
                    promise(.success(decodedData))

                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
