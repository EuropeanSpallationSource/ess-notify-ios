//
//  GlobalDataUtilities.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-17.
//

import Foundation

struct UserData: Codable {
    var APNToken: String
    var ESSToken: String
    var server: String
}

var userData = UserData(APNToken: "", ESSToken: "", server: "")

struct UserNotification: Identifiable, Decodable {
    var id: Int
    var title: String
    var subtitle: String
    var url: String
    var timestamp: String
    var service_id: String
    var is_read: Bool
}

var userNotifications = [UserNotification]()

struct UserService: Decodable {
    var category: String
    var color: String
    var owner: String
    var id: String
    var is_subscribed: Bool
}

var userServices = [UserService]()

var invalidToken = false
