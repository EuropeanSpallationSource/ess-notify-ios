//
//  NotificationsView.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-18.
//

import SwiftUI
import SwiftUIRefresh

struct NotificationsView: View {
    @Binding var screenSelector: String
    @State private var currentTime = Date()
    @State var noteList = userNotifications
    @State private var currentService = "any"
    @State private var isShowing = false
    @State private var readAll = false
    @State private var deleteAll = false
    @Environment(\.openURL) var openURL
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack {
            Image("ESS_Notify_logo_white")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                .padding(10)
                .background(cellColor)
            List{
                ForEach(0..<noteList.count, id: \.self) { i in
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.3)) {
                            noteList[i].is_read = true
                            setNotifications(token: userData.ESSToken, notifications: [noteList[i].id: "read"])
                            if noteList[i].url != "" {
                                openURL(URL(string: noteList[i].url) ?? URL(string: "http://www.blank.com/")!)
                            }
                        }
                    })
                    {
                        VStack{
                            HStack{
                                if !noteList[i].is_read {
                                    HStack {
                                        Image(systemName: "circlebadge.fill").foregroundColor(Color.red)
                                        Text("New").font(.footnote)
                                    }
                                }
                                Spacer()
                                Text(noteList[i].timestamp).font(.footnote)
                            }
                            Text(noteList[i].title)
                            Text(noteList[i].subtitle)
                        }
                    }.listRowBackground(Color(hex: getColorNotification(Index: noteList[i].id)))
                    if i < noteList.count-1 {
                        Divider().listRowBackground(bgColor).deleteDisabled(true)
                    }
                }.onDelete { indexSet in
                    for idx in indexSet {
                        setNotifications(token: userData.ESSToken, notifications: [noteList[idx].id: "deleted"])
                    }
                    withAnimation {
                        noteList.remove(atOffsets: indexSet)
                        
                    }
                }
            }.environment(\.defaultMinListRowHeight, 20)
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isShowing = false
                        screenSelector = "splash"
                        screenSelector = "notifications"
                }
            }
            Spacer()
            HStack {
                HStack {
                    Menu {
                        Picker(selection: $currentService, label: Text("")) {
                            ForEach(getNotificationsColors().sorted(by: <), id: \.key) { key, value in
                                Text(value).tag(key)
                            }
                            Text("All").tag("any")
                        }
                    } label: {
                        Label("", systemImage: "line.horizontal.3.decrease.circle.fill")
                            .padding()
                            .background(cellColor)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    }
                    Button(action: {
                            if noteList.count > 0 {
                                readAll = true
                            }})
                        {Image(systemName: "envelope.open.fill")}.frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(cellColor)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .alert(isPresented: $readAll) { () -> Alert in
                            let readAllButton = Alert.Button.default(Text("Mark as Read")) {
                                bulkAction(service_id: currentService, action: "read")
                                readAll = false
                                currentService = "any"
                            }
                            return Alert(title: Text("Read All"), message: Text("Do you want to mark the current messages as read?"), primaryButton: readAllButton, secondaryButton: Alert.Button.cancel(Text("Cancel")){ readAll = false })
                        }
                    Button(action: {
                            if noteList.count > 0 {
                                deleteAll = true
                            }})
                        {Image(systemName: "trash.fill")}.frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(cellColor)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .alert(isPresented: $deleteAll) { () -> Alert in
                            let deleteAllButton = Alert.Button.default(Text("Delete All")) {
                                bulkAction(service_id: currentService, action: "deleted")
                                deleteAll = false
                                currentService = "any"
                            }
                            return Alert(title: Text("Delete All"), message: Text("Do you want to delete all the current messages?"), primaryButton: deleteAllButton, secondaryButton: Alert.Button.cancel(Text("Cancel")){ deleteAll = false })
                        }
                }
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {self.screenSelector = "services"}
                    }){Image(systemName: "gearshape.2.fill")
                        }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(cellColor)
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            }
        }
        .onAppear() {
            UITableView.appearance().backgroundColor = .clear
            registerForPushNotifications()
            getNotifications(token: userData.ESSToken)
            getServices(token: userData.ESSToken)
        }
        .onReceive(timer) { newTime in
            if newTime.timeIntervalSince(currentTime) > 2 {
                getNotifications(token: userData.ESSToken)
            }
            noteList = [UserNotification]()
            if userNotifications.count == 0 {
                currentService = "any"
            }
            UIApplication.shared.applicationIconBadgeNumber = 0
            for i in 0..<userNotifications.count {
                if !userNotifications[i].is_read {
                    UIApplication.shared.applicationIconBadgeNumber += 1
                }
                if userNotifications[i].service_id == currentService || currentService == "any" {
                    noteList.append(userNotifications[i])
                }
            }
            if invalidToken {
                userData.ESSToken = ""
                self.screenSelector = "login"
            }
            currentTime = newTime
        }
    }
}
