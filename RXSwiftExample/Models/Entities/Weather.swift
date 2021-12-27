//
//  Weather.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import CoreLocation

//extension CLLocationCoordinate2D: Codable {
//    public init(from decoder: Decoder) throws {
//        <#code#>
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        <#code#>
//    }
//
//
//}

public struct Weather: Decodable {
    let cityName: String
    let temperature: Int
    let humidity: Int
    let icon: String
    let coordinate: CLLocationCoordinate2D
    
    static let empty = Weather(
        cityName: "Unknown",
        temperature: -1000,
        humidity: 0,
        icon: iconNameToChar(icon: "e"),
        coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
    )
    
    static let dummy = Weather(
        cityName: "Da Nang",
        temperature: 99,
        humidity: 99,
        icon: iconNameToChar(icon: "01d"),
        coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
    )
    
    init(cityName: String,
         temperature: Int,
         humidity: Int,
         icon: String,
         coordinate: CLLocationCoordinate2D) {
        self.cityName = cityName
        self.temperature = temperature
        self.humidity = humidity
        self.icon = icon
        self.coordinate = coordinate
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // cityName
        cityName = try values.decode(String.self, forKey: .cityName)
        
        let info = try values.decode([AdditionalInfo].self, forKey: .weather)
        // icon
        icon = Weather.iconNameToChar(icon: info.first?.icon)
        
//        let weatherInfo = try values.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
//        let iconString = try weatherInfo.decode(String.self, forKey: .icon)
//        icon = Weather.iconNameToChar(icon: iconString)
        
        let mainInfoContainer = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temperature = Int(try mainInfoContainer.decode(Double.self, forKey: .temp))
        humidity = try mainInfoContainer.decode(Int.self, forKey: .humidity)
        
        let coord = try values.decode(Coordinate.self, forKey: .coordinate)
        coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
    }
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case main
        case weather
        case coordinate = "coord"
    }
    
    enum MainKeys: String, CodingKey {
        case temp
        case humidity
    }
    
    enum WeatherKeys: String, CodingKey {
        case main
        case description
        case icon
    }
    
    private struct AdditionalInfo: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    private struct Coordinate: Decodable {
        let lat: CLLocationDegrees
        let lon: CLLocationDegrees
    }
}

extension Weather {
    static func iconNameToChar(icon: String?) -> String {
        switch icon {
        case "01d":
            return  "☀️"
        case "01n":
            return "🌙"
        case "02d":
            return "🌤"
        case "02n":
            return "🌤"
        case "03d", "03n":
            return "☁️"
        case "04d", "04n":
            return "☁️"
        case "09d", "09n":
            return "🌧"
        case "10d", "10n":
            return "🌦"
        case "11d", "11n":
            return "⛈"
        case "13d", "13n":
            return "❄️"
        case "50d", "50n":
            return "💨"
        default:
            return "E"
        }
    }
}

/*
{
   "coord":{
      "lon":-0.13,
      "lat":51.51
   },
   "weather":[
      {
         "id":801,
         "main":"Clouds",
         "description":"few clouds",
         "icon":"02n"
      }
   ],
   "base":"stations",
   "main":{
      "temp":10.74,
      "feels_like":8.36,
      "temp_min":10,
      "temp_max":12,
      "pressure":1020,
      "humidity":81
   },
   "visibility":10000,
   "wind":{
      "speed":2.6,
      "deg":230
   },
   "clouds":{
      "all":15
   },
   "dt":1599364473,
   "sys":{
      "type":1,
      "id":1414,
      "country":"GB",
      "sunrise":1599369706,
      "sunset":1599417370
   },
   "timezone":3600,
   "id":2643743,
   "name":"London",
   "cod":200
}
*/
