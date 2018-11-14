//
//  WelcomeTableViewCell.swift
//  CreditsWallet
//
//  Created by Thomas Houghton on 28/10/2018.
//  Copyright © 2018 Thomas Houghton. All rights reserved.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    func setupView() {
        mainView.layer.cornerRadius = 30
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowRadius = 7
        mainView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        mainView.layer.shadowOpacity = 0.25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
