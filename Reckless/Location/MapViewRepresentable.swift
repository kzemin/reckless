//
//  MapViewRepresentable.swift
//  Reckless
//
//  Created by Facundo Kzemin on 13/07/2024.
//

import Foundation
import SwiftUI

struct MapViewRepresentable: UIViewControllerRepresentable {
    let centerOnUserLocation: () -> Void
    let navigation: Navigation
    
    func makeUIViewController(context: Context) -> MapViewController {
        let controller = MapViewController(navigation: navigation)
        context.coordinator.mapViewController = controller
        DispatchQueue.main.async {
            context.coordinator.parent.setCoordinator(context.coordinator)
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: MapViewRepresentable
        var mapViewController: MapViewController?
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
//        @MainActor func centerOnUserLocation() {
//            guard let userLocation = navigation.
//            mapViewController?.centerAndFollowUser()
//        }
    }
    
    func setCoordinator(_ coordinator: Coordinator) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .init("MapViewCoordinatorSet"), object: coordinator)
        }
    }
}
