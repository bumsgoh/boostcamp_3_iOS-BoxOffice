//
//  BoxOfficeDetailViewController.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
// * 두번째 화면의 컨트롤러: 한 영화에 대한 상세 정보들을 보여줌 *

import UIKit

class BoxOfficeDetailViewController: UIViewController {
    //MARK:- Property
    private var comments: [Comment] = []
    var movieDetail: MovieDetail?
    var movieId: String? //이전 화면에서 넘겨준 영화 id를 받음
    
    //MARK:- IBOutlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    //MARK:- Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let movieId = movieId else { return }
        indicator.startAnimating()
        
        requestMovieDetail(id: movieId)
        requestComments(id: movieId)
        
        navigationController?.navigationBar.topItem?.title = "영화목록"
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    //MARK:- Method
    @IBAction func thumbImageTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //BoxOfficeMovieThumbModalViewController 클래스를 인스턴스화
        guard let boxOfficeMovieThumbModalViewController = storyboard.instantiateViewController(withIdentifier: "boxOfficeMovieThumbModalViewController") as? BoxOfficeMovieThumbModalViewController else { return }
        
        boxOfficeMovieThumbModalViewController.image = movieDetail?.image
        
        self.present(boxOfficeMovieThumbModalViewController, animated: true, completion: nil)
    }
    
    //영화 상세정보 서버에 요청
    func requestMovieDetail(id: String) {
        let baseURL = "http://connect-boxoffice.run.goorm.io/movie?id="
        
        guard let movieId = movieId else { return }
        guard let url = URL(string: baseURL + movieId) else { return }

        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                self.alert("데이터 수신 실패")
                print("error in dataTask: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("data unwrapping error")
                return
            }
            
            do {
                let movieDetailApiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                self.movieDetail = movieDetailApiResponse
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
                
            } catch let error {
                print(error.localizedDescription)
                
                self.alert("데이터를 수신 실패.")
            }
        }
        dataTask.resume()
    }

    func requestComments(id: String) {
        let baseURL = "http://connect-boxoffice.run.goorm.io/comments?movie_id="
        
        guard let movieId = movieId else { return }
        guard let url = URL(string: baseURL + movieId) else { return }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                self.alert("데이터 수신 실패")
                print("error in dataTask: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("data unwrapping error")
                return
            }
            
            do {
                let commentsApiResponse: CommentApiResponse = try JSONDecoder().decode(CommentApiResponse.self, from: data)
                guard let comments = commentsApiResponse.comments else { return }
                self.comments = comments
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
                
            } catch let error {
                print(error.localizedDescription)
                self.alert("데이터를 수신 실패.")
            }
        }
        dataTask.resume()
    }
}

//MARK:- TableView Data Source,Delegate
extension BoxOfficeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        selectedCell?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 150
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            
            headerView.backgroundColor = UIColor.white
            
            let title = UILabel()
            title.frame = CGRect(x: self.view.bounds.width * 0.02 , y: 0, width: 100, height: 40)
            title.font = UIFont.systemFont(ofSize: 21.0)
            title.textColor = UIColor.black
            title.text = "한줄평"
            
            let image = UIImage(named: "btn_compose")
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x: self.view.bounds.width * 0.9, y: 0, width: 25, height: 25)
            
            headerView.addSubview(title)
            headerView.addSubview(imgView)
            
            return headerView
        }
        return nil
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return comments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? BoxOfficeDetailTableViewCell else { return UITableViewCell() }
            
            if let movieDetail = movieDetail {
                cell.configure(movieDetail)
            }
            
            DispatchQueue.global().async {
                guard let image = self.movieDetail?.image, let imageURL = URL(string: image), let imageData = try? Data(contentsOf: imageURL) else { return }
                
                DispatchQueue.main.async {
                    cell.movieThumb.image = UIImage(data: imageData)
                }
            }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? BoxOfficeCommentTableViewCell else { return UITableViewCell() }
            let comment = comments[indexPath.row]
            cell.configure(comment)

            return cell
        default:
            return UITableViewCell()
        }
    }
}
