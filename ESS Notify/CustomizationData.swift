//
//  CustomizationData.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2021-04-07.
//

import SwiftUI

// Default values
var baseServer = "https://notify.esss.lu.se"
var loginEndpoint = baseServer+"/api/v2/login"
var apnEndpoint = baseServer+"/api/v2/users/user/device-token"
var profileEndpoint = baseServer+"/api/v2/users/user/profile"
var servicesEndpoint = baseServer+"/api/v2/users/user/services"
var notificationsEndpoint = baseServer+"/api/v2/users/user/notifications"

var labLogo = "ess-logo"
var bgColor = Color(red: 0.0703125, green: 0.1328125,blue: 0.171875, opacity: 1.0)
var cellColor = Color(red: 0.1171875, green: 0.2265625,blue: 0.28125, opacity: 1.0)
var searchColor = Color(red: 0.8203125, green: 0.8203125, blue: 0.8203125, opacity: 1.0)

let credits = """
iOS Design by Emanuele Laface
Android Design by Georg Weiss
Back-end by Benjamin Bertrand
Graphics by Dirk Nordt
Infrastructure by Alessio Curri and Anders Harrisson
IT Support by Maj-Britt González Engberg and Mikael Johansson
"""

let copyright = """
Copyright © 2021
European Spallation Source ERIC
All rights reserved.
"""

func applyCustomization(laboratory: String) {
    if laboratory == "" || laboratory == "ess" {
        baseServer = "https://notify.esss.lu.se"
        labLogo = "ess-logo"
        bgColor = Color(red: 0.0703125, green: 0.1328125,blue: 0.171875, opacity: 1.0)
        cellColor = Color(red: 0.1171875, green: 0.2265625,blue: 0.28125, opacity: 1.0)
        searchColor = Color(red: 0.8203125, green: 0.8203125, blue: 0.8203125, opacity: 1.0)
    }
    if laboratory == "maxiv" {
        baseServer = "https://notify.maxiv.lu.se"
        labLogo = "maxiv-logo"
        bgColor = Color(red: 0.2431372, green: 0.2431372, blue: 0.2431372, opacity: 1.0)
        cellColor = Color(red: 0.41176, green: 0.6, blue: 00, opacity: 1.0)
        searchColor = Color(red: 0.9176, green: 0.9176, blue: 0.9176, opacity: 1.0)
    }
    loginEndpoint = baseServer+"/api/v2/login"
    apnEndpoint = baseServer+"/api/v2/users/user/device-token"
    profileEndpoint = baseServer+"/api/v2/users/user/profile"
    servicesEndpoint = baseServer+"/api/v2/users/user/services"
    notificationsEndpoint = baseServer+"/api/v2/users/user/notifications"
}
