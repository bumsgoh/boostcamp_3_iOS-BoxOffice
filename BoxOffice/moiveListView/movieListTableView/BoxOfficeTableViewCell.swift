//
//  BoxOfficeTableViewCell.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {
    //MARK:- IBOutlet 
    @IBOutlet var movieThumb: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieGrade: UIImageView!
    @IBOutlet var movieUserRating: UILabel! //평점
    @IBOutlet var movieReservationGrade: UILabel! //예매순위
    @IBOutlet var movieReservationRate: UILabel! //예매율
    @IBOutlet var movieReleaseDate: UILabel!
}
