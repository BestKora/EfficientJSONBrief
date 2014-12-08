//
//  Place.swift
//  EfficientJSON
//
//  Created by Tatiana Kornilova on 10/15/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation

// ---- Модель Place ----

struct Place {
    
    let placeURL: NSURL
    let timeZone: String
    let photoCount : Int
    let content : String

}

extension Place: Printable, JSONDecodable {
    var description :String {
        return "Place { placeURL = \(placeURL), timeZone = \(timeZone), photoCount = \(photoCount),content = \(content)} \n"
    }

    static func create(placeURL: String)(timeZone: String)(photoCount: String)(content: String) -> Place {
        return Place(placeURL: toURL(placeURL), timeZone: timeZone, photoCount: photoCount.toInt() ?? 0,content: content)
    }
    static func decode(json: JSON) -> Place? {
        return _JSONParse(json) >>> { d in
            Place.create
                <^> d <| "place_url"
                <*> d <| "timezone"
                <*> d <| "photo_count"
                <*> d <| "_content"
        }
    }
}

//---------------------- String --> NSURL--------
func toURL(urlString: String) -> NSURL {
    return NSURL(string: urlString)!
}


// ---- Модель Places ----

struct Places{
    var places : [Place]
}

extension Places: Printable, JSONDecodable {
    
    var description :String  { get {
        var str: String = ""
        for place in self.places {
            str = str +  "\(place) \n"
        }
        return str
        }
    }
   
    static func create(places: [Place]) -> Places {
        return Places(places: places)
    }
    static func decode(json: JSON) -> Places? {
        return _JSONParse(json) >>> { d in
            Places.create
                <^> d <| "places" <| "place"
            
        }
    }
}
// ---- Конец  Places----

