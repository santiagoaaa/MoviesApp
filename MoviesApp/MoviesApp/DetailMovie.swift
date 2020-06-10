//
//  DetailMovie.swift
//  MoviesApp
//
//  Created by santi on 02/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI
import Network

struct DetailMovie: View {
    
    var movie : MovieModel
    @State var videosMovie = [VideoModel]()
    @State var castMovie = [CastModel]()
    @State var responsePost : PostModel?
    @State var showAlert = false
    @State var statusBuy = false
    
    @State private var listBuyMovie = [MovieModel]()
    
    @FetchRequest(
             entity: BuyTBL.entity(),
             sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
         ) var buyDB:FetchedResults<BuyTBL>
         
    //Con esto propagamos la conexion a la BD local
    @Environment(\.managedObjectContext) var conexionBD
    
    var body: some View {
        VStack{
            
            if(videosMovie.count > 0){
                VideoPlayer(url: "https://www.youtube.com/embed/\(videosMovie[0].key)")
                .frame(height: UIScreen.main.bounds.height/3)
                
            }else{
                Text("Video no disponible")
            }
            
           
            Form{
                Section(header:TitleHeader(title: movie.title)){
                    Text(movie.overview).padding()
                }
                
                
                
                Section(header: buyHeader() ){
                    
                    if(statusBuy){
                        Text("Done")
                        
                    }else{
                        Button(action: {
                            print("Comprar pelicula")
                            self.buyMovie()
                            self.getDetailMovie()
                        }){
                            HStack{
                                Image(systemName: "cart.badge.plus").font(.title)
                                Text("Buy").fontWeight(.medium).font(.title)
                                
                            }
                            .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                            .cornerRadius(40)
                        }
                        
                    }
                    
                    
                    
                }
                Section(header: CastHeader()){
                    ScrollView(.horizontal){
                        HStack (alignment: .center){
                            ForEach(castMovie){ cast in
                                VStack(alignment: .center, spacing: 10){
                                    if (cast.profile_path != nil){
                                       ImageView(withURL: "https://image.tmdb.org/t/p/w500\(cast.profile_path!)", width: 70, height: 70, type: 2)
                                    }else{
                                        Image("notimage").resizable()
                                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/5)
                                    }
                                    Text(cast.name).font(.footnote)
                                }

                            }
                        }.frame(height: 200)
                        
                    }
                }
                
            }
        }.onAppear(perform: getDetailMovie)
            .navigationBarTitle("Detail Movie", displayMode: .large)
            .navigationBarItems(trailing: Button(action:{self.addFavorites()}){
                Image(systemName: "heart.circle")
                
            })
            .alert(isPresented: $showAlert){
                Alert(title:Text( "Important"), message: Text(responsePost!.status_message), dismissButton: .default(Text ("Close")))
        }
        
    }
    
    func buyMovie(){
        let objBuyMovie = BuyTBL(context: self.conexionBD)
        objBuyMovie.id = self.movie.id
        objBuyMovie.title = self.movie.title
        objBuyMovie.overview = self.movie.overview
        objBuyMovie.backdrop_path = self.movie.backdrop_path
        objBuyMovie.poster_path = self.movie.poster_path
        try? self.conexionBD.save()
    }
    
    func compare(){
        print("id recibido")
        print(movie.id)
        print("id BD")
        
        print(listBuyMovie.count)
        
        for mov in listBuyMovie {
            if (movie.id == mov.id){
                print("Pelicula comprada")
                print(mov.id)
                statusBuy = true;
            }
        }
        
    }
    
    func loadMovies(){
      
            //Con esto cargamos el lista con los datos de la BD local
            self.listBuyMovie = [MovieModel]()
            for movieBuy in self.buyDB{
                let objMovieBuy = MovieModel(popularity: 0.0, vote_count: 0, video: false, poster_path: movieBuy.poster_path, id: movieBuy.id, adult: false, backdrop_path: movieBuy.backdrop_path, original_language: "", original_title: "", title: movieBuy.title, vote_average: 0.0, overview: movieBuy.overview, release_date: "")
                self.listBuyMovie.append(objMovieBuy)
            }//for
        compare()
    }
    
    func addFavorites(){
        let endPointAddFavorite: String = "https://api.themoviedb.org/3/list/142660/add_item?api_key=418f34125f6649eb790ee7a0777c0cbc&session_id=4d652b4ce63509e6d74fbac914e497056453d349"
        guard let urlAddFavorite = URL (string:endPointAddFavorite) else{
            print("Error: cannot create URL")
            return
        }
        

        
        var urlRequest = URLRequest(url: urlAddFavorite)
             urlRequest.httpMethod = "POST"
             
             let cadenaJSON : [String:Any] = ["media_id":movie.id]
             let objJSON : Data
             do{
                 objJSON = try JSONSerialization.data(withJSONObject: cadenaJSON, options: [])
                 urlRequest.httpBody = objJSON
                 urlRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
             }catch{
                 print("Error: cannont creare URL")
                 return
             }


        
        let session = URLSession.shared
        session.dataTask(with: urlRequest){
            (data,_,_) in
            do{
                let response = try JSONDecoder().decode(PostModel.self, from: data!)
                self.responsePost = response
                self.showAlert = true
                /*
                let objFavoritesTBL = FavoritesTBL(context: self.conexionBD)
                objFavoritesTBL.id = self.movie.id
                objFavoritesTBL.title = self.movie.title
                objFavoritesTBL.overview = self.movie.overview
                objFavoritesTBL.backdrop_path = self.movie.backdrop_path
                objFavoritesTBL.poster_path = self.movie.poster_path
                try? self.conexionBD.save()	
                */
                
                
            }catch{
                print("Error")
            }
        }.resume()
    }
    
    func getDetailMovie(){
        loadMovies()
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                print("Online");
                let session = URLSession(configuration: .default)
                //Info de pelicula con video
                session.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/\(self.movie.id)/videos?api_key=418f34125f6649eb790ee7a0777c0cbc")!)
                { (data,_,_) in
                    do{
                         let videos = try JSONDecoder().decode(VideoList.self, from:data!)
                        DispatchQueue.main.async{
                            self.videosMovie=videos.results
                        }
                     }catch{
                         print(error.localizedDescription)
                     }
                    
                }.resume()
                
                //Info de casting de la pelicula
                session.dataTask(with: URL(string:"https://api.themoviedb.org/3/movie/\(self.movie.id)/credits?api_key=418f34125f6649eb790ee7a0777c0cbc")!){ (data,_,_) in
                    do{
                        let casting = try JSONDecoder().decode(CastList.self, from:data!)
                       DispatchQueue.main.async{
                           self.castMovie = casting.cast
                       }
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                }.resume()
            }else{
                print("Offline")
                
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        
        
 
    }
}

struct TitleHeader: View {
    var title : String
    var body : some View{
        HStack{
            Image(systemName :"film.fill")
            Text(self.title).font(.headline)
        }
    }
}

struct CastHeader:View {
    var body : some View{
        HStack{
            Image(systemName :"person.3.fill")
            Text("Casting").font(.headline)
        }
    }
}

struct buyHeader:View{
    var body: some View{
        HStack{
            Image(systemName :"cart.fill")
            
            Text("Buy").font(.headline)
        }
    }
}


