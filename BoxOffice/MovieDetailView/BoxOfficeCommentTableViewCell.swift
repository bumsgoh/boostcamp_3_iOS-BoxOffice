//
//  BoxOfficeCommentTableViewCell.swift
//  BoxOffice
//
//  Created by 공지원 on 12/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeCommentTableViewCell: UITableViewCell {
    //MARK:- IBOutlet
    @IBOutlet var commentWriter: UILabel!
    @IBOutlet var commentDate: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var commentTitle: UILabel!

    @IBOutlet var starRatingView: StarRatingView!
    
    //MARK:- Method
    func configure(_ data: Comment) {
        commentWriter.text = data.writer
        
        if let timestamp = data.timestamp, let rating = data.rating {
            //UNIX TImestamp 값 변환
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let strDate = dateFormatter.string(from: date)
            commentDate.text = strDate
            comment.text = data.contents
            starRatingView.resetStarRating()
            starRatingView.setupStarRating(rating: rating)
        }
    }
}
