//
//  BoxOfficeMovieThumbModalViewController.swift
//  BoxOffice
//
//  Created by 공지원 on 13/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

//image: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg"

import UIKit

class BoxOfficeMovieThumbModalViewController: UIViewController {
    //MARK:- Property
    var image: String?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- IBOutlet
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        fetchMovieThumb()
    }
    
    //MARK:- IBAction
    @IBAction func thumbImageTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Method
    private func fetchMovieThumb() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            guard let imageUrlString = self.image, let imageURL = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.thumbImageView.image = UIImage(data: imageData)
            }
        }
    }
}

extension BoxOfficeMovieThumbModalViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return thumbImageView
    }
}
