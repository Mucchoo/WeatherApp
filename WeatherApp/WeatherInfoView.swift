//
//  WeatherInfoView.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import SwiftUI

struct WeeklyForecast: Hashable {
    let day: String
    let celcius: Int
    let image: String
}

struct WeatherInfoView: View {
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
                    Text("San Jose")
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
        }
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
    WeatherInfoView()
}
