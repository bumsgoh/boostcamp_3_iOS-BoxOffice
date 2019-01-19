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
    private var sortType: OrderType = .reservation// Enum으로 구성해보면 가독성이 더 좋아질 것 같습니다.
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetAndFetchMovies(orderType: BoxOfficeAPI.orderType)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //resetAndFetchMovies(orderType: sortType)
    }
    
    //MARK:- Method
    @objc func handleRefreshControl(_ sender: UIRefreshControl) {
        indicator.startAnimating()
        fetchMovieList(sortType: sortType)
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
    
    private func resetAndFetchMovies(orderType: OrderType) {
        let navigationTitle: String
        
        switch orderType {
        case .reservation:
            navigationTitle = "예매율순"
        case .quration:
            navigationTitle = "큐레이션"
        case .date:
            navigationTitle = "개봉일순"
        default:
            navigationTitle = "예매율순"
        }
        
        navigationController?.navigationBar.topItem?.title = navigationTitle
        
        indicator.startAnimating()
        
        //orderType에 맞게 영화목록 다시 가져오기
        fetchMovieList(sortType: BoxOfficeAPI.orderType)
    }
    //<같은 기능의 메서드가 테이블 / 컬렉션 두 군데에 있습니다. 하나로 합쳐볼 수 있을것 같습니다>
    private func showOrderTypeSettingActionSheet(style: UIAlertController.Style) {
        let orderSettingAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let sortByRateAction = UIAlertAction(title: "예매율", style: .default) { (action) in
            self.sortType = .reservation
            BoxOfficeAPI.orderType = .reservation
            self.resetAndFetchMovies(orderType: .reservation)
        }
        
        let sortByCurationAction = UIAlertAction(title: "큐레이션", style: .default) { (action) in
            self.sortType = .quration
            BoxOfficeAPI.orderType = .quration
            self.resetAndFetchMovies(orderType: .quration)
        }
        
        let sortByDateAction = UIAlertAction(title: "개봉일순", style: .default) { (action) in
            self.sortType = .date
            BoxOfficeAPI.orderType = .date
            self.resetAndFetchMovies(orderType: .date)
        }
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            self.sortType = .reservation
            BoxOfficeAPI.orderType = .reservation
            print("cancel")
        }
        orderSettingAlertController.addAction(sortByRateAction)
        orderSettingAlertController.addAction(sortByCurationAction)
        orderSettingAlertController.addAction(sortByDateAction)
        orderSettingAlertController.addAction(cancleAction)
        
        present(orderSettingAlertController, animated: true, completion: nil)
    }
    
    func fetchMovieList(sortType: OrderType) {
        guard let request = BoxOfficeAPI.shared.makeRequest(path: .list, components: .orderType, orderType: sortType) else {
            
            return
        }
        BoxOfficeAPI.shared.requestMovie(with: request, decodeType: APIResponse.self) { [weak self]  result, isSucceed in
            guard let self = self else {
                return
            }
            
            if !isSucceed {
                DispatchQueue.main.async {
                     self.alert("해당 영화에 대한 데이터가 없습니다.")
                }
               
                return
            }
            
            guard let result = result else {
                DispatchQueue.main.async {
                    self.alert("해당 영화에 대한 데이터가 없습니다.")
                }
                return
            }
            
            self.movies = result.movies
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
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
        /*
         데이터 리퀘스트에서 오류시 사용자에게 보여줄 수 있는 화면이 없습니다. 추가한다면 더 사용자에게 유익할 것 같습니다.
         
         */
        DispatchQueue.global().async { [weak self] in
            guard let thumb = movie.thumb else { return }
            guard let thumbImageURL = URL(string: thumb) else {
                DispatchQueue.main.async {
                    self?.alert("썸네일 로딩 실패")
                }
                return
            }
            
            guard let thumbImageData = try? Data(contentsOf: thumbImageURL) else {
                DispatchQueue.main.async {
                    self?.alert("썸네일 로딩 실패")
                }
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

