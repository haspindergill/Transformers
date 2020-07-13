
//
//  APIResponse.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation

enum APIResponse {
    case Success(AnyObject?)
    case Failure(String?)
}

enum ImageResponse {
    case Success(Data)
    case Failure
}


extension API {
    
    func handleResponse(response: Data) -> APIResponse {
        switch self {
        case .AllSpark:
            return .Success(String(bytes: response, encoding: String.Encoding.utf8) as AnyObject?)
        case .GetTransformers:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let transformers = try? decoder.decode(Transformers.self, from: response) else {
                return .Failure(String(bytes: response, encoding: String.Encoding.utf8))
            }
            return .Success(transformers as AnyObject?)
        case .DeleteTransformer(_):
            return .Success(nil)
        default:
            guard let transformer = try? JSONDecoder().decode(Transformer.self, from: response) else {
                return .Failure(String(bytes: response, encoding: String.Encoding.utf8))
            }
            return .Success(transformer as AnyObject?)
        }
    }
}
