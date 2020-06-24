//
//  DonateViewController.swift
//  TranquilForest
//
//  Created by David Ritchie on 12/26/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import UIKit
import StoreKit

class DonateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    var tableView = UITableView()
    let productIdentifiers = Set([""])
    var product: SKProduct?
    var productsArray = Array(arrayLiteral: String())
    
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
    
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplication.openSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.open(url! as URL)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response:  SKProductsResponse!) {
       
        let products = response.products
        
        if (products.count != 0) {
            for product in products
            {
                self.product = product
                self.productsArray.append(product.localizedTitle)
            }
            self.tableView.reloadData()
        } else {
            print("No products found")
        }
        
        for product in response.invalidProductIdentifiers
        {
            print("Product not found: \(product)")
        }
    }
}
