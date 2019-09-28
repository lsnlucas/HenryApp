//
//  ViewController.swift
//  CarApp
//
//  Created by Daniel Sousa on 03/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.animationView.play()
        self.navigationController?.navigationBar.isHidden = true
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let navigation = UINavigationController(rootViewController: LoginViewController())
            self.present(navigation, animated: true, completion: nil)
        }
        
    }


}

