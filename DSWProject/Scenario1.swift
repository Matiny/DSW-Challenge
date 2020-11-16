//
//  Scenario1.swift
//  DSWProject
//
//  Created by Matiny L on 11/13/20.
//  Copyright © 2020 Matiny L. All rights reserved.
//

import Foundation

// MARK: Codable Structs

struct DSWData: Codable {
    let products: [OneProduct]
    let promos: [OnePromo]
    let summary: TheSummary
}

struct OneProduct: Codable {
    let sku: String
    let displayName: String
    let price: String
    let quantity: Int
}

struct OnePromo: Codable {
    let code: String
    let description: String
    let value: String
}

struct TheSummary: Codable {
    let subtotal: String
    let tax: String
    let discounts: String
    let total: String
}




class DSW {
    
    static let shared = DSW()
    
    // MARK: Online Api Call
    
    func urlRequest(completion: @escaping ([String:Any]) -> ()) {
        
        /* Fake path example */
        let urlString = "https://www.dsw.com/api/v1/bag"
        
        guard let url = URL(string: urlString) else {return}
        
        /* Actual path */
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("Error while getting data")
                return
            }
            
            guard let shoeData = try? JSONDecoder().decode(DSWData.self, from: data) else {
                print("Error while decoding JSON")
                return
            }
            
            /* Data goes here */
            //            completion()
            
        }
        task.resume()
    }
    
    // MARK: Local Api Call
    
    func fakeRequest(completion: @escaping ([String:Any]) -> ()) {
        
        if let path = Bundle.main.path(forResource: "MockData", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
                let decoder = JSONDecoder()
                do {
                    let decodedRes = try decoder.decode(DSWData.self, from: jsonData)
                    completion(["products": decodedRes.products,
                                "promos": decodedRes.promos,
                                "summary": decodedRes.summary])
                } catch  {
                    print(error)
                }
            }
        }
    }
}
