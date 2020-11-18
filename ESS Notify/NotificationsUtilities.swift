//
//  NotificationsUtilities.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-18.
//

import Foundation

func getColorNotification(Index: Int) -> String {
    for notification in userNotifications {
        if notification.id == Index {
            for service in userServices {
                if service.id == notification.service_id {
                    return "#"+service.color
                }
            }
        }
    }
    
    return "#000000"
}

func getNotificationsColors() -> [String:String] {
    var colors = [String: String]()
    for notification in userNotifications {
        for service in userServices {
            if notification.service_id == service.id {
                colors[service.id]=service.category
            }
        }
    }
    return colors
}

func bulkAction(service_id: String, action: String) {
    var todo = [Int: String]()
    for notification in userNotifications {
        if notification.service_id == service_id || service_id == "any" {
            todo[notification.id] = action
        }
    }
    setNotifications(token: userData.ESSToken, notifications: todo)
}
