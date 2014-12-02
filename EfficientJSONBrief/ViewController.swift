
//  ViewController.swift
//  EfficientJSONBrief
//

//---- по статье http://robots.thoughtbot.com/efficient-json-in-swift-with-functional-concepts-and-generics

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--------------- URL для places из Flickr.com ------------------------------------------
        
        let urlPlaces  = NSURLRequest( URL: FlickrFetcher.URLforTopPlaces())
        
        performRequest(urlPlaces ) { (places: Result<Places>) in
            println("\(stringResult(places))")
            
            
        }
    }
}

// ---------- БУДЬТЕ ВНИМАТЕЛЬНЫ - КОМПИЛИРУЕТСЯ около 1 минуты--------


