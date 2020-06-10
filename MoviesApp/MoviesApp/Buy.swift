//
//  Buy.swift
//  MoviesApp
//
//  Created by santi on 09/06/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI
import Network

struct Buy: View {
    @State private var listBuyMovie = [MovieModel]()
    //Con esto propagamos la conexion a la BD local
    @Environment(\.managedObjectContext) var conexionBD
    @State private var bandera : Bool = true

    
    @FetchRequest(
           entity: BuyTBL.entity(),
           sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
       ) var buyDB:FetchedResults<BuyTBL>
       
    var body: some View {
        NavigationView{
            List {
                ForEach (listBuyMovie){ movie in
                 ListItem (movie:movie, bandera: self.bandera)
                }
            }
            .onAppear(perform: loadMovies)
            .navigationBarTitle("My Movies")
        }
    }
    
    func loadMovies(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            path in
            self.bandera=false
            if path.status == .satisfied{
                print("Online");
                self.bandera=true
            }//if
            
            //Con esto cargamos el la lista con los datos de la BD local
            self.listBuyMovie = [MovieModel]()
            for favorite in self.buyDB{
                let objFavorite = MovieModel(popularity: 0.0, vote_count: 0, video: false, poster_path: favorite.poster_path, id: favorite.id, adult: false, backdrop_path: favorite.backdrop_path, original_language: "", original_title: "", title: favorite.title, vote_average: 0.0, overview: favorite.overview, release_date: "")
                self.listBuyMovie.append(objFavorite)
            }//for
            
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
