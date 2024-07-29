////
////  ContinuousSearchViewController.swift
////  Reckless
////
////  Created by Facundo Kzemin on 22/07/2024.
////
//
//import MapboxSearch
//import UIKit
//
//class ContinuousSearchViewController: TextViewLoggerViewController {
//    let searchEngine = SearchEngine()
//    let textField = UITextField()
//    let responseLabel = UILabel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        textField.borderStyle = .line
//        textField.addTarget(self, action: #selector(textFieldTextDidChanged), for: .editingChanged)
//        responseLabel.lineBreakMode = .byTruncatingMiddle
//        
//        view.addSubview(textField)
//        view.addSubview(responseLabel)
//        
//        searchEngine.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        textField.becomeFirstResponder()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        textField.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50 * 2, height: 32)
//        responseLabel.frame = CGRect(x: 50, y: textField.frame.maxY + 16, width: view.bounds.width - 50 * 2, height: 32)
//    }
//}
//
//extension ContinuousSearchViewController {
//    @objc 
//    func textFieldTextDidChanged() {
//        searchEngine.query = textField.text!
//    }
//}
//
//extension ContinuousSearchViewController: SearchEngineDelegate {
//    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
//        dumpSuggestions(suggestions, query: searchEngine.query)
//    }
//    
//    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
//        print("Dumping resolved result:", dump(result))
//    }
//    
//    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
//        print("Error during search: \(searchError)")
//    }
//}
