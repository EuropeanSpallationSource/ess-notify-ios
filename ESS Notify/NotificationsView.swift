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
    @State private var detailedView: UserNotification? = nil
    @State private var shareContent = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack {
            Image("splash-logo")
                .resizable()
                .scaleEffect(x: 0.17, y: 1.8)
                .frame(minHeight: 0, maxHeight: 20)
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                .padding(.top, 8)
            List{
                ForEach(0..<noteList.count, id: \.self) { i in
                    let serviceColor = Color(hex: getColorNotification(Index: noteList[i].id))
                    HStack {
                        Text(getServiceCategory(Index: noteList[i].id))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 20))
                            .background(serviceColor)
                        Spacer()
                    }.listRowBackground(serviceColor)
                     .deleteDisabled(true)
                    Button(action: {
                        if !noteList[i].is_read {
                            noteList[i].is_read = true
                            setNotifications(token: userData.ESSToken, notifications: [noteList[i].id: "read"])
                        }
                        detailedView = noteList[i]
                    }){
                        VStack{
                            HStack(alignment: .top) {
                                if !noteList[i].is_read {
                                    Button(action: {
                                        noteList[i].is_read = true
                                        setNotifications(token: userData.ESSToken, notifications: [noteList[i].id: "read"])
                                    }){
                                        Image(systemName: "circlebadge.fill").foregroundColor(Color.red)
                                    }.buttonStyle(PlainButtonStyle())
                                }
                                Text(.init(noteList[i].title))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(Font.system(size: 18).weight(.semibold))
                                    .foregroundColor(.white)
                            }
                            HStack {
                                Spacer()
                                Text(convertTimeFormat(timestamp: noteList[i].timestamp))
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                            Text(.init(noteList[i].subtitle))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    .listRowBackground(cellColor)
                    if i < noteList.count-1 {
                        Divider()
                            .listRowBackground(bgColor)
                            .deleteDisabled(true)
                    }
                }
                .onDelete { indexSet in
                    for idx in indexSet {
                        setNotifications(token: userData.ESSToken, notifications: [noteList[idx].id: "deleted"])
                    }
                    withAnimation {
                        noteList.remove(atOffsets: indexSet)
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 20)
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isShowing = false
                    screenSelector = "splash"
                    screenSelector = "notifications"
                }
            }
            .sheet(item: $detailedView, content: { detailedView in
                VStack{
                    HStack{
                        Spacer()
                        Text(getServiceCategory(Index: detailedView.id))
                            .font(.system(size: 20))
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 30)
                        Spacer()
                        Button(action: {self.shareContent = true})
                        {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 0, maxWidth: 20)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .padding(.trailing, 10)
                        }.sheet(isPresented: $shareContent) {
                            let message = """
                            \(convertTimeFormat(timestamp: detailedView.timestamp))
                            Notify Service: \(getServiceCategory(Index: detailedView.id))
                            Title: \(detailedView.title)
                            - - - - -
                            \(detailedView.subtitle)
                            - - - - -
                            \(detailedView.url)
                            """
                            ShareSheet(activityItems: [message])
                         }
                    }.frame(minWidth:0, maxWidth: .infinity, minHeight:0, maxHeight: 40, alignment: .topLeading)
                    .background(Color(hex: getColorNotification(Index: detailedView.id)))
                    Text(.init(detailedView.title))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 330, alignment: .center)
                        .font(Font.system(size: 18).weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    Divider()
                    Text(convertTimeFormat(timestamp: detailedView.timestamp))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                    List {
                        VStack {
                            Text(.init(detailedView.subtitle))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            if detailedView.url != "" {
                                Divider()
                                Button(action: {
                                    UIApplication.shared.open(URL(string: detailedView.url) ?? URL(string: "http://www.blank.com/")!)
                                }){
                                    Text(.init(detailedView.url))
                                        .font(.system(size: 16))
                                }.buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 16))
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .listRowBackground(bgColor)
                    }
                }.background(bgColor)
            })
            Spacer()
            HStack {
                Menu {
                    Picker(selection: $currentService, label: Text("")) {
                        ForEach(getNotificationsColors().sorted(by: <), id: \.key) { key, value in
                            Text(value).tag(key)
                        }
                        Text("All").tag("any")
                    }
                } label: {
                    Image("icon-filter")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: 30)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                }.padding(.horizontal)
                Spacer()
                Button(action: {
                        if noteList.count > 0 {
                            readAll = true
                        }})
                    {Image("icon-unread")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: 30)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .alert(isPresented: $readAll) { () -> Alert in
                        let readAllButton = Alert.Button.default(Text("Mark as Read")) {
                            bulkAction(service_id: currentService, action: "read")
                            readAll = false
                            currentService = "any"
                        }
                        return Alert(title: Text("Read All"), message: Text("Do you want to mark the current messages as read?"), primaryButton: readAllButton, secondaryButton: Alert.Button.cancel(Text("Cancel")){ readAll = false })
                    }.padding(.horizontal)
                Spacer()
                Button(action: {
                        if noteList.count > 0 {
                            deleteAll = true
                        }})
                    {Image("icon-trash")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: 30)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .alert(isPresented: $deleteAll) { () -> Alert in
                        let deleteAllButton = Alert.Button.default(Text("Delete All")) {
                            bulkAction(service_id: currentService, action: "deleted")
                            deleteAll = false
                            currentService = "any"
                        }
                        return Alert(title: Text("Delete All"), message: Text("Do you want to delete all the current messages?"), primaryButton: deleteAllButton, secondaryButton: Alert.Button.cancel(Text("Cancel")){ deleteAll = false })
                    }.padding(.horizontal)
                Spacer()
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {self.screenSelector = "services"}
                    }){Image("icon-settings")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: 30)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        }.padding(.horizontal)
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                Spacer()
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {self.screenSelector = "info"}
                    }){Image("icon-information")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: 30)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                }.foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
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
