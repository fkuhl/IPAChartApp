//
//  ViewController.swift
//  IPAChartApp
//
//  Created by Frederick Kuhl on 4/20/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//

import UIKit

class CarryingViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var webView: UIWebView?
    @IBOutlet var back: UIBarButtonItem?
    @IBOutlet var forward: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.delegate = self
        //The docs say you should load a local file as a String, rather than requesting it.
        //If you do that, the back and forward buttons don't get set.
//        let url = Bundle.main.url(forResource: "app-index", withExtension: "html")
//        var content: String
//        do {
//            try content = String(contentsOf: url!)
//        } catch {
//            content = "Error"
//        }
//        webView?.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
//        updateButtons()
        
        let request = URLRequest(url: Bundle.main.url(forResource: "app-index", withExtension: "html")!)
        webView?.loadRequest(request)
        //delegate will notice when we're done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //print ("finished load")
        updateButtons()
    }
    
    private func updateButtons() {
        //print("update. fwd:\(webView!.canGoForward) back:\(webView!.canGoForward)")
        forward?.isEnabled = (webView?.canGoForward)!
        back?.isEnabled = (webView?.canGoBack)!
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if (webView?.canGoBack)! {
            webView?.goBack()
            updateButtons()
        }
    }

    @IBAction func goForward(_ sender: UIBarButtonItem) {
        if (webView?.canGoForward)! {
            webView?.goForward()
            updateButtons()
        }
    }
}

