//
//  SearchResultController.swift
//  ios-itunes-search
//
//  Created by Joshua Sharp on 9/3/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class SearchResultController {
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    var searchResults: [SearchResult] = []
    
    func performSearch (searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        var searchItems: [URLQueryItem] = []
        searchItems.append(URLQueryItem(name: "entity", value: resultType.rawValue))
        searchItems.append(URLQueryItem(name: "term", value: searchTerm))
        
        components?.queryItems = searchItems
        
        guard let requestURL = components?.url else {
            completion("Components errored out." as? Error)
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog ("Error searching API: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from searching: \(error ?? "" as! Error)")
                completion(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResults.self,from: data)
                self.searchResults = searchResults.results
                completion(nil)
            } catch {
                NSLog("Error decoding searchResults from data: \(error)")
                completion(error)
            }
        }.resume()
    }
}

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

