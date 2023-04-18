//
//  WeatherManager.swift
//  Clima
//
//  Created by enes öztürk on 30.01.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import CoreLocation
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var apiKey = "your_api_key"
    var weatherURL: String { "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric" }

    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityname: String) {
        let urlString = "\(weatherURL)&q=\(cityname)"
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let newURLWithLocation = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(with: newURLWithLocation)
        print(newURLWithLocation)
    }

    func performRequest(with urlString: String) {
        // 1.create a url
        if let url = URL(string: urlString) {
            // 2.crate a url session
            let session = URLSession(configuration: .default)
            // 3.give the session a task
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        // let weatherVC = WeatherViewController()
                        //  weatherVC.didUpdateWeather(weather: weather)

                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // start the task
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)

            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
