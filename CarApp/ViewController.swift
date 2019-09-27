//
//  ViewController.swift
//  CarApp
//
//  Created by Daniel Sousa on 03/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let navigation = UINavigationController(rootViewController: LoginViewController())
        
        
        
        self.present(navigation, animated: true, completion: nil)
    }


}

