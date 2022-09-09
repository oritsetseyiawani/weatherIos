//
//  HomeViewModel.swift
//  Weather
//
//  Created by Melvyn Awani on 12/04/2022.
//

import Foundation
import CoreLocation
import Combine

protocol HomeViewModelType {
    var dataReceivedFromAPI: WeatherData? {get}
    func getWeatherIconURL()->String
    func informNetworkManagerToPerformRequest(textEntered: String, isDataReturned:@escaping(_ response: Bool)->Void)
    func informNetworkManagerToPerformRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees, isDataReturned:@escaping(_ response: Bool)->Void)
    var tableViewData: [WeatherRecord] {get}
    func getBackgroundImage()-> String
    
}

class HomeViewModel: HomeViewModelType {
    private let networkManager: Networkable
    
    init(networkManager: Networkable){
        self.networkManager = networkManager
    }
    var dataReceivedFromAPI: WeatherData?
    var tableViewData: [WeatherRecord] = []
    var observers: [AnyCancellable] = []

    
    func informNetworkManagerToPerformRequest(textEntered: String, isDataReturned:@escaping(_ response: Bool)->Void){

        networkManager.performRequest(baseUrl: EndPoints.baseUrl, path: Path.searchWeather, params: ["api_key":"3215a185b25eb297a66e63d137fb994f", "units": "metric", "q": textEntered, "appid": "111c704b48268f9adbc8dce3c913c272"]).sink { completion in
            switch(completion) {
            case .finished:
                print("")
            case .failure(let completion):
                print(completion)
            }
        } receiveValue: { [weak self] weatherData in
            self?.populateTableView(weatherData: weatherData)
            self?.dataReceivedFromAPI = weatherData
            isDataReturned(true)
        }.store(in: &observers)
    }
    
    
    
    func informNetworkManagerToPerformRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees, isDataReturned:@escaping(_ response: Bool)->Void){

        networkManager.performRequest(baseUrl: EndPoints.baseUrl, path: Path.searchWeather, params: ["api_key":"3215a185b25eb297a66e63d137fb994f", "units": "metric", "lat": "\(latitude)", "lon": "\(longitude)", "appid": "111c704b48268f9adbc8dce3c913c272"]).sink { completion in
            switch(completion) {
            case .finished:
                print("")
            case .failure(let completion):
                print(completion)
            }
        } receiveValue: { [weak self] weatherData in
            self?.populateTableView(weatherData: weatherData)
            self?.dataReceivedFromAPI = weatherData
            isDataReturned(true)
        }.store(in: &observers)
    }
    
    func getWeatherIconURL()->String{
        return "https://openweathermap.org/img/wn/\(dataReceivedFromAPI?.weather[0].icon ?? "")@4x.png"
    }
    
    func populateTableView(weatherData: WeatherData) {
        let row1 = WeatherRecord(fieldName: "Feels like", fieldValue: "\(weatherData.main.feelsLike)°")
        let row2 = WeatherRecord(fieldName: "Minimum Temperature", fieldValue: "\(weatherData.main.tempMin)°")
        let row3 = WeatherRecord(fieldName: "Maximum Temperature", fieldValue: "\(weatherData.main.tempMax)°")
        let row4 = WeatherRecord(fieldName: "Pressure", fieldValue: "\(weatherData.main.pressure) hpa")
        let row5 = WeatherRecord(fieldName: "Humidity", fieldValue: "\(weatherData.main.humidity)%")
        let row6 = WeatherRecord(fieldName: "Visibility", fieldValue: "\(weatherData.visibility) km")
        let row7 = WeatherRecord(fieldName: "Wind Speed", fieldValue: "\(weatherData.wind.speed) m/s")
        let row8 = WeatherRecord(fieldName: "Longitude", fieldValue: "\(weatherData.coord.lon) ")
        let row9 = WeatherRecord(fieldName: "Latitude", fieldValue: "\(weatherData.coord.lat) ")
        
        tableViewData = [row1, row2, row3, row4, row5, row6, row7, row8, row9]
        
        
    }
    
    func getBackgroundImage()-> String{
        let weatherDescription = dataReceivedFromAPI?.weather[0].weatherDescription
        switch (weatherDescription) {
        case "clear sky":
            return "clearSky"
        case "few clouds", "scattered clouds", "broken clouds", "overcast clouds":
            return "cloud"
        case "shower rain", "rain", "light rain", "moderate rain":
            return "rain"
        case "snow":
            return "snow"
        case "mist":
            return "mist"
        default:
            return "default"
        }
    }
}
