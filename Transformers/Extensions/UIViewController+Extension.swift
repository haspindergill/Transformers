
//
//  UIViewController+Extension.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
   func showInternetActivity() {
       if let activity = self.view.viewWithTag(9999) {
           self.view.bringSubviewToFront(activity)
           return
       }
       let internetActivity = InternetActivity(frame: UIScreen.main.bounds)
       internetActivity.tag = 9999
       UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
           self.view.addSubview(internetActivity)
       }, completion: nil)
   }
   
   func hideInternetActivity() {
       if let activity = self.view.viewWithTag(9999) {
           activity.removeFromSuperview()
       }
   }
    
}
