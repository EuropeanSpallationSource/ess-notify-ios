//
//  URLUtilities.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-10-27.
//

import Foundation



var connectionError = false

func requests<T: Encodable>(payload: T, headers: [String: String], address: String, method: String,  completion: @escaping (Data, Int) -> ())
{
    do {
        let url = URL(string: address)!
        var request = URLRequest(url: url)
        if method != "GET" {
            request.httpMethod = method
            if payload is [String: String] {
                let payload = payload as! [String : String]
                var bodyComponents = ""
                for key in payload.keys {
                    bodyComponents += key+"="+payload[key]!+"&"
                }
                request.httpBody = bodyComponents.data(using: .utf8)
            }
            else {
                request.httpBody = try? JSONEncoder().encode(payload)
            }
        }
        for field in headers.keys {
            request.addValue(headers[field] ?? "", forHTTPHeaderField: field)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                return
            }
            completion(data, response.statusCode)
        }
        task.resume()
    }
}

func login(username: String, password: String) -> (String, Int) {
    struct Login: Decodable {
        var access_token: String
        var token_type: String
    }
    struct Result {
        var login: Login
        var response: Int
        var done: Bool
    }
    let start_time = Date().timeIntervalSince1970
    var result = Result(login: Login(access_token: "", token_type: ""), response: 0, done: false)
    let payload = ["username": username, "password": password]
    let headers = ["Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"]
    connectionError = false
    requests(payload: payload, headers: headers, address: loginEndpoint, method: "POST") { data, response in
        if response == 200 {
            result.login = try! JSONDecoder().decode(Login.self, from: data)
        }
        result.response = response
        result.done = true
    }
    while !result.done {
        if (Date().timeIntervalSince1970-start_time > 5) {
            connectionError = true
            return (result.login.access_token, result.response)
        }
    }
    return (result.login.access_token, result.response)
}

func checkUserProfile(token: String) -> Bool {
    struct User: Decodable {
        var id: Int
        var username: String
        var device_tokens: [String]
        var is_active: Bool
        var is_admin: Bool
    }
    struct Result {
        var user: User
        var response: Int
        var done: Bool
    }
    let start_time = Date().timeIntervalSince1970
    var result = Result(user: User(id: 0, username: "", device_tokens: [], is_active: false, is_admin: false), response: 0, done: false)
    let payload = ""
    let headers = ["Accept": "application/json", "Authorization": "Bearer "+token]
    connectionError = false
    requests(payload: payload, headers: headers, address: profileEndpoint, method: "GET") { data, response in
        if response == 200 {
            print(data)
            result.user = try! JSONDecoder().decode(User.self, from: data)
        }
        result.response = response
        result.done = true
    }
    while !result.done {
        if (Date().timeIntervalSince1970-start_time > 5) {
            connectionError = true
            return (result.user.is_active)
        }
    }
    return (result.user.is_active)
}

func setAPNToken(token: String, apn: String) {
    struct Result {
        var response: Int
        var done: Bool
    }
    struct APN: Encodable {
        var device_token: String
    }
    var result = Result(response: 0, done: false)

    let payload = APN(device_token: apn)
    let headers = ["Accept": "application/json", "Authorization": "Bearer "+token]
    
    requests(payload: payload, headers: headers, address: apnEndpoint, method: "POST") { data, response in
        result.response = response
        if response == 401 {
            invalidToken = true
        }
    }
}

func getServices(token: String) {
    struct Result {
        var response: Int
        var done: Bool
    }
    
    var result = Result(response: 0, done: false)

    let payload = ""
    let headers = ["Accept": "application/json", "Authorization": "Bearer "+token]
    
    requests(payload: payload, headers: headers, address: servicesEndpoint, method: "GET") { data, response in
        if response == 200 {
            userServices = try! JSONDecoder().decode([UserService].self, from: data)
        }
        if response == 401 {
            invalidToken = true
        }
        result.response = response
    }
}

func setSubscriptions(token: String, services: [String: Bool]) {
    struct Service: Encodable {
        var id: String
        var is_subscribed: Bool
    }
    struct Result {
        var response: Int
        var done: Bool
    }
    var result = Result(response: 0, done: false)
    var payload = [Service]()
    for service in services.keys {
        payload.append(Service(id: service, is_subscribed: services[service] ?? false))
    }
    let headers = ["Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer "+token]
    requests(payload: payload, headers: headers, address: servicesEndpoint, method: "PATCH") { data, response in
        result.response = response
        if response == 401 {
            invalidToken = true
        }
    }
}

func getNotifications(token: String) {
    struct Result {
        var response: Int
        var done: Bool
    }
    var result = Result(response: 0, done: false)
    let payload = ""
    let headers = ["Accept": "application/json", "Authorization": "Bearer "+token]
    requests(payload: payload, headers: headers, address: notificationsEndpoint, method: "GET") { data, response in
        if response == 200 {
            userNotifications = try! JSONDecoder().decode([UserNotification].self, from: data)
        }
        if response == 401 {
            invalidToken = true
        }
        result.response = response
    }
}

func setNotifications(token: String, notifications: [Int: String]) {
    struct Notification: Encodable {
        var id: Int
        var status: String
    }
    struct Result {
        var response: Int
        var done: Bool
    }
    var result = Result(response: 0, done: false)
    var payload = [Notification]()
    for notification in notifications.keys {
        payload.append(Notification(id: notification, status: notifications[notification] ?? ""))
    }
    let headers = ["Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer "+token]
    requests(payload: payload, headers: headers, address: notificationsEndpoint, method: "PATCH") { data, response in
        result.response = response
        result.done = true
        if response == 401 {
            invalidToken = true
        }
    }
    
    var tmpNotifications = [UserNotification]()
    var include: Bool
    for var notification in userNotifications {
        include = true
        for id in notifications.keys {
            if notification.id == id {
                if notifications[id] == "deleted" {
                    include = false
                }
                if notifications[id] == "read" {
                    notification.is_read = true
                }
                if notifications[id] == "unread" {
                    notification.is_read = false
                }
            }
        }
        if include {
            tmpNotifications.append(notification)
        }
    }
    userNotifications = tmpNotifications
}
