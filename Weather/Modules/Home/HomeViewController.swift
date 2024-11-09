//
//  HomeViewController.swift
//  Weather
//
//  Created by Melvyn Awani on 12/04/2022.
//

import CoreLocation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var currentWeatherIcon: UIImageView!
    @IBOutlet var currentCityNameLbl: UILabel!
    @IBOutlet var temperatureInCelsiusLbl: UILabel!
    @IBOutlet var currentWeatherDescription: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var tableview: UITableView!
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
        homeViewModel.informNetworkManagerToPerformRequest(textEntered: cityName) { [weak self] response in

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
        currentCityNameLbl.text = homeViewModel.dataReceivedFromAPI?.name ?? Constants.invalidCity
        if let temperature = homeViewModel.dataReceivedFromAPI?.main.temp {
            temperatureInCelsiusLbl.text = "\(Int(temperature))°"
        }
        currentWeatherIcon.load(urlString: homeViewModel.getWeatherIconURL())
        currentWeatherDescription.text = "\(homeViewModel.dataReceivedFromAPI?.weather[0].weatherDescription ?? "")"
        if (homeViewModel.dataReceivedFromAPI) != nil {
            showLabelsRepresentingValues()
            backgroundImage.image = UIImage(named: homeViewModel.getBackgroundImage())
            tableview.reloadData()
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    @IBAction func locationPressed(_: UIButton) {
        locationManager.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            homeViewModel.informNetworkManagerToPerformRequest(latitude: lat, longitude: lon) { [weak self] response in

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

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return homeViewModel.tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherTableViewCellIdentifier) as! WeatherTableViewCell
        cell.fieldName.text = homeViewModel.tableViewData[indexPath.row].fieldName
        cell.fieldValue.text = homeViewModel.tableViewData[indexPath.row].fieldValue
        return cell
    }
}

extension UIView {
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
