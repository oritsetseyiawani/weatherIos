//
//  NetworkManager.swift
//  Weather
//
//  Created by Melvyn Awani on 12/04/2022.
//

import Foundation


protocol Networkable{
    func performRequest(baseUrl: String, path: String, params: [String: String], completionHandler:@escaping(Result<WeatherData, Error>) -> Void)
}

class NetworkManager: Networkable{
        
    func performRequest(baseUrl: String, path: String, params: [String: String], completionHandler:@escaping(Result<WeatherData, Error>) -> Void){
        
        var urlComponents = URLComponents(string: baseUrl.appending(path))
        let queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url
        else{
            return
        }
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: url){ data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            if let safeData = data{
                let decoder = JSONDecoder()
                do{
                    let decodedData = try decoder.decode(WeatherData.self, from: safeData)
                    completionHandler(.success(decodedData))
                    
                } catch{
                    completionHandler(.failure(error))
                    print(error)
                }
            }
        }
        dataTask.resume()
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}
