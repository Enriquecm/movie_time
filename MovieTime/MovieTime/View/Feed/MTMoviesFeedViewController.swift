//
//  MTMoviesFeedViewController.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

class MTMoviesFeedViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var searchBarMovies: UISearchBar! {
        didSet {
            searchBarMovies.searchBarStyle = .minimal
            searchBarMovies.showsCancelButton = true
            searchBarMovies.delegate = self
        }
    }

    @IBOutlet var viewDropDownMenu: UIView!

    @IBOutlet weak var barButtonSettings: UIBarButtonItem!
    @IBOutlet weak var barButtonSearch: UIBarButtonItem!

    // MARK: Properties
    private let viewModel = MTMoviesFeedViewModel()

    private var searchBar: UISearchBar?
    private var searchController: UISearchController?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
    }

    private func setupNavigationController() {
        setupForNoSearching()
    }

    private func setupSearchController() {
        let resultController = MTSearchMoviesViewController()
        searchController = UISearchController(searchResultsController: resultController)

        searchBar = searchController?.searchBar
        searchController?.searchResultsUpdater = resultController
    }

    // MARK: Actions

    @IBAction func barButtonSettingsPressed(_ sender: UIBarButtonItem) {
        // TODO: Go to settings
    }

    @IBAction func barButtonSearchPressed(_ sender: UIBarButtonItem) {
        setupForSearching()
        searchBarMovies.becomeFirstResponder()
    }

    @IBAction func dropDownMenuPressed(_ sender: UIButton) {
        // TODO: Show Drop down menu
    }

    // MARK: Helpers
    fileprivate func setupForNoSearching() {
        UIView.animate(withDuration: 0.5) {
            self.navigationItem.titleView = self.viewDropDownMenu
            self.navigationItem.setLeftBarButton(self.barButtonSettings, animated: true)
            self.navigationItem.setRightBarButton(self.barButtonSearch, animated: true)
        }
    }

    fileprivate func setupForSearching() {
        UIView.animate(withDuration: 0.5) {
            self.navigationItem.titleView = self.searchBarMovies
            self.navigationItem.setLeftBarButton(nil, animated: true)
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
}

extension MTMoviesFeedViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setupForNoSearching()
    }
}
