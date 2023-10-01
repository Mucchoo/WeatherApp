//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import Foundation

struct WeatherResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherData]
    let city: City
    
    struct WeatherData: Codable {
        let dt: Int
        let main: WeatherMain
        let weather: [WeatherInfo]
        let dt_txt: String
    }

    struct WeatherMain: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct WeatherInfo: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coordinates
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }

    struct Coordinates: Codable {
        let lat: Double?
        let lon: Double?
    }
}
