//
//  LoanManager.swift
//  LoanStar
//
//  Created by mbarrass on 10/6/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import Foundation
import web3swift

final class LoanManager {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Loan]?, String) -> ()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var loans: [Loan] = []
    var errorMessage = ""
    
    func getLoanResults(_ completion: @escaping QueryResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://kovan-api.bloqboard.com/api/v1/Debts") {
            urlComponents.query = "sortBy=CreationTime&limit=20"
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateLoanResults(data)
                    DispatchQueue.main.async {
                        completion(self.loans, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func updateLoanResults(_ data: Data) {
        var response: JSON?
        loans.removeAll()
        
        do {
            response = try JSON(data: data)
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
        }
        
        guard let array = response?.array else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        for loanObject in array {
            if let bigIntAmount = Web3Utils.parseToBigUInt(loanObject["principalAmount"].stringValue, units: .wei) {
                let amount = Web3Utils.formatToEthereumUnits(bigIntAmount)
                let name = loanObject["id"].stringValue
                let category = loanObject["status"].stringValue
                loans.append(Loan(name: name, amount: amount!, category: category))
            }
        }
    }
}

