//
//  NavigationMapView.swift
//  Reckless
//
//  Created by Facundo Kzemin on 20/07/2024.
//

import SwiftUI
import UIKit

struct NavigationMapViewStruct: UIViewControllerRepresentable {
    let navigation: Navigation
    
    func makeUIViewController(context: Context) -> UIViewController {
        NavigationMapViewController(navigation: navigation)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
