//
//  HistoryViewController.swift
//  CarApp
//
//  Created by Daniel Sousa on 04/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
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
        title = "Corridas Anteriores"
        setupTable()
        
        
        getHistory(status: 2, UserId: user!.id, success: { (data) in
            self.arrayHistory = data.history
            self.tableView.reloadData()
            
        }, failure: { (error) in
            print("Deu Ruim")
        })
    }
    
    func setupTable() {
        self.tableView.delegate = self
        self.tableView.dataSource  = self
        let nib = UINib(nibName: "RunningTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RunningTableViewCell")
    }

}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RunningTableViewCell", for: indexPath) as? RunningTableViewCell {
            cell.setup(history: self.arrayHistory[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157.0
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
