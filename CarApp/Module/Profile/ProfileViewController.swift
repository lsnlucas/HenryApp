//
//  ProfileViewController.swift
//  CarApp
//
//  Created by Daniel Sousa on 03/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var globalScore: UILabel!
    @IBOutlet weak var titleUser: UILabel!
    @IBOutlet weak var progressScore: UILabel!
    @IBOutlet weak var modelCar: UILabel!
    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var globalScoreView: UIView!
    @IBOutlet weak var progressScoreView: UIView!
    
    var arrayHistory: [HistoryModel] = []
    
    var user: UserModel?
    
    init(user: UserModel) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.user = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = ""
        
        self.profileName.text = user?.name
        if let urlString = user?.imageUrl, let url = URL(string: urlString){
            self.profileImage.kf.setImage(with: url)
        }
        
        getHistory(status: 2, UserId: user!.id, success: { (data) in
            self.arrayHistory = data.history
            self.progressScore.text = "\(self.arrayHistory.first?.actualScore ?? 0)"
            
        }, failure: { (error) in
            print("Deu Ruim")
        })
        
//        SVProgressHUD.setDefaultAnimationType(.flat)
//        SVProgressHUD.setDefaultStyle(.dark)
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
        
//        getUser(success: { (data) in
//            self.profileName.text = data.users.first?.name
//            if let urlString = data.users.first?.imageUrl, let url = URL(string: urlString){
//                self.profileImage.kf.setImage(with: url)
//            }
//            SVProgressHUD.dismiss()
//        }, failure: { (error) in
//            print("Deu Ruim")
//            SVProgressHUD.dismiss()
//        })
//        postInfraction(title: "Acelero demais mermao", scoreLost: 20)
    }
    
    func getUser(success: @escaping (_ user: DataModel) -> Void, failure: @escaping (_ error: NetworkingError) -> Void) {
        let networking = Networking()
        
        let request = AbstractRequest()
        request.url = EndPoints.getUsersService
        
        networking.doGet(requestObject: request, success: { (data: DataModel?) in
            guard let data = data else {
                failure(NetworkingError.init(errorType: .unknownError))
                return
            }
            
            success(data)
            
        }, failure: { (error) in
            failure(NetworkingError.init(errorType: .unknownError))
        })
    }

    func setupUI() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        globalScoreView.layer.masksToBounds = true
        globalScoreView.layer.cornerRadius = 20.0
        progressScoreView.layer.masksToBounds = true
        progressScoreView.layer.cornerRadius = 20.0
    }
    
    @IBAction func historyTapped(_ sender: Any) {
        let viewController = HistoryViewController(user: user!)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func postInfraction(title: String, scoreLost: Int) {
        let request = InfractionRequest(title: title, scoreLost: scoreLost)
        request.url = EndPoints.postInfractionService
        let networking = Networking()
        
        networking.doPost(requestObject: request, success: { (response:InfractionResponse?) in
            print(response?.message)
        }) { (error) in
            print("Deu ruim")
        }
    }
    
    func getHistory(status: Int, UserId: String, success: @escaping (_ history: DataHistoryModel) ->Void, failure: @escaping (_ error: NetworkingError) -> Void) {
        let networking = Networking()
        
        let request = AbstractRequest()
        request.url = String.init(format: EndPoints.getHistoryService, "\(status)", "\(UserId)")
        
        networking.doGet(requestObject: request, success: { (data: DataHistoryModel?) in
            guard let data = data else {
                failure(NetworkingError.init(errorType: .unknownError))
                return
            }
            
            success(data)
        }, failure:{(error) in
            failure(NetworkingError.init(errorType: .unknownError))
        })
    }

    
}

class CustomRoundedButton: UIButton {
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1.0
    }
}
