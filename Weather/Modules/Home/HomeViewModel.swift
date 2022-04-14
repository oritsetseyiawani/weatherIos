//
//  HomeViewModel.swift
//  Weather
//
//  Created by Melvyn Awani on 12/04/2022.
//

import Foundation
import CoreLocation

protocol HomeViewModelType {
    var dataReceivedFromAPI: WeatherData? {get}
    func getWeatherIconURL()->String
    func informNetworkManagerToPerformRequest(textEntered: String, isDataReturned:@escaping(_ response: Bool)->Void)
    func informNetworkManagerToPerformRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees, isDataReturned:@escaping(_ response: Bool)->Void)

}

class HomeViewModel: HomeViewModelType {
    private let networkManager: Networkable
    
      init(networkManager: Networkable){
          self.networkManager = networkManager
      }
    var dataReceivedFromAPI: WeatherData?

    
    func informNetworkManagerToPerformRequest(textEntered: String, isDataReturned:@escaping(_ response: Bool)->Void){
        networkManager.performRequest(baseUrl: EndPoints.baseUrl, path: Path.searchWeather, params: ["api_key":"3215a185b25eb297a66e63d137fb994f", "units": "metric", "q": textEntered, "appid": "111c704b48268f9adbc8dce3c913c272"]) {[weak self] result in
            
            switch(result){
            case .success(let weatherData):
                self?.dataReceivedFromAPI = weatherData
                isDataReturned(true)
            case .failure(let error):
                print(error)
                isDataReturned(false)
            }
        }
            
        
    }
    
    func informNetworkManagerToPerformRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees, isDataReturned:@escaping(_ response: Bool)->Void){
        networkManager.performRequest(baseUrl: EndPoints.baseUrl, path: Path.searchWeather, params: ["api_key":"3215a185b25eb297a66e63d137fb994f", "units": "metric", "lat": "\(latitude)", "lon": "\(longitude)", "appid": "111c704b48268f9adbc8dce3c913c272"]) {[weak self] result in
            
            switch(result){
            case .success(let weatherData):
                self?.dataReceivedFromAPI = weatherData
                isDataReturned(true)
            case .failure(let error):
                print(error)
                isDataReturned(false)
            }
        }
            
        
    }
    
    func getWeatherIconURL()->String{
        return "https://openweathermap.org/img/wn/\(dataReceivedFromAPI?.weather[0].icon ?? "")@4x.png"
    }
    
    
    
}
