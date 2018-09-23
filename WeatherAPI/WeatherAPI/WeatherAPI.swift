//
//  WeatherAPI.swift
//  WeatherAPI
//
//  Created by Sunil Chauhan on 23/09/18.
//  Copyright © 2018 Sunil Chauhan. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

/// Manages the API for weather.
public class WeatherAPI {
    private enum Constants {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
        static let apiKey = "d49199147cdf1cde201e5ecd228b2241"
    }

    private enum PlaceMarkResult {
        case success(LocatioinString)
        case failure(Swift.Error)
    }

    public enum WeatherError: Swift.Error {
        case placemarkNotFound
        case invalidJsonReceived
    }

    public enum WeatherResult {
        case success(LocationWeatherInfo)
        case failure(Error)
    }

    public typealias GetWeatherInfoCompletionBlock = (WeatherResult) -> Void
    private typealias GetAreaNameFromLocationCompletionBlock = (PlaceMarkResult) -> Void
    private typealias LocatioinString = String

    public var requestInProgress = false

    //MARK: - Public methods

    public init() { }

    public func getWeather(location: CLLocation, completion: @escaping GetWeatherInfoCompletionBlock) {
        requestInProgress = true
        //  Get city/country first if we can. This will help simulate caching the data,
        //  otherwise user can never select similar coordinates on map. (almost never)
        getAreaNameFrom(location: location) { (result) in
            var url = Constants.baseUrl

            switch result {
            case .success(let locationString):
                url = url.appending("q=\(locationString)")
            case .failure(_):
                url = url.appending("lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)")
            }
            url = url.appending("&appid=\(Constants.apiKey)")

            self.actuallyFetchWeatherInformation(url: url, completion: completion)
        }
    }

    //MARK: - Private methods

    private func actuallyFetchWeatherInformation(url: String, completion: @escaping GetWeatherInfoCompletionBlock) {
        // Actually fetch weather info from the server.
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let json):
                if let json = json as? [String: Any] {
                    let locationInfo = LocationWeatherInfo(json: json)
                    completion(.success(locationInfo))
                    self.requestInProgress = false
                } else {
                    completion(.failure(WeatherError.invalidJsonReceived))
                    self.requestInProgress = false
                }
            case .failure(let error):
                completion(.failure(error))
                self.requestInProgress = false
            }
        })
    }

    /// Get string that we can use to send to the API.
    private func getAreaNameFrom(location: CLLocation, completion: @escaping GetAreaNameFromLocationCompletionBlock) {
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let placemark = placemarks?.first {
                var query = [String]()
                if let city = placemark.locality {
                    query.append(city)
                }
                if let country = placemark.country {
                    query.append(country)
                }

                if query.count > 0, let string = query.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    completion(.success(string))
                } else {
                    completion(.failure(WeatherError.placemarkNotFound))
                }
            } else {
                completion(.failure(WeatherError.placemarkNotFound))
            }
        }
    }
}
