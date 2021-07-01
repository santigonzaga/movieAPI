//
//  ViewController.swift
//  movieAPI
//
//  Created by Santiago del Castillo Gonzaga on 30/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Movie] = []
    
    let movieAPI = MovieAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieAPI.requestNowPlayingMovies { (a) in
            self.movies = a
        }
    }

}

