//
//  Navigation.swift
//  Reckless
//
//  Created by Facundo Kzemin on 18/07/2024.
//

import Combine
import CoreLocation
import MapboxNavigationCore

@MainActor
final class Navigation: ObservableObject {
    let predictiveCacheManager: PredictiveCacheManager?
    
    @Published private(set) var isInActiveNavigation: Bool = false
    @Published private(set) var activeNavigationRoutes: NavigationRoutes?
    @Published private(set) var currentPreviewRoutes: NavigationRoutes?
    @Published private(set) var visualInstruction: VisualInstructionBanner?
    @Published private(set) var routeProgress: RouteProgress?
    @Published private(set) var currentLocation: CLLocation?
    
    @Published var cameraState: NavigationCameraState = .idle
    @Published var profileIdentifier: ProfileIdentifier = .automobileAvoidingTraffic
    @Published var shouldRequestMapMatching = false
    
    private let core: MapboxNavigation
    private var waypoints: [Waypoint] = []
    
    init() {
        let config = CoreConfig(
            credentials: .init()
            )
        let navigatioProvider = MapboxNavigationProvider(coreConfig: config)
        self.core = navigatioProvider.mapboxNavigation
        self.predictiveCacheManager = navigatioProvider.predictiveCacheManager
        observeNavigation()
    }
    
    private func observeNavigation() {
        core.tripSession().session.map {
            if case .activeGuidance = $0.state { return true }
            return false
        }
        .removeDuplicates()
        .assign(to: &$isInActiveNavigation)
        
        core.navigation().bannerInstructions
            .map { $0.visualInstruction }
            .assign(to: &$visualInstruction)
        
        core.navigation().routeProgress
            .map { $0?.routeProgress }
            .assign(to: &$routeProgress)
        
        core.tripSession().navigationRoutes
            .assign(to: &$activeNavigationRoutes)
        
        core.navigation().locationMatching
            .map { $0.location }
            .assign(to: &$currentLocation)
    }
    
    func startFreeDrive() {
        core.tripSession().startFreeDrive()
    }
    
    func cancelPreview() {
        waypoints =  []
        currentPreviewRoutes = nil
        cameraState = .following
    }
    
    func startActiveNavigation() {
        core.tripSession().startFreeDrive()
        cameraState = .following
    }
    
    func stopActiveNavigation() {
        core.tripSession().startFreeDrive()
        cameraState = .following
    }
    
    func selectAlternativeRoute(at index: Int) async {
        if let previewRoutes = currentPreviewRoutes {
            currentPreviewRoutes = await previewRoutes.selectingAlternativeRoute(at: index)
        } else {
            core.navigation().selectAlternativeRoute(at: index)
        }
    }
    
    func requestRoutes(to mapPoint: MapPoint) async throws {
        guard !isInActiveNavigation, let currentLocation else { return }
        
        waypoints.append(Waypoint(coordinate: mapPoint.coordinate, name: mapPoint.name))
        var userWaypoint = Waypoint(location: currentLocation)
        if currentLocation.course >= 0, !shouldRequestMapMatching {
            userWaypoint.heading = currentLocation.course
            userWaypoint.headingAccuracy = 90
        }
        var optionsWaypoints = waypoints
        optionsWaypoints.insert(userWaypoint, at: 0)
        
        let provider = core.routingProvider()
        if shouldRequestMapMatching {
            let mapMatchingOptions = NavigationMatchOptions(
                waypoints: optionsWaypoints,
                profileIdentifier: profileIdentifier
            )
            let previewRoutes = try await provider.calculateRoutes(options: mapMatchingOptions).value
            currentPreviewRoutes = previewRoutes
        } else {
            let routeOptions = NavigationRouteOptions(
                waypoints: optionsWaypoints,
                profileIdentifier: profileIdentifier
            )
            let previewRoutes = try await provider.calculateRoutes(options: routeOptions).value
            currentPreviewRoutes = previewRoutes
        }
        cameraState = .idle
    }
}
