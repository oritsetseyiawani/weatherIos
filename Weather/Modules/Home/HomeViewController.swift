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
    @IBOutlet weak var currentWeatherDescription: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    let homeViewModel: HomeViewModelType = HomeViewModel(networkManager: NetworkManager())
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        hideLabelsRepresentingValues()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        tableview.dataSource = self
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cityName = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        searchBar.text = ""
        homeViewModel.informNetworkManagerToPerformRequest(textEntered: cityName) {[weak self] response in
            
            switch response {
            case true:
                DispatchQueue.main.async {
                    self?.populateValuesReceivedIntoUI()
                }
            case false:
                DispatchQueue.main.async {
                    self?.currentCityNameLbl.text = Constants.invalidCity
                    self?.hideLabelsRepresentingValues()
                    self?.tableview.reloadData()
                }
            }
        }
    }
    
    func hideLabelsRepresentingValues() {
        temperatureInCelsiusLbl.isHidden = true
        currentWeatherDescription.isHidden = true
    }
    
    func showLabelsRepresentingValues() {
        temperatureInCelsiusLbl.isHidden = false
        currentWeatherIcon.isHidden = false
        currentWeatherDescription.isHidden = false
    }
    
    
    func populateValuesReceivedIntoUI() {
        self.currentCityNameLbl.text = self.homeViewModel.dataReceivedFromAPI?.name ?? Constants.invalidCity
        if let temperature = self.homeViewModel.dataReceivedFromAPI?.main.temp{
            self.temperatureInCelsiusLbl.text = "\(Int(temperature))°"
        }
        self.currentWeatherIcon.load(urlString: self.homeViewModel.getWeatherIconURL())
        self.currentWeatherDescription.text = "\(self.homeViewModel.dataReceivedFromAPI?.weather[0].weatherDescription ?? "")"
        if (self.homeViewModel.dataReceivedFromAPI) != nil {
            self.showLabelsRepresentingValues()
            backgroundImage.image = UIImage(named: homeViewModel.getBackgroundImage())
            tableview.reloadData()
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
                        self?.currentCityNameLbl.text = Constants.invalidCity
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

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherTableViewCellIdentifier) as! WeatherTableViewCell
        cell.fieldName.text = homeViewModel.tableViewData[indexPath.row].fieldName
        cell.fieldValue.text = homeViewModel.tableViewData[indexPath.row].fieldValue
        return cell
    }
}

