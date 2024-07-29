////
////  MapboxMapsCategoryResultsViewController.swift
////  Reckless
////
////  Created by Facundo Kzemin on 25/07/2024.
////
//
//import MapboxSearch
//import UIKit
//
//class MapboxMapsCategoryResultsViewController: MapsViewController {
//    let searchEngine = CategorySearchEngine(accessToken: "sk.eyJ1IjoiY3VmYXBhZXoiLCJhIjoiY2x5aXBtZjdrMGhsaTJrb3N5NXB0dGViNiJ9.oo5EC6tEKlxg2K5TINgePA")
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        /// Configure RequestOptions to perform search near the Mapbox Office in San Francisco
//        let requestOptions = SearchOptions(proximity: .sanFrancisco)
//
//        searchEngine.search(categoryName: "cafe", options: requestOptions) { response in
//            do {
//                let results = try response.get()
//                self.showAnnotations(results: results)
//            } catch {
//                self.showError(error)
//            }
//        }
//    }
//}
