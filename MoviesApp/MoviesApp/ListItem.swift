//
//  ListItem.swift
//  MoviesApp
//
//  Created by santi on 04/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI



struct ListItem: View {
    var movie : MovieModel
    var bandera : Bool
    
    var body: some View {
        NavigationLink (destination: DetailMovie(movie: movie)){
            VStack{
                if (movie.backdrop_path != nil && bandera){
                    ImageView(withURL: "https://image.tmdb.org/t/p/w500\(movie.backdrop_path!)", width: 350, height: 200, type: 1)
                    
                }else{
                    Image("notimage").resizable()
                    .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/5)
                    	
                }
                HStack{
                    Image(systemName: "film.fill").font(.headline)
                    Text(movie.title)
                }
                
            }
        }
        
        
    }
}

/*
struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem()
    }
}
*/
