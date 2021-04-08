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
            appLogo
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                .padding(10)
            Spacer()
            Image("ess-logo").padding(.all, -25.0)
            Spacer()
            Text("ESS Notify "+versionLabelText).frame(maxWidth: .infinity, alignment: .leading).padding()
            Spacer()
            Text(credits).frame(maxWidth: .infinity, alignment: .leading).padding()

            Spacer()
            Text(copyright).frame(maxWidth: .infinity, alignment: .leading).padding()
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    self.screenSelector = "notifications"
                }
            })
            {
                HStack{
                    Image("icon-back")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: 30)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    Text("Back")
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
        }
    }
}
