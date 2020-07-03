//
//  SearchController.swift
//  movie-db2
//
//  Created by katia kutsi on 7/3/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedMovieCollection: UICollectionView!
    
    let apiService = APIService()
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    
    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchedMovieCollection.register(UINib(nibName: "MovieCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movie_cell")
        
        searchedMovieCollection.delegate = self
        searchedMovieCollection.dataSource = self

        searchBar.delegate = self
        apiService.getPopularMovies { (movies) in
            self.movies.append(contentsOf: movies.movies)
            
            DispatchQueue.main.async {
                self.searchedMovieCollection.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "search_item_details" {
            if let detailsVC = segue.destination as? DetailedViewController {
                detailsVC.selectedMovie = selectedMovie
            }
        }
    }
}

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMovie = filteredMovies[indexPath.row]
        
        performSegue(withIdentifier: "search_item_details", sender: self)
    }
}

extension SearchController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 82) / 3
        
        return CGSize(width: width, height: width*1.5)
        
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
}

extension SearchController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchedMovieCollection.dequeueReusableCell(withReuseIdentifier: "movie_cell", for: indexPath) as! MovieCollectionViewCell
        
        filteredMovies[indexPath.row].posterURL.downloadImage(completion: { (img) in
            DispatchQueue.main.async {
                cell.photo.image = img
            }
        })
        
        return cell
    }
    
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.filteredMovies = movies.filter({ (movie) in
                movie.title.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredMovies = []
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.searchedMovieCollection.reloadData()
        }
    }
}
