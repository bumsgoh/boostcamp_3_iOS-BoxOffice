//
//  StarRatingView.swift
//  BoxOffice
//
//  Created by 공지원 on 13/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class StarRatingView: UIView {
    
    //MARK:- Property
    weak var containerView: UIView?
    
    //MARK:- IBOutlet
    @IBOutlet var stars: [UIImageView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitializer()
    }
    
    private func commonInitializer() {
        
        guard let containerView = Bundle.main.loadNibNamed("StarRatingView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        /*
         아래와 같은 방식으로 하면 더 간결할 것 같습니다.
        */
        self.containerView = containerView
        containerView.frame = self.bounds
        addSubview(containerView)
    }
    
    func resetStarRating() {
        for i in 0..<5 {
            stars[i].image = UIImage(named: "ic_star_large")
        }
    }
    
    func setupStarRating(rating: Double) {
        
        let fullStarNum = Int(rating / 2)
        let remainder = rating.truncatingRemainder(dividingBy: 2)
        var halfStarNum = 0
        
        if remainder>=0 && remainder < 1 {
            halfStarNum = 0
        }
        else if remainder>=1 && remainder < 2 {
            halfStarNum = 1
        }
        
        if fullStarNum == 0 && remainder < 1 {
            for i in 0..<5 {
                stars[i].image = UIImage(named: "ic_star_large")
            }
        }
        
        for i in 0..<fullStarNum {
            stars[i].image = UIImage(named: "ic_star_large_full")
        }
        
        if halfStarNum == 1 {
            stars[fullStarNum].image = UIImage(named: "ic_star_large_half")
        }
  
    }
}
