//
//  ContentView.swift
//  MoviesApp
//
//  Created by santi on 02/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI
import Network

struct Popular: View {
    //let listMovies : [Movie] = [Movie(nameMovie: "End Game", overview: "lorem...", image:"vengadores"), Movie(nameMovie: "The pianist", overview: "lorem...", image:"pianist")]
    
    //Con esto propagamos la conexion a la BD local
    @Environment(\.managedObjectContext) var conexionBD
    @State private var listMovies = [MovieModel]()
    
    @State private var bandera : Bool = true
    //Consulta a la tabla popularTBL
    @FetchRequest(
        entity: PopularTBL.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var popularDB:FetchedResults<PopularTBL>
    
    var body: some View {
        NavigationView{
            List(listMovies){ movie in
                //Text(movie.title)
                ListItem (movie:movie, bandera: self.bandera)
                
                /*NavigationLink(destination: DetailMovie()){
                    VStack{
                        ListItem(movie: movie)//hace una instacia de ListItem y le envia un objeto de tipo MovieModel
                       /* Image(movie.poster_path)
                        .resizable()
                            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 5)*/
                            //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        //Text(movie.title).font(.title).bold()
                    }
                    
                }
 */
            }.navigationBarTitle("Popular Movies")//list
            .onAppear(perform: loadPopular)//esto llena el objeto movie
        }//navview
    }
    
    func loadPopular(){
        let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied{
                    print("Online app")
                    self.bandera = true
                    //aqui va lo de la api
                    let session = URLSession(configuration: .default)
                    session.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=418f34125f6649eb790ee7a0777c0cbc&language=en-US&page=1")!)//el ! obliga a que no sea nil, si es ? seria opcional
                    { (data,_,_) in
                        do{
                            let movies = try JSONDecoder().decode(PopularModel.self,from: data!)
                            DispatchQueue.main.async {
                            self.listMovies = movies.results
                                self.deleteAllPopular()
                                for movie in movies.results{
                                    let objPopularTBL = PopularTBL (context: self.conexionBD)
                                    objPopularTBL.id = movie.id
                                    objPopularTBL.title = movie.title
                                    objPopularTBL.poster_path = movie.poster_path
                                    objPopularTBL.backdrop_path = movie.backdrop_path
                                    objPopularTBL.overview = movie.overview
                                    objPopularTBL.adult = movie.adult
                                    objPopularTBL.original_languaje = movie.original_language
                                    objPopularTBL.original_title = movie.original_title
                                    objPopularTBL.popularity = movie.popularity
                                    objPopularTBL.release_date = movie.release_date
                                    objPopularTBL.video = movie.video
                                    objPopularTBL.vote_average = movie.vote_average
                                    objPopularTBL.vote_count = movie.vote_count
                                }
                                try? self.conexionBD.save()
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                    }.resume()
                    
                }else{
                    //peticion a la BD
                    print("Offline!!!!! :D")
                    self.bandera=false
                    self.listMovies = [MovieModel]()
                    for popular in self.popularDB{
                        let objPopular = MovieModel(popularity: popular.popularity, vote_count: popular.vote_count, video: popular.video, poster_path: popular.poster_path, id: popular.id, adult: popular.adult, backdrop_path: popular.backdrop_path, original_language: popular.original_languaje, original_title: popular.original_title, title: popular.title, vote_average: popular.vote_average, overview: popular.overview!, release_date: popular.release_date)
                        self.listMovies.append(objPopular)
                    }
                    
                }
            }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        
        
    }
    func deleteAllPopular(){
        
        for movieTBL in self.popularDB{
            self.conexionBD.delete(movieTBL)
        }
        
    }
}//popular view




