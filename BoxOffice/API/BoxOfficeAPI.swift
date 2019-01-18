//
//  BoxOfficeAPI.swift
//  BoxOffice
//
//  Created by 공지원 on 13/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import Foundation
// 이 부분을 전체적으로 네트워크 동작을 실행 시켜주는 클래스로 바꿔보면 다른 뷰컨트롤러에서 간결한 코드 구현이 가능할 것 같습니다. 거기에 제너릭은 사용한 메서드를 구현하면 더욱 큰 효과를 가질 수 있을거라고 생각합니다.

func requestMovie(orderType: String, completion: @escaping ([Movie]?, Bool) -> Void) {
    
    let baseURL = "http://connect-boxoffice.run.goorm.io/"
    
    guard let url = URL(string: baseURL + "movies?order_type=" + orderType) else { return }
    
    let session = URLSession(configuration: .default)

    let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print("error in dataTask: \(error.localizedDescription)")
            return
        }
                
        guard let data = data else {
            print("data unwrapping error")
            return
        }
        
        do {
            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            completion(apiResponse.movies, true)
            
        } catch let error {
            print(error.localizedDescription)
            completion(nil, false)
        }
    }
    dataTask.resume()
}
