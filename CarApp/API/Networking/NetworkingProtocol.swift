//
//  NetworkProtocol.swift
//  CarApp
//
//  Created by Daniel Rocha on 9/4/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation

typealias NetworkSuccessBlock<R> = (_ responseObject: R?) -> ()
typealias NetworkFailureBlock = (NetworkingError?) -> ()

protocol NetworkingProtocol: AnyObject {
    
    func doGet<P: AbstractRequest, R: Codable>(requestObject: P,
                                               success: @escaping NetworkSuccessBlock<R>,
                                               failure: @escaping NetworkFailureBlock)
    
    func doPost<P: AbstractRequest, R: Codable>(requestObject: P,
                                                success: @escaping NetworkSuccessBlock<R>,
                                                failure: @escaping NetworkFailureBlock)
}
