//
//  ContentView.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    let cities = ["現在地", "東京", "大分", "京都", "北海道"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cities, id: \.self) { city in
                    NavigationLink(destination: WeatherInfoView()) {
                        cityText(city: city)
                    }
                }
            }
            .navigationTitle("Cities")
        }
    }
    
    func cityText(city: String) -> some View {
        let text: String
        
        if city == cities.first, let cityName = locationManager.cityName {
            text = "現在地: \(cityName)"
        } else {
            text = city
        }
        
        return Text(text)
            .font(.title)
            .bold()
            .foregroundStyle(.primary)
            .padding(.vertical)
    }
}

#Preview {
    ContentView()
}
