//
//  NetworkingError.swift
//  CarApp
//
//  Created by Daniel Rocha on 9/4/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation

class NetworkingError: Error {
    
    enum ErrorType {
        case responseParseError
        case unitTestError
        case unknownError
    }
    
    let errorCode: String
    let errorMessage: String
    
    init(errorCode: String, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        
    }
    
    init(errorType: ErrorType) {
        switch errorType {
        case .responseParseError:
            self.errorCode = "8000"
            self.errorMessage = "Falha ao baixar as informações do servidor :("
        case .unknownError:
            self.errorCode = "-1"
            self.errorMessage = "Erro Inesperado"
        case .unitTestError:
            self.errorCode = "-3"
            self.errorMessage = "Error used for fake unit tests errors"
            
        }
    }
}
