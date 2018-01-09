//
//  MTRefreshControl.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 09/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

final class MTRefreshControl: UIRefreshControl {

    private let endRefreshingDelay: TimeInterval = 0.5

    override func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + endRefreshingDelay) {
            super.endRefreshing()
        }
    }
}
