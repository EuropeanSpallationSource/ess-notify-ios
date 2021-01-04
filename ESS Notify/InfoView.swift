//
//  InfoView.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-12-23.
//

import SwiftUI

struct InfoView: View {
    @Binding var screenSelector: String
    
    var versionLabelText: String {
            guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                  let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            else { return "" }
            return "version: "+version + " build: " + build
        }
    var body: some View {
        VStack {
            Image("ESS_Notify_logo_white")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                .padding(10)
                .background(cellColor)
            Spacer()
            Image("ess-logo").padding(.all, -25.0)
            Spacer()
            Text("ESS Notify "+versionLabelText).frame(maxWidth: .infinity, alignment: .leading).padding()
            Spacer()
            Text("""
iOS Design by Emanuele Laface
Graphics by Dirk Nordt
IT Support by Maj-Britt González Engberg and Mikael Johansson
Back-end by Benjamin Bertrand
""").frame(maxWidth: .infinity, alignment: .leading).padding()

            Spacer()
            Text("""
Copyright © 2020
European Spallation Source ERIC
All rights reserved.
""").frame(maxWidth: .infinity, alignment: .leading).padding()
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    self.screenSelector = "notifications"
                }
            })
            {
                HStack{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                    Text("Back")
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(cellColor)
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
        }
    }
}
