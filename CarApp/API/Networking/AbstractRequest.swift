//
//  AbstractRequest.swift
//  CarApp
//
//  Created by Daniel Rocha on 9/4/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation

class AbstractRequest {
    
    var url: String = ""
    
    func toDictionary() -> [String: Any]? {
        return nil
    }
}

class InfractionRequest : AbstractRequest{
    
    let title: String
    let scoreLost: Int
    
    init(title: String, scoreLost: Int){
        self.title = title
        self.scoreLost = scoreLost
    }
    
    override func toDictionary() -> [String : Any]? {
        return ["title": self.title,
                "scoreLost":self.scoreLost]
    }
}

struct InfractionResponse : Codable {
    let message: String
    let data: DataResponse
    
    enum CodingKeys: String, CodingKey {
        case message = "_message"
        case data = "_data"
    }
}

struct DataResponse: Codable{
    let user: UserModel
}
