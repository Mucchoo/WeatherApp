//
//  ContentView.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import SwiftUI
import CoreLocation

struct City: Hashable {
    let name: String
    let location: CLLocation
}

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var showingSheet = false
    @State private var selectedCity: City?
    
    private let cities: [City] = [
        .init(name: "東京", location: .init(latitude: 35.6762, longitude: 139.6503)),
        .init(name: "大分", location: .init(latitude: 33.2396, longitude: 131.6095)),
        .init(name: "京都", location: .init(latitude: 35.0116, longitude: 135.7681)),
        .init(name: "北海道", location: .init(latitude: 43.2203, longitude: 142.8635))
    ]

    var body: some View {
        NavigationStack {
            List {
                if let cityName = locationManager.cityName,
                   let cityLocation = locationManager.location {
                    cityButton(city: .init(name: cityName, location: cityLocation))
                }
                
                ForEach(cities, id: \.self) { city in
                    cityButton(city: city)
                }
            }
            .navigationTitle("都市")
            .fullScreenCover(isPresented: $showingSheet) {
                if let selectedCity {
                    WeatherInfoView(showingSheet: $showingSheet, city: selectedCity)
                }
            }
        }
    }
    
    func cityButton(city: City) -> some View {
        return Button(action: {
            selectedCity = city
            showingSheet = true
        }, label: {
            Text(city.name)
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .padding(.vertical)
        })
    }
}

#Preview {
    ContentView()
}
