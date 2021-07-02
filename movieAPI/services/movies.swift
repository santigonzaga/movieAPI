//
//  movies.swift
//  movieAPI
//
//  Created by Santiago del Castillo Gonzaga on 30/06/21.
//

// popular API https://api.themoviedb.org/3/movie/popular?
// genre API https://api.themoviedb.org/3/genre/movie/list?
// now playing API https://api.themoviedb.org/3/movie/now_playing?

import UIKit

struct MovieAPI {
    let api_key: String = "api_key=e93b8bbdf3d35298717bb67103decfaa"
    
    func requestPopularMovies(page: Int = 1, completionHandler: @escaping ([Movie]) -> Void) {
        if page < 0 { fatalError("Page should not be lower than 0") }
        let urlString = "https://api.themoviedb.org/3/movie/popular?" + api_key
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (popularMoviesData, response, error) in
            guard let data = popularMoviesData,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["results"] as? [[String: Any]]
            else {
                completionHandler([])
                return
            }
            
            let popularMovies: [Movie] = movieDictionatyToArray(movies: movies)

            completionHandler(popularMovies)
        }
        .resume()
    }
    
    func requestGenres(completionHandler: @escaping ([Int: String]) -> Void) {
        
    }
    
    func requestNowPlayingMovies(page: Int = 1, completionHandler: @escaping ([Movie]) -> Void) {
        if page < 0 { fatalError("Page should not be lower than 0") }
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?" + api_key
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (nowPlayingMoviesData, response, error) in
            guard let data = nowPlayingMoviesData,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["results"] as? [[String: Any]]
            else {
                completionHandler([])
                return
            }
            
            let nowPlayingMovies: [Movie] = movieDictionatyToArray(movies: movies)
            
            completionHandler(nowPlayingMovies)
        }
        .resume()
    }
    
    func movieDictionatyToArray(movies: [[String: Any]]) -> [Movie] {
        
        var moviesArray: [Movie] = []
        
        for movieDictionary in movies {
            guard let title = movieDictionary["title"] as? String,
                  let average = movieDictionary["vote_average"] as? Double,
                  let overview = movieDictionary["overview"] as? String,
                  let image = movieDictionary["poster_path"] as? String,
                  let genre = movieDictionary["genre_ids"] as? [Int],
                  let imageUI = fetchMoviePoster(with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
            else { continue }
            let movie = Movie(title: title, average: average, overview: overview, image: imageUI, genre: genre)
            moviesArray.append(movie)
        }
        
        return moviesArray
    }
    
    func fetchMoviePoster(with url: URL?) -> UIImage? {
        guard let url = url, let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    
}
