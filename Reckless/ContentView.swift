//
//  ContentView.swift
//  Reckless
//
//  Created by Facundo Kzemin on 11/07/2024.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps
import CoreLocation

struct MapViewCoordinatorKey: PreferenceKey {
    static var defaultValue: MapViewRepresentable.Coordinator?
    
    static func reduce(value: inout MapViewRepresentable.Coordinator?, nextValue: () -> MapViewRepresentable.Coordinator?) {
        value = nextValue()
    }
}

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var needsMapUpdate = false
    @State private var mapViewCoordinator: MapViewRepresentable.Coordinator?
    @ObservedObject var navigation: Navigation
    
    var body: some View {
        ZStack {
            VStack {
                MapViewRepresentable(centerOnUserLocation: {
                    mapViewCoordinator?.centerOnUserLocation()
                })
                .edgesIgnoringSafeArea(.all)
                
                HStack {
                    if navigation.currentPreviewRoutes == nil, !navigation.isInActiveNavigation {
                        Text("Long press anywhere to build a route")
                    } else if navigation.currentPreviewRoutes != nil {
                        Button("Clear") {
                            navigation.cancelPreview()
                        }
                        Spacer()
                        Button("Start navigation") {
                            navigation.startActiveNavigation()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 45)
                
                Button(action: {
                    mapViewCoordinator?.centerOnUserLocation()
                    
                    
        //            navigation.isInActiveNavigation {
        //
        //            }
                }, label: {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                })
                .padding()
                .onReceive(NotificationCenter.default.publisher(for: .init("MapViewCoordinatorSet"))) { notification in
                    if let coordinator = notification.object as? MapViewRepresentable.Coordinator {
                        self.mapViewCoordinator = coordinator
                    }
                }
                .onReceive(locationManager.$userLocation) { location in
                    if let location = location {
                        needsMapUpdate = true
                        print("the location is: \(location)")
                        //                    return Map(initialViewport: .camera(center: location, zoom: 18, bearing: 0, pitch: 0))
                    }
                    return
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//}

//    .safeAreaInset(edge: .bottom) {
//        HStack(spacing: 15) {
//            Button {
//            } label: {
//                Image(systemName: "person.fill")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .padding(.horizontal, 50)
//            }
//            
//            Button {
//                //
//            } label: {
//                Image(systemName: "person.fill")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .padding(.horizontal, 50)
//            }
//        }
//        .frame(width: 250, height: 55)
//        .background(.black)
//        .cornerRadius(50)
//        .padding(.bottom, 50)
//    }
