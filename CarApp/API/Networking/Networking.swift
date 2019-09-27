//
//  Network.swift
//  CarApp
//
//  Created by Daniel Rocha on 9/4/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation


class Networking: NetworkingProtocol {
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    

    func doGet<P: AbstractRequest, R: Codable>(requestObject: P, success: @escaping NetworkSuccessBlock<R>, failure: @escaping NetworkFailureBlock) {
        return self.doRequest(requestObject: requestObject, method: HTTPMethod.get, success: success, failure: failure)
    }
    
    func doPost<P: AbstractRequest, R: Codable>(requestObject: P, success: @escaping NetworkSuccessBlock<R>, failure: @escaping NetworkFailureBlock) {
        return self.doRequest(requestObject: requestObject, method: HTTPMethod.post, success: success, failure: failure)
    }
    
    private func doRequest<P: AbstractRequest, R: Codable>(requestObject: P, method: HTTPMethod,
                                                           success: @escaping NetworkSuccessBlock<R>,
                                                           failure: @escaping NetworkFailureBlock) {
        guard let url = URL(string: requestObject.url) else {
            return
        }
        
        dataTask?.cancel()
        
        print("🚀 URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
        
        if let body = requestObject.toDictionary(), request.httpMethod == HTTPMethod.post.rawValue {
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        
        dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            defer { self.dataTask = nil }
            
            if let error = error {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                let apiError = NetworkingError(errorCode: "\(httpResponse.statusCode)", errorMessage: error.localizedDescription)
                print("❌ Erro de requisição: " + error.localizedDescription)
                failure(apiError)
                return
            }
            
            guard let data = data else { return }
            
            do {
                print(String(data: data, encoding: String.Encoding.utf8))
                let response = try JSONDecoder().decode(R.self, from: data) as R
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("✅ Response: \(json)")
                }
                
                DispatchQueue.main.async {
                    success(response)
                }
                
            } catch {
                print("\n❓JSONDecoder -> \(R.self): \(error)\n")
            }
        })
        
        dataTask?.resume()
    }
    
    private func JSONDecode<T: Codable>(to object: T.Type, from data: Data) -> T? {
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("\n❓JSONDecoder -> \(T.self): \(error)\n")
            return nil
        }
    }
}
