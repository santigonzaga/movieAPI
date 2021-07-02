//
//  MovieViewController.swift
//  movieAPI
//
//  Created by Santiago del Castillo Gonzaga on 01/07/21.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate, UISearchResultsUpdating {
    
    var movies: [Movie] = []
    var movies2: [Movie] = []
    var moviesFilter: [Movie] = []
    var moviesFilter2: [Movie] = []
    let movieAPI = MovieAPI()
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        movieAPI.requestPopularMovies { (movies) in
            self.movies = movies
            self.moviesFilter = movies
            
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
        
        movieAPI.requestNowPlayingMovies { (movies2) in
            self.movies2 = movies2
            self.moviesFilter2 = movies2
            
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        moviesFilter = movies
        moviesFilter2 = movies2
        
        if !text.isEmpty {
            self.moviesFilter = moviesFilter.filter({ movie in
                return movie.title.lowercased().contains(text.lowercased())
            })
            
            self.moviesFilter2 = moviesFilter2.filter({ movie in
                return movie.title.lowercased().contains(text.lowercased())
            })
        }
        
        movieTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return moviesFilter.count
        }else {
            return moviesFilter2.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Popular Movies"
        }else {
            return "Now Playing"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {
            fatalError("Não foi possivel converter a celula para movieCell")
        }
        
        let movie = indexPath.section == 0 ? moviesFilter[indexPath.row] : moviesFilter2[indexPath.row]

        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        cell.averageLabel.text = String(movie.average)
        cell.coverImage.image = movie.image
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        performSegue(withIdentifier: "toDetails", sender: indexPath)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetails" {
//            let destination = segue.destination as? UINavigationController
//            let details = destination?.viewControllers.first as? DetailsViewController
//        }
//    }
    

}
