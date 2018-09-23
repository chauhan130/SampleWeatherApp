//
//  WeatherDetailViewController.swift
//  SampleWeatherApp
//
//  Created by Sunil Chauhan on 23/09/18.
//  Copyright © 2018 Sunil Chauhan. All rights reserved.
//

import UIKit
import CoreLocation
import WeatherAPI

class WeatherDetailViewController: UIViewController {
    var location: CLLocation?
    @IBOutlet var textView: UITextView!

    private let weatherApi = WeatherAPI()
    private let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        loader.hidesWhenStopped = true
        let barItem = UIBarButtonItem(customView: loader)
        self.navigationItem.rightBarButtonItem = barItem
        loader.startAnimating()
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        guard let location = location, weatherApi.requestInProgress == false else {
            return
        }
        weatherApi.getWeather(location: location) { (result) in
            switch result {
            case .success(let location):
                self.textView.text = "\(location)"
            case .failure(let err):
                print("Error: \(err)")
                self.textView.text = "\(err)"
            }
            self.loader.stopAnimating()
        }
    }
}
