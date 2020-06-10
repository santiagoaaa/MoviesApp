//
//  Search.swift
//  MoviesApp
//
//  Created by santi on 02/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI
import Network

struct Search: View {
    @State private var searchMovie : String = ""
    @State private var showCancelButton : Bool = false
    @State private var listMovies = [MovieModel]()
    @State private var bandera : Bool = true
    
    var body: some View {
        NavigationView{
            VStack{
                
                HStack{
                    Image(systemName: "magnifyingglass.circle")
                    TextField("search",text: $searchMovie,
                              onEditingChanged: {
                                isEditing in
                                self.showCancelButton = true
                    },
                    onCommit: {
                        print("on commit")
                        self.findMovies()
                        
                        
                                
                    }).foregroundColor(.primary)
                    Button(action:{}){
                        Image(systemName: "xmark.circle.fill").opacity(searchMovie == "" ? 0 : 1)
                    }
                    if showCancelButton {
                        Button("Cancel"){
                            self.showCancelButton=false
                        }
                    }
                }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                
                
                if(bandera){
                    List(listMovies){movie in
                         ListItem (movie:movie, bandera: self.bandera)
                    }
                }else{
                    Text("No internet access")
                }
                
            }.padding(.horizontal)
            .navigationBarHidden(showCancelButton)
        }
        
        
    }
    
    func findMovies(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                print("Online search")
                self.bandera = true
                let session = URLSession(configuration: .default)
                       session.dataTask(with: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=418f34125f6649eb790ee7a0777c0cbc&query=\(self.searchMovie)&page=1&include_adult=false")!){
                           (data,_,_) in
                           do{
                               let movies = try JSONDecoder().decode(PopularModel.self, from: data!)
                               DispatchQueue.main.sync {
                                   self.listMovies = movies.results
                                   
                              
                               }
                           }catch{error.localizedDescription}
                       }.resume()
            }else{
                print("Offline search")
                self.bandera = false
                               
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
       
    }
}
