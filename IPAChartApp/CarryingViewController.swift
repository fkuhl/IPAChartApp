//
//  ViewController.swift
//  IPAChartApp
//
//  Created by Frederick Kuhl on 4/20/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//

import UIKit
import WebKit

class CarryingViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: Bundle.main.url(forResource: "app-index", withExtension: "html")!)
        webView.load(request)
    }
}

