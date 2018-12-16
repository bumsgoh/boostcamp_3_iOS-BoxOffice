//
//  BoxOfficeDetailTableViewCell.swift
//  BoxOffice
//
//  Created by 공지원 on 12/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeDetailTableViewCell: UITableViewCell {
    let numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    //MARK:- IBOutlet
    @IBOutlet var movieThumb: UIImageView!
    @IBOutlet var movieGrade: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieGenre: UILabel!
    @IBOutlet var movieDuration: UILabel!
    
    @IBOutlet var movieReservationGrade: UILabel!
    @IBOutlet var movieReservationRate: UILabel!
    @IBOutlet var movieRating: UILabel!
    @IBOutlet var movieAudienceCount: UILabel!
    
    @IBOutlet var synopsis: UILabel!
    
    @IBOutlet var movieDirector: UILabel!
    @IBOutlet var movieActor: UILabel!
    
    @IBOutlet var starRatingView: StarRatingView!
    
    //MARK:- Method 
    func configure(_ movieDetail: MovieDetail) {
        if let date = movieDetail.date, let duration = movieDetail.duration, let reservationGrade = movieDetail.reservationGrade, let reservationRate = movieDetail.reservationRate, let userRating = movieDetail.userRating, let audienceCount = movieDetail.audience {
            let audienceToStr = numberFormatter.string(from: NSNumber(integerLiteral: audienceCount))

            movieTitle.text = movieDetail.title
            movieReleaseDate.text = date + "개봉"
            movieGenre.text = movieDetail.genre
            movieDuration.text = String(duration) + "분"
            movieReservationGrade.text = String(reservationGrade) + "위"
            movieReservationRate.text = String(reservationRate) + "%"
            movieRating.text = String(userRating)
            movieAudienceCount.text = audienceToStr
            synopsis.text = movieDetail.synopsis
            movieDirector.text = movieDetail.director
            movieActor.text = movieDetail.actor
            
            starRatingView.setupStarRating(rating: userRating)
        }
        
        let gradeImageName: String
        
        switch movieDetail.grade {
        case 0:
            gradeImageName = "ic_allages"
        case 12:
            gradeImageName = "ic_12"
        case 15:
            gradeImageName = "ic_15"
        case 19:
            gradeImageName = "ic_19"
        default:
            gradeImageName = "ic_allages"
        }
        
        movieGrade.image = UIImage(named: gradeImageName)
    }
    
}
