//
//  BoxOfficeCollectionViewController.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewController: UIViewController {
    
    //MARK:- Property
    private var movies: [Movie] = []
    private let cellIdentifier = "movieCollectionCell"
    private var orderType: String = "0"
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- IBOutlet
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    //MARK:- IBAction
    @IBAction func settingsTapped(_ sender: Any) {
        //설정 버튼이 눌리면 영화 정렬방식을 선택할 수 있도록 액션시트 띄움
        showOrderTypeSettingActionSheet(style: .actionSheet)
    }

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetAndFetchMovies(orderType: orderType)
    }
    
    //MARK:- Method
    @objc func handleRefreshControl(_ sender: UIRefreshControl) {
        indicator.startAnimating()
        
        requestMovie(orderType: orderType) { [weak self] result, isSucceed in
            guard let self = self else {
                return
            }
            
            if !isSucceed {
                self.alert("해당 영화에 대한 데이터가 없습니다.")
                return
            }
            
            guard let result = result else {
                self.alert("해당 영화에 대한 데이터가 없습니다.")
                return
            }
            
            self.movies = result
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController else { return }

        guard let cell = sender as? BoxOfficeCollectionViewCell else { return }
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let selectedIndex = indexPath.row

        boxOfficeDetailViewController.movieId = movies[selectedIndex].id
        boxOfficeDetailViewController.navigationItem.title = movies[selectedIndex].title
    }
    
    private func resetAndFetchMovies(orderType: String) {
        let navigationTitle: String
        
        switch orderType {
        case "0":
            navigationTitle = "예매율순"
        case "1":
            navigationTitle = "큐레이션"
        case "2":
            navigationTitle = "개봉일순"
        default:
            navigationTitle = "예매율순"
        }
        
        navigationController?.navigationBar.topItem?.title = navigationTitle
        
        indicator.startAnimating()
        
        //orderType에 맞게 영화목록 다시 가져오기
        requestMovie(orderType: orderType) { [weak self] result, isSucceed in
            guard let self = self else { return }
            if !isSucceed {
                self.alert("해당 영화에 대한 데이터가 없습니다.")
                return
            }
            
            guard let result = result else {
                self.alert("해당 영화에 대한 데이터가 없습니다.")
                return
            }
            
            self.movies = result
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func showOrderTypeSettingActionSheet(style: UIAlertController.Style) {
        let orderSettingAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let sortByRateAction = UIAlertAction(title: "예매율", style: .default) { (action) in
            self.orderType = "0"
            self.resetAndFetchMovies(orderType: "0")
        }
        
        let sortByCurationAction = UIAlertAction(title: "큐레이션", style: .default) { (action) in
            self.orderType = "1"
            self.resetAndFetchMovies(orderType: "1")
        }
        
        let sortByDateAction = UIAlertAction(title: "개봉일순", style: .default) { (action) in
            self.orderType = "2"
            self.resetAndFetchMovies(orderType: "2")
        }
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            self.orderType = "0"
            print("cancle")
        }
        
        orderSettingAlertController.addAction(sortByRateAction)
        orderSettingAlertController.addAction(sortByCurationAction)
        orderSettingAlertController.addAction(sortByDateAction)
        orderSettingAlertController.addAction(cancleAction)
        
        present(orderSettingAlertController, animated: true, completion: nil)
    }
}

//MARK:- CollectionView Data Source, Delegate
extension BoxOfficeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? BoxOfficeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        
        if let reservationGrade = movie.reservationGrade, let date = movie.date, let userRating = movie.userRating, let reservationRate = movie.reservationRate {
        
        cell.movieTitle.text = movie.title
        cell.movieReservationGrade.text = String(reservationGrade) + "위"
        cell.movieReleaseDate.text = String(date)
        cell.movieUserRating.text = "(" + String(userRating) + ")"
        cell.movieReservationRate.text = String(reservationRate) + "%"
        }
        
        let gradeImageName: String
        
        switch movie.grade {
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
        
        cell.movieGrade.image = UIImage(named: gradeImageName)
        cell.movieThumb.image = UIImage(named: "img_placeholder")
        
        DispatchQueue.global().async {
            guard let thumb = movie.thumb else { return }
            guard let thumbImageURL = URL(string: thumb) else {
                return
            }
            
            guard let thumbImageData = try? Data(contentsOf: thumbImageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.movieThumb.image = UIImage(data: thumbImageData)
                    }
                }
            }
        }
        return cell
    }
}

