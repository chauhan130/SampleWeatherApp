//
//  WeatherDataSource.swift
//  SampleWeatherApp
//
//  Created by Sunil Chauhan on 23/09/18.
//  Copyright © 2018 Sunil Chauhan. All rights reserved.
//

import UIKit
import WeatherAPI

class WeatherDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private enum Constants {
        static let cellReuseIdentifier = "WeatherDataCellId"
    }

    var locationInfo: LocationWeatherInfo? {
        didSet {
            rows.removeAll()
            if let location = locationInfo {
                if let name = location.locationName {
                    let data = ["key": "Location", "value" : "\(name)"]
                    rows.append(data)
                }
                if let sunrise = location.sunrise {
                    let value = shortTime(date: sunrise)
                    let data = ["key": "Sunrise", "value" : "\(value)"]
                    rows.append(data)
                }
                if let sunset = location.sunset {
                    let value = shortTime(date: sunset)
                    let data = ["key": "Sunset", "value" : "\(value)"]
                    rows.append(data)
                }
                if let wind = location.wind {
                    if let speed = wind.speed {
                        let speedValue = MeasurementFormatter().string(from: speed)
                        let data = ["key": "Wind Speed", "value" : "\(speedValue)"]
                        rows.append(data)
                    }
                    if let degree = wind.degree {
                        let degreeValue = MeasurementFormatter().string(from: degree)
                        let data = ["key": "Wind Degree", "value" : "\(degreeValue)"]
                        rows.append(data)
                    }
                }
                if let temperature = location.temperature {
                    if let main = temperature.main {
                        let tempValue = MeasurementFormatter().string(from: main)
                        let data = ["key": "Temperature (Main)", "value" : "\(tempValue)"]
                        rows.append(data)
                    }
                    if let min = temperature.temperatureMin {
                        let minTempValue = MeasurementFormatter().string(from: min)
                        let data = ["key": "Temperature (Min)", "value" : "\(minTempValue)"]
                        rows.append(data)
                    }
                    if let max = temperature.temperatureMax {
                        let maxTempValue = MeasurementFormatter().string(from: max)
                        let data = ["key": "Temperature (Max)", "value" : "\(maxTempValue)"]
                        rows.append(data)
                    }
                }
                if let pressure = location.pressure {
                    let pressureValue = MeasurementFormatter().string(from: pressure)
                    let data = ["key": "Pressure", "value" : "\(pressureValue)"]
                    rows.append(data)
                }
                if let humidityPercent = location.humidityPercent {
                    let data = ["key": "Humidity", "value" : "\(humidityPercent)%"]
                    rows.append(data)
                }
            }
        }
    }

    private var rows = [[String: String]]()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) {
            cell.textLabel?.text = rows[indexPath.row]["key"]
            cell.detailTextLabel?.text = rows[indexPath.row]["value"]
            return cell
        }
        assertionFailure("Cell could not be initialized.!")
        return UITableViewCell()
    }

    private func shortTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from:date)
    }
}
