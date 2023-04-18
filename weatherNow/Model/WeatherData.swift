

import Foundation

struct WeatherData: Decodable {
    let name: String
    // let temp: Float
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
   // let humidity: Double?
  //  let sea_level: Double?
  //  let pressure: Double?
}

struct Weather: Decodable {
    let id: Int
    
}
