//
//  URL+Extension.swift
//  WeatherTests
//
//  Created by Melvyn Awani on 14/04/2022.
//

import Foundation

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}
