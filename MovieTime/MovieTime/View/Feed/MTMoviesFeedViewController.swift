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
    @IBOutlet weak var collectionView: UICollectionView!

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
    fileprivate let viewModel = MTMoviesFeedViewModel()

    private let refreshControl = UIRefreshControl()
    private var searchBar: UISearchBar?
    private var searchController: UISearchController?

    fileprivate let interItemSpacing: CGFloat = 10

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        setupCollectionView()
        setupUI()
        setupViewModel()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }

    // MARK: Methods
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }

    private func setupCollectionView() {

        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: interItemSpacing, bottom: 0, right: interItemSpacing)
    }

    private func setupUI() {
        title = viewModel.title
        setupNavigationController()
    }

    private func setupViewModel() {
        viewModel.onDataSourceChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }

        viewModel.onDataSourceFailed = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(withTitle: "Failed to load movies.", message: error?.localizedDescription)
                self?.refreshControl.endRefreshing()
            }
        }
        refreshControl.beginRefreshing()
        viewModel.loadFeed()
    }

    @objc
    private func pullToRefresh(_ sender: Any) {
        viewModel.loadFeed()
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

    func showAlert(withTitle title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MTMoviesFeedViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setupForNoSearching()
    }
}

extension MTMoviesFeedViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier = viewModel.identifier(for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let movieCell = cell as? MTMovieCollectionViewCell {
            let movieViewModel = viewModel.data(for: indexPath)
            movieCell.setup(withViewModel: movieViewModel)
        }
        return cell
    }
}

extension MTMoviesFeedViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension MTMoviesFeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let totalWidth: CGFloat
        if viewModel.isDeviceLandscape {
            totalWidth = collectionView.bounds.height - collectionView.contentInset.left - collectionView.contentInset.right - interItemSpacing
        } else {
            totalWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - interItemSpacing
        }

        // Half of width
        let width = totalWidth / 2
        let height = 1.5 * width - MTMovieCollectionViewCell.informationHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
}
