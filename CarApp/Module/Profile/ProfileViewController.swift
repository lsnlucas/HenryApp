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

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var globalScore: UILabel!
    @IBOutlet weak var titleUser: UILabel!
    @IBOutlet weak var progressScore: UILabel!
    @IBOutlet weak var modelCar: UILabel!
    @IBOutlet weak var globalScoreView: UIView!
    @IBOutlet weak var progressScoreView: UIView!
    @IBOutlet weak var historyButton: CustomRoundedButton!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
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
        
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        self.profileName.text = user?.name
        if let urlString = user?.imageUrl, let url = URL(string: urlString){
            self.profileImage.kf.setImage(with: url)
        }
        
        guard let user = self.user else { return }
        getHistory(complete: true, status: nil, userId: user.id, success: { (data) in
            self.arrayHistory = data.history
//            guard let history = self.arrayHistory.first else {
//                self.progressScoreView.isHidden = true
//                self.historyButton.isHidden = true
//                self.stackViewHeight.constant = 100
//                return
//            }`
            let corridaEmProgresso = self.arrayHistory.first { $0.status == 1 }
            let corridasFinalidas = self.arrayHistory
                //.filter { $0.status == 2}
            
            if corridasFinalidas.count == 0 {
                self.historyButton.isHidden = true
            } else {
                let pontuacaoGlobal = (corridasFinalidas.reduce(0, {$0 + $1.actualScore}) / corridasFinalidas.count)
                self.globalScore.text = "\(pontuacaoGlobal)"
                if pontuacaoGlobal >= 950 {
                    self.titleUser.text = "Herói do asfalto!"
                } else if pontuacaoGlobal >= 900 && pontuacaoGlobal < 950 {
                    self.titleUser.text = "Prodígio do volante!"
                } else if pontuacaoGlobal >= 500 && pontuacaoGlobal < 850 {
                    self.titleUser.text = "Cangaceiro do tráfego"
                    //self.titleUser.textColor = UIColor(hexString: "#b4180d")
                    //self.titleUser.textColor = UIColor(named: "#b4180d")
                    self.globalScore.textColor = UIColor(hexString: "#b4180d")
                } else if pontuacaoGlobal > 0 && pontuacaoGlobal < 500 {
                    self.titleUser.text = "À espera de um milagre"
                    //self.titleUser.textColor = UIColor(hexString: "#b4180d")
                    //self.titleUser.textColor = UIColor(named: "#b4180d")
                    self.globalScore.textColor = UIColor(hexString: "#b4180d")
                }
            }
//            let total = pontuacaoGlobal.reduce(0, {$0 + $1.actualScore})
            guard let corridaEmProgresso1 = corridaEmProgresso else{
                self.progressScoreView.isHidden = true
                self.stackViewHeight.constant = 200
                self.globalScore.text = "Você não possui nenhuma corrida"
                self.globalScore.font = UIFont.systemFont(ofSize: 17)
                self.globalScore.textColor = .white
                SVProgressHUD.dismiss()
                return
            }
            self.progressScore.text = "\(corridaEmProgresso1.actualScore)"
            if corridaEmProgresso1.actualScore < 850 {
                self.progressScore.textColor = UIColor(hexString: "#b4180d")
            }
            self.modelCar.text = corridaEmProgresso1.model
            //self.modelCar.text = self.arrayHistory.first?.model ?? ""
            SVProgressHUD.dismiss()
        }, failure: { (error) in
            print("Deu Ruim")
            SVProgressHUD.dismiss()
        })
        
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
    
    func getHistory(complete: Bool, status: Int?, userId: String, success: @escaping (_ history: DataHistoryModel) ->Void, failure: @escaping (_ error: NetworkingError) -> Void) {
        let networking = Networking()
        
        let request = AbstractRequest()
        if complete{
            request.url = String.init(format: EndPoints.getCompleteHistoryServiceFromUser, "\(userId)")
        } else {
            request.url = String.init(format: EndPoints.getHistoryService, "\(status ?? 0)", "\(userId)")
        }
        
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

//    func getCompleteHistoryFromUser(UserId: String, success: @escaping (_ history: DataHistoryModel) ->Void, failure: @escaping (_ error: NetworkingError) -> Void) {
//        let networking = Networking()
//
//        let request = AbstractRequest()
//        request.url = String.init(format: EndPoints.getCompleteHistoryServiceFromUser, "\(UserId)")
//
//        networking.doGet(requestObject: request, success: { (data: DataHistoryModel?) in
//            guard let data = data else {
//                failure(NetworkingError.init(errorType: .unknownError))
//                return
//            }
//
//            success(data)
//        }, failure:{(error) in
//            failure(NetworkingError.init(errorType: .unknownError))
//        })
//    }
}

class CustomRoundedButton: UIButton {
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1.0
    }
}
