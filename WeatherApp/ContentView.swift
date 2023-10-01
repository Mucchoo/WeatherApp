//
//  ContentView.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var showingSheet = false
    
    private let cities = ["東京", "大分", "京都", "北海道"]

    var body: some View {
        NavigationStack {
            List {
                if let cityName = locationManager.cityName {
                    cityButton(city: "現在地: \(cityName)")
                }
                
                ForEach(cities, id: \.self) { city in
                    cityButton(city: city)
                }
            }
            .navigationTitle("都市")
            .fullScreenCover(isPresented: $showingSheet, content: {
                WeatherInfoView()
            })
        }
    }
    
    func cityButton(city: String) -> some View {
        return Button(action: {
            showingSheet = true
        }, label: {
            Text(city)
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .padding(.vertical)
        })
    }
}

#Preview {
    ContentView()
}
