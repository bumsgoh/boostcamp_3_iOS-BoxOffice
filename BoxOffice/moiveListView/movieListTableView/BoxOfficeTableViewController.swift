//
//  BoxOfficeTableViewController.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit
/*
 1. 이미지의 contentType이나 제약조건이 제대로 설정되있지 않아 이미지가 길게 늘어나는 현상이 보입니다.
 2. 레이블의 위치가 과제 요구사항과는 조금 다릅니다.
 
 
 */
class BoxOfficeTableViewController: UIViewController {
    
    //MARK:- Property
    private var movies: [Movie] = []
    private let cellIdentifier = "movieTableCell"
    private var sortType: OrderType = .reservation // Enum을 사용하면 가독성에 도움이 될것같습니다.
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    //MARK:- IBAction
    @IBAction func settingsTapped(_ sender: Any) {
        //설정 버튼이 눌리면 영화 정렬방식을 선택할 수 있도록 액션시트 띄움
        showOrderTypeSettingActionSheet(style: .actionSheet)
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetAndFetchMovies(orderType: BoxOfficeAPI.orderType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         뷰가 appear 할때마다 계속해서 데이터 리퀘스트를 보내면 refresh의 의미가 없어지는것 같습니다. 추가해야하는 이유가 있을까요 ?
         */
        indicator.startAnimating()
        //fetchMovieList(sortType: sortType)
       
    }

    //MARK:- Method
    @objc func handleRefreshControl(_ sender: UIRefreshControl) {
        indicator.startAnimating()
        fetchMovieList(sortType: sortType)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController else {
            return
        }

        guard let selectedRowIndex = tableView.indexPathForSelectedRow?.row else { return }
        
        boxOfficeDetailViewController.movieId = movies[selectedRowIndex].id
        boxOfficeDetailViewController.navigationItem.title = movies[selectedRowIndex].title
    }
    
    //settings버튼을 통해 영화 정렬타입을 변경했을 경우
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
       fetchMovieList(sortType: orderType)
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
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

//MARK:- TableView Data Source, Delegate
extension BoxOfficeTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BoxOfficeTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        
        if let reservationGrade = movie.reservationGrade, let date = movie.date, let userRating = movie.userRating, let reservationRate = movie.reservationRate {
        
        cell.movieTitle.text = movie.title
        cell.movieReservationGrade.text = String(reservationGrade)
        cell.movieReleaseDate.text = String(date)
        cell.movieUserRating.text = String(userRating)
        cell.movieReservationRate.text = String(reservationRate)
        
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
                if let index = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.movieThumb.image = UIImage(data: thumbImageData)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
    }
}
