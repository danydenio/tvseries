//
//  NetworkManagerService.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class NetworkManagerService {
    func getRequest(urlComponents: URLComponents, completion: ((Result<Data>) -> Void)?) {
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default        
        config.timeoutIntervalForRequest = TimeInterval(10000)
        config.timeoutIntervalForResource = TimeInterval(1000)
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else {
                    completion?(.failure(responseError!))
                    return
                }                
                guard let jsonData = responseData else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                    return
                }
                completion?(.success(jsonData))
        }
        task.resume()
    }
}
