//
//  ViewController.swift
//  RWReminder
//
//  Created by Iavor Dekov on 5/15/17.
//  Copyright © 2017 Iavor Dekov. All rights reserved.
//

import UIKit

class TutorialsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tutorials = [Tutorial]()
  var refreshControl: UIRefreshControl!
  let parser = Parser(url: "https://www.raywenderlich.com/feed")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    parser.delegate = self
    parser.downloadAndParse()
    setupRefreshControl()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowTutorialDetails" {
      let destinationVC = segue.destination as! TutorialViewController
      let selectedTutorial = tutorials[tableView.indexPathForSelectedRow!.row]
      destinationVC.tutorial = selectedTutorial
    }
  }
  
  func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
    tableView.addSubview(refreshControl) // not required when using UITableViewController
  }
  
  func refresh() {
    print("refreshing")
    parser.downloadAndParse()
  }
  
}

extension TutorialsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell", for: indexPath)
    
    let tutorial = tutorials[indexPath.row]
    cell.textLabel?.text = tutorial.title
    cell.detailTextLabel?.text = tutorial.pubDate
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tutorials.count
  }
}

extension TutorialsViewController: ParserDelegate {
  func didFinishParsing(tutorials: [Tutorial]) {
    print("Finish parsing feed")
    self.tutorials = tutorials
    tableView.reloadData()
    if refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }
  }
}
