//
//  Favorite.swift
//  MoviesApp
//
//  Created by santi on 02/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI
import Network
struct Favorite: View {
    @State private var listFavorites = [MovieModel]()
    //Con esto propagamos la conexion a la BD local
    @Environment(\.managedObjectContext) var conexionBD
    @State private var bandera : Bool = true

    
    @FetchRequest(
           entity: FavoritesTBL.entity(),
           sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
       ) var favoritesDB:FetchedResults<FavoritesTBL>
       
    var body: some View {
        NavigationView{
            List {
                ForEach (listFavorites){ movie in
                 ListItem (movie:movie, bandera: self.bandera)
                }.onDelete(perform: delFavorites)
            }
            .onAppear(perform: loadFavorites)
            .navigationBarTitle("Favorites Movies")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func delFavorites(at offsets: IndexSet){
        var id : Int32 = 0
        for index in offsets{
            id = self.listFavorites[index].id
            //Construimos url
            let endPointDelFav : String = "https://api.themoviedb.org/3/list/142660/remove_item?api_key=418f34125f6649eb790ee7a0777c0cbc&session_id=4d652b4ce63509e6d74fbac914e497056453d349"
            guard let urlDelFav = URL(string: endPointDelFav) else{
                print("Error: cannot crete url")
                return
            }
            
            //construimos peticion
            var urlRequest = URLRequest(url: urlDelFav)
            urlRequest.httpMethod = "POST"
            let cadJSON : [String:Any] = ["media_id":id]
            let objJSON : Data
            do{
                objJSON = try JSONSerialization.data(withJSONObject: cadJSON, options: [])
                urlRequest.httpBody = objJSON
                urlRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
            }catch{
                print ("Cannot creare JSON")
            }
            
            //Session
            let session = URLSession.shared
            session.dataTask(with: urlRequest){
                (data,_,_) in
                do{
                    let response = try JSONDecoder().decode(PostModel.self, from: data!)
                    DispatchQueue.main.async {
                        self.loadFavorites()
                        
                        
                        
                    }
                }catch{print ("Error delete favorite")}
            }.resume()
        }
    }
    
    func loadFavorites(){
        let monitor = NWPathMonitor()
             monitor.pathUpdateHandler = {
                 path in
                 if path.status == .satisfied{
                    print("Online");
                    self.bandera=true
                    let session = URLSession(configuration: .default)
                    session.dataTask(with: URL(string: "https://api.themoviedb.org/3/list/142660?api_key=418f34125f6649eb790ee7a0777c0cbc&language=en-US")!){
                        (data,_,_) in //esto es una especie de foreach, data tiene todo
                        
                        do{
                            let favorites = try JSONDecoder().decode(FavoritesModel.self, from: data!)
                            DispatchQueue.main.async {
                                
                                self.listFavorites = favorites.items
                                self.deleteAllFavorite()
                                for movie in favorites.items{
                                let objFavoritesTBL = FavoritesTBL(context: self.conexionBD)
                                objFavoritesTBL.id = movie.id
                                objFavoritesTBL.title = movie.title
                                objFavoritesTBL.overview = movie.overview
                                objFavoritesTBL.backdrop_path = movie.backdrop_path
                                objFavoritesTBL.poster_path = movie.poster_path
                                }
                                try? self.conexionBD.save()    
                                
                                
                                
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                    }.resume()
                 }else{
                    print("Sin internet");
                    self.bandera=false
                   self.listFavorites = [MovieModel]()
                    for favorite in self.favoritesDB{
                        let objFavorite = MovieModel(popularity: 0.0, vote_count: 0, video: false, poster_path: favorite.poster_path, id: favorite.id, adult: false, backdrop_path: favorite.backdrop_path, original_language: "", original_title: "", title: favorite.title, vote_average: 0.0, overview: favorite.overview!, release_date: "")
                        self.listFavorites.append(objFavorite)
                    }
                }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func deleteAllFavorite(){
        
        for movieTBL in self.favoritesDB{
            self.conexionBD.delete(movieTBL)
        }
        
    }
    
}
