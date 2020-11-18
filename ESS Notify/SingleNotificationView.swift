//
//  SingleNotificationView.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-18.
//

import SwiftUI
import WebKit

struct SingleNotificationView: View {
    @Binding var screenSelector: String
    @Binding var noteURL: String

    var body: some View {
        VStack {
            Button(action: {withAnimation(.easeOut(duration: 0.3)) {self.screenSelector = "notifications" }}){
                HStack{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                    Text("Back")
                    Spacer()
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(15)
            .background(cellColor)
            .foregroundColor(Color.white)
            Spacer()
            if noteURL == "" {
                Image("ess-logo").opacity(0.5)
                Spacer()
                Text("No URL available in the message")
                Spacer()
            }
            else {
                WebView(request: URLRequest(url: URL(string: noteURL) ?? URL(string: "http://www.blank.com/")!))
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context){
        uiView.load(request)
    }
}
