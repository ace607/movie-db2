//
//  DetailedViewController.swift
//  movie-db2
//
//  Created by katia kutsi on 7/3/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var similarMoviesCollection: UICollectionView!
    
    var selectedMovie : Movie?
    let apiService = APIService()
    var genres = [Genre]()
    var similarMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        similarMoviesCollection.delegate = self
        similarMoviesCollection.dataSource = self
        
        
        similarMoviesCollection.register(UINib(nibName: "DetailedHeaderCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DetailedHeaderCell")
        similarMoviesCollection.register(UINib(nibName: "SimilarMovieCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SimilarMovieCell")
        
        apiService.getGenres { (genresResponse) in
            self.genres.append(contentsOf: genresResponse.genres)
        }
        
        apiService.getSimilarMovies(id: selectedMovie!.id) { (moviesResponse) in
            self.similarMovies.append(contentsOf: moviesResponse.movies)
            DispatchQueue.main.async {
                self.similarMoviesCollection.reloadData()
            }
        }
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailedViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = similarMoviesCollection.dequeueReusableCell(withReuseIdentifier: "DetailedHeaderCell", for: indexPath) as! DetailedHeaderCell
            selectedMovie!.posterURL.downloadImage(completion: { (img) in
                DispatchQueue.main.async {
                    cell.imv.image = img
                }
            })
            cell.title.text = selectedMovie?.title
            
            cell.rate.text = String(describing: selectedMovie!.imdb)
            for (index, item) in cell.rateStackView.subviews.enumerated() {
                if index <= Int(selectedMovie!.imdb/2) {
                    (item as! UIImageView).image = UIImage(systemName: "star.fill")
                } else {
                    (item as! UIImageView).image = UIImage(systemName: "star")
                }
            }
            var genre = ""
            for i in selectedMovie!.genreIDS{
                for j in stride(from: 0, to: genres.count, by: 1){
                    if i == genres[j].id{
                        genre = genre + genres[j].name + "  |  "
                    }
                }
            }
            
            cell.genres.text = String(genre.dropLast(5))
            cell.overview.text = selectedMovie?.overview
            
            return cell
        }
        let cell = similarMoviesCollection.dequeueReusableCell(withReuseIdentifier: "SimilarMovieCell", for: indexPath) as! SimilarMovieCell
        let similarMovie = similarMovies[indexPath.row]
        similarMovie.posterURL.downloadImage(completion: { (img) in
            DispatchQueue.main.async {
                cell.imv.image = img
            }
        })
        cell.title.text = similarMovie.title
        return cell
    }
    
    
}

extension DetailedViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: similarMoviesCollection.frame.width, height: 611)
        }
        return CGSize(width: similarMoviesCollection.frame.width, height: 90)
    }
}
