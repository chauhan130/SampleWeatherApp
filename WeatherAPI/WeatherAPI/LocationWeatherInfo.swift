//
//  LocationWeatherInfo.swift
//  WeatherAPI
//
//  Created by Sunil Chauhan on 23/09/18.
//  Copyright © 2018 Sunil Chauhan. All rights reserved.
//

import Foundation

/// Wind Info
public struct WindInfo {
    public var speed: Measurement<UnitSpeed>?
    public var degree: Measurement<UnitAngle>?
}

/// Temperature Information
public struct Temperature {
    public var main: Measurement<UnitTemperature>?
    public var temperatureMin: Measurement<UnitTemperature>?
    public var temperatureMax: Measurement<UnitTemperature>?
}

//TODO: Try to use Codable instead.

/// Stores location weather information.
public struct LocationWeatherInfo {
    public var wind: WindInfo?
    public var temperature: Temperature?
    public var pressure: Measurement<UnitPressure>?
    public var humidityPercent: Double?
    public var locationName: String?
    public var sunrise: Date?
    public var sunset: Date?

    init(json: [String: Any]) {
        if let main = json["main"] as? [String: Any] {
            if let pressure = main["pressure"] as? Double {
                self.pressure = Measurement(value: pressure, unit: UnitPressure.hectopascals)
            }

            if let humidity = main["humidity"] as? Double {
                self.humidityPercent = humidity
            }

            var temperature = Temperature()
            if let temperatureMain = main["temp"] as? Double {
                temperature.main = Measurement(value: temperatureMain, unit: UnitTemperature.kelvin)
            }
            if let tempMin = main["temp_min"] as? Double {
                temperature.temperatureMin = Measurement(value: tempMin, unit: UnitTemperature.kelvin)
            }
            if let tempMax = main["temp_max"] as? Double {
                temperature.temperatureMax = Measurement(value: tempMax, unit: UnitTemperature.kelvin)
            }
            self.temperature = temperature
        }

        if let name = json["name"] as? String {
            self.locationName = name
        }

        if let windJson = json["wind"] as? [String: Any] {
            var windInfo = WindInfo()
            if let speed = windJson["speed"] as? Double {
                windInfo.speed = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
            }
            if let degree = windJson["deg"] as? Double {
                windInfo.degree = Measurement(value: degree, unit: UnitAngle.degrees)
            }
            self.wind = windInfo
        }

        if let sys = json["sys"] as? [String: Any] {
            if let sunsetTimeStamp = sys["sunset"] as? TimeInterval {
                self.sunset = Date(timeIntervalSince1970: sunsetTimeStamp)
            }
            if let sunriseTimeStamp = sys["sunrise"] as? TimeInterval {
                self.sunrise = Date(timeIntervalSince1970: sunriseTimeStamp)
            }
        }
    }
}
