//
//  Extensions.swift
//  Noon Assignment
//
//  Created by Sandeep Rana on 02/03/19.
//  Copyright © 2019 Sandeep Rana. All rights reserved.
//

import UIKit

extension NSObject {
    class func className() -> String {
        return String(describing: self);
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel));
        alert.modalPresentationStyle = .overFullScreen;
        self.present(alert, animated: true, completion: nil);
    }
}
