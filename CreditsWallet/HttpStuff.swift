//
//  HttpStuff.swift
//  CreditsWallet
//
//  Created by Tom Houghton on 28/12/2018.
//  Copyright © 2018 Thomas Houghton. All rights reserved.
//

import Foundation


func postData() {
    // Resources: https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4
    
    // Create URL:
    guard let url = URL(string: "") else {
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
        let newTransaction = Transaction(data: "")
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

func getData() {
    guard let url = URL(string: "") else {
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
//
//            let jsonDecoder = JSONDecoder()
//            self.blocks.removeAll()
//            for b in chain {
//                let hash = b["hash"] as! String
//                let lastHash = b["lastHash"] as! String
//                let bData = b["data"] as! String
//                let timestamp = b["timestamp"] as! Int
//
//                let newBlock = Block(hash: hash, timestamp: timestamp, lastHash: lastHash, data: bData)
//                self.blocks.append(newBlock)
            //}
        } catch {
//            print("Couldn't create and array of blocks")
//            print(error.localizedDescription)
        }
    }
    task.resume()
}
