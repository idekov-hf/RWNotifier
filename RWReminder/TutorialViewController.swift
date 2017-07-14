//
//  TutorialViewController.swift
//  RWReminder
//
//  Created by Iavor Dekov on 5/17/17.
//  Copyright © 2017 Iavor Dekov. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var tutorial: Tutorial?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = tutorial?.title
    dateLabel.text = tutorial?.pubDate
    descriptionLabel.text = tutorial?.description
  }
}
