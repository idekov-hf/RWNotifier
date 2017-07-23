//
//  XMLParser.swift
//  RWReminder
//
//  Created by Iavor Dekov on 5/15/17.
//  Copyright © 2017 Iavor Dekov. All rights reserved.
//

import Foundation

class Parser: NSObject {
  
  var url: URL
  var tutorials = [Tutorial]()
  var xmlParser: XMLParser!
  weak var delegate: ParserDelegate?
  var tutorial: Tutorial?
  var element = ""
  
  init(url: String) {
    self.url = URL(string: url)!
    super.init()
  }
  
  func downloadAndParse() {
    let urlSession = URLSession.shared
    urlSession.dataTask(with: url) { (data, response, error) in
      if let data = data {
        self.setupXMLParser(data: data)
      }
    }.resume()
  }
  
  func setupXMLParser(data: Data) {
    xmlParser = XMLParser(data: data)
    xmlParser.delegate = self
    xmlParser.parse()
  }
  
}

extension Parser: XMLParserDelegate {
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    element = elementName
    if elementName == "item" {
      tutorial = Tutorial()
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    switch element {
    case "title":
      tutorial?.title.append(string)
    case "pubDate":
      tutorial?.pubDate.append(string)
    case "description":
      tutorial?.description.append(string)
    default:
      break
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "item" {
      tutorial?.title = tutorial!.title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      
      let index = tutorial!.pubDate.index(tutorial!.pubDate.startIndex, offsetBy: 16)
      tutorial?.pubDate = tutorial!.pubDate.substring(to: index)
      
      tutorial?.description = tutorial!.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
      
      tutorials.append(tutorial!)
    }
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    DispatchQueue.main.async {
      self.delegate?.didFinishParsing(tutorials: self.tutorials)
    }
  }
}

protocol ParserDelegate: class {
  func didFinishParsing(tutorials: [Tutorial])
}
