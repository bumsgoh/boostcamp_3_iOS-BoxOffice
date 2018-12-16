//
//  CustomAlert.swift
//  BoxOffice
//
//  Created by 공지원 on 15/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ title: String? = nil, message: String? = nil, cancelTitle: String? = "확인", actionTitle: String? = nil, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        
        if let actionTitle = actionTitle {
            alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: completion))
        }
        present(alertController, animated: true, completion: nil)
    }
}
