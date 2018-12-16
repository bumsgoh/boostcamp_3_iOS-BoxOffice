//
//  BoxOfficeCollectionViewCell.swift
//  BoxOffice
//
//  Created by 공지원 on 11/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewCell: UICollectionViewCell {
    //MARK:- IBOutlet 
    @IBOutlet var movieThumb: UIImageView!
    @IBOutlet var movieGrade: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieReservationGrade: UILabel!
    @IBOutlet var movieReservationRate: UILabel!
    @IBOutlet var movieUserRating: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
}
