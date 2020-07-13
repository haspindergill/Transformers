
//
//  APIRoutes.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation

protocol Router {
    var route: String { get }
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

enum HTTPMethod : String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}


enum API {
    case AllSpark
    case CreateTransformer(transformer: Transformer)
    case GetTransformers
    case EditTransformer(transformer: Transformer)
    case DeleteTransformer(transformerID: String)
    case DownloadImage(url: String)

}

// MARK: - Router Protocol

extension API: Router {
    
    var body: Data? {
        switch self {
        case .CreateTransformer(let transformer),.EditTransformer(let transformer):
            guard let httpBody = try? JSONEncoder().encode(transformer) else {return nil}
            return httpBody
        default:
            return nil
        }
    }
    
  
    var route: String  {
        switch self {
        case .AllSpark:
            return "allspark"
        case .CreateTransformer,.DeleteTransformer,.EditTransformer,.GetTransformers:
            return "transformers"
        case .DownloadImage(_):
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .AllSpark,.DownloadImage:
            return .GET
        case .CreateTransformer:
            return .POST
        case .GetTransformers:
            return .GET
        case .EditTransformer:
            return .PUT
        case .DeleteTransformer:
            return .DELETE
        }
            
    }
    
    var baseURL: String {
        return "https://transformers-api.firebaseapp.com/"
    }
    
    
    func url() -> String {
        switch self {
        case .DeleteTransformer(let transformerID):
            return baseURL + route + "/" + transformerID
        case .DownloadImage(let url):
            return url
        default:
            return baseURL + route
        }
    }
}
