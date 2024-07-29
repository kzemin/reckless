////
////  SimpleListSearchViewController.swift
////  Reckless
////
////  Created by Facundo Kzemin on 23/07/2024.
////
//
//import MapboxSearch
//import UIKit
//
//class SimpleListSearchViewController: MapsViewController {
//    let searchEngine = SearchEngine(accessToken: "sk.eyJ1IjoiY3VmYXBhZXoiLCJhIjoiY2x5aXBtZjdrMGhsaTJrb3N5NXB0dGViNiJ9.oo5EC6tEKlxg2K5TINgePA")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        searchEngine.delegate = self
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        searchEngine.query = "Mapbox"
//    }
//}
//
//extension SimpleListSearchViewController: SearchEngineDelegate {
//    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
//        print("Number of search results: \(searchEngine.suggestions.count)")
//        
//        guard let randomSuggestion: SearchSuggestion = searchEngine.suggestions.randomElement() else {
//            print("No available suggestions to select")
//            return
//        }
//        
//        searchEngine.select(suggestion: randomSuggestion)
//    }
//    
//    func resultResolved(result:  SearchResult, searchEngine: SearchEngine) {
//        print(
//            "Resolved result: coordinate: \(result.coordinate), address: \(result.address?.formattedAddress(style: .medium) ?? "N/A")"
//        )
//        
//        print("Dumping resolved result:", dump(result))
//        
//        showAnnotation(result)
//    }
//    
//    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
//        print("Error during search: \(searchError)")
//    }
//}
