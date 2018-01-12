//
//  MTSettingsViewController.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 12/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

class MTSettingsViewController: MTViewController {

    // MARK: Outlets

    // MARK: Properties
    override class var storyboardName: String {
        return MTIdentifiers.Storyboard.Settings.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    @IBAction func buttonClosePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
