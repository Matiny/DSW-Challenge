//
//  ViewController.swift
//  DSWProject
//
//  Created by Matiny L on 11/13/20.
//  Copyright © 2020 Matiny L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
//    MARK: Save Data
    
    var DSWbag = [String:Any]() {
        didSet {
            saveData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closure = { (fetchedData: [String:Any]) in
            self.DSWbag = fetchedData
        }
        
        DSW.shared.fakeRequest(completion: closure)
        
//        MARK: Load data

        if defaults.object(forKey: "SavedBag") != nil {
            print("Yes")
            loadData()
        }
        else {
            print("No")
        }

    }
    
    func loadData() {
        if let savedBag = defaults.object(forKey: "SavedBag") as? Data {
            let decoder = JSONDecoder()
            if let loadedBag = try? decoder.decode(DSWData.self, from: savedBag) {
                
                DSWbag = ["products": loadedBag.products,
                          "promos": loadedBag.promos,
                          "summary": loadedBag.summary]
            }
        }
    }
    
    func saveData() {
        guard let products = DSWbag["products"] else {return}
        guard let promos = DSWbag["promos"] else {return}
        guard let summary = DSWbag["summary"] else {return}
        
        let quickBag = DSWData(products: products as! [OneProduct], promos: promos as! [OnePromo], summary: summary as! TheSummary)
        
        let demo = "Matty Mat"
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(quickBag) {
            defaults.set(encoded, forKey: "SavedBag")
        }
        
        defaults.set(demo, forKey: "Demo")
        
//        print(defaults.object(forKey: "Demo"))
        
    }
}

