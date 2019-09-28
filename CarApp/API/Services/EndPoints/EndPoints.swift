//
//  EndPoints.swift
//  CarApp
//
//  Created by Daniel Rocha on 9/4/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation

class EndPoints {
    
    private static let baseUrl = "https://henry-api-ford-challenge.herokuapp.com"
    private static let getUsers = "/users"
    private static let postInfraction = "/travels/5d6da476516eb344f48c3011/infractions"
    private static let getHistory = "/travels?status=%@"
    private static let getHistoryFromUser = "&user=%@"
    private static let getCompleteHistoryFromUser = "/travels?user=%@"
    
    
    static let getUsersService = baseUrl + getUsers
    
    static let postInfractionService = baseUrl + postInfraction
    
    static let getHistoryService = baseUrl + getHistory + getHistoryFromUser
    
    static let getCompleteHistoryServiceFromUser = baseUrl + getCompleteHistoryFromUser
    
}
