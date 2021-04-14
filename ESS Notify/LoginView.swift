//
//  LoginView.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-18.
//

import SwiftUI

struct LoginView: View {
    @Binding var screenSelector: String
    @State private var username = ""
    @State private var password = ""
    @State private var errorLogin: Bool = false
    @State private var buttonLogin = "Login"
    @State private var labSwitch = false
    @State private var colorESSLabel = Color.white
    @State private var colorMAXIVLabel = Color(red: 0.33, green: 0.37, blue: 0.40, opacity: 1.0)

    var body: some View {
        VStack {
            Image(labLogo)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 150)
                .padding(10)
            Spacer()
            HStack {
                Spacer()
                Text("ESS").font(.title2).padding().foregroundColor(colorESSLabel)
                Toggle("",isOn: $labSwitch)
                    .padding()
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.21, green: 0.24,blue: 0.27, opacity: 1.0)))
                    .onChange(of: labSwitch) { value in
                            if value {
                                colorMAXIVLabel = Color.white
                                colorESSLabel = Color(red: 0.33, green: 0.37, blue: 0.40, opacity: 1.0)
                                userData.server = "maxiv"
                            }
                            else {
                                colorESSLabel = Color.white
                                colorMAXIVLabel = Color(red: 0.33, green: 0.37, blue: 0.40, opacity: 1.0)
                                userData.server = "ess"
                            }
                            saveCredentials()
                            applyCustomization(laboratory: userData.server)
                            screenSelector = "splash"
                            screenSelector = "login"
                        }
                    .onAppear() {
                        if userData.server == "" || userData.server == "ess" {
                            labSwitch = false
                        }
                        if userData.server == "maxiv" {
                            labSwitch = true
                        }
                    }
                Text("MAX IV").font(.title2).padding().foregroundColor(colorMAXIVLabel)
                Spacer()
            }
            Spacer()
            TextField("Username", text: $username).padding().font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(bgColor).border(cellColor, width: 3).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            Spacer()
            SecureField("Password", text: $password).padding().font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(bgColor).border(cellColor, width: 3).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            Spacer()
            Button(action: {
                buttonLogin = "Logging in..."
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if checkLogin(username: username, password: password) {
                        invalidToken = false
                        self.screenSelector = "notifications"
                    }
                    else {
                        buttonLogin = "Login"
                        self.errorLogin = true
                        self.screenSelector = "login"
                    }
                }
            })
            {
                Text(buttonLogin).frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding()
            .background(cellColor)
            .cornerRadius(/*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            .alert(isPresented: $errorLogin) {
                if connectionError {
                    return Alert(title: Text("Network Error"), message: Text("It was not possible to contact the Notify server"), dismissButton: .default(Text("Try Again")))
                }
                else {
                    return Alert(title: Text("Error"), message: Text("Wrong Username or Password"), dismissButton: .default(Text("Try Again")))
                }
            }
            Spacer()
        }
    }
}
