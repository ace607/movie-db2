//
//  ViewController.swift
//  movie-db2
//
//  Created by Admin on 7/3/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieCollection: UICollectionView!
    
    var apiService = APIService()
    
    var movies = [Movie]()
    var topMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieCollection.delegate = self
        movieCollection.dataSource = self
        
        
        movieCollection.register(UINib(nibName: "HeaderCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "header_cell")
        movieCollection.register(UINib(nibName: "MovieCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movie_cell")
        
        
        apiService.getPopularMovies { (movies) in
            self.movies.append(contentsOf: movies.movies)
            //print(movies)
            
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
            }
        }
        
        apiService.getTopRatedMovie { (movie) in
            self.topMovie = movie
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
            }
        }
    }


}


extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topMovie != nil ? 1 : 0
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = movieCollection.dequeueReusableCell(withReuseIdentifier: "header_cell", for: indexPath) as! HeaderCollectionViewCell
            
            cell.ratingLabel.text = String(topMovie!.imdb)
            
            for (index, item) in cell.ratingStackView.subviews.enumerated() {
                if index <= Int(topMovie!.imdb/2) {
                    (item as! UIImageView).image = UIImage(systemName: "star.fill")
                } else {
                    (item as! UIImageView).image = UIImage(systemName: "star")
                }
            }
            
            topMovie!.posterURL.downloadImage(completion: { (img) in
                DispatchQueue.main.async {
                    cell.photo.image = img
                }
            })
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = movieCollection.dequeueReusableCell(withReuseIdentifier: "movie_cell", for: indexPath) as! MovieCollectionViewCell
            
            movies[indexPath.row].posterURL.downloadImage(completion: { (img) in
                DispatchQueue.main.async {
                    cell.photo.image = img
                }
            })
            
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if (kind == UICollectionView.elementKindSectionHeader) {
//            if indexPath.section == 0 {
//                
//            }
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath)
//            
//        }
//        fatalError()
//
//    }
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 600)
        }
        
        let width = (self.view.frame.width - 82) / 3
        
        return CGSize(width: width, height: width*1.5)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
}

