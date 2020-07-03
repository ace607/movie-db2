//
//  DetailedHeaderCell.swift
//  movie-db2
//
//  Created by katia kutsi on 7/3/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class DetailedHeaderCell: UICollectionViewCell {
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var rateStackView: UIStackView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var watchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        watchButton.layer.cornerRadius = 16
    }

}
