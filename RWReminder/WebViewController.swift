//
//  WebViewController.swift
//  RWNotifier
//
//  Created by Iavor Dekov on 7/23/17.
//  Copyright © 2017 Iavor Dekov. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

  @IBOutlet weak var webView: UIWebView!
  var url: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(url ?? "no url")
  }
  
}
