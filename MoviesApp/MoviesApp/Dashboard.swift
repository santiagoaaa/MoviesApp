//
//  Dashboard.swift
//  MoviesApp
//
//  Created by santi on 02/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        TabView{
            Popular().tabItem{
                Image(systemName: "tv")
                Text("Popular Movies")
            }
            Search().tabItem{
                Image(systemName: "viewfinder.circle")
                Text("Search Movies")
            }
            Favorite().tabItem{
                Image(systemName: "heart.circle")
                Text("Favorites Movies")
            }
            Buy().tabItem{
                Image(systemName: "cart.fill")
                Text("Shopping")
            }
        }
    }
}
