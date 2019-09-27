//
//  UserModel.swift
//  CarApp
//
//  Created by Daniel Rocha on 9/4/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation

struct DataModel: Codable {
    let users: [UserModel]
    
    enum CodingKeys: String, CodingKey {
        case users = "_data"
    }
}

struct DataHistoryModel: Codable {
    let history : [HistoryModel]
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        history = try container.decode(HistoryModel.self, forKey: .history)
//    }

    enum CodingKeys: String, CodingKey {
        case history = "_data"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(history, forKey: .history)
    }
}

struct HistoryModel: Codable {
    let user: UserModel
    let store: StoreModel
    let initialScore: Int
    let actualScore: Int
    let currentKm: Int
    let id: String
    let status: Int
    let model: String
    let color: String
    let licensePlate: String
    let vin: String
    let startDate: String
    let endDate: String
    let startPrice: Float
    //let infractions: String
    //let v: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(UserModel.self, forKey: .user)
        store = try container.decode(StoreModel.self, forKey: .store)
        initialScore = try container.decode(Int.self, forKey: .initialScore)
        actualScore = try container.decode(Int.self, forKey: .actualScore)
        currentKm = try container.decode(Int.self, forKey: .currentKm)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(Int.self, forKey: .status)
        model = try container.decode(String.self, forKey: .model)
        color = try container.decode(String.self, forKey: .color)
        licensePlate = try container.decode(String.self, forKey: .licensePlate)
        vin = try container.decode(String.self, forKey: .vin)
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        startPrice = try container.decode(Float.self, forKey: .startPrice)
        //infractions = try container.decode(String.self, forKey: .infractions)
        //v = try container.decode(String.self, forKey: .v)
    }
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case store = "store"
        case initialScore = "initialScore"
        case actualScore = "actualScore"
        case currentKm = "currentKm"
        case id = "_id"
        case status = "status"
        case model = "model"
        case color = "color"
        case licensePlate = "licensePlate"
        case vin = "vin"
        case startDate = "startDate"
        case endDate = "endDate"
        case startPrice = "startPrice"
        case infractions = "infractions"
        //case v = "__v"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
        try container.encode(store, forKey: .store)
        try container.encode(initialScore, forKey: .initialScore)
        try container.encode(actualScore, forKey: .actualScore)
        try container.encode(currentKm, forKey: .currentKm)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
        try container.encode(model, forKey: .model)
        try container.encode(color, forKey: .color)
        try container.encode(licensePlate, forKey: .licensePlate)
        try container.encode(vin, forKey: .vin)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(startPrice, forKey: .startPrice)
        //try container.encode(infractions, forKey: .infractions)
        //try container.encode(v, forKey: .v)
    }
}

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let cpf: String
    let imageUrl: String
    //let v: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        cpf = try container.decode(String.self, forKey: .cpf)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        //v = try container.decode(Int.self, forKey: .v)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case email = "email"
        case cpf = "cpf"
        case imageUrl = "imageSrc"
        //case v = "__v"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(cpf, forKey: .cpf)
        try container.encode(imageUrl, forKey: .imageUrl)
        //try container.encode(v, forKey: .v)
    }
    
}

struct StoreModel: Codable{
    let name: String
    let group: String
    let cnpj: String
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        group = try container.decode(String.self, forKey: .group)
        cnpj = try container.decode(String.self, forKey: .cnpj)
    }
    
    enum CodingKeys: String, CodingKey{
        case name = "name"
        case group = "group"
        case cnpj = "cnpj"
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(group, forKey: .group)
        try container.encode(cnpj, forKey: .cnpj)
    }
}
