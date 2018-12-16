//
//  BoxOfficeAPI.swift
//  BoxOffice
//
//  Created by 공지원 on 13/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import Foundation

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
