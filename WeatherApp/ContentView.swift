//
//  ContentView.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    let cities = ["東京", "大分", "京都", "北海道"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cities, id: \.self) { city in
                    NavigationLink(destination: WeatherInfoView()) {
                        Text(city)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.primary)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
