//
//  WebViewController.swift
//  FoodPin
//
//  Created by Myron Hicks on 2/18/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://www.appcoda.com/contact") {
            let request = URLRequest(url : url)
            webView.load(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
