//
//  Scenario3.swift
//  DSWProject
//
//  Created by Matiny L on 11/15/20.
//  Copyright © 2020 Matiny L. All rights reserved.
//

import Foundation
import UIKit

class ViewModelVC: UIViewController {
    
    var viewModel: ViewModel?
    
    var DSWbag = [String:Any]()
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.bindLabelToModel()
        }
    }
    
    func loadData() {
        if let savedBag = defaults.object(forKey: "SavedBag") as? Data {
            let decoder = JSONDecoder()
            if let loadedBag = try? decoder.decode(DSWData.self, from: savedBag) {
                
                DSWbag = ["products": loadedBag.products,
                          "promos": loadedBag.promos,
                          "summary": loadedBag.summary]
                
                self.viewModel = ViewModel(model: loadedBag)
            }
            
        }
    }

    func bindLabelToModel() {
        viewModel?.setClosure(bindingClosure: { [weak self] (data) in
            let product = data.products[0]
            self?.skuLabel.text = product.sku
            self?.nameLabel.text = product.displayName
            self?.priceLabel.text = product.price
            self?.quantityLabel.text = String(product.quantity)
        })
    }
    
}

class ViewModel {
    typealias BindingClosure = (DSWData) -> Void
    var bindingClosure: (BindingClosure)?
    
    var model: DSWData {
        didSet {
            bindingClosure?(model)
        }
    }
    
    init(model: DSWData) {
        self.model = model
    }
    
    func setClosure(bindingClosure: BindingClosure?) {
        self.bindingClosure = bindingClosure
        bindingClosure?(model)
    }
    
}
