//
//  RespondParse.swift
//  EfficientJSON
//
//  Created by Tatiana Kornilova on 10/16/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation

struct Response {
    let data: NSData
    let statusCode: Int = 500
    
    init(data: NSData, urlResponse: NSURLResponse) {
        self.data = data
        if let httpResponse = urlResponse as? NSHTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
    }
}

func performRequest<A: JSONDecodable>
                   (request: NSURLRequest, callback: (Result<A>) -> ()) {
                    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
        data, urlResponse, error in
            callback( parseResult(data, urlResponse, error))
    }
                    
    task.resume()
}

func parseResult<A: JSONDecodable>(data: NSData!,
                                   urlResponse: NSURLResponse!,
                                   error: NSError!) -> Result<A> {
    let responseResult: Result<Response> =
                        Result(error, Response(data: data, urlResponse: urlResponse))
    return responseResult >>> parseResponse
                          >>> decodeJSON
                          >>> decodeObject
}

func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError()) // customize the error message to your liking
    }
    return Result(nil, response.data)
}

//------------------ Для Result<JSON> -----

func decodeJSON(data: NSData) -> Result<JSON> {
    var jsonErrorOptional: NSError?
    let jsonOptional: JSON! = NSJSONSerialization.JSONObjectWithData(data,
        options: NSJSONReadingOptions(0),
        error: &jsonErrorOptional)
    if let err = jsonErrorOptional {
        return resultFromOptional(jsonOptional,
            NSError (localizedDescription: err.localizedDescription ))
    } else {
        
        return resultFromOptional(jsonOptional, NSError ())
    }
}

