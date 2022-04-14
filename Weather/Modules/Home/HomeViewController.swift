//
//  ViewController.swift
//  Weather
//
//  Created by Melvyn Awani on 12/04/2022.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentCityNameLbl: UILabel!
    @IBOutlet weak var temperatureInCelsiusLbl: UILabel!
    @IBOutlet weak var temperatureFeelsLike: UILabel!
    @IBOutlet weak var minTemperatureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    @IBOutlet weak var pressureValueLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var maxTemperatureLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var currentWeatherDescription: UILabel!
    @IBOutlet weak var feelsDescription: UILabel!
    @IBOutlet weak var humidityDescription: UILabel!
    @IBOutlet weak var pressureDescription: UILabel!
    @IBOutlet weak var maxTempDescription: UILabel!
    @IBOutlet weak var longitudeDescription: UILabel!
    @IBOutlet weak var windSpeedDescription: UILabel!
    @IBOutlet weak var latitudeDescription: UILabel!
    @IBOutlet weak var visibilityDescription: UILabel!
    @IBOutlet weak var minTempDescription: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    let homeViewModel: HomeViewModelType = HomeViewModel(networkManager: NetworkManager())
    var networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        hideLabelsRepresentingValues()
        hideLabelsRepresentingDescription()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let textEntered = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        searchBar.text = ""
        homeViewModel.informNetworkManagerToPerformRequest(textEntered: textEntered) {[weak self] response in
            
            switch response {
            case true:
                DispatchQueue.main.async {
                    self?.populateValuesReceivedIntoUI()
                }
            case false:
                DispatchQueue.main.async {
                    self?.currentCityNameLbl.text = "City not found"
                    self?.hideLabelsRepresentingValues()
                    self?.hideLabelsRepresentingDescription()
                }
            }
        }
    }
    
    func hideLabelsRepresentingValues(){
        temperatureInCelsiusLbl.isHidden = true
        temperatureFeelsLike.isHidden = true
        minTemperatureLbl.isHidden = true
        maxTemperatureLbl.isHidden = true
        pressureValueLbl.isHidden = true
        humidityLbl.isHidden = true
        visibilityLbl.isHidden = true
        windSpeedLbl.isHidden = true
        longitudeLbl.isHidden = true
        latitudeLbl.isHidden = true
        currentWeatherDescription.isHidden = true
    }
    
    func showLabelsRepresentingValues(){
        temperatureInCelsiusLbl.isHidden = false
        currentWeatherIcon.isHidden = false
        temperatureFeelsLike.isHidden = false
        minTemperatureLbl.isHidden = false
        maxTemperatureLbl.isHidden = false
        pressureValueLbl.isHidden = false
        humidityLbl.isHidden = false
        visibilityLbl.isHidden = false
        windSpeedLbl.isHidden = false
        longitudeLbl.isHidden = false
        latitudeLbl.isHidden = false
        currentWeatherDescription.isHidden = false
    }
    
    func hideLabelsRepresentingDescription(){
        feelsDescription.isHidden = true
        humidityDescription.isHidden = true
        pressureDescription.isHidden = true
        maxTempDescription.isHidden = true
        longitudeDescription.isHidden = true
        windSpeedDescription.isHidden = true
        latitudeDescription.isHidden = true
        visibilityDescription.isHidden = true
        minTempDescription.isHidden = true
    }
    
    func showLabelsRepresentingDescription(){
        feelsDescription.isHidden = false
        humidityDescription.isHidden = false
        pressureDescription.isHidden = false
        maxTempDescription.isHidden = false
        longitudeDescription.isHidden = false
        windSpeedDescription.isHidden = false
        latitudeDescription.isHidden = false
        visibilityDescription.isHidden = false
        minTempDescription.isHidden = false
    }
    
    func populateValuesReceivedIntoUI() {
        self.currentCityNameLbl.text = self.homeViewModel.dataReceivedFromAPI?.name ?? "City entered not found"
        if let temperature = self.homeViewModel.dataReceivedFromAPI?.main.temp{
            self.temperatureInCelsiusLbl.text = "\(Int(temperature))°"
        }
        self.currentWeatherIcon.load(urlString: self.homeViewModel.getWeatherIconURL())
        self.currentWeatherDescription.text = "\(self.homeViewModel.dataReceivedFromAPI?.weather[0].weatherDescription ?? "")"
        if let dataReceived = self.homeViewModel.dataReceivedFromAPI{
            self.temperatureFeelsLike.text = "\(dataReceived.main.feelsLike)°"
            self.minTemperatureLbl.text = "\(dataReceived.main.tempMin)°"
            self.maxTemperatureLbl.text = "\(dataReceived.main.tempMax)°"
            self.pressureValueLbl.text = "\(dataReceived.main.pressure) hpa"
            self.humidityLbl.text = "\(dataReceived.main.humidity)%"
            self.visibilityLbl.text = "\(dataReceived.visibility) km"
            self.windSpeedLbl.text = "\(dataReceived.wind.speed) m/s"
            self.longitudeLbl.text = "\(dataReceived.coord.lon)"
            self.latitudeLbl.text = "\(dataReceived.coord.lat)"
            self.showLabelsRepresentingValues()
            self.showLabelsRepresentingDescription()
            let weatherDescription = self.homeViewModel.dataReceivedFromAPI?.weather[0].weatherDescription
            
            switch (weatherDescription) {
            case "clear sky":
                backgroundImage.image = UIImage(named: "clearSky")
            case "few clouds":
                backgroundImage.image = UIImage(named: "cloud")
            case "scattered clouds":
                backgroundImage.image = UIImage(named: "cloud")
            case "broken clouds":
                backgroundImage.image = UIImage(named: "cloud")
            case "overcast clouds":
                backgroundImage.image = UIImage(named: "overcast")
            case "shower rain":
                backgroundImage.image = UIImage(named: "rain")
            case "rain":
                backgroundImage.image = UIImage(named: "rain")
            case "light rain":
                backgroundImage.image = UIImage(named: "rain")
            case "moderate rain":
                backgroundImage.image = UIImage(named: "rain")
            case "snow":
                backgroundImage.image = UIImage(named: "snow")
            case "mist":
                backgroundImage.image = UIImage(named: "mist")
            default:
                backgroundImage.image = UIImage(named: "default")
            }
            
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            homeViewModel.informNetworkManagerToPerformRequest(latitude: lat, longitude: lon) {[weak self] response in
                
                switch response {
                case true:
                    DispatchQueue.main.async {
                        self?.populateValuesReceivedIntoUI()
                    }
                case false:
                    DispatchQueue.main.async {
                        self?.currentCityNameLbl.text = "City not found"
                        self?.hideLabelsRepresentingValues()
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
}


