//
//  RunningTableViewCell.swift
//  CarApp
//
//  Created by Daniel Sousa on 04/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class RunningTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var carro: UILabel!
    @IBOutlet weak var pontuacao: UILabel!
    @IBOutlet weak var loja: UILabel!
    @IBOutlet weak var valor: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ballView.layer.cornerRadius = ballView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(history: HistoryModel){
        carro.text = history.model
        pontuacao.text = "\(history.actualScore)"
        var texto: String = ""
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: history.startDate) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            texto = dateFormatter.string(from: date)
        }
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let dateFim = dateFormatter.date(from: history.endDate) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            texto = texto + " - " + dateFormatter.string(from: dateFim)
        }
        data.text = texto
        loja.text = history.store.name
        valor.text = "\(history.startPrice)"
    }
    
}
