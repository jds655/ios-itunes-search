//
//  SearchResultsTableViewController.swift
//  ios-itunes-search
//
//  Created by Joshua Sharp on 9/3/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {

    let searchResultsController = SearchResultController()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.style = .gray
    }
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        updateViews()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultsController.searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = searchResultsController.searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResultsController.searchResults[indexPath.row].creator
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateViews()
    }
    
    private func updateViews() {
        guard let searchText = searchBar.text else { return }
        var resultType: ResultType?
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            resultType = ResultType.software
        case 1:
            resultType = ResultType.musicTrack
        case 2:
            resultType = ResultType.movie
        default:
            break
        }
        activityIndicator.startAnimating()
        searchResultsController.performSearch(searchTerm: searchText, resultType: resultType!) { (error) in
            if let error = error {
                NSLog("performSearch failed: \(error)")
                return
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
