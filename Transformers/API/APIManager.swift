//
//  APIManager.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation

typealias APICompletion = (APIResponse) -> ()
typealias ImageDownloadComplete = (ImageResponse) -> ()

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()

    func opertationWithRequest ( withApi api : API , completion : @escaping APICompletion )  {
        
        guard let request = api.createRequest() else {
            completion(.Failure("Please check url \(api.url())"))
            return
        }
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                completion(.Failure(error?.localizedDescription))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 204 else {
                completion(.Failure(String(bytes: data, encoding: String.Encoding.utf8)))
                return
            }
            completion(api.handleResponse(response: data))

        }.resume()

    }
    
    
    func downloadImage(withurl api: API,completion : @escaping ImageDownloadComplete )  {
        guard let url = URL(string: api.url()) else {
            completion(.Failure)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue

        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                completion(.Failure)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode == 200 || statusCode == 201 || statusCode == 204 else {
                completion(.Failure)
                return
            }
            completion(.Success(data))

        }.resume()
        completion(.Failure)
    }

}
