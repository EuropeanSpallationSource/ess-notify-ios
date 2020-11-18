//
//  ServicesView.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-18.
//

import SwiftUI

struct ServicesView: View {
    @Binding var screenSelector: String
    @State var serviceList = userServices
    @State private var selection = ""
    
    var body: some View {
        VStack {
            Text("Available Notification Services")
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(15)
            .background(cellColor)
            CustomTextField(placeholder: Text("Search...").foregroundColor(.gray),
                        text: $selection)
                .padding(7)
                .background(searchColor)
                .foregroundColor(.black)
                .cornerRadius(8)
                .autocapitalization(.none)
            List{
                ForEach(0..<serviceList.count, id: \.self) { i in
                    if serviceList[i].category.lowercased().contains(selection.lowercased()) || selection == ""{
                    Button(action: {
                        serviceList[i].is_subscribed.toggle()
                        userServices[i].is_subscribed.toggle()
                        setSubscriptions(token: userData.ESSToken, services: [userServices[i].id: userServices[i].is_subscribed])
                    })
                    {
                        HStack {
                            if serviceList[i].is_subscribed {
                                Image(systemName: "checkmark.seal.fill")
                            }
                            else {
                                Image(systemName: "square")
                            }
                            Spacer()
                            Text(serviceList[i].category)
                            Spacer()
                        }
                    }.listRowBackground(Color(hex: "#"+serviceList[i].color))
                    }
                }
            }
            Spacer()
            Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {self.screenSelector = "notifications" }}){
                HStack{
                    Image(systemName: "text.badge.checkmark")
                    Text("Save")
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(15)
            .background(cellColor)
            .foregroundColor(Color.white)
        }.onAppear() {
            getServices(token: userData.ESSToken)
            serviceList = userServices
        }
    }
}
