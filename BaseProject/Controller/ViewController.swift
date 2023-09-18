// Created for BaseProject in 2023
// Using Swift 5.0
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        callLoginApi()
    }

    func callLoginApi() {
        let param: [String:Any] = [
            ApiKeys.kemail: "UserName" as Any,
            ApiKeys.kpassword: "Password" as Any
        ]
        
//        ApiService.shared.callUserLogin(parameter: param, loadingView: self.view) { [self] (statsCode, message,user) in
//            if user != nil {
//                //SUCCESS
//                print("\(statsCode):\(message)")
//                print("USER Details :",user)
//            } else {
//                //ERROR
//                print("Login Error :" ,message)
//            }
//        }

    }

}

