//
//  WebView.swift
//  Dining App
//
//  Created by Udit Garg on 9/20/21.
//

import Foundation
import UIKit
import SwiftUI
import WebKit

// WebView with a back button
struct WebView: View {
    
    var url: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {

        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image("exitIcon")
                .resizable()
                .frame(width: 15, height: 15)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .padding(.leading, 20)
        
        MealWebView(url: url)
            .navigationTitle(url)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100, alignment: .center)
        
    }
}

//Takes URL and loads webview
struct MealWebView: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let wkWebview = WKWebView()
        wkWebview.load(request)
        return wkWebview
    }
        
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }

}
