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
    var developmentAPIs = ["http://192.168.1.65:3001/mine", "http://192.168.1.65:3001/blocks"]
    
    struct Block: Codable {
        var hash: String
        var timestamp: Int
        var lastHash: String
        var data: String
    }
    
    var theme = "light"
    
    var blocks: [Block] = [Block]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup the view:
        
        if theme == "light" {
            setupView(mainShadowColor: UIColor.black.cgColor)
            
        } else if theme == "dark" {
            setupView(mainShadowColor: UIColor.red.cgColor)
        }
        
        // Key board:
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Table View:
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        // Positions:
        mainOriginPos = mainView.frame
        transactionOriginPos = transactionView.frame
        
        // Prototyping:
        balanceLabel.text = String(startAmount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    // Visual Setup:
    func setupView(mainShadowColor: CGColor) {
        cornerRadius()
        shadows(shadowColor: mainShadowColor)
        themeColor(
            backColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 1),
            foreColor: UIColor.init(red: 26, green: 26, blue: 26, alpha: 1),
            borderColors: true
        )
    }
    
    func themeColor(backColor: UIColor, foreColor: UIColor, borderColors: Bool) {
        // Main View Background Color:
        mainView.backgroundColor = backColor
        mainView.layer.borderWidth = 3
        
        // Amount View:
        amountView.backgroundColor = foreColor
        
        // Transaction View:
        transactionView.backgroundColor = backColor
        
        // Border Colors
        handleBorderColors(hasBorder: borderColors)
    }
    
    func handleBorderColors(hasBorder: Bool) {
        if hasBorder == true {
            let borderColor = UIColor.init(red: 254, green: 87, blue: 87, alpha: 1)
            mainView.layer.borderWidth = 3
            mainView.layer.borderColor = borderColor.cgColor
            
            transactionView.layer.borderWidth = 3
            transactionView.layer.borderColor = borderColor.cgColor
        } else {
            print("No border")
        }
    }
    
    func cellBackColor(cellTheme: String) -> UIColor {
        let r: CGFloat = 26
        let g: CGFloat = 26
        let b: CGFloat = 26
        let a: CGFloat = 1
        
        if cellTheme == "light" {
            return UIColor.white
        } else if cellTheme == "Dark" {
            return UIColor.init(red: r, green: g, blue: b, alpha: a)
        }
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
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
    
    func postData() {
        // Resources: https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4
        
        // Create URL:
        guard let url = URL(string: developmentAPIs[0]) else {
            print("Error creating the URL")
            return
        }
        
        // Create URLRequest Object:
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set the header of the data packet.
        urlRequest.httpMethod = "POST" // Set httpMethod of the data packet.
        
        struct Transaction: Codable {
            var data: String
        }
        
        // Set the http body of the data packet.
        do {
            // Set the http body:
            let newTransaction = Transaction(data: amountTextField.text!)
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(newTransaction)
            urlRequest.httpBody = jsonData // Assign data to the http body.
            
            // Check the json:
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString ?? "")
            
            // Check the values:
            let jsonDecoder = JSONDecoder()
            let decodedData = try jsonDecoder.decode(Transaction.self, from: jsonData)
            print(decodedData.data)
        } catch {
            print("Couldn't create json")
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("Error calling POST on /mine")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("error couldn't get any data")
                return
            }
            
            print("Here is the response")
            print(responseData)
        }
        task.resume()
    }
    
    @objc func getData() {
        guard let url = URL(string: developmentAPIs[1]) else {
            print("Couldn't genereate the url")
            return
        }
        
        // Create the url session:
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Make the request:
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error calling post on /blocks")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("error couldn't get ant data")
                return
            }
            
            do {
                guard let chain = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] else {
                    print("Can't create a dictionary from JSON data")
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                self.blocks.removeAll()
                for b in chain {
                    let hash = b["hash"] as! String
                    let lastHash = b["lastHash"] as! String
                    let bData = b["data"] as! String
                    let timestamp = b["timestamp"] as! Int
                    
                    let newBlock = Block(hash: hash, timestamp: timestamp, lastHash: lastHash, data: bData)
                    self.blocks.append(newBlock)
                }
            } catch {
                print("Couldn't create and array of blocks")
                print(error.localizedDescription)
            }
        }
        task.resume()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            tableView.rowHeight = 176
            let wcell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell") as! WelcomeTableViewCell
            return wcell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        let currentBlock = blocks[indexPath.row - 1]
        cell.cellView.backgroundColor = cellBackColor(cellTheme: theme)
        cell.amount.text = currentBlock.data
        tableView.rowHeight = 85
        return cell
    }
}
