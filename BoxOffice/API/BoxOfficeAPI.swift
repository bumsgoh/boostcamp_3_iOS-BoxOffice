//
//  BoxOfficeAPI.swift
//  BoxOffice
//
//  Created by 공지원 on 13/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import Foundation
// 이 부분을 전체적으로 네트워크 동작을 실행 시켜주는 클래스로 바꿔보면 다른 뷰컨트롤러에서 간결한 코드 구현이 가능할 것 같습니다. 거기에 제너릭은 사용한 메서드를 구현하면 더욱 큰 효과를 가질 수 있을거라고 생각합니다.

class BoxOfficeAPI {
    
    private let baseURL = "http://connect-boxoffice.run.goorm.io/"
    static let shared = BoxOfficeAPI()
    static var orderType: OrderType = .reservation
    
    private init() {}
    func makeRequest(path: Path, components: Components, orderType: OrderType?, movieId: String? = nil) -> URLRequest? {
        
        var urlString = baseURL
        switch path {
        case .list:
            urlString.append("/movies")
        case .detail:
            urlString.append("/movie")
        case .comments:
            urlString.append("/comments")
        }
        switch components {
        case .orderType:
            urlString.append("?order_type=\(orderType?.rawValue ?? "")")
        case .movieId:
            urlString.append("?id=\(movieId ?? "")")
        case .commentsMovieId:
            urlString.append("?movie_id=\(movieId ?? "")")
        }
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }

    func requestMovie<T: Decodable>(with request: URLRequest, decodeType: T.Type, completion: @escaping (T?, Bool) -> Void) {
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error in dataTask: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("data unwrapping error")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(decodeType, from: data)
                completion(apiResponse, true)
                
            } catch let error {
                print(error.localizedDescription)
                completion(nil, false)
            }
        }
        dataTask.resume()
    }

}
