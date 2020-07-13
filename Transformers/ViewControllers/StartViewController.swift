//
//  StartViewController.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let token = String(bytes: KeyChain.load(key: "token") ?? Data(), encoding: String.Encoding.utf8), token.count > 0 else {
            self.fetchToken()
            return
        }
        self.presentVC()
    }
    
    


    // MARK: - API

    private func fetchToken() {
        APIManager.sharedInstance.opertationWithRequest(withApi: API.AllSpark) { (APIResponse) in
            switch APIResponse {
            case .Success(let response):
                guard let token = response as? String else {
                    return
                }
                let _ = KeyChain.save(key: "token", data: token.data(using: .utf8) ?? Data())
                DispatchQueue.main.async {
                    self.presentVC()
                }
                print("Response: \(token)")
            case .Failure(let error):
                print("Error: \(error ?? "")")
            }
            print(APIResponse)
        }
    }
    
    // MARK: - Navigation
    
    private func presentVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let listVC = storyBoard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {return}
        self.navigationController?.pushViewController(listVC, animated: false)
    }

}
