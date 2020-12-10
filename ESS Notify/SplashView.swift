//
//  SplashView.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-10-23.
//

import SwiftUI

struct SplashView: View {
    @State private var screenSelector: String = "splash"
    @ObservedObject var notificationCenter: NotificationCenter
    
    var body: some View {
        bgColor.overlay(
            VStack {
                switch self.screenSelector {
                case "login":
                    LoginView(screenSelector: $screenSelector)
                case "notifications":
                    NotificationsView(screenSelector: $screenSelector)
                case "services":
                    ServicesView(screenSelector: $screenSelector)
                default:
                    Image("ess-logo")
                }
            }
        ).onAppear() {
            self.screenSelector = checkCredentials()
            }
        }
    }
