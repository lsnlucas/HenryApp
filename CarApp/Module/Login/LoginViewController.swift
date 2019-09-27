//
//  LoginViewController.swift
//  CarApp
//
//  Created by Lucas Santiago do Nascimento on 21/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var users: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        title = "Login"
        setupTableView()
        
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        getUser(success: { (dataModel) in
            self.users = dataModel.users
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (erro) in
            print("Deu ruim")
            SVProgressHUD.dismiss()
        }
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserTableViewCell")
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
}

extension LoginViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ProfileViewController(user: users[indexPath.row])
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LoginViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell {
            cell.setup(user: users[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
