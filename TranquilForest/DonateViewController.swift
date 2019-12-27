//
//  DonateViewController.swift
//  TranquilForest
//
//  Created by David Ritchie on 12/26/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func donateButtonTapped(_ sender: Any) {
        openURL(url: "https://paypal.me/tranquilforest")
    }
    
    func openURL(url: String) {
        if let requestUrl = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(requestUrl)
            }
        }
    }
}
