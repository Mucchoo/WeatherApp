//
//  WeatherInfoView.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import SwiftUI
import CoreLocation

struct WeeklyForecast: Hashable {
    let day: String
    let celcius: Int
    let image: String
}

struct WeatherInfoView: View {
    @Binding var showingSheet: Bool
    let city: City
    let weeklyForecasts: [WeeklyForecast] = [
        .init(day: "Mon", celcius: 90, image: "sun.min"),
        .init(day: "Tue", celcius: 91, image: "cloud.sun"),
        .init(day: "Wed", celcius: 92, image: "cloud.sun.bolt"),
        .init(day: "Thu", celcius: 93, image: "sun.max"),
        .init(day: "Fri", celcius: 94, image: "cloud.sun"),
        .init(day: "Sat", celcius: 95, image: "cloud.sun.bolt"),
        .init(day: "Sun", celcius: 96, image: "sun.min"),
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("cloudy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .ignoresSafeArea()
            .overlay(.ultraThinMaterial)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text(city.name)
                        .font(.system(size: 35))
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                    
                    Text("98°")
                        .font(.system(size: 45))
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                        .padding(.leading)
                    
                    Text("Cloudy")
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                    
                    Text("H:103°L:105°")
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                showingSheet = false
                            }, label: {
                                Image(systemName: "multiply")
                                    .resizable()
                                    .foregroundStyle(.white)
                                    .frame(width: 25, height: 25)
                                    .shadow(radius: 5)
                            })
                            Spacer()
                        }
                    }
                )
                
                VStack(spacing: 8) {
                    CustomStackView {
                        Label {
                            Text("Hourly Forecast")
                        } icon: {
                            Image(systemName: "clock")
                        }
                    } contentView: {
                        ScrollView(.horizontal) {
                            HStack(spacing: 30) {
                                ForecastView(time: "12 PM", celcius: 90, image: "sun.min")
                                ForecastView(time: "1 PM", celcius: 90, image: "sun.min")
                                ForecastView(time: "2 PM", celcius: 90, image: "sun.min")
                                ForecastView(time: "3 PM", celcius: 90, image: "cloud.sun")
                                ForecastView(time: "4 PM", celcius: 90, image: "sun.haze")
                            }
                            .padding(.vertical, 10)
                        }
                    }

                    CustomStackView {
                        Label {
                            Text("Weekly Forecast")
                        } icon: {
                            Image(systemName: "calendar")
                        }
                        
                    } contentView: {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(weeklyForecasts, id: \.self) { forecast in
                                weeklyForecast(forecast)
                            }
                        }
                        .padding(.bottom)
                    }

                }

            }
            .padding()
            .onAppear {
                fetchWeather(for: city.location) { result in
                    switch result {
                    case .success(let response):
                        print("weather response: \(response)")
                    case .failure(let error):
                        print("weather fetch failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func fetchWeather(for location: CLLocation, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let apiKey = "14379450f55fe65f99b0236875893d09"
        
        let url = "\(baseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)"
        
        guard let requestURL = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherData))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }.resume()
    }
    
    private func weeklyForecast(_ forecast: WeeklyForecast) -> some View {
        return VStack {
            HStack(spacing: 15) {
                Text(forecast.day)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(width: 45, alignment: .leading)
                
                Image(systemName: forecast.image)
                    .font(.title3)
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.yellow, .white)
                    .frame(width: 30)
                
                Text("\(forecast.celcius)")
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
                    .frame(width: 30, alignment: .leading)
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.tertiary)
                        .foregroundStyle(.white)
                    
                    GeometryReader { geometry in
                        Capsule()
                            .fill(.linearGradient(.init(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: (CGFloat(forecast.celcius) / 140) * geometry.size.width)
                    }
                }
                .frame(height: 4)
                
                Text("\(forecast.celcius)")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(width: 30, alignment: .leading)
            }

            if forecast != weeklyForecasts.last {
                Divider()
            }
        }
        .padding(.vertical, 8)
    }
}

struct ForecastView: View {
    let time: String
    let celcius: Int
    let image: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text(time)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Image(systemName: image)
                .font(.title2)
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .white)
                .frame(height: 30)
            
            Text("\(celcius)°")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
    }
}

struct CustomStackView<Title: View, Content: View>: View {
    var titleView: Title
    var contentView: Content
    
    init(@ViewBuilder titleView: @escaping () -> Title, @ViewBuilder contentView: @escaping () -> Content) {
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .font(.callout)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(.ultraThinMaterial, in: CustomCorner(corners: [.topLeft, .topRight], radius: 12))
            
            VStack {
                Divider()
                
                contentView
                    .padding(.horizontal)
            }
            .background(.ultraThinMaterial, in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: 12))
        }
        .colorScheme(.dark)
    }
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: .init(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

#Preview {
    WeatherInfoView(showingSheet: .constant(true),
                    city: .init(name: "Test", location: .init(latitude: 0, longitude: 0)))
}
