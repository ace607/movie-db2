//
//  download+image.swift
//  movie-db2
//
//  Created by Admin on 7/3/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

extension String {
    func downloadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
}
