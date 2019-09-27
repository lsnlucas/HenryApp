//
//  UserTableViewCell.swift
//  CarApp
//
//  Created by Lucas Santiago do Nascimento on 21/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foto.layer.cornerRadius = foto.frame.height / 2
        foto.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(user: UserModel) {
        nome.text = user.name
        email.text = user.email
        if let url = URL(string: user.imageUrl) {
            foto.kf.setImage(with: url)
        }
    }
}
