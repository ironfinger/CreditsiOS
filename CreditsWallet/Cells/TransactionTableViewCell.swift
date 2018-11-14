//
//  TransactionTableViewCell.swift
//  CreditsWallet
//
//  Created by Thomas Houghton on 25/10/2018.
//  Copyright © 2018 Thomas Houghton. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var transactionType: UIView!
    @IBOutlet weak var amount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
    func setupCell() {
        cellView.layer.cornerRadius = cellView.frame.height / 2
        transactionType.layer.cornerRadius = transactionType.frame.width / 2
        
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.25
        cellView.layer.shadowRadius = 7
        cellView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        
        transactionType.layer.borderColor = UIColor.green.cgColor
        transactionType.layer.borderWidth = 2
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
