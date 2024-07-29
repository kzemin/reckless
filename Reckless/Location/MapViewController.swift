//
//  MapViewController.swift
//  Reckless
//
//  Created by Facundo Kzemin on 12/07/2024.
//

import UIKit
import CoreLocation
@_spi(Experimental) import MapboxMaps
import MapboxSearch
import MapboxDirections
import MapboxNavigationCore
import MapboxNavigationUIKit

@MainActor
final class MapViewController: UIViewController {
    var mapView: MapView!
    var isFollowingUser = false
    
    private var cancelables = Set<AnyCancelable>()
    
    lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = MapInitOptions()
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
        
        mapView.mapboxMap.onStyleLoaded.observeNext { _ in
            self.setupMapView()
        }.store(in: &cancelables)
        
        setupGestureRecognizers()
        
    }
    
    // Puck configuration
    
    private func setupMapView() {
        // Fetch the asset
        let uri = Bundle.main.url(forResource: "scene", withExtension: "gltf")
        
        // Instantiate the model
        let myModel = Model(uri: uri, orientation: [0, 0, 180])
        
        let configuration = Puck3DConfiguration(
            model: myModel,
            modelScale: .constant([10,10,10])
        )
        //.constant([0.08, 0.08, 0.08])
        
        mapView.location.options.puckType = .puck3D(configuration)
        mapView.location.options.puckBearing = .course
        mapView.location.options.puckBearingEnabled = true
        
        mapView.location.onLocationChange.observeNext { [weak mapView] newLocation in
            guard let location = newLocation.last, let mapView else { return }
            mapView.camera.ease(
                to: CameraOptions(
                    center: location.coordinate,
                    zoom: 15,
                    bearing: 0,
                    pitch: 55),
                duration: 1,
                curve: .linear,
                completion: nil
            )
        }.store(in: &cancelables)
    }
    
    // Gesture & Map centering
    
    func setupGestureRecognizers() {
        mapView.gestures.panGestureRecognizer.addTarget(self, action: #selector(mapPanned))
        mapView.gestures.pinchGestureRecognizer.addTarget(self, action: #selector(mapPinched))
    }
    
    @objc func mapPanned() {
        stopFollowingUser()
    }
    
    @objc func mapPinched() {
        stopFollowingUser()
    }
    
    func centerAndFollowUser() {
        guard let userLocation = mapView.location.latestLocation?.coordinate else { return }
        mapView.camera.ease(to: CameraOptions(center: userLocation, zoom: 15), duration: 0.5)
        startFollowingUser()
    }
    
    private func startFollowingUser() {
        isFollowingUser = true
        mapView.location.options.puckBearingEnabled = true
        
        mapView.location.onLocationChange.observe { [weak self] newLocation in
            guard let self = self, self.isFollowingUser else { return }
            self.updateCamera(with: newLocation.last ?? Location.init(clLocation: CLLocation(latitude: 0, longitude: 0)))
        }
        .store(in: &cancelables)
    }
    
    private func stopFollowingUser() {
        isFollowingUser = false
        mapView.location.options.puckBearingEnabled = true
        cancelables.removeAll()
    }
    
    private func updateCamera(with location: Location) {
        mapView.camera.ease(
            to: CameraOptions(
                center: location.coordinate,
                zoom: 15,
                bearing: location.bearing
            ),
            duration: 0.5
        )
    }
    
    // Directions
    
//    func showAnnotations(results: [SearchResult], cameraShouldFollow: Bool = true) {
//        annotationsManager.annotations = results.map(PointAnnotation.init)
//        
//        if cameraShouldFollow {
//            cameraToAnnotations(annotationsManager.annotations)
//        }
//    }
    
    func cameraToAnnotations(_ annotations: [PointAnnotation]) {
        if annotations.count == 1, let annotation = annotations.first {
            mapView.camera.fly(
                to: .init(center: annotation.point.coordinates, zoom: 15),
                duration: 0.25,
                completion: nil
            )
        } else {
            do {
                let cameraState = mapView.mapboxMap.cameraState
                let coordinatesCamera = try mapView.mapboxMap.camera(
                    for: annotations.map(\.point.coordinates),
                    camera: CameraOptions(cameraState: cameraState),
                    coordinatesPadding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
                    maxZoom: nil,
                    offset: nil
                )
                
                mapView.camera.fly(to: coordinatesCamera, duration: 0.25, completion: nil)
            } catch {
                _Logger.searchSDK.error(error.localizedDescription)
            }
        }
    }
    
//    func showAnnotation(_ result: SearchResult) {
//        showAnnotations(results: [result])
//    }
    
//    func showAnnotation(_ favorite: FavoriteRecord) {
//        annotationsManager.annotations = [PointAnnotation(favoriteRecord: favorite)]
//        
//        cameraToAnnotations(annotationsManager.annotations)
//    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
    
//    func getDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
//        let options = RouteOptions(coordinates: [start, end])
//        options.profileIdentifier = .automobileAvoidingTraffic
//        options.includesSteps = true
//        
//        let directions = Directions.shared
//        directions.calculate(options) { [weak self] (session, result) in
//            switch result {
//            case .failure(let error):
//                print("Error calculating directions: \(error.localizedDescription)")
//            case .success(let response):
//                guard let route = response.routes?.first else {
//                    print("No routes found")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self?.displayRoute(route)
//                }
//            }
//        }
//    }
//    
//    func displayRoute(_ route: Route) {
//        let sourceId = "route-source-id"
//        
//        var routeSource = GeoJSONSource(id: sourceId)
//        routeSource.data = .feature(Feature(geometry: Geometry.lineString(route.shape!)))
//        
//        do {
//            try mapView.mapboxMap.addSource(routeSource)
//        } catch {
//            print("Error adding source: \(error)")
//        }
//        
//        var routeLayer = LineLayer(id: "route-layer", source: routeSource.id)
//        routeLayer.lineColor = .constant(StyleColor(UIColor.blue))
//        routeLayer.lineWidth = .constant(10)
//        
//        do {
//            try mapView.mapboxMap.addLayer(routeLayer)
//        } catch {
//            print("Error adding layer: \(error)")
//        }
//    }
