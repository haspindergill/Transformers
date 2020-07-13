
//
//  APIHandler.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation


extension API {

    func createRequest() -> URLRequest? {
        guard let url = URL(string: self.url()) else {
            return nil
        }
        var request = URLRequest(url:url)
        request.httpMethod = self.method.rawValue
        request.httpBody = self.body
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        switch self {
        case .AllSpark:
            return request
        default:
            guard let token = String(bytes: KeyChain.load(key: "token") ?? Data(), encoding: String.Encoding.utf8), token.count > 0 else {
                return nil
            }
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
    }
}
