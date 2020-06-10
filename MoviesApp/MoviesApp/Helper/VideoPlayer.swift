//
//  VideoPlayer.swift
//  MoviesApp
//
//  Created by santi on 04/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct VideoPlayer: UIViewRepresentable {

var url : String

func makeUIView(context: Context) -> WKWebView {
    guard let url = URL(string: self.url) else {
        return WKWebView()
    }

    let request = URLRequest(url: url)
    let wkWebview = WKWebView()
    wkWebview.load(request)
    return wkWebview
}

func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<VideoPlayer>) {
}


}
