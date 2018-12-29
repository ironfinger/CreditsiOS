//
//  ViewController.swift
//  CreditsWallet
//
//  Created by Thomas Houghton on 25/10/2018.
//  Copyright © 2018 Thomas Houghton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Main View
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var newTransactionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    // Transaction View
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountAddButton: UIButton!
    @IBOutlet weak var amountSubtractButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var sendTransactionButton: UIButton!
    @IBOutlet weak var addressSubmit: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressView: UIView!
    
    // UI:
    var mainOriginPos: CGRect = CGRect.init()
    var transactionOriginPos: CGRect = CGRect.init()
    var refreshControl = UIRefreshControl()
    let CandyRed = UIColor.init(red: 254, green: 87, blue: 87, alpha: 1)
    
    var state = "mainView"
    
    // Prototyping:
    var startAmount = 5.165573
    var amountToSend = 0
    var developmentAPIs = ["http://192.168.1.65:3001/mine", "http://192.168.1.65:3001/blocks", "http://192.168.1.214:3000/get-balance"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the view:
        setupView(mainShadowColor: UIColor.black.cgColor)
        
        // Key board:
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Table View:
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //refreshControl.addTarget(self, action: #selector(getData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        // Positions:
        mainOriginPos = mainView.frame
        transactionOriginPos = transactionView.frame
        
        // Prototyping:
        balanceLabel.text = String(startAmount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // Visual Setup:
    func setupView(mainShadowColor: CGColor) {
        cornerRadius()
        shadows(shadowColor: mainShadowColor)
    }

    func cornerRadius() {
        // Change the corner radiuses:
        mainView.layer.cornerRadius = 30
        balanceView.layer.cornerRadius = balanceView.frame.size.height / 2
        newTransactionButton.layer.cornerRadius = newTransactionButton.frame.size.height / 2
        transactionView.layer.cornerRadius = 30
        amountView.layer.cornerRadius = amountView.frame.size.height / 2
        amountAddButton.layer.cornerRadius = amountAddButton.frame.size.height / 2
        amountSubtractButton.layer.cornerRadius = amountSubtractButton.frame.size.height / 2
        sendTransactionButton.layer.cornerRadius = 10
        addressView.layer.cornerRadius = addressView.frame.size.height / 2
        addressSubmit.layer.cornerRadius = addressSubmit.frame.size.height / 2
    }
    
    func shadows(shadowColor: CGColor) {
        // Shadows:
        mainView.layer.shadowColor = shadowColor
        mainView.layer.shadowOpacity = 0.25
        mainView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        mainView.layer.shadowRadius = 7
        
        balanceView.layer.shadowColor = UIColor.black.cgColor
        balanceView.layer.shadowOpacity = 0.25
        balanceView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        balanceView.layer.shadowRadius = 7
        
        amountView.layer.shadowColor = UIColor.black.cgColor
        amountView.layer.shadowOpacity = 0.25
        amountView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        amountView.layer.shadowRadius = 7
        
        addressView.layer.shadowColor = UIColor.black.cgColor
        addressView.layer.shadowOpacity = 0.25
        addressView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        addressView.layer.shadowRadius = 7
        
        sendTransactionButton.layer.shadowColor = UIColor.black.cgColor
        sendTransactionButton.layer.shadowOpacity = 0.25
        sendTransactionButton.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        sendTransactionButton.layer.shadowRadius = 7
    }
    
    // Actions:
    @IBAction func addTransactionPressed(_ sender: Any) {
        if state == "mainView" {
            transactionViewTransition()
        } else if state == "transactionView" {
            mainViewTransition()
        }
    }
    
    @IBAction func amountAddTapped(_ sender: Any) {
        amountToSend += 1
        amountTextField.text = String(amountToSend) + ".000000)"
        startAmount -= 1
        balanceLabel.text = String(startAmount)
    }
    
    @IBAction func amountSubtractTapped(_ sender: Any) {
        amountToSend -= 1
        amountTextField.text = "\(String(amountToSend)).000000)"
        startAmount += 1
        balanceLabel.text = String(startAmount)
    }
    
    @IBAction func sendTransactionTapped(_ sender: Any) {
        mainViewTransition()
        
        // Complete POST Request:
        postData()
        
        // Get Data
        getData()
    }
    
    // Other Functions:
    func transactionViewTransition() {
        UIView.animate(withDuration: 0.5, animations: {
            var nPos: CGRect = self.mainView.frame
            nPos.origin.y = 704
            self.mainView.frame = nPos
            
            var ntPos: CGRect = self.transactionView.frame
            ntPos.origin.y = 53
            self.transactionView.frame = ntPos
        
        }) { (true) in
            print("Complete")
            self.newTransactionButton.titleLabel?.text = "X"
            self.state = "transactionView"
        }
    }
    
    func mainViewTransition() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.frame = self.mainOriginPos
            self.transactionView.frame = self.transactionOriginPos
        }) { (true) in
            print("Complete")
            self.newTransactionButton.titleLabel?.text = "+"
            self.state = "mainView"
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            tableView.rowHeight = 176
            let wcell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell") as! WelcomeTableViewCell
            return wcell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        //let currentBlock = blocks[indexPath.row - 1]
        cell.amount.text = "BOI"
        tableView.rowHeight = 85
        return cell
    }
}
