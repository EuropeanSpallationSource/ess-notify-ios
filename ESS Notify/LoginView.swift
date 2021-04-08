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
    
    var body: some View {
        VStack {
            Spacer()
            labLogo.padding(.all, -25.0)
            Spacer()
            TextField("ESS Username", text: $username).padding().font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(bgColor).border(cellColor, width: 3).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            Spacer()
            SecureField("ESS Password", text: $password).padding().font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(bgColor).border(cellColor, width: 3).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
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
