//
//  Alert.swift
//  FindRoute
//
//  Created by Aleksandr Pimanov on 15.08.2022.
//

import UIKit

extension UIViewController {
    
    func alertAddAddress(title: String, placeHoler: String, complitionHandler: @escaping (String) -> Void ) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { action in
            
            let tfText = alertController.textFields?.first
            guard let text = tfText?.text else { return }
            complitionHandler(text)
        }
        
        alertController.addTextField { textField in
            textField.placeholder = placeHoler
        }
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .default)
            
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true)
    }
    
    func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(alertOk)
        present(alertController, animated: true)
    }
}
