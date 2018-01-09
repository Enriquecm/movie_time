//
//  MTMovieFeedViewModelTests.swift
//  MovieTimeTests
//
//  Created by Enrique Melgarejo on 09/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import XCTest
@testable import MovieTime

class MTMovieFeedViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let viewModel = MTMoviesFeedViewModel()
        XCTAssertNotNil(viewModel, "The view model should not be nil.")
        XCTAssertTrue(viewModel.dataSource.isEmpty, "The dataSource should start empty.")

        let moviesService = MTMovieDBServiceMock(helper: MTServiceHelper())
        let moviesViewModel = MTMoviesFeedViewModel(service: moviesService)
        XCTAssertNotNil(moviesViewModel, "The view model should not be nil.")
        XCTAssertTrue(moviesViewModel.movieDbService === moviesService, "The service should be equal to the service that was passed in.")
    }

    func testMethods() {
        let movieDBService = MTMovieDBServiceMock(helper: MTServiceHelper())
        let moviesViewModel = MTMoviesFeedViewModel(service: movieDBService)
        moviesViewModel.loadFeed()
        XCTAssertTrue(movieDBService.didRequest, "The request method should be called.")
    }

    func testDataSourceMethods() {
        let viewModel = MTMoviesFeedViewModel()
        XCTAssertEqual(viewModel.numberOfSections(), 1, "The number of sections should be 1")
        XCTAssertEqual(viewModel.numberOfItemsInSection(for: 0), 0 , "The number of items in section 0 should be 0")

        let indexPath1 = IndexPath(item: 0, section: 0)
        let indexPath2 = IndexPath(item: 1, section: 0)
        XCTAssertEqual(viewModel.identifier(for: indexPath1), MTMovieCollectionViewCell.identifier , "The identifier should be MTMovieCollectionViewCell for all indexPath's")
        XCTAssertEqual(viewModel.identifier(for: indexPath2), MTMovieCollectionViewCell.identifier , "The identifier should be MTMovieCollectionViewCell for all indexPath's")
        XCTAssertNil(viewModel.data(for: indexPath1), "The data should be nil before load information")
        XCTAssertNil(viewModel.data(for: indexPath2), "The data should be nil before load information")
    }
}

private class MTServiceMock: MTServiceProtocol {

    var didRequest = false
    var requestedUrl: MTURLConvertible?
    var requestMethod: MTHTTPMethod?
    var requestedHeaders: MTHTTPHeaders?

    func requestHttp(url: MTURLConvertible?, method: MTHTTPMethod, parameters: MTParameters?, encoding: MTParameterEncoding, headers: MTHTTPHeaders?, completion: MTRequestResponse) {

        didRequest = true
        requestedUrl = url
        requestMethod = method
        requestedHeaders = headers
    }

    func loadImage(baseURL: MTURLConvertible?, endpoint: String?, completion: MTImageRequestResponse) {
        // TODO
    }
}

private class MTMovieDBServiceMock: MTMovieDBServiceProtocol {
    var didRequest = false
    private var currentService: MTServiceProtocol

    required init(service: MTServiceProtocol = MTServiceMock(), helper: MTServiceHelperProtocol) {
        currentService = service
    }

    func requestUpcomingMovies(forPage page: Int, completion: ((Data?, MTNetworkError?) -> Void)?) {
        // TODO:
        didRequest = true
    }
}
